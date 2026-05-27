package controller.song;

import dao.SongDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;

@WebServlet(name = "LikeSongServlet", urlPatterns = {"/song/like", "/like-song"})
public class LikeSongServlet extends HttpServlet {
    private static final String LIKED_SONG_IDS = "likedSongIds";
    private final SongDAO songDAO = new SongDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer songId = parseInt(request.getParameter("songId"));
        if (songId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "songId la bat buoc.");
            return;
        }
        if (songDAO.findById(songId) == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay bai hat.");
            return;
        }

        Set<Integer> likedSongIds = likedSongIds(session);
        boolean liked;
        if (likedSongIds.contains(songId)) {
            likedSongIds.remove(songId);
            liked = false;
        } else {
            likedSongIds.add(songId);
            liked = true;
        }

        String ajax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(ajax)) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"songId\":" + songId + ",\"liked\":" + liked + "}");
            return;
        }

        response.sendRedirect(resolveReturnUrl(request, songId));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @SuppressWarnings("unchecked")
    private Set<Integer> likedSongIds(HttpSession session) {
        Object value = session.getAttribute(LIKED_SONG_IDS);
        if (value instanceof Set<?>) {
            return (Set<Integer>) value;
        }

        Set<Integer> likedSongIds = new LinkedHashSet<>();
        session.setAttribute(LIKED_SONG_IDS, likedSongIds);
        return likedSongIds;
    }

    private String resolveReturnUrl(HttpServletRequest request, Integer songId) {
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl != null && returnUrl.startsWith(request.getContextPath() + "/")) {
            return returnUrl;
        }
        return request.getContextPath() + "/song/detail?id=" + songId;
    }

    private Integer parseInt(String value) {
        try {
            return value == null ? null : Integer.valueOf(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
