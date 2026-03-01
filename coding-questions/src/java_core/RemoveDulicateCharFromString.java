package src.java_core;

import java.util.HashSet;
import java.util.Set;

public class RemoveDulicateCharFromString {
    public static void main(String[] args) {
        String str = "Azad";
        System.out.println("Stream: " + str.toLowerCase()
                .chars()
                .mapToObj(x -> String.valueOf((char)x))
                .distinct()
                .reduce("", (a, b) -> a + b)
        );

        System.out.println("Set: " + removeDuplicates(str));

    }

    private static String removeDuplicates (String str){
        str = str.toLowerCase();
        Set<Character> set = new HashSet<>();
        StringBuilder result = new StringBuilder();

        for (char ch : str.toCharArray()){
            if(!set.contains(ch)){
                set.add(ch);
                result.append(ch);
            }
        }

        return result.toString();
    }
}
