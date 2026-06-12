package com.nhacso.servlet.playlist;

import com.nhacso.dao.PlaylistDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class DeletePlaylistServlet {

    @Autowired
    private PlaylistDAO playlistDAO;

    @PostMapping("/playlist/delete")
    public String processDeletePlaylist(
            @RequestParam("id") int playlistId,
            HttpSession session) {

        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            return "redirect:/login";
        }

        playlistDAO.deletePlaylist(playlistId, userId);

        return "redirect:/playlist";
    }
}
