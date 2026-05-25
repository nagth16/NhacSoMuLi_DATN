package com.nhacso.servlet.home;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    /**
     * Định tuyến khi người dùng truy cập vào trang chủ hệ thống.
     * Trả về "home" để Spring Boot render file /WEB-INF/views/home.jsp.
     */
    @GetMapping({"/", "/home"})
    public String index() {
        return "home";
    }
}
