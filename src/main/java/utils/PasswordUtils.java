package utils;

public class PasswordUtils {
    private PasswordUtils() {
    }

    public static String hashPassword(String rawPassword) {
        return rawPassword == null ? null : rawPassword.trim();
    }

    public static boolean matches(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null) {
            return false;
        }
        return storedPassword.equals(rawPassword.trim());
    }
}
