package com.nhacso.servlet.admin;

import com.nhacso.dao.*;
import com.nhacso.entity.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/songs")
public class AdminSongController {

    private final SongDAO songDAO;
    private final ArtistDAO artistDAO;
    private final AlbumDAO albumDAO;
    private final GenreDAO genreDAO;
    private final PlaylistDAO playlistDAO;

    public AdminSongController(SongDAO songDAO, ArtistDAO artistDAO, AlbumDAO albumDAO, GenreDAO genreDAO, PlaylistDAO playlistDAO) {
        this.songDAO = songDAO;
        this.artistDAO = artistDAO;
        this.albumDAO = albumDAO;
        this.genreDAO = genreDAO;
        this.playlistDAO = playlistDAO;
    }

    @GetMapping
    public String listSongs(
            @RequestParam(value = "q", required = false) String keyword,
            HttpSession session, Model model) {
        List<Song> songs;
        if (keyword != null && !keyword.trim().isEmpty()) {
            songs = songDAO.findByTitle(keyword.trim());
        } else {
            songs = songDAO.findAllWithArtists();
        }
        model.addAttribute("songs", songs);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentPage", "admin/song-list");
        model.addAttribute("pageTitle", "Quản lý nhạc hot");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }

    @GetMapping("/create")
    public String createSong(HttpSession session, Model model) {
        model.addAttribute("song", new Song());
        model.addAttribute("songArtistIds", Collections.emptySet());
        model.addAttribute("songGenreIds", Collections.emptySet());
        model.addAttribute("allArtists", artistDAO.findAll());
        model.addAttribute("allAlbums", albumDAO.findAll());
        model.addAttribute("allGenres", genreDAO.findAll());
        model.addAttribute("currentPage", "admin/song-form");
        model.addAttribute("pageTitle", "Thêm nhạc hot mới");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }

    @GetMapping("/edit")
    public String editSong(@RequestParam("id") Integer id, HttpSession session, Model model) {
        Song song = songDAO.findById(id).orElse(null);
        if (song == null) {
            return "redirect:/admin/songs";
        }
        // Eagerly load lazy collections for JSP rendering
        if (song.getArtists() != null) song.getArtists().size();
        if (song.getGenres() != null) song.getGenres().size();

        Set<Integer> songArtistIds = song.getArtists() != null
                ? song.getArtists().stream().map(Artist::getArtistId).collect(Collectors.toSet())
                : Collections.emptySet();
        Set<Integer> songGenreIds = song.getGenres() != null
                ? song.getGenres().stream().map(Genre::getGenreId).collect(Collectors.toSet())
                : Collections.emptySet();

        model.addAttribute("song", song);
        model.addAttribute("songArtistIds", songArtistIds);
        model.addAttribute("songGenreIds", songGenreIds);
        model.addAttribute("allArtists", artistDAO.findAll());
        model.addAttribute("allAlbums", albumDAO.findAll());
        model.addAttribute("allGenres", genreDAO.findAll());
        model.addAttribute("currentPage", "admin/song-form");
        model.addAttribute("pageTitle", "Chỉnh sửa nhạc hot");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }

    @PostMapping("/save")
    @Transactional
    public String saveSong(
            @RequestParam(value = "songId", required = false) Integer songId,
            @RequestParam("title") String title,
            @RequestParam(value = "duration", required = false) Integer duration,
            @RequestParam(value = "fileUrl", required = false) String fileUrl,
            @RequestParam(value = "streamUrl", required = false) String streamUrl,
            @RequestParam(value = "youtubeUrl", required = false) String youtubeUrl,
            @RequestParam(value = "coverImage", required = false) String coverImage,
            @RequestParam(value = "albumId", required = false) Integer albumId,
            @RequestParam(value = "artistIds", required = false) List<Integer> artistIds,
            @RequestParam(value = "genreIds", required = false) List<Integer> genreIds) {

        Song song;
        boolean isNew = (songId == null || songId == 0);
        if (isNew) {
            song = new Song();
            song.setListensCount(0);
        } else {
            song = songDAO.findById(songId).orElse(null);
            if (song == null) return "redirect:/admin/songs";
        }

        song.setTitle(title);
        song.setDuration(duration);
        song.setFileUrl(fileUrl);
        song.setStreamUrl(streamUrl);
        song.setYoutubeUrl(youtubeUrl);
        song.setCoverImage(coverImage);

        if (albumId != null) {
            Album album = albumDAO.findById(albumId).orElse(null);
            song.setAlbum(album);
        } else {
            song.setAlbum(null);
        }

        if (artistIds != null && !artistIds.isEmpty()) {
            List<Artist> artists = artistIds.stream()
                    .map(id -> artistDAO.findById(id).orElse(null))
                    .filter(a -> a != null)
                    .collect(Collectors.toList());
            song.setArtists(artists);
        } else if (isNew) {
            song.setArtists(new ArrayList<>());
        }

        if (genreIds != null && !genreIds.isEmpty()) {
            List<Genre> genres = genreIds.stream()
                    .map(id -> genreDAO.findById(id).orElse(null))
                    .filter(g -> g != null)
                    .collect(Collectors.toList());
            song.setGenres(genres);
        } else if (isNew) {
            song.setGenres(new ArrayList<>());
        }

        songDAO.save(song);
        return "redirect:/admin/songs";
    }

    @GetMapping("/delete")
    public String deleteSong(@RequestParam("id") Integer id) {
        songDAO.delete(id);
        return "redirect:/admin/songs";
    }
}
