package Tajweed;

import javafx.util.Pair;
import jess.*;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Zaher Airout on 2017/5/8.
 */
public class AhkamController {

    private Rete engine;

    private ArrayList<Pair<String, String>> correctedWords;

    public AhkamController() {

        engine = new Rete();
        correctedWords = new ArrayList<>();

        correctedWords.add(new Pair<>("هَٰؤُلَاء", "هَاؤلَاء"));
        correctedWords.add(new Pair<>("أُولَٰئِ", "أُلَائِ"));
        correctedWords.add(new Pair<>("الم", "الفلَامْمِيمْ"));
        correctedWords.add(new Pair<>("آ", "أَا"));
        correctedWords.add(new Pair<>("هَٰؤُلَاء", "هَاؤلَاء"));
    }

    //Used in JESS
    public static String insertAt(String s, int index) {
        return s.substring(0, index - 1) + "." + s.substring(index, s.length());
    }

    public static char[] getLetters(String ignored, String alphabet) {

        alphabet = alphabet.replaceAll(" ", "");
        for (Character c : ignored.toCharArray()) {
            alphabet = alphabet.replace(c.toString(), "");
        }
        return alphabet.toCharArray();
    }

    public ArrayList<Integer> Range(int from, int to) {
        ArrayList<Integer> result = new ArrayList<>();
        for (int i = from; i <= to; i++)
            result.add(i);
        return result;
    }

    //JESS Functions PLEASE DON'T RENAME OR MOVE
    public HashMap<String, HashMap<String, List<String>>> ParseAya(String ayaStr) throws JessException {

        int ayaNum = 0;
//        for Last character
        ayaStr += " ";

        for (Pair<String, String> correctedWord : correctedWords) {
            ayaStr = ayaStr.replace(correctedWord.getKey(), correctedWord.getValue());
        }

        Batch.batch("stringMatching.clp", StandardCharsets.UTF_8.toString(), engine);

        Fact fact = new Fact("aya", engine);
        fact.setSlotValue("id", new Value(ayaNum, RU.INTEGER));
        fact.setSlotValue("content", new Value(ayaStr, RU.SYMBOL));

        engine.assertFact(fact);
        engine.run();

        HashMap<String, HashMap<String, List<String>>> map = new HashMap<>();

        Iterator list = engine.listFacts();
        while (list.hasNext()) {
            fact = (Fact) list.next();

            if (fact.getName().compareTo("MAIN::TR") == 0) {

                String occurrence = fact.getSlotValue("occurrence").toString();
                String type = fact.getSlotValue("type").toString().replace("\"", "");
                String name = fact.getSlotValue("name").toString().replace("\"", "");
                String position = fact.getSlotValue("position").toString();
                String words = occurrence.compareTo("two-word") == 0 ?
                        this.getWords(ayaStr, Integer.valueOf(position)) :
                        this.getWord(ayaStr, Integer.valueOf(position));

                for (Pair<String, String> correctedWord : correctedWords) {
                    words = words.replace(correctedWord.getValue(), correctedWord.getKey());
                }

                HashMap<String, List<String>> typeMap;
                List<String> typeList;

                if (map.get(type) == null) {
                    typeMap = new HashMap<>();
                } else {
                    typeMap = map.get(type);
                }

                if (typeMap.get(name) == null) {
                    typeList = new ArrayList<>();
                    typeList.add(words);
                    typeMap.put(name, typeList);
                } else {
                    typeList = typeMap.get(name);
                    typeList.add(words);
                }

                map.put(type, typeMap);
            }
        }

        return map;
    }

    private String getWord(String s, int index) {
        return split(s, index, index);
    }

    private String getWords(String s, int index) {
        return split(s, s.charAt(index - 1) == ' ' ? index - 2 : index - 1, s.charAt(index + 1) == ' ' ? index + 2 : index + 1);
    }

    private String split(String s, int beginning, int end) {
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
}
