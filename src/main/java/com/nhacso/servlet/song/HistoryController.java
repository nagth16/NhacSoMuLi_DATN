package com.nhacso.servlet.song;

import com.nhacso.dao.ListenHistoryDAO;
import com.nhacso.dao.PlaylistDAO;
import com.nhacso.entity.ListenHistory;
import com.nhacso.entity.Playlist;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HistoryController {

    @Autowired
    private ListenHistoryDAO listenHistoryDAO;

    @Autowired
    private PlaylistDAO playlistDAO;

    @GetMapping("/history")
    public String getHistory(HttpSession session, Model model) {
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }
        if (userId == null) {
            return "redirect:/login";
        }

        List<ListenHistory> histories = listenHistoryDAO.findByUserId(userId);
        model.addAttribute("histories", histories);
        model.addAttribute("currentPage", "user/history");
        model.addAttribute("pageTitle", "Lịch sử nghe nhạc");

        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
        model.addAttribute("playlists", playlists);

        return "user/home";
    }
}
