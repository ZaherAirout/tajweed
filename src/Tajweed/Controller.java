package Tajweed;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Controller {
    public ComboBox<Integer> cbAyaNumber;
    public ImageView imageView;
    public ComboBox<Integer> pageSelector;
    public TreeView resultTreeView;

    @FXML
    Button btnRun;

    @FXML
    TextArea lblAya;
    @FXML
    ComboBox<String> cbSurah;


    private AhkamController ahkamController = new AhkamController();
    //    Database connection
    private AyatDatabase ayatDatabase = new AyatDatabase();

    private int CurrentPageNumber = -1;

    public Controller() throws Exception {
    }

    @FXML
    private void initialize() throws Exception {

//        JUST for testing
//        showMessage(System.getProperty("user.dir"));
        // Handle Button event.
        cbSurah.getItems().addAll(ayatDatabase.getSurahList());
        pageSelector.getItems().addAll(ahkamController.Range(1, 604));

        pageSelector.setOnAction(event -> setImage(pageSelector.getValue()));
        pageSelector.getSelectionModel().select(0);
        cbSurah.getSelectionModel().select(0);

        cbAyaNumber.setOnAction(this::addAya);
        cbSurah.setOnAction(event1 -> ayaAdapter());
        btnRun.setOnAction((event) -> {
            HashMap<String, HashMap<String, List<String>>> jessResult = null;
            try {
                jessResult = ahkamController.CallJess(lblAya.getText());
            } catch (Exception e) {
                showMessage(e.getMessage());
                e.printStackTrace();
            }
            setResult(jessResult);


        });
        pageSelector.fireEvent(new ActionEvent());
        imageView.setOnMouseClicked(event -> {
            String ayaByXY = ayatDatabase.getAyaByXY(pageSelector.getValue(), event.getX(), event.getY());
            lblAya.setText(ayaByXY);
            btnRun.fireEvent(new ActionEvent());
        });
        cbSurah.fireEvent(new ActionEvent());
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
        resultTreeView.setRoot(root);
    }

    private void setImage(Integer number) {

        if (CurrentPageNumber != number)
            try {
                CurrentPageNumber = number;
                imageView.setImage(new Image(new FileInputStream("./images/" + number + ".png")));
            } catch (Exception e) {
                showMessage("Please Check images directory");
                e.printStackTrace();
            }
    }


    private void ayaAdapter() {

        ArrayList<Integer> result = ayatDatabase.getAyatCount(cbSurah.getSelectionModel().getSelectedIndex() + 1);

        cbAyaNumber.getItems().clear();
        cbAyaNumber.getItems().addAll(ahkamController.Range(1, result.get(0)));
        cbAyaNumber.getSelectionModel().select(0);
        pageSelector.getSelectionModel().select(result.get(1));

    }

    private void addAya(ActionEvent event) {
        Integer surahId = cbSurah.getSelectionModel().getSelectedIndex() + 1;
        int selected = cbAyaNumber.getSelectionModel().getSelectedIndex() + 1;
        selected = (selected == 0 ? 1 : selected);

        String aya = ayatDatabase.getAyaByNumber(surahId, selected);
        pageSelector.getSelectionModel().select(ayatDatabase.getPageByNumber(surahId, selected));
        lblAya.setText(aya);

    }

    private void showMessage(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR, message, ButtonType.OK);
        alert.showAndWait();

        if (alert.getResult() == ButtonType.OK) {
            alert.close();
        }
    }
}
