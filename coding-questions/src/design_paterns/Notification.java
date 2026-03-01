package src.design_paterns;

public interface Notification {
    String send();
}

class EmailNotification implements Notification {
    @Override
    public String send() {
        return "Email Notification Send";
    }
}

class SmsNotification implements Notification {
    @Override
    public String send() {
        return "Sms Notification Send";
    }
}

class NotificationFactory {
    public static Notification getNotification(String notificationaType) {
        if(notificationaType.trim().equalsIgnoreCase("email")){
            return new EmailNotification();
        } else if (notificationaType.trim().equalsIgnoreCase("sms")){
            return new SmsNotification();
        } else {
            return null;
        }
    }
}

class FactoryExample {
    public static void main(String[] args) {
        Notification notification = NotificationFactory.getNotification("sms");
        System.out.println(notification.send());

        Notification notification1 = NotificationFactory.getNotification("email");
        System.out.println(notification1.send());
    }
}