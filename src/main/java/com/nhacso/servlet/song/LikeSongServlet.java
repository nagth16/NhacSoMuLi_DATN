package com.nhacso.servlet.song;

import com.nhacso.dao.UserLikeSongDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LikeSongServlet {

    @Autowired
    private UserLikeSongDAO userLikeSongDAO;

    @PostMapping({"/song/like", "/playlist/like-song", "/playlist/song/like"})
    public String handleLikeSong(
            @RequestParam("songId") Integer songId,
            @RequestParam(value = "returnUrl", required = false) String returnUrl,
            HttpSession session) {

        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null || songId == null) {
            return "redirect:/login";
        }

        userLikeSongDAO.toggleLike(userId, songId);

        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            return "redirect:" + returnUrl;
        }
        return "redirect:/";
    }
}
