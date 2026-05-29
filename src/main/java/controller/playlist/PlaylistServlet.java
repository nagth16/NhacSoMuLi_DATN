package controller.playlist;

import dao.PlaylistDAO;
import entity.Playlist;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "PlaylistServlet", urlPatterns = {"/playlist", "/playlists"})
public class PlaylistServlet extends HttpServlet {
    private final PlaylistDAO playlistDAO = new PlaylistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = currentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Playlist> playlists = playlistDAO.findByUser(userId);
        render(response, request.getContextPath(), playlists);
    }

    private void render(HttpServletResponse response, String contextPath, List<Playlist> playlists)
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><meta charset='UTF-8'><title>Playlist cua toi</title></head><body>");
            out.println("<h2>Playlist cua toi</h2>");
            out.println("<p><a href='" + contextPath + "/playlist/create'>Tao playlist moi</a></p>");

            if (playlists.isEmpty()) {
                out.println("<p>Ban chua co playlist nao.</p>");
            } else {
                out.println("<ul>");
                for (Playlist playlist : playlists) {
                    out.println("<li>");
                    out.println("<a href='" + contextPath + "/playlist/detail?id=" + playlist.getPlaylistId() + "'>"
                            + escapeHtml(playlist.getName()) + "</a>");
                    if (playlist.getDescription() != null && !playlist.getDescription().trim().isEmpty()) {
                        out.println(" - " + escapeHtml(playlist.getDescription()));
                    }
                    out.println("</li>");
                }
                out.println("</ul>");
            }

            out.println("<p><a href='" + contextPath + "/'>Ve trang chu</a></p>");
            out.println("</body></html>");
        }
    }

    private Integer currentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object value = session == null ? null : session.getAttribute("userId");
        return value instanceof Integer ? (Integer) value : null;
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
