package com.nhacso.servlet.auth;

import com.nhacso.dao.UserDAO;
import com.nhacso.entity.User;
import com.nhacso.utils.PasswordUtils;
import jakarta.persistence.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;

@Controller
public class RegisterController {

    @Autowired
    private UserDAO userDAO;

    /**
     * Hiển thị form đăng ký
     */
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("registerForm", new RegisterFormHelper());
        return "register"; // Trả về /WEB-INF/views/register.jsp
    }

    /**
     * Xử lý logic đăng ký tài khoản mới.
     * Đồng bộ hoàn toàn với các tham số gửi lên từ form của register.jsp.
     */
    @PostMapping("/register")
    public String processRegister(
            @RequestParam("email") String rawEmail,
            @RequestParam("password") String password,
            @RequestParam("firstName") String rawFirstName,
            @RequestParam("lastName") String rawLastName,
            Model model) {

        String email = normalize(rawEmail);
        String firstName = normalize(rawFirstName);
        String lastName = normalize(rawLastName);

        // 1. Kiểm tra các trường bắt buộc
        if (isBlank(email) || isBlank(password) || isBlank(firstName) || isBlank(lastName)) {
            model.addAttribute("errorMsg", "Email, mật khẩu, họ và tên là bắt buộc.");
            fillModel(model, email, firstName, lastName);
            return "register";
        }

        // 2. Tự sinh username từ email (phần trước kí tự @) để khớp với cấu trúc DB
        String username = email.split("@")[0];
        // Đảm bảo username không bị trùng, nếu trùng thì gắn thêm hậu tố
        String baseUsername = username;
        int count = 1;
        while (userDAO.findByUsername(username) != null) {
            username = baseUsername + count;
            count++;
        }

        // 3. Kiểm tra trùng lặp Email
        if (userDAO.findByEmail(email) != null) {
            model.addAttribute("errorMsg", "Email đã được sử dụng.");
            fillModel(model, email, firstName, lastName);
            return "register";
        }

        // 4. Ghép fullName từ firstName và lastName
        String fullName = firstName + " " + lastName;

        // 5. Tạo đối tượng User mới và lưu xuống DB
        User user = User.builder()
                .username(username)
                .password(PasswordUtils.hashPassword(password))
                .email(email)
                .fullName(fullName)
                .role("USER")
                .status(1)
                .createdAt(LocalDateTime.now())
                .build();

        try {
            userDAO.create(user);
        } catch (PersistenceException ex) {
            model.addAttribute("errorMsg", "Không thể tạo tài khoản. Vui lòng thử lại.");
            fillModel(model, email, firstName, lastName);
            return "register";
        }

        // 6. Đăng ký thành công -> Chuyển hướng về trang đăng nhập với thông báo
        return "redirect:/login?username=" + email + "&registered=true";
    }

    private void fillModel(Model model, String email, String firstName, String lastName) {
        RegisterFormHelper helper = new RegisterFormHelper();
        helper.setEmail(email);
        helper.setFirstName(firstName);
        helper.setLastName(lastName);
        model.addAttribute("registerForm", helper);
    }

    private String normalize(String value) {
        return value == null ? null : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    // Helper class để truyền dữ liệu điền sẵn lại cho form JSP thông qua EL expressions (e.g. ${registerForm.email})
    public static class RegisterFormHelper {
        private String email = "";
        private String firstName = "";
        private String lastName = "";
        private String birthday = "";
        private String gender = "";

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getFirstName() { return firstName; }
        public void setFirstName(String firstName) { this.firstName = firstName; }
        public String getLastName() { return lastName; }
        public void setLastName(String lastName) { this.lastName = lastName; }
        public String getBirthday() { return birthday; }
        public void setBirthday(String birthday) { this.birthday = birthday; }
        public String getGender() { return gender; }
        public void setGender(String gender) { this.gender = gender; }
    }
}