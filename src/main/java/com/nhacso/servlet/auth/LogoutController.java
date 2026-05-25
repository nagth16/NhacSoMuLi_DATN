package com.nhacso.servlet.auth;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class LogoutController {

    /**
     * Xử lý Đăng xuất cho cả request GET và POST.
     * Xóa session và chuyển hướng người dùng về trang đăng nhập.
     */
    @RequestMapping(value = "/logout", method = {RequestMethod.GET, RequestMethod.POST})
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        // Chuyển hướng về trang đăng nhập
        return "redirect:/login";
    }
}