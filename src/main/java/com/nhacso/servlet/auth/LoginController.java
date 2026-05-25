package com.nhacso.servlet.auth;

import com.nhacso.dao.UserDAO;
import com.nhacso.entity.User;
import com.nhacso.utils.PasswordUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @Autowired
    private UserDAO userDAO;

    /**
     * Hiển thị form đăng nhập.
     * Nhận thêm tham số 'registered' để hiển thị thông báo đăng ký thành công.
     */
    @GetMapping("/login")
    public String showLoginForm(
            @RequestParam(value = "username", required = false) String username,
            @RequestParam(value = "registered", required = false) String registered,
            Model model) {
        model.addAttribute("savedEmail", username);
        if ("true".equals(registered)) {
            model.addAttribute("successMsg", "Đăng ký thành công! Vui lòng đăng nhập.");
        }
        return "login"; // Trả về /WEB-INF/views/login.jsp
    }

    /**
     * Xử lý logic đăng nhập
     */
    @PostMapping("/login")
    public String processLogin(
            @RequestParam("email") String rawEmail,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {

        String email = normalize(rawEmail);

        // 1. Kiểm tra trống
        if (isBlank(email) || isBlank(password)) {
            model.addAttribute("errorMsg", "Email và password là bắt buộc.");
            model.addAttribute("savedEmail", email);
            return "login";
        }

        // 2. Kiểm tra tài khoản và mật khẩu
        User user = userDAO.findByUsernameOrEmail(email);
        if (user == null || !PasswordUtils.matches(password, user.getPassword())) {
            model.addAttribute("errorMsg", "Thông tin đăng nhập không đúng.");
            model.addAttribute("savedEmail", email);
            return "login";
        }

        // 3. Kiểm tra trạng thái tài khoản
        if (user.getStatus() != null && user.getStatus() == 0) {
            model.addAttribute("errorMsg", "Tài khoản đã bị khóa.");
            model.addAttribute("savedEmail", email);
            return "login";
        }

        // 4. Đăng nhập thành công -> Lưu thông tin vào Session
        session.setAttribute("username", user.getUsername());
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("role", user.getRole());

        // 5. Kiểm tra xem có yêu cầu chuyển hướng trước đó không
        String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
        if (redirectUrl != null) {
            session.removeAttribute("redirectAfterLogin");
            return "redirect:" + redirectUrl;
        }

        // Nếu không có, chuyển hướng thẳng về trang chủ
        return "redirect:/home";
    }

    private String normalize(String value) {
        return value == null ? null : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}