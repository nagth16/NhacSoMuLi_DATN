import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
public class HashGen {
    public static void main(String[] args) {
        BCryptPasswordEncoder enc = new BCryptPasswordEncoder();
        for (String p : args) {
            System.out.println(p + "|" + enc.encode(p));
        }
    }
}
