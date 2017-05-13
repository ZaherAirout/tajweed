package sample;

import jess.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Zaher Airout on 2017/5/8.
 */
public class Helper {

    public static ArrayList<Integer> Range (int from,int to){
        ArrayList<Integer> result  = new ArrayList<>();
        for (int i= from ; i<= to ; i++)
            result.add(i);
    return result;
    }
    //          JESS Functions PLEASE DON'T RENAME OR MOVE
    public static String CallJess(String ayaStr, int ayaNum) {
        Rete engine = new Rete();

        HashMap<String, HashMap<String, List<String>>> map = new HashMap<>();

        StringBuilder sb = new StringBuilder();
        try {
            engine.batch("stringMatching.clp");
            Fact f = new Fact("aya", engine);
            f.setSlotValue("id", new Value(ayaNum, RU.INTEGER));
            f.setSlotValue("content", new Value(ayaStr, RU.SYMBOL));
            engine.assertFact(f);
            engine.run();
            Iterator list = engine.listFacts();
            while (list.hasNext()) {
                Fact x = (Fact) list.next();
                if (x.getName().compareTo("MAIN::TR") == 0) {
                    String occurrence = x.getSlotValue("occurrence").toString();
                    String type = x.getSlotValue("type").toString().replace("\"", "");
                    String name = x.getSlotValue("name").toString().replace("\"", "");
                    String position = x.getSlotValue("position").toString();
                    String words = occurrence.compareTo("two-word") == 0 ?
                            Helper.getWords(ayaStr, Integer.valueOf(position)) :
                            Helper.getWord(ayaStr, Integer.valueOf(position));

                    HashMap<String, List<String>> m;
                    List<String> l;
                    if (map.get(type) == null) {
                        m = new HashMap<>();
                        if (m.get(name) == null) {
                            l = new ArrayList<>();
                            l.add(words);
                            m.put(name, l);
                        } else {
                            l = m.get(name);
                            l.add(words);
                        }

                        map.put(type, m);

                    } else {

                        m = map.get(type);
                        if (m.get(name) == null) {
                            l = new ArrayList<>();
                            l.add(words);
                            m.put(name, l);
                        } else {
                            l = m.get(name);
                            l.add(words);
                        }
                    }


                    /*sb.append("======================= \n");
                    sb.append("type is  = " + type + "\n");
                    sb.append("name is  = " + name + "\n");
                    sb.append("occurrence is  = " + occurrence + "\n");
                    sb.append("at is  = " + words + "\n");*/
                }
            }
        } catch (JessException e) {
            System.out.println("JESS ERROR");
            e.printStackTrace();
        }

        return parseHashMap(map);
    }

    private static String parseHashMap(HashMap<String, HashMap<String, List<String>>> map) {

        StringBuilder sb = new StringBuilder();

        for (String type : map.keySet()) {
            sb.append(type + "\n");
            sb.append("===================\n");
            HashMap<String, List<String>> stringListHashMap = map.get(type);
            for (String name : stringListHashMap.keySet()) {
                sb.append(name + "\n");
                sb.append("-------------\n");

                List<String> strings = stringListHashMap.get(name);
                for (String string : strings) {
                    sb.append(string + "\n");
                }

                sb.append("-------------\n");
            }

        }


        return sb.toString();
    }

    public static String getWord(String s, int index) {
        return split(s, index, index);
    }

    public static String getWords(String s, int index) {
        return split(s, index - 1, s.charAt(index + 1) == ' ' ? index + 2 : index + 1);
    }

    public static String split(String s, int beginning, int end) {
        int change = -1;
        //		Printing is JUST for test
        //		System.out.println(s.charAt(beginning)+"   "+s.charAt(end));
        // if values not changed since last loop break loop
        while (change != end - beginning) {
            change = end - beginning;
            if (beginning > 0 && s.charAt(beginning) != ' ')
                beginning--;
            if (end < s.length() && s.charAt(end) != ' ')
                end++;
        }
        return s.substring(beginning, end);
    }

    public static String insertAt(String s, int index) {
        return s.substring(0, index - 1) + "." + s.substring(index, s.length());
    }

}
