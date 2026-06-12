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
public class AddSongPlaylistServlet{

    @Autowired
    private PlaylistDAO playlistDAO;

    /**
     * Xử lý thêm bài hát vào Playlist cho cả request GET và POST
     * Hỗ trợ 2 urlPatterns cũ: /playlist/add-song và /add-song-playlist
     */
    @RequestMapping(
            value = {"/playlist/add-song", "/add-song-playlist"},
            method = {RequestMethod.GET, RequestMethod.POST}
    )
    public String addSongToPlaylist(
            @RequestParam(value = "playlistId", required = false) Integer playlistId,
            @RequestParam(value = "songId", required = false) Integer songId,
            @RequestParam(value = "returnUrl", required = false) String returnUrl,
            HttpSession session,
            HttpServletResponse response) throws IOException {

        // 1. Kiểm tra trạng thái đăng nhập dựa trên session userId
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            return "redirect:/login";
        }

        // 2. Validate dữ liệu đầu vào (Spring tự động ép kiểu thành Integer)
        if (playlistId == null || songId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "playlistId va songId la bat buoc.");
            return null;
        }

        // 3. Kiểm tra quyền sở hữu playlist
        if (!playlistDAO.isOwner(playlistId, userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen voi playlist nay.");
            return null;
        }

        // 4. Thực thi logic thêm bài hát vào DB
        boolean added = playlistDAO.addSongToPlaylist(playlistId, songId);
        if (!added) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay playlist hoac bai hat.");
            return null;
        }

        // 5. Xử lý logic chuyển hướng (Redirect)
        // Nếu client truyền lên returnUrl hợp lệ (không trống), ta sẽ chuyển hướng về link đó
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            // Trong Spring, nếu redirect về một URL đầy đủ bắt đầu bằng context path (e.g. /NhacSo/playlist/detail),
            // ta có thể dùng redirect trực tiếp hoặc xử lý cắt chuỗi.
            // Cách an toàn và phổ biến nhất là trả về chuỗi redirect thẳng tới returnUrl
            // (vì trong JSTL form bạn đã gắn sẵn ${pageContext.request.contextPath} rồi)
            return "redirect:" + returnUrl;
        }

        // Nếu không có returnUrl mặc định quay về trang chi tiết playlist
        return "redirect:/playlist/detail?id=" + playlistId;
    }
}