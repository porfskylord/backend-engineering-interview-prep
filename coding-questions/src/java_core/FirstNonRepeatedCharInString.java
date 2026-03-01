package src.java_core;

import java.util.HashMap;
import java.util.Map;

public class FirstNonRepeatedCharInString {
    public static void main(String[] args) {
        String s = "swiss";

        System.out.println( "Stream version: " + s
                .chars()
                .mapToObj(x -> (char)x)
                .filter(x -> s.indexOf(x) == s.lastIndexOf(x))
                .findFirst().orElse('0')
        );

        System.out.println("Map version: " + firstNonRepeating(s));

    }

    private static char firstNonRepeating (String str){
        Map<Character, Integer> freq = new HashMap<>();

        for( char ch : str.toCharArray()){
            freq.put(ch, freq.getOrDefault(ch,0) + 1);
        }

        for (char ch : str.toCharArray()){
            if(freq.get(ch) == 1){
                return ch;
            }
        }

        return '\0';
    }
}
