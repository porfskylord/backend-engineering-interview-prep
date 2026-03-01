package src.java_core;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public class OccurrenceOfCharInString {
    public static void main(String[] args) {
        String s = "akjnsfijabsfiyvajsasf";

        System.out.println("Stream: " + s.chars()
                .mapToObj(x -> String.valueOf((char)x))
                .collect(Collectors.groupingBy(Function.identity(),Collectors.counting()))
        );

        System.out.println("Map:" + countFrequency(s));
    }

    private static Map<Character, Integer> countFrequency (String str) {
        Map<Character, Integer> map = new HashMap<>();

        for (char ch : str.toCharArray()){
            map.put(ch, map.getOrDefault(ch,0) + 1);
        }

        return map;
    }
}
