<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MuLi — Đăng nhập</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
:root{--bg:#121212;--surface:#181818;--surface2:#282828;--accent:#1DB954;--accent-hover:#1ed760;--text:#ffffff;--muted:#b3b3b3;--dim:#7a7a8c;--radius:8px}
*,::before,::after{box-sizing:border-box;margin:0;padding:0}
html,body{height:100%}
body{font-family:"Inter","Helvetica Neue",Arial,sans-serif;background:var(--bg);color:var(--text);display:flex;align-items:center;justify-content:center;min-height:100vh}
a{color:inherit;text-decoration:none}
.auth-wrap{width:100%;max-width:440px;padding:32px 24px}
.logo{display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:40px}
.logo svg{width:36px;height:36px;fill:var(--accent)}
.logo span{font-size:24px;font-weight:800;letter-spacing:-.5px}
.auth-card{background:var(--surface);border-radius:var(--radius);padding:32px}
.auth-title{font-size:28px;font-weight:700;text-align:center;margin-bottom:4px}
.auth-sub{font-size:14px;color:var(--muted);text-align:center;margin-bottom:28px}
.alert{padding:12px 14px;border-radius:var(--radius);font-size:13px;margin-bottom:20px;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(255,70,70,.1);border:1px solid rgba(255,70,70,.3);color:#ff6b6b}
.alert-success{background:rgba(29,185,84,.1);border:1px solid rgba(29,185,84,.3);color:var(--accent)}
.field{margin-bottom:16px}
label{display:block;font-size:13px;font-weight:600;color:var(--text);margin-bottom:6px}
input[type=email],input[type=password]{width:100%;height:46px;background:rgba(255,255,255,.06);border:1px solid var(--surface2);border-radius:var(--radius);color:var(--text);font-family:inherit;font-size:14px;padding:0 14px;outline:none;transition:border-color .2s}
input:focus{border-color:var(--accent)}
input::placeholder{color:var(--dim)}
.forgot-row{display:flex;justify-content:flex-end;margin-bottom:20px}
.forgot-link{font-size:13px;font-weight:500;color:var(--muted);transition:color .15s}
.forgot-link:hover{color:var(--text)}
.btn-primary{width:100%;height:46px;border-radius:100px;background:var(--accent);border:none;color:#000;font-family:inherit;font-size:15px;font-weight:700;cursor:pointer;transition:all .15s;display:flex;align-items:center;justify-content:center}
.btn-primary:hover{background:var(--accent-hover);transform:scale(1.02)}
.btn-primary:active{transform:scale(1)}
.divider{display:flex;align-items:center;gap:12px;margin:22px 0;color:var(--muted);font-size:12px}
.divider::before,.divider::after{content:'';flex:1;height:1px;background:var(--surface2)}
.switch-note{font-size:14px;color:var(--muted);text-align:center;margin-top:22px}
.switch-note a{color:var(--text);font-weight:600;transition:color .15s}
.switch-note a:hover{color:var(--accent)}
@media(max-width:480px){.auth-wrap{padding:16px}.auth-card{padding:24px}}
</style>
</head>
<body>
<%
  String errorMsg   = (String) request.getAttribute("errorMsg");
  String successMsg = (String) request.getAttribute("successMsg");
  String savedEmail = (String) request.getAttribute("savedEmail");
  if (savedEmail == null) savedEmail = "";
%>

<div class="auth-wrap">
  <a href="${pageContext.request.contextPath}/" class="logo">
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 0C5.372 0 0 5.373 0 12s5.372 12 12 12 12-5.373 12-12S18.628 0 12 0zm5.507 17.31a.748.748 0 0 1-1.03.25c-2.821-1.725-6.372-2.114-10.557-1.158a.748.748 0 1 1-.333-1.459c4.579-1.047 8.509-.597 11.671 1.338a.748.748 0 0 1 .249 1.029zm1.47-3.267a.936.936 0 0 1-1.288.308C14.82 12.26 10.87 11.7 7.815 12.6a.936.936 0 0 1-.573-1.786c3.47-1.017 7.833-.453 10.843 1.64a.937.937 0 0 1 .892 1.589zm.127-3.401C15.533 8.38 10.36 8.19 7.235 9.126a1.124 1.124 0 1 1-.652-2.15c3.584-1.087 9.546-.877 13.313 1.454a1.125 1.125 0 0 1-1.792 1.212z"/></svg>
    <span>MuLi</span>
  </a>

  <div class="auth-card">
    <h1 class="auth-title">Đăng nhập</h1>
    <p class="auth-sub">Đăng nhập để tiếp tục nghe nhạc</p>

    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= errorMsg %></div>
    <% } %>
    <% if (successMsg != null && !successMsg.isEmpty()) { %>
      <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= successMsg %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <div class="field">
        <label for="login-email">Email</label>
        <input type="email" name="email" id="login-email" placeholder="hello@example.com" value="<%= savedEmail %>" required>
      </div>
      <div class="field">
        <label for="login-password">Mật khẩu</label>
        <input type="password" name="password" id="login-password" placeholder="Nhập mật khẩu" required>
      </div>
      <div class="forgot-row">
        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Quên mật khẩu?</a>
      </div>
      <button type="submit" class="btn-primary">Đăng nhập</button>
    </form>

    <div class="divider">hoặc</div>

    <p class="switch-note">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a></p>
  </div>
</div>
</body>
</html>
