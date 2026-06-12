package com.nhacso.servlet.playlist;

import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.UserDAO;
import com.nhacso.entity.Playlist;
import com.nhacso.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class CreatePlaylistServlet {

    @Autowired
    private PlaylistDAO playlistDAO;

    @Autowired
    private UserDAO userDAO;

    /**
     * Hiển thị Form tạo Playlist mới - chuyển hướng về trang playlist
     */
    @GetMapping({"/playlist/create", "/create-playlist"})
    public String showCreateForm() {
        return "redirect:/playlist";
    }

    /**
     * Xử lý dữ liệu gửi lên để tạo Playlist
     */
    @PostMapping({"/playlist/create", "/create-playlist"})
    @Transactional
    public String processCreatePlaylist(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "description", required = false) String description,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        // 1. Kiểm tra trạng thái đăng nhập
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            return "redirect:/login";
        }

        // 2. Chuẩn hóa dữ liệu
        name = (name == null) ? "" : name.trim();
        description = (description == null) ? "" : description.trim();

        // 3. Kiểm tra tính hợp lệ của dữ liệu (Validation)
        if (name.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tên playlist là bắt buộc.");
            redirectAttributes.addFlashAttribute("name", name);
            redirectAttributes.addFlashAttribute("description", description);
            return "redirect:/playlist";
        }
        if (name.length() > 150) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tên playlist không được quá 150 ký tự.");
            redirectAttributes.addFlashAttribute("name", name);
            redirectAttributes.addFlashAttribute("description", description);
            return "redirect:/playlist";
        }
        if (description.length() > 500) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mô tả không được quá 500 ký tự.");
            redirectAttributes.addFlashAttribute("name", name);
            redirectAttributes.addFlashAttribute("description", description);
            return "redirect:/playlist";
        }

        // 4. Kiểm tra trùng tên playlist
        if (playlistDAO.isNameTaken(name, userId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn đã có playlist với tên này rồi. Vui lòng chọn tên khác.");
            redirectAttributes.addFlashAttribute("name", name);
            redirectAttributes.addFlashAttribute("description", description);
            return "redirect:/playlist";
        }

        // 5. Tạo đối tượng Playlist và lưu xuống database
        User user = userDAO.findById(userId);
        if (user == null) {
            return "redirect:/login";
        }
        Playlist playlist = new Playlist();
        playlist.setName(name);
        playlist.setDescription(description);
        playlist.setUser(user);
        int playlistId = playlistDAO.createPlaylist(playlist);

        // Điều hướng sang trang chi tiết của playlist vừa tạo thành công
        return "redirect:/playlist/detail?id=" + playlistId;
    }
}
