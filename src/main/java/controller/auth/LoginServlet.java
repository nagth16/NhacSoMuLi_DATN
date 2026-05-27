package controller.auth;

import dao.UserDAO;
import entity.User;
import utils.PasswordUtils;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderForm(response, null, request.getParameter("username"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = normalize(request.getParameter("username"));
        String password = request.getParameter("password");

        if (isBlank(username) || isBlank(password)) {
            renderForm(response, "Username/email va password la bat buoc.", username);
            return;
        }

        User user = userDAO.findByUsernameOrEmail(username);
        if (user == null || !PasswordUtils.matches(password, user.getPassword())) {
            renderForm(response, "Thong tin dang nhap khong dung.", username);
            return;
        }

        if (user.getStatus() != null && user.getStatus() == 0) {
            renderForm(response, "Tai khoan da bi khoa.", username);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("username", user.getUsername());
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("role", user.getRole());

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Login Success</title></head><body>");
            out.println("<h2>Login successful</h2>");
            out.println("<p>Hello, " + escapeHtml(displayName(user)) + ".</p>");
            out.println("<p>Role: " + escapeHtml(user.getRole()) + "</p>");
            out.println("<p><a href='index.jsp'>Ve trang chu</a></p>");
            out.println("<p><a href='logout'>Dang xuat</a></p>");
            out.println("</body></html>");
        }
    }

    private void renderForm(HttpServletResponse response, String errorMessage, String username)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Login</title></head><body>");
            out.println("<h2>Login</h2>");
            if (!isBlank(errorMessage)) {
                out.println("<p style='color:red;'>" + escapeHtml(errorMessage) + "</p>");
            }
            out.println("<form method='post' action='login'>");
            out.println("Username hoac Email: <input type='text' name='username' value='" + escapeHtml(username) + "'><br><br>");
            out.println("Password: <input type='password' name='password'><br><br>");
            out.println("<button type='submit'>Login</button>");
            out.println("</form>");
            out.println("<p><a href='register'>Dang ky tai khoan</a></p>");
            out.println("</body></html>");
        }
    }

    private String displayName(User user) {
        return isBlank(user.getFullName()) ? user.getUsername() : user.getFullName();
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
