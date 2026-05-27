package controller.playlist;

import dao.PlaylistDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AddSongPlaylistServlet", urlPatterns = {"/playlist/add-song", "/add-song-playlist"})
public class AddSongPlaylistServlet extends HttpServlet {
    private final PlaylistDAO playlistDAO = new PlaylistDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Integer userId = currentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer playlistId = parseInt(request.getParameter("playlistId"));
        Integer songId = parseInt(request.getParameter("songId"));
        if (playlistId == null || songId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "playlistId va songId la bat buoc.");
            return;
        }

        boolean added = playlistDAO.addSong(playlistId, songId, userId);
        if (!added) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay playlist hoac bai hat.");
            return;
        }

        response.sendRedirect(resolveReturnUrl(request, playlistId));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    private String resolveReturnUrl(HttpServletRequest request, Integer playlistId) {
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl != null && returnUrl.startsWith(request.getContextPath() + "/")) {
            return returnUrl;
        }
        return request.getContextPath() + "/playlist/detail?id=" + playlistId;
    }

    private Integer currentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object value = session == null ? null : session.getAttribute("userId");
        return value instanceof Integer ? (Integer) value : null;
    }

    private Integer parseInt(String value) {
        try {
            return value == null ? null : Integer.valueOf(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
