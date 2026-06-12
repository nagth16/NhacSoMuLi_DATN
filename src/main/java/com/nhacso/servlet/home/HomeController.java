package com.nhacso.servlet.home;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.SongDAO;
import com.nhacso.entity.Playlist;
import com.nhacso.entity.Song;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    private final SongDAO songDAO;
    private final PlaylistDAO playlistDAO;

    public HomeController(SongDAO songDAO, PlaylistDAO playlistDAO) {
        this.songDAO = songDAO;
        this.playlistDAO = playlistDAO;
    }

    @GetMapping({"/", "/home"})
    public String index(HttpSession session, Model model) {
        List<Song> trendingSongs = songDAO.findTopListened(20);
        model.addAttribute("trendingSongs", trendingSongs);
        model.addAttribute("pageTitle", "Khám Phá");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
            model.addAttribute("playlists", playlists);
        }

        return "user/home";
    }
}
