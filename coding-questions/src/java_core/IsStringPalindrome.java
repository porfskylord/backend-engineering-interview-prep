package src.java_core;

public class IsStringPalindrome {
    public static void main(String[] args) {
        System.out.println(isPalindrome("jahaj"));
    }
    private static boolean isPalindrome (String str) {
        str = str.toLowerCase().replace("[^a-z0-9]","");
        int left = 0;
        int right = str.length() - 1;

        while (left<right){
            if(str.charAt(left) != str.charAt(right)) return false;
            left++;
            right--;
        }
        return true;
    }
}
