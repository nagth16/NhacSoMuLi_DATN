package com.nhacso.servlet.song;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.UserLikeSongDAO;
import com.nhacso.entity.Playlist;
import com.nhacso.entity.Song;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class FavoritesController {

    @Autowired
    private UserLikeSongDAO userLikeSongDAO;

    @Autowired
    private PlaylistDAO playlistDAO;

    @GetMapping("/favorites")
    public String getFavorites(HttpSession session, Model model) {
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }
        if (userId == null) {
            return "redirect:/login";
        }

        List<Song> favoriteSongs = userLikeSongDAO.getLikedSongs(userId);
        model.addAttribute("favoriteSongs", favoriteSongs);
        model.addAttribute("currentPage", "user/favorite");
        model.addAttribute("pageTitle", "Bài hát yêu thích");

        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
        model.addAttribute("playlists", playlists);

        return "user/home";
    }
}
