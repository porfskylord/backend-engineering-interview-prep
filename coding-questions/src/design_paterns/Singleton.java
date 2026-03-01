package src.design_paterns;

public class Singleton {
    private static volatile Singleton INSTANCE;

    private Singleton() {}

    public static Singleton getInstance() {
        if (INSTANCE == null){
            synchronized (Singleton.class) {
                if (INSTANCE == null) {
                    INSTANCE = new Singleton();
                }
            }
        }
        return INSTANCE;
    }
}

class MainSingleton {
    public static void main(String[] args) {
        Singleton s = Singleton.getInstance();
        System.out.println(s);
    }
}
