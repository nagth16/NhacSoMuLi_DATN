<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
</head>
<body>
<h2>Trang chu</h2>
<%
    String username = (String) session.getAttribute("username");
%>
<% if (username != null) { %>
<p>Xin chao, <%= username %></p>
<p><a href="logout">Dang xuat</a></p>
<% } else { %>
<p><a href="register">Dang ky</a></p>
<p><a href="login">Dang nhap</a></p>
<% } %>
</body>
</html>
