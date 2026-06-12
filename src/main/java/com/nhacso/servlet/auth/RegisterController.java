package com.nhacso.servlet.auth;

import com.nhacso.dao.UserDAO;
import com.nhacso.dao.VerificationCodeDAO;
import com.nhacso.entity.User;
import com.nhacso.entity.VerificationCode;
import com.nhacso.service.EmailService;
import com.nhacso.utils.PasswordUtils;
import jakarta.persistence.PersistenceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;

@Controller
public class RegisterController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private VerificationCodeDAO verificationCodeDAO;

    @Autowired
    private EmailService emailService;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("registerForm", new RegisterFormHelper());
        return "auth/register";
    }

    @PostMapping("/register/send-code")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendVerificationCode(@RequestParam("email") String rawEmail) {
        String email = normalize(rawEmail);
        if (isBlank(email)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Vui lòng nhập email."));
        }
        if (userDAO.findByEmail(email) != null) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email đã được sử dụng."));
        }
        String code = String.format("%06d", new Random().nextInt(999999));
        verificationCodeDAO.invalidatePreviousCodes(email);
        VerificationCode vc = VerificationCode.builder()
                .email(email)
                .code(code)
                .expiresAt(LocalDateTime.now().plusMinutes(5))
                .verified(false)
                .build();
        verificationCodeDAO.save(vc);
        try {
            emailService.sendVerificationCode(email, code);
            return ResponseEntity.ok(Map.of("message", "Mã xác thực đã được gửi đến email " + email));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Không thể gửi email. Vui lòng thử lại sau."));
        }
    }

    @PostMapping("/register")
    public String processRegister(
            @RequestParam("email") String rawEmail,
            @RequestParam("password") String password,
            @RequestParam("firstName") String rawFirstName,
            @RequestParam("lastName") String rawLastName,
            @RequestParam(value = "birthday", required = false) String birthday,
            @RequestParam(value = "gender", required = false) String gender,
            @RequestParam("otpCode") String otpCode,
            Model model) {

        String email = normalize(rawEmail);
        String firstName = normalize(rawFirstName);
        String lastName = normalize(rawLastName);

        if (isBlank(email) || isBlank(password) || isBlank(firstName) || isBlank(lastName)) {
            model.addAttribute("errorMsg", "Email, mật khẩu, họ và tên là bắt buộc.");
            fillModel(model, email, firstName, lastName);
            return "auth/register";
        }

        VerificationCode validCode = verificationCodeDAO.findValidCode(email, otpCode);
        if (validCode == null) {
            model.addAttribute("errorMsg", "Mã xác thực không hợp lệ hoặc đã hết hạn.");
            fillModel(model, email, firstName, lastName);
            return "auth/register";
        }

        String username = email.split("@")[0];
        String baseUsername = username;
        int count = 1;
        while (userDAO.findByUsername(username) != null) {
            username = baseUsername + count;
            count++;
        }

        if (userDAO.findByEmail(email) != null) {
            model.addAttribute("errorMsg", "Email đã được sử dụng.");
            fillModel(model, email, firstName, lastName);
            return "auth/register";
        }

        String fullName = firstName + " " + lastName;

        User user = User.builder()
                .username(username)
                .password(PasswordUtils.hashPassword(password))
                .email(email)
                .fullName(fullName)
                .role("USER")
                .status(1)
                .premium(false)
                .createdAt(LocalDateTime.now())
                .build();

        try {
            userDAO.create(user);
            verificationCodeDAO.markVerified(validCode.getId());
        } catch (PersistenceException ex) {
            model.addAttribute("errorMsg", "Không thể tạo tài khoản. Vui lòng thử lại.");
            fillModel(model, email, firstName, lastName);
            return "auth/register";
        }

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
