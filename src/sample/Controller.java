package sample;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

import java.util.ArrayList;

public class Controller {
    public ComboBox<Integer> cbAyaNumber;
    public ImageView img;
    public ComboBox<Integer> pageSelector;
    @FXML
    Button btnRun;
    @FXML
    TextArea taResult;
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
        // Handle Button event.
//        img.setImage( new Image(getClass().getResource("/assets/image/1.png").toExternalForm()));

//        img = new ImageView();
//        pageSelector.setValueFactory(new SpinnerValueFactory.IntegerSpinnerValueFactory(1, 604, 1));
//        pageSelector.setOnInputMethodTextChanged(event -> System.out.println(pageSelector.getValue()));
//        pageSelector.increment();
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
        cbSura.fireEvent(new ActionEvent());
        cbAyaNumber.fireEvent(new ActionEvent());
        btnRun.setOnAction((event) -> {
            String result = Helper.CallJess(lblAya.getText(), cbSura.getSelectionModel().getSelectedIndex());
            taResult.setText(result);

        });
        img.setImage(new Image("images/1.png"));
        img.setOnMouseClicked(event -> {
            String ayaByXY = DB.getAyaByXY(pageSelector.getValue(), event.getX(), event.getY());
            lblAya.setText(ayaByXY);
        });

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
