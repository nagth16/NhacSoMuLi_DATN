package com.nhacso.servlet.song;

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
public class LibraryController {

    private final SongDAO songDAO;
    private final PlaylistDAO playlistDAO;

    public LibraryController(SongDAO songDAO, PlaylistDAO playlistDAO) {
        this.songDAO = songDAO;
        this.playlistDAO = playlistDAO;
    }

    @GetMapping("/library")
    public String library(HttpSession session, Model model) {
        List<Song> songs = songDAO.findAllWithArtists();
        model.addAttribute("librarySongs", songs);
        model.addAttribute("pageTitle", "Th\u01B0 vi\u1EC7n");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
            model.addAttribute("playlists", playlists);
        }

        model.addAttribute("isLibrary", true);
        model.addAttribute("currentPage", "user/library");
        return "user/home";
    }
}
