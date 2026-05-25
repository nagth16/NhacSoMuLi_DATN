package com.nhacso;

import com.nhacso.filter.AdminFilter;
import com.nhacso.filter.AuthFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FilterConfig {

    // Cấu hình các đường dẫn chịu sự quản lý của AuthFilter
    @Bean
    public FilterRegistrationBean<AuthFilter> loggingFilter(AuthFilter authFilter){
        FilterRegistrationBean<AuthFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(authFilter);
        registrationBean.addUrlPatterns("/favorites", "/share", "/account/*", "/logout");
        registrationBean.setOrder(1); // Chạy trước
        return registrationBean;
    }

    // Cấu hình các đường dẫn chịu sự quản lý của AdminFilter
    @Bean
    public FilterRegistrationBean<AdminFilter> adminFilterRegistration(AdminFilter adminFilter){
        FilterRegistrationBean<AdminFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(adminFilter);
        registrationBean.addUrlPatterns("/admin/*");
        registrationBean.setOrder(2); // Chạy sau AuthFilter
        return registrationBean;
    }
}
