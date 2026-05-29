package controller.playlist;

import dao.PlaylistDAO;
import dao.SongDAO;
import entity.Playlist;
import entity.Song;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Set;

@WebServlet(name = "PlaylistDetailServlet", urlPatterns = "/playlist/detail")
public class PlaylistDetailServlet extends HttpServlet {
    private final PlaylistDAO playlistDAO = new PlaylistDAO();
    private final SongDAO songDAO = new SongDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = currentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer playlistId = parseInt(request.getParameter("id"));
        if (playlistId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "id la bat buoc.");
            return;
        }

        Playlist playlist = playlistDAO.findOwnedByIdWithSongs(playlistId, userId);
        if (playlist == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay playlist.");
            return;
        }

        render(response, request.getContextPath(), playlist, songDAO.findAll());
    }

    private void render(HttpServletResponse response, String contextPath, Playlist playlist, List<Song> allSongs)
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><meta charset='UTF-8'><title>"
                    + escapeHtml(playlist.getName()) + "</title></head><body>");
            out.println("<h2>" + escapeHtml(playlist.getName()) + "</h2>");
            if (playlist.getDescription() != null && !playlist.getDescription().trim().isEmpty()) {
                out.println("<p>" + escapeHtml(playlist.getDescription()) + "</p>");
            }

            out.println("<h3>Bai hat trong playlist</h3>");
            Set<Song> songs = playlist.getSongs();
            if (songs == null || songs.isEmpty()) {
                out.println("<p>Playlist nay chua co bai hat.</p>");
            } else {
                out.println("<table border='1' cellpadding='6' cellspacing='0'>");
                out.println("<tr><th>Ten bai hat</th><th>Thoi luong</th><th>Luot nghe</th><th>Thao tac</th></tr>");
                for (Song song : songs) {
                    out.println("<tr>");
                    out.println("<td>" + escapeHtml(song.getTitle()) + "</td>");
                    out.println("<td>" + formatDuration(song.getDuration()) + "</td>");
                    out.println("<td>" + (song.getListensCount() == null ? 0 : song.getListensCount()) + "</td>");
                    out.println("<td>");
                    out.println("<form method='post' action='" + contextPath + "/playlist/remove-song' style='display:inline'>");
                    out.println("<input type='hidden' name='playlistId' value='" + playlist.getPlaylistId() + "'>");
                    out.println("<input type='hidden' name='songId' value='" + song.getSongId() + "'>");
                    out.println("<input type='hidden' name='returnUrl' value='" + contextPath
                            + "/playlist/detail?id=" + playlist.getPlaylistId() + "'>");
                    out.println("<button type='submit'>Xoa</button>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }

            out.println("<h3>Them bai hat</h3>");
            out.println("<form method='post' action='" + contextPath + "/playlist/add-song'>");
            out.println("<input type='hidden' name='playlistId' value='" + playlist.getPlaylistId() + "'>");
            out.println("<input type='hidden' name='returnUrl' value='" + contextPath
                    + "/playlist/detail?id=" + playlist.getPlaylistId() + "'>");
            out.println("<select name='songId'>");
            for (Song song : allSongs) {
                out.println("<option value='" + song.getSongId() + "'>" + escapeHtml(song.getTitle()) + "</option>");
            }
            out.println("</select>");
            out.println("<button type='submit'>Them</button>");
            out.println("</form>");

            out.println("<p><a href='" + contextPath + "/playlist'>Quay lai danh sach playlist</a></p>");
            out.println("</body></html>");
        }
    }

    private String formatDuration(Integer duration) {
        if (duration == null || duration < 0) {
            return "";
        }
        int minutes = duration / 60;
        int seconds = duration % 60;
        return String.format("%d:%02d", minutes, seconds);
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

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
