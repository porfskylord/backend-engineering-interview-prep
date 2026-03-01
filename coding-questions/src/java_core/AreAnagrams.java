package src.java_core;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class AreAnagrams {
    public static void main(String[] args) {
        String s1 = "listen";
        String s2 = "silent";

        System.out.println("Stream and sorting:" + Arrays.equals(s1.chars().sorted().toArray(),s2.chars().sorted().toArray()));
        System.out.println("map:" + isAnagram(s1, s2) );
    }

    public static boolean isAnagram (String s1, String s2) {
        if(s1.length() != s2.length()) return false;

        Map<Character, Integer> map = new HashMap<>();

        for (char ch : s1.toCharArray()){
            map.put(ch , map.getOrDefault(ch, 0) + 1);
        }

        for (char ch : s2.toCharArray()){
            if(!map.containsKey(ch)){
                return false;
            }

            map.put(ch, map.get(ch) - 1);

            if(map.get(ch) == 0){
                map.remove(ch);
            }
        }

        return map.isEmpty();
    }
}
