package com.nhacso.servlet.auth;

import com.nhacso.dao.UserDAO;
import com.nhacso.dao.VerificationCodeDAO;
import com.nhacso.entity.User;
import com.nhacso.entity.VerificationCode;
import com.nhacso.service.EmailService;
import com.nhacso.utils.PasswordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;

@Controller
@RequestMapping("/forgot-password")
public class ForgotPasswordController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private VerificationCodeDAO verificationCodeDAO;

    @Autowired
    private EmailService emailService;

    @GetMapping
    public String showForgotForm() {
        return "auth/forgot-password";
    }

    @PostMapping("/send-code")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendCode(@RequestParam("email") String rawEmail) {
        String email = rawEmail.trim();
        if (email.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Vui lòng nhập email."));
        }
        User user = userDAO.findByEmail(email);
        if (user == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email không tồn tại trong hệ thống."));
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

    @PostMapping("/reset")
    public String resetPassword(
            @RequestParam("email") String rawEmail,
            @RequestParam("otpCode") String otpCode,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model) {

        String email = rawEmail.trim();

        VerificationCode validCode = verificationCodeDAO.findValidCode(email, otpCode);
        if (validCode == null) {
            model.addAttribute("errorMsg", "Mã xác thực không hợp lệ hoặc đã hết hạn.");
            return "auth/forgot-password";
        }

        if (newPassword.length() < 8) {
            model.addAttribute("errorMsg", "Mật khẩu mới phải có ít nhất 8 ký tự.");
            return "auth/forgot-password";
        }

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("errorMsg", "Mật khẩu xác nhận không khớp.");
            return "auth/forgot-password";
        }

        User user = userDAO.findByEmail(email);
        if (user == null) {
            model.addAttribute("errorMsg", "Email không tồn tại trong hệ thống.");
            return "auth/forgot-password";
        }

        try {
            user.setPassword(PasswordUtils.hashPassword(newPassword));
            userDAO.update(user);
            verificationCodeDAO.markVerified(validCode.getId());
        } catch (Exception e) {
            model.addAttribute("errorMsg", "Không thể đặt lại mật khẩu. Vui lòng thử lại.");
            return "auth/forgot-password";
        }

        return "redirect:/login?reset=true";
    }
}
