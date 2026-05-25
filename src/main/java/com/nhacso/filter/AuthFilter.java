package com.nhacso.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Đồng bộ check "username" giống như đã lưu ở LoginController
        boolean isLoggedIn = (session != null && session.getAttribute("username") != null);

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            // Lưu lại link đang vào dở để đăng nhập xong quay lại
            String requestedURL = httpRequest.getRequestURL().toString();
            String queryString = httpRequest.getQueryString();
            if (queryString != null) {
                requestedURL += "?" + queryString;
            }

            session = httpRequest.getSession(true);
            session.setAttribute("redirectAfterLogin", requestedURL);

            // Redirect thẳng về trang login, Spring Boot tự hiểu context path trống ""
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
}