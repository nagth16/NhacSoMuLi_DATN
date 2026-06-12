package com.nhacso.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/assets/css/");
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/assets/js/");
        registry.addResourceHandler("/image/**")
                .addResourceLocations("/assets/image/");
        registry.addResourceHandler("/music/**")
                .addResourceLocations("/music/");
    }
}
