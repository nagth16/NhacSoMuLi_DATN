package com.nhacso.servlet.playlist;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.SongDAO;
import com.nhacso.entity.Playlist;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.List;

@Controller
public class PlaylistDetailServlet {

    @Autowired
    private PlaylistDAO playlistDAO;

    @Autowired
    private SongDAO songDAO;

    /**
     * Xử lý hiển thị chi tiết playlist (Thay thế cho doGet)
     */
    @GetMapping("/playlist/detail")
    public String getPlaylistDetail(
            @RequestParam(value = "id", required = false) Integer playlistId,
            HttpSession session,
            Model model,
            HttpServletResponse response) throws IOException {

        // 1. Kiểm tra đăng nhập qua session 'userId' giống hệt hàm currentUserId cũ
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            return "redirect:/login";
        }

        // 2. Kiểm tra ID playlist truyền vào (Spring tự chuyển String -> Integer giúp bạn)
        if (playlistId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "id la bat buoc.");
            return null;
        }

        // 3. Kiểm tra quyền sở hữu và lấy thông tin Playlist
        boolean isOwner = playlistDAO.isOwner(playlistId, userId);
        if (!isOwner) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay playlist.");
            return null;
        }

        // 4. Lấy Playlist và danh sách bài hát
        Playlist playlist = playlistDAO.getPlaylistById(playlistId);
        model.addAttribute("playlist", playlist);
        model.addAttribute("songs", playlistDAO.getSongsByPlaylistId(playlistId));

        // Truyền thêm cả class hiện tại vào view để gọi hàm formatDuration trực tiếp trên JSP nếu cần
        model.addAttribute("playlistDetailController", this);
        model.addAttribute("currentPage", "user/playlist-detail");
        model.addAttribute("pageTitle", playlist.getName());

        List<Playlist> userPlaylists = playlistDAO.getPlaylistsByUserId(userId);
        model.addAttribute("playlists", userPlaylists);

        return "user/home";
    }

    /**
     * Hàm định dạng thời lượng bài hát (Giữ nguyên từ code cũ của bạn)
     */
    public String formatDuration(Integer duration) {
        if (duration == null || duration < 0) {
            return "";
        }
        int minutes = duration / 60;
        int seconds = duration % 60;
        return String.format("%d:%02d", minutes, seconds);
    }
}
