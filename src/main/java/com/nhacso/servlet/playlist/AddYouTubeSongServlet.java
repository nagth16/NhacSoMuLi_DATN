package com.nhacso.servlet.playlist;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.SongDAO;
import com.nhacso.entity.Song;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
public class AddYouTubeSongServlet {

    private final SongDAO songDAO;
    private final PlaylistDAO playlistDAO;

    public AddYouTubeSongServlet(SongDAO songDAO, PlaylistDAO playlistDAO) {
        this.songDAO = songDAO;
        this.playlistDAO = playlistDAO;
    }

    @PostMapping("/playlist/add-youtube-song")
    @ResponseBody
    public Map<String, Object> addYouTubeSong(
            @RequestParam("playlistId") Integer playlistId,
            @RequestParam("videoId") String videoId,
            @RequestParam("title") String title,
            @RequestParam("channelTitle") String channelTitle,
            @RequestParam(value = "thumbnailUrl", required = false) String thumbnailUrl,
            HttpSession session) {

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) {
            return Map.of("success", false, "error", "Chưa đăng nhập");
        }

        if (!playlistDAO.isOwner(playlistId, userId)) {
            return Map.of("success", false, "error", "Không có quyền với playlist này");
        }

        Song song = new Song();
        song.setTitle(title);
        song.setYoutubeUrl("https://www.youtube.com/watch?v=" + videoId);
        song.setCoverImage(thumbnailUrl != null ? thumbnailUrl : "");
        song.setFileUrl("");
        song.setStreamUrl("");
        song.setDuration(0);
        song.setListensCount(0);

        Song saved = songDAO.save(song);
        if (saved == null || saved.getSongId() == null) {
            return Map.of("success", false, "error", "Không thể tạo bài hát");
        }

        boolean added = playlistDAO.addSongToPlaylist(playlistId, saved.getSongId());
        if (!added) {
            return Map.of("success", false, "error", "Không thể thêm vào playlist");
        }

        return Map.of("success", true, "songId", saved.getSongId());
    }
}
