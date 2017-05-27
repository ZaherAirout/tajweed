package sample;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Controller {
    public ComboBox<Integer> cbAyaNumber;
    public ImageView img;
    public ComboBox<Integer> pageSelector;
    public TreeView tresult;
    @FXML
    Button btnRun;

    @FXML
    TextArea lblAya;
    @FXML
    ComboBox<String> cbSura;

    //    Database connection
    DBhelper DB;

    @FXML
    Button btnAdd;


    @FXML
    private void initialize() {
        try {
            PushbackReader pushbackReader = new PushbackReader(new InputStreamReader(new FileInputStream("src/stringMatching.clp"), "utf-8"));
        } catch (FileNotFoundException e) {
//            showMessage("cannot find file src");

            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
//        JUST for testing
//        showMessage(System.getProperty("user.dir"));
        // Handle Button event.
        DB = new DBhelper();
        cbSura.getItems().addAll(DB.getSuraList());
        pageSelector.getItems().addAll(Helper.Range(1, 604));
        pageSelector.setOnAction(event -> setImage(pageSelector.getValue()));
        pageSelector.getSelectionModel().select(0);
        cbSura.getSelectionModel().select(0);

        cbAyaNumber.setOnAction(event -> addAya(event));
        cbSura.setOnAction(event1 -> {
            ayaAdapter();
        });
        btnRun.setOnAction((event) -> {
            HashMap<String, HashMap<String, List<String>>> jessResult = Helper.CallJess(lblAya.getText(), cbSura.getSelectionModel().getSelectedIndex());
            setResult(jessResult);


        });
        img.setImage(new Image("images/1.png"));
        img.setOnMouseClicked(event -> {
            String ayaByXY = DB.getAyaByXY(pageSelector.getValue(), event.getX(), event.getY());
            lblAya.setText(ayaByXY);
        });
        cbSura.fireEvent(new ActionEvent());
        cbAyaNumber.fireEvent(new ActionEvent());
        btnRun.fireEvent(new ActionEvent());

    }

    private void setResult(HashMap<String, HashMap<String, List<String>>> jessResult) {
        TreeItem root = new TreeItem("الأحكام المستخرجة");
        for (String type : jessResult.keySet()) {
            TreeItem typeNode = new TreeItem(type);
            root.getChildren().add(typeNode);
            HashMap<String, List<String>> stringListHashMap = jessResult.get(type);
            for (String name : stringListHashMap.keySet()) {
                TreeItem nameNode = new TreeItem(name);
                typeNode.getChildren().add(nameNode);

                List<String> strings = stringListHashMap.get(name);
                for (String string : strings) {
                    TreeItem leafNode = new TreeItem(string);
                    nameNode.getChildren().add(leafNode);
                }
            }
        }
        tresult.setRoot(root);
    }

    private void setImage(Integer number) {
        img.setImage(new Image("images/" + number + ".png"));
    }


    private void ayaAdapter() {
        int suraAyatCount = DB.getSuraAyatCount(cbSura.getSelectionModel().getSelectedIndex() + 1);
        ArrayList<Integer> integers = new ArrayList<>();
        for (int i = 1; i <= suraAyatCount; i++)
            integers.add(i);
        cbAyaNumber.getItems().clear();
        cbAyaNumber.getItems().addAll(integers);
        cbAyaNumber.getSelectionModel().select(0);
    }

    private void addAya(ActionEvent event) {
        // Button was clicked, do something...

        Integer suraId = cbSura.getSelectionModel().getSelectedIndex() + 1;
        int suraAyatCount = DB.getSuraAyatCount(suraId);
        int selected = cbAyaNumber.getSelectionModel().getSelectedIndex() + 1;
        if (suraAyatCount >= selected) {
            String aya = DB.getAyaNumber(suraId, selected);
            lblAya.setText(aya);
        } else {
            showMessage("Please enter a Number less than" + suraAyatCount);
        }
    }

    private void showMessage(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR, message, ButtonType.OK);
        alert.showAndWait();

        if (alert.getResult() == ButtonType.OK) {
            alert.close();
        }
//        Stage dialogStage = new Stage();
//        dialogStage.initModality(Modality.WINDOW_MODAL);
//
//        VBox vbox = new VBox(new Text(message), new Button("Ok."));
//        vbox.setAlignment(Pos.CENTER);
//        vbox.setPadding(new Insets(15));
//
//        dialogStage.setScene(new Scene(vbox));
//        dialogStage.show();
    }
}
