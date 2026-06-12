package com.nhacso.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component // Đăng ký Filter này với Spring Boot
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // 1. Check xem đã đăng nhập chưa
        if (session == null || session.getAttribute("username") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // 2. Lấy role từ session ra check (Đồng bộ với role "ADMIN" đã lưu từ LoginController)
        String role = (String) session.getAttribute("role");
        if (role != null && role.equalsIgnoreCase("ADMIN")) {
            chain.doFilter(request, response);
        } else {
            // Không phải admin thì báo lỗi 403 cấm truy cập
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You don't have permission to access this page.");
        }
    }
}
