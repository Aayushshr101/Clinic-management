import util.PasswordUtil;

public class HashGenerator {
    public static void main(String[] args) {
        String rawPassword = "admin123";
        String hashed = PasswordUtil.hashPassword(rawPassword);
        System.out.println("Hashed password: " + hashed);
    }
}
