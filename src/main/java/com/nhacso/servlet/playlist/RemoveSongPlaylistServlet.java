package com.nhacso.servlet.playlist;

import com.nhacso.dao.PlaylistDAO;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;

@Controller
public class RemoveSongPlaylistServlet {

    @Autowired
    private PlaylistDAO playlistDAO;

    /**
     * Xử lý xóa bài hát khỏi Playlist cho cả request GET và POST
     * Hỗ trợ 2 urlPatterns cũ: /playlist/remove-song và /remove-song-playlist
     */
    @RequestMapping(
            value = {"/playlist/remove-song", "/remove-song-playlist"},
            method = {RequestMethod.GET, RequestMethod.POST}
    )
    public String removeSongFromPlaylist(
            @RequestParam(value = "playlistId", required = false) Integer playlistId,
            @RequestParam(value = "songId", required = false) Integer songId,
            @RequestParam(value = "returnUrl", required = false) String returnUrl,
            HttpSession session,
            HttpServletResponse response) throws IOException {

        // 1. Kiểm tra trạng thái đăng nhập qua session userId
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            return "redirect:/login";
        }

        // 2. Kiểm tra dữ liệu đầu vào (Spring Boot tự ép kiểu tự động)
        if (playlistId == null || songId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "playlistId va songId la bat buoc.");
            return null;
        }

        // 3. Kiểm tra quyền sở hữu playlist
        if (!playlistDAO.isOwner(playlistId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen voi playlist nay.");
            return null;
        }

        // 4. Thực thi logic xóa bài hát thông qua PlaylistDAO
        boolean removed = playlistDAO.removeSongFromPlaylist(playlistId, songId);
        if (!removed) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay playlist hoac bai hat.");
            return null;
        }

        // 5. Xử lý chuyển hướng quay lại giao diện cũ (Redirect)
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            return "redirect:" + returnUrl;
        }

        // Nếu không nhận được returnUrl, mặc định quay lại trang chi tiết playlist hiện tại
        return "redirect:/playlist/detail?id=" + playlistId;
    }
}