package com.nhacso.servlet.song;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.SongDAO;
import com.nhacso.entity.Playlist;
import com.nhacso.entity.Song;
import com.nhacso.service.YouTubeService;
import com.nhacso.service.YouTubeService.YouTubeVideo;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class SearchController {

    private final SongDAO songDAO;
    private final PlaylistDAO playlistDAO;
    private final YouTubeService youTubeService;

    public SearchController(SongDAO songDAO, PlaylistDAO playlistDAO, YouTubeService youTubeService) {
        this.songDAO = songDAO;
        this.playlistDAO = playlistDAO;
        this.youTubeService = youTubeService;
    }

    @GetMapping("/search")
    public String search(@RequestParam(value = "q", required = false) String keyword,
                         HttpSession session, Model model) {
        List<Song> results = List.of();
        List<YouTubeVideo> ytResults = List.of();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String q = keyword.trim();
            results = songDAO.searchByKeyword(q);
            try {
                ytResults = youTubeService.searchVideos(q);
            } catch (Exception e) {
                model.addAttribute("ytError", e.getMessage());
            }
        }

        model.addAttribute("searchResults", results);
        model.addAttribute("youtubeResults", ytResults);
        model.addAttribute("keyword", keyword);
        model.addAttribute("pageTitle", keyword != null && !keyword.trim().isEmpty()
                ? "Kết quả cho \"" + keyword.trim() + "\""
                : "Tìm kiếm");
        model.addAttribute("currentPage", "user/search");
        model.addAttribute("isSearch", true);

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
            model.addAttribute("playlists", playlists);
        }

        return "user/home";
    }
}
