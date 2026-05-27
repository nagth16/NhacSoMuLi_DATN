package controller.auth;

import dao.UserDAO;
import entity.User;
import utils.PasswordUtils;

import java.io.IOException;
import java.io.PrintWriter;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderForm(response, null, "", "", "");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = normalize(request.getParameter("username"));
        String fullName = normalize(request.getParameter("fullName"));
        String email = normalize(request.getParameter("email"));
        String password = request.getParameter("password");

        if (isBlank(username) || isBlank(email) || isBlank(password)) {
            renderForm(response, "Username, email va password la bat buoc.", username, fullName, email);
            return;
        }

        if (userDAO.findByUsername(username) != null) {
            renderForm(response, "Username da ton tai.", username, fullName, email);
            return;
        }

        if (userDAO.findByEmail(email) != null) {
            renderForm(response, "Email da duoc su dung.", username, fullName, email);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtils.hashPassword(password));
        user.setEmail(email);
        user.setFullName(fullName);
        user.setRole("USER");
        user.setStatus(1);

        try {
            userDAO.create(user);
        } catch (PersistenceException ex) {
            renderForm(response, "Khong the tao tai khoan. Vui long thu lai.", username, fullName, email);
            return;
        }

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Register Success</title></head><body>");
            out.println("<h2>Register successful</h2>");
            out.println("<p>Welcome, " + escapeHtml(isBlank(fullName) ? username : fullName) + ".</p>");
            out.println("<p><a href='login?username=" + escapeHtml(username) + "'>Go to login</a></p>");
            out.println("</body></html>");
        }
    }

    private void renderForm(HttpServletResponse response, String errorMessage, String username, String fullName, String email)
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Register</title></head><body>");
            out.println("<h2>Register</h2>");
            if (!isBlank(errorMessage)) {
                out.println("<p style='color:red;'>" + escapeHtml(errorMessage) + "</p>");
            }
            out.println("<form method='post' action='register'>");
            out.println("Username: <input type='text' name='username' value='" + escapeHtml(username) + "'><br><br>");
            out.println("Full name: <input type='text' name='fullName' value='" + escapeHtml(fullName) + "'><br><br>");
            out.println("Email: <input type='email' name='email' value='" + escapeHtml(email) + "'><br><br>");
            out.println("Password: <input type='password' name='password'><br><br>");
            out.println("<button type='submit'>Register</button>");
            out.println("</form>");
            out.println("<p><a href='login'>Da co tai khoan? Dang nhap</a></p>");
            out.println("</body></html>");
        }
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
