package com.nhacso.servlet.admin;

import com.nhacso.dao.ArtistDAO;
import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.SongDAO;
import com.nhacso.entity.Artist;
import com.nhacso.entity.Playlist;
import com.nhacso.entity.Song;
import com.nhacso.service.YouTubeService;
import com.nhacso.service.YouTubeService.YouTubeVideo;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/admin/youtube-import")
public class AdminYouTubeImportController {

    private final YouTubeService youTubeService;
    private final SongDAO songDAO;
    private final ArtistDAO artistDAO;
    private final PlaylistDAO playlistDAO;

    public AdminYouTubeImportController(YouTubeService youTubeService, SongDAO songDAO,
                                        ArtistDAO artistDAO, PlaylistDAO playlistDAO) {
        this.youTubeService = youTubeService;
        this.songDAO = songDAO;
        this.artistDAO = artistDAO;
        this.playlistDAO = playlistDAO;
    }

    @GetMapping
    public String showPage(HttpSession session, Model model) {
        model.addAttribute("currentPage", "admin/youtube-import");
        model.addAttribute("pageTitle", "Import từ YouTube");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }

    @PostMapping("/search")
    public String search(@RequestParam("q") String query, HttpSession session, Model model) {
        List<YouTubeVideo> results = youTubeService.searchVideos(query);
        model.addAttribute("results", results);
        model.addAttribute("query", query);
        model.addAttribute("currentPage", "admin/youtube-import");
        model.addAttribute("pageTitle", "Import từ YouTube");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }

    @PostMapping("/import")
    @Transactional
    public String importSongs(@RequestParam("videoIds") List<String> videoIds,
                              HttpSession session, Model model) {
        if (videoIds == null || videoIds.isEmpty()) {
            return "redirect:/admin/youtube-import";
        }

        int count = 0;
        for (String videoId : videoIds) {
            try {
                YouTubeVideo video = youTubeService.getVideoDetails(videoId);
                if (video == null) continue;

                Artist artist = findOrCreateArtist(video.getChannelTitle());

                Song song = new Song();
                song.setTitle(video.getTitle());
                song.setYoutubeUrl(video.getYoutubeUrl());
                song.setCoverImage(video.getThumbnailUrl());
                song.setDuration(video.getDurationSeconds());
                song.setListensCount(0);
                song.setFileUrl("youtube:" + videoId);
                List<Artist> artists = new ArrayList<>();
                artists.add(artist);
                song.setArtists(artists);
                song.setGenres(new ArrayList<>());
                songDAO.save(song);
                count++;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return "redirect:/admin/youtube-import?imported=" + count;
    }

    private Artist findOrCreateArtist(String name) {
        if (name == null || name.trim().isEmpty()) {
            name = "Unknown Artist";
        }
        name = name.trim();
        Artist existing = artistDAO.findByNameExact(name);
        if (existing != null) return existing;
        Artist artist = new Artist();
        artist.setName(name);
        return artistDAO.save(artist);
    }
}
