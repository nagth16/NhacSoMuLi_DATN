package com.nhacso.servlet.admin;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.UserDAO;
import com.nhacso.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/employees")
public class AdminEmployeeController {

    private final UserDAO userDAO;
    private final PlaylistDAO playlistDAO;

    public AdminEmployeeController(UserDAO userDAO, PlaylistDAO playlistDAO) {
        this.userDAO = userDAO;
        this.playlistDAO = playlistDAO;
    }

    @GetMapping
    public String listEmployees(HttpSession session, Model model) {
        List<User> users = userDAO.findAll();
        model.addAttribute("users", users);
        model.addAttribute("currentPage", "admin/employees");
        model.addAttribute("pageTitle", "Quản lý nhân viên");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }
}
