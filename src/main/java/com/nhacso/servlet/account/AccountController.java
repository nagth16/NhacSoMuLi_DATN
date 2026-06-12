package com.nhacso.servlet.account;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.UserDAO;
import com.nhacso.entity.Playlist;
import com.nhacso.entity.User;
import com.nhacso.utils.PasswordUtils;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private PlaylistDAO playlistDAO;

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userDAO.findById(userId);
        model.addAttribute("profileUser", user);
        model.addAttribute("currentPage", "user/account-profile");
        model.addAttribute("pageTitle", "Hồ sơ của tôi");

        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
        model.addAttribute("playlists", playlists);

        return "user/home";
    }

    @PostMapping("/profile")
    public String updateProfile(
            @RequestParam("fullName") String fullName,
            HttpSession session,
            Model model) {

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userDAO.findById(userId);
        user.setFullName(fullName);
        try {
            userDAO.update(user);
            session.setAttribute("user", user);
            model.addAttribute("successMsg", "Cập nhật thông tin thành công!");
        } catch (Exception e) {
            model.addAttribute("errorMsg", "Không thể cập nhật thông tin. Vui lòng thử lại.");
        }

        model.addAttribute("profileUser", user);
        model.addAttribute("currentPage", "user/account-profile");
        model.addAttribute("pageTitle", "Hồ sơ của tôi");

        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
        model.addAttribute("playlists", playlists);

        return "user/home";
    }

    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            Model model) {

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userDAO.findById(userId);

        if (!PasswordUtils.matches(currentPassword, user.getPassword())) {
            model.addAttribute("pwError", "Mật khẩu hiện tại không đúng.");
        } else if (newPassword.length() < 8) {
            model.addAttribute("pwError", "Mật khẩu mới phải có ít nhất 8 ký tự.");
        } else if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("pwError", "Mật khẩu xác nhận không khớp.");
        } else {
            user.setPassword(PasswordUtils.hashPassword(newPassword));
            try {
                userDAO.update(user);
                model.addAttribute("successMsg", "Đổi mật khẩu thành công!");
            } catch (Exception e) {
                model.addAttribute("pwError", "Không thể đổi mật khẩu. Vui lòng thử lại.");
            }
        }

        model.addAttribute("profileUser", user);
        model.addAttribute("currentPage", "user/account-profile");
        model.addAttribute("pageTitle", "Hồ sơ của tôi");

        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
        model.addAttribute("playlists", playlists);

        return "user/home";
    }
}
