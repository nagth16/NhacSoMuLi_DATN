package com.nhacso.servlet.playlist;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.entity.Playlist;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class PlaylistServlet {

    @Autowired
    private PlaylistDAO playlistDAO;

    /**
     * Xử lý hiển thị danh sách playlist của người dùng
     * Hỗ trợ cả 2 urlPatterns cũ: /playlist và /playlists
     */
    @GetMapping({"/playlist", "/playlists", "/my-playlists"})
    public String getMyPlaylists(HttpSession session, Model model) {

        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            return "redirect:/login";
        }

        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);

        model.addAttribute("playlists", playlists);
        model.addAttribute("currentPage", "user/playlist");
        model.addAttribute("pageTitle", "Playlist của tôi");

        return "user/home";
    }
}