package sample;


import java.sql.*;
import java.util.*;

/**
 * Created by Zaher Airout on 2017/5/9.
 */

public class DBhelper {
    private Connection connection;

    public DBhelper() {
        try {
            this.connection = DriverManager.getConnection("jdbc:sqlite:ayat.ayt");
        } catch (SQLException e) {
            System.out.println("can't connect to database ayat.ayt");
        }

    }

    public ArrayList<String> getSuraList() {
        ArrayList result = new ArrayList();
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("select id,name from sura");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
//                System.out.println("name = " + name);
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

    public ArrayList getSuraAyatCount(int id) {
        ArrayList<Integer> result = new ArrayList();
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("select id,ayaCount from sura WHERE id=" + id);
            result.add(rs.getInt("ayaCount"));
            Statement st = connection.createStatement();
            st.setQueryTimeout(30);  // set timeout to 30 sec
            rs = st.executeQuery("select sura,safha from ayat WHERE sura=" + id);
            result.add(rs.getInt("safha"));

        } catch (SQLException e) {
//             if the error message is "out of memory",
//             it probably means no database file is found
            System.out.println("GetSurafailed");
            e.printStackTrace();
        }
        return result;
    }

    public String getAyaByNumber(int surahId, int selected) {
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


    public String getAyaByXY(Integer pageNumber, double x, double y) {
        int padding = 8;
        //        select * from amaken_hafs where safha=1 and y < 325+8
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("select * from amaken_hafs where safha=" + pageNumber + " and y+" + padding + " >" + y);
            int id = 0;
            while (rs.next()) {
                int ayaY = rs.getInt("y");
                id = rs.getInt("id");
//                System.out.println("ayay" + ayaY + " y" + y);
                if (Math.abs(ayaY - y) <= padding) { // same Row
//                    System.out.println("same row checking");
                    int ayaX = rs.getInt("x");
                    if (ayaX > x)
                        continue;
                }
//                System.out.println(id);
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

    public Integer getSafhaByNumber(Integer suraId, int selected) {
        try {
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec
            ResultSet rs = statement.executeQuery("SELECT sura,aya,safha FROM ayat where sura=" + suraId + " and aya=" + selected);
            return rs.getInt("safha");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }
}