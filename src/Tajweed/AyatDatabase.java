package Tajweed;


import java.sql.*;
import java.util.ArrayList;

/**
 * Created by Zaher Airout on 2017/5/9.
 */

class AyatDatabase {
    private Connection connection;

    AyatDatabase() {
        try {
            this.connection = DriverManager.getConnection("jdbc:sqlite:ayat.ayt");
        } catch (SQLException e) {
            System.out.println("can't connect to database ayat.ayt");
        }

    }

    ArrayList<String> getSurahList() {
        ArrayList result = new ArrayList();
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("select id,name from sura");
            while (rs.next()) {
                String name = rs.getString("name");
                result.add(name);
            }
        } catch (SQLException e) {
//             if the error message is "out of memory",
//             it probably means no database file is found
            System.out.println("Ayat file doesn't exist");
            e.printStackTrace();
        }
        return result;
    }

    ArrayList getAyatCount(int surahId) {
        ArrayList result = new ArrayList();
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("select id,ayaCount from sura WHERE id=" + surahId);
            result.add(rs.getInt("ayaCount"));
            Statement st = connection.createStatement();
            st.setQueryTimeout(30);  // set timeout to 30 sec
            rs = st.executeQuery("select sura,safha from ayat WHERE sura=" + surahId);
            result.add(rs.getInt("safha"));

        } catch (SQLException e) {
//             if the error message is "out of memory",
//             it probably means no database file is found
            System.out.println("GetSurafailed");
            e.printStackTrace();
        }
        return result;
    }

    String getAyaByNumber(int surahId, int selected) {
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("SELECT sura,aya,text FROM ayat where sura=" + surahId + " and aya=" + selected);
            return rs.getString("text").replace("?", "");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "not found";
    }


    String getAyaByXY(Integer pageNumber, double x, double y) {
        int padding = 8;
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("select * from amaken_hafs where safha=" + pageNumber + " and y+" + padding + " >" + y);
            int id = 0;
            while (rs.next()) {
                int ayaY = rs.getInt("y");
                id = rs.getInt("id");
                if (Math.abs(ayaY - y) <= padding) { // same Row
                    int ayaX = rs.getInt("x");
                    if (ayaX > x)
                        continue;
                }
                return getAyaById(id);
            }
        } catch (SQLException e) {
//             if the error message is "out of memory",
//             it probably means no database file is found
            e.printStackTrace();
        }

        return "No aya Selected";
    }

    private String getAyaById(int id) {
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("SELECT sura,aya,text FROM ayat where id=" + id);
            return rs.getString("text").replace("?", "");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "not found";

    }

    Integer getPageByNumber(Integer surahId, int selected) {
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("SELECT sura,aya,safha FROM ayat where sura=" + surahId + " and aya=" + selected);
            return rs.getInt("safha");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }
}