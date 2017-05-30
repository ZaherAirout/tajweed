package sample;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import jess.JessException;

import java.io.FileInputStream;
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
            HashMap<String, HashMap<String, List<String>>> jessResult = null;
            try {
                jessResult = Helper.CallJess(lblAya.getText(), cbSura.getSelectionModel().getSelectedIndex());
            } catch (JessException e) {
                showMessage(e.getMessage());
                e.printStackTrace();
            }
            setResult(jessResult);


        });
        pageSelector.fireEvent(new ActionEvent());
        img.setOnMouseClicked(event -> {
            String ayaByXY = DB.getAyaByXY(pageSelector.getValue(), event.getX(), event.getY());
            lblAya.setText(ayaByXY);
            btnRun.fireEvent(new ActionEvent());
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
        System.out.println(img.getImage());
        if (img.getImage()==null || pageSelector.getSelectionModel().getSelectedIndex()+1 != number)
            try {
                img.setImage(new Image(new FileInputStream("./images/" + number + ".png")));
            } catch (Exception e) {
                showMessage("Please Check images directory");
                e.printStackTrace();
            }
    }


    private void ayaAdapter() {

        ArrayList<Integer> result = DB.getSuraAyatCount(cbSura.getSelectionModel().getSelectedIndex() + 1);

        cbAyaNumber.getItems().clear();
        cbAyaNumber.getItems().addAll(Helper.Range(1, result.get(0)));
        cbAyaNumber.getSelectionModel().select(0);
        pageSelector.getSelectionModel().select(result.get(1));

    }

    private void addAya(ActionEvent event) {
        // Button was clicked, do something...
        Integer suraId = cbSura.getSelectionModel().getSelectedIndex() + 1;
        int selected = cbAyaNumber.getSelectionModel().getSelectedIndex() + 1;
        selected = (selected == 0 ? 1 : selected);

        String aya = DB.getAyaByNumber(suraId, selected);
        setImage(DB.getSafhaByNumber(suraId, selected));
        lblAya.setText(aya);

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
