package com.nhacso.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtils {

    // Khởi tạo bộ mã hóa BCrypt
    private static final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * Hàm dùng khi ĐĂNG KÝ: Mã hóa mật khẩu thuần thành chuỗi Hash để lưu vào DB
     * @param rawPassword Mật khẩu chữ thường do người dùng nhập (e.g., "123456")
     * @return Chuỗi đã mã hóa mã hóa (e.g., "$2a$10$X5...")
     */
    public static String hashPassword(String rawPassword) {
        if (rawPassword == null) {
            return null;
        }
        return passwordEncoder.encode(rawPassword);
    }

    /**
     * Hàm dùng khi ĐĂNG NHẬP: Kiểm tra mật khẩu người dùng nhập có khớp với mật khẩu đã mã hóa trong DB không
     * @param rawPassword Mật khẩu chữ thường người dùng vừa gõ vào Form login
     * @param storedPassword Chuỗi mật khẩu lấy ra từ database của User đó
     * @return true nếu khớp, false nếu sai mật khẩu
     */
    public static boolean matches(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null) {
            return false;
        }
        // Nếu mật khẩu trong DB đã được hash BCrypt, dùng BCrypt để kiểm tra
        if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
            return passwordEncoder.matches(rawPassword, storedPassword);
        }
        // Fallback: so sánh plain text (cho dữ liệu cũ chưa hash)
        return rawPassword.equals(storedPassword);
    }

    public static boolean isHashed(String password) {
        return password != null && (password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$"));
    }
}