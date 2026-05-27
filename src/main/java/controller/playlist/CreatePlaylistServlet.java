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

@WebServlet(name = "CreatePlaylistServlet", urlPatterns = {"/playlist/create", "/create-playlist"})
public class CreatePlaylistServlet extends HttpServlet {
    private final PlaylistDAO playlistDAO = new PlaylistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderForm(response, null, "", "");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Integer userId = currentUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String name = normalize(request.getParameter("name"));
        String description = normalize(request.getParameter("description"));

        if (isBlank(name)) {
            renderForm(response, "Ten playlist la bat buoc.", name, description);
            return;
        }
        if (name.length() > 150) {
            renderForm(response, "Ten playlist khong duoc qua 150 ky tu.", name, description);
            return;
        }
        if (description != null && description.length() > 500) {
            renderForm(response, "Mo ta khong duoc qua 500 ky tu.", name, description);
            return;
        }

        Playlist playlist = playlistDAO.create(name, description, userId);
        response.sendRedirect(request.getContextPath() + "/playlist/detail?id=" + playlist.getPlaylistId());
    }

    private void renderForm(HttpServletResponse response, String errorMessage, String name, String description)
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Tao playlist</title></head><body>");
            out.println("<h2>Tao playlist</h2>");
            if (!isBlank(errorMessage)) {
                out.println("<p style='color:red;'>" + escapeHtml(errorMessage) + "</p>");
            }
            out.println("<form method='post'>");
            out.println("Ten playlist: <input type='text' name='name' maxlength='150' value='" + escapeHtml(name) + "'><br><br>");
            out.println("Mo ta: <textarea name='description' maxlength='500'>" + escapeHtml(description) + "</textarea><br><br>");
            out.println("<button type='submit'>Tao playlist</button>");
            out.println("</form>");
            out.println("</body></html>");
        }
    }

    private Integer currentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object value = session == null ? null : session.getAttribute("userId");
        return value instanceof Integer ? (Integer) value : null;
    }

    private String normalize(String value) {
        return value == null ? null : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String escapeHtml(String value) {
        return value == null ? "" : value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
