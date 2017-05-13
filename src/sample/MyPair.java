package sample;

import javafx.util.Pair;

/**
 * Created by Zaher Airout on 2017/5/11.
 */

/**
 *
 * @param <K> Key
 * @param <V> Value
 */
public class MyPair<K,V> extends Pair {
    /**
     * Creates a new pair
     *
     * @param key   The key for this pair
     * @param value The value to use for this pair
     */


    public MyPair(K key, V value) {
        super(key, value);
    }

    @Override
    public K getKey() {
        return (K) super.getKey();
    }

    @Override
    public V getValue() {
        return (V) super.getValue();
    }

    @Override
    public String toString() {
        return getValue().toString();
    }
}
