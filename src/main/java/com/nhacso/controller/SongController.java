package com.nhacso.controller;

import com.nhacso.dao.SongDAO;
import com.nhacso.dao.UserLikeSongDAO;
import com.nhacso.entity.Song;
import com.nhacso.service.YouTubeService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/songs")
public class SongController {

    private final SongDAO songDAO;
    private final YouTubeService youTubeService;
    private final UserLikeSongDAO userLikeSongDAO;

    public SongController(SongDAO songDAO, YouTubeService youTubeService, UserLikeSongDAO userLikeSongDAO) {
        this.songDAO = songDAO;
        this.youTubeService = youTubeService;
        this.userLikeSongDAO = userLikeSongDAO;
    }

    @GetMapping
    public List<Song> getAllSongs() {
        return songDAO.findAllWithArtists();
    }

    @GetMapping("/{id}")
    public Song getSong(@PathVariable Integer id) {
        return songDAO.findById(id)
                .orElseThrow(() -> new RuntimeException("Song not found: " + id));
    }

    @GetMapping("/trending")
    public List<Song> getTrendingSongs() {
        return songDAO.findTopListened(20);
    }

    @GetMapping("/search")
    public ResponseEntity<List<Song>> searchSongs(@RequestParam("q") String keyword) {
        try {
            return ResponseEntity.ok(songDAO.searchByKeyword(keyword));
        } catch (Exception e) {
            return ResponseEntity.ok(Collections.emptyList());
        }
    }

    @GetMapping("/yt-search")
    public ResponseEntity<List<YouTubeService.YouTubeVideo>> searchYouTube(@RequestParam("q") String keyword) {
        try {
            return ResponseEntity.ok(youTubeService.searchVideos(keyword));
        } catch (Exception e) {
            return ResponseEntity.ok(Collections.emptyList());
        }
    }

    @GetMapping("/{id}/like")
    public ResponseEntity<Map<String, Object>> getLikeStatus(@PathVariable Integer id, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        Map<String, Object> res = new HashMap<>();
        res.put("liked", userId != null && userLikeSongDAO.isLiked(userId, id));
        res.put("count", userLikeSongDAO.countLikesForSong(id));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/like-status")
    public ResponseEntity<Map<Integer, Boolean>> getBatchLikeStatus(@RequestBody List<Integer> songIds, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        Map<Integer, Boolean> res = new HashMap<>();
        if (userId == null) {
            songIds.forEach(id -> res.put(id, false));
            return ResponseEntity.ok(res);
        }
        List<Integer> likedIds = userLikeSongDAO.getLikedSongIds(userId);
        Set<Integer> likedSet = likedIds.stream().collect(Collectors.toSet());
        songIds.forEach(id -> res.put(id, likedSet.contains(id)));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/{id}/like")
    public ResponseEntity<Map<String, Object>> toggleLike(@PathVariable Integer id, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        Map<String, Object> res = new HashMap<>();
        if (userId == null) {
            res.put("error", "Chưa đăng nhập");
            return ResponseEntity.status(401).body(res);
        }
        boolean liked = userLikeSongDAO.toggleLike(userId, id);
        res.put("liked", liked);
        res.put("count", userLikeSongDAO.countLikesForSong(id));
        return ResponseEntity.ok(res);
    }
}
