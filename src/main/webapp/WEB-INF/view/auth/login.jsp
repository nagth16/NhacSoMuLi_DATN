<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MuLi — Đăng nhập</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
  :root {
    --bg:       #080a0f;
    --card:     #111520;
    --border:   #1c2236;
    --accent:   #6c63ff;
    --accent2:  #ff5fa0;
    --glow:     rgba(108,99,255,0.35);
    --text:     #eef0f6;
    --muted:    #5a6282;  
    --input-bg: #0b0e18;
    --error:    #ff5f5f;
    --success:  #36d9a0;
  }
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    background: var(--bg);
    font-family: 'DM Sans', sans-serif;
    color: var(--text);
    min-height: 100vh;
    display: flex;
    overflow: hidden;
  }

  /* ── LEFT ── */
  .left-panel {
    flex: 1; position: relative;
    display: flex; flex-direction: column; justify-content: center;
    padding: 60px; overflow: hidden;
  }
  .bg-gradient {
    position: absolute; inset: 0; z-index: 0;
    background:
      radial-gradient(ellipse 80% 80% at 20% 50%, rgba(108,99,255,0.18) 0%, transparent 60%),
      radial-gradient(ellipse 60% 60% at 80% 20%, rgba(255,95,160,0.12) 0%, transparent 55%),
      radial-gradient(ellipse 50% 50% at 60% 80%, rgba(54,217,160,0.08) 0%, transparent 50%);
  }
  .vinyl-art {
    position: absolute; right: -80px; top: 50%;
    transform: translateY(-50%);
    width: 420px; height: 420px; border-radius: 50%;
    background:
      radial-gradient(circle at center, #1a1040 0%, #0d0820 30%, #080a0f 50%),
      conic-gradient(from 0deg, #1c1c2e, #2a1a3e, #1c1c2e, #2a1a3e, #1c1c2e);
    box-shadow: 0 0 0 2px #1c2236, 0 0 60px rgba(108,99,255,0.2), inset 0 0 40px rgba(0,0,0,0.6);
    animation: spin 24s linear infinite; opacity: 0.6;
  }
  .vinyl-art::before {
    content: ''; position: absolute; top: 50%; left: 50%;
    transform: translate(-50%,-50%);
    width: 80px; height: 80px; border-radius: 50%;
    background: var(--bg); border: 2px solid #1c2236;
  }
  .vinyl-art::after {
    content: ''; position: absolute; top: 50%; left: 50%;
    transform: translate(-50%,-50%);
    width: 12px; height: 12px; border-radius: 50%;
    background: var(--accent); box-shadow: 0 0 10px var(--accent);
  }
  @keyframes spin { to { transform: translateY(-50%) rotate(360deg); } }

  .left-content { position: relative; z-index: 1; max-width: 420px; }
  .logo {
    display: flex; align-items: center; gap: 10px;
    margin-bottom: 56px; text-decoration: none;
  }
  .logo-icon {
    width: 38px; height: 38px;
    background: linear-gradient(135deg, var(--accent), var(--accent2));
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 18px; box-shadow: 0 0 20px var(--glow);
  }
  .logo-text {
    font-family: 'Syne', sans-serif; font-size: 22px; font-weight: 800;
    background: linear-gradient(90deg, #fff, #a09af0);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  }
  .left-headline {
    font-family: 'Syne', sans-serif; font-size: 46px; font-weight: 800;
    line-height: 1.08; letter-spacing: -2px; margin-bottom: 18px;
  }
  .left-headline .hl {
    background: linear-gradient(90deg, var(--accent), var(--accent2));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  }
  .left-sub { font-size: 15px; color: var(--muted); line-height: 1.7; max-width: 320px; margin-bottom: 40px; }
  .stats-row { display: flex; gap: 28px; }
  .stat-num { font-family: 'Syne', sans-serif; font-size: 24px; font-weight: 700; color: #fff; line-height: 1; }
  .stat-label { font-size: 11px; color: var(--muted); margin-top: 3px; letter-spacing: 0.5px; text-transform: uppercase; }

  /* ── RIGHT ── */
  .right-panel {
    width: 460px; min-width: 460px;
    background: var(--card); border-left: 1px solid var(--border);
    display: flex; flex-direction: column; justify-content: center;
    padding: 48px 44px; overflow-y: auto;
  }
  .form-title { font-family: 'Syne', sans-serif; font-size: 24px; font-weight: 700; margin-bottom: 6px; }
  .form-sub { font-size: 13px; color: var(--muted); margin-bottom: 32px; }

  /* Alert từ Servlet */
  .alert {
    padding: 11px 14px; border-radius: 8px; font-size: 13px;
    margin-bottom: 20px; display: flex; align-items: center; gap: 8px;
  }
  .alert-error   { background: rgba(255,95,95,0.1); border: 1px solid rgba(255,95,95,0.3); color: #ff8080; }
  .alert-success { background: rgba(54,217,160,0.1); border: 1px solid rgba(54,217,160,0.3); color: #36d9a0; }

  .field { margin-bottom: 18px; }
  label {
    display: block; font-size: 11px; font-weight: 500;
    color: var(--muted); text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 7px;
  }
  .input-wrap { position: relative; }
  .input-wrap .icon {
    position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
    color: var(--muted); font-size: 14px; pointer-events: none;
  }
  input[type=email], input[type=password] {
    width: 100%; background: var(--input-bg); border: 1px solid var(--border);
    border-radius: 8px; color: var(--text);
    font-family: 'DM Sans', sans-serif; font-size: 14px;
    padding: 12px 14px 12px 40px; outline: none;
    transition: border-color 0.2s, box-shadow 0.2s; -webkit-appearance: none;
  }
  input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(108,99,255,0.18); }
  input.is-invalid { border-color: var(--error); }
  input::placeholder { color: #2e3450; }
  .toggle-pw {
    position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
    background: none; border: none; color: var(--muted);
    cursor: pointer; padding: 2px; font-size: 14px; transition: color 0.2s;
  }
  .toggle-pw:hover { color: var(--text); }

  .remember-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 22px; }
  .checkbox-label { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--muted); cursor: pointer; }
  .checkbox-label input[type=checkbox] { display: none; }
  .custom-check {
    width: 16px; height: 16px; border: 1px solid var(--border); border-radius: 4px;
    background: var(--input-bg); display: flex; align-items: center; justify-content: center;
    flex-shrink: 0; transition: all 0.2s;
  }
  .checkbox-label input:checked + .custom-check { background: var(--accent); border-color: var(--accent); }
  .custom-check::after { content: '✓'; color: #fff; font-size: 10px; display: none; }
  .checkbox-label input:checked + .custom-check::after { display: block; }
  .forgot-link { font-size: 12px; color: var(--accent); text-decoration: none; }
  .forgot-link:hover { text-decoration: underline; }

  .btn-primary {
    width: 100%; padding: 13px;
    background: linear-gradient(135deg, var(--accent), #8b5cf6);
    border: none; border-radius: 10px; color: #fff;
    font-family: 'Syne', sans-serif; font-size: 14px; font-weight: 700; letter-spacing: 0.4px;
    cursor: pointer; box-shadow: 0 8px 24px var(--glow);
    transition: transform 0.15s, box-shadow 0.15s;
    position: relative; overflow: hidden;
  }
  .btn-primary::before {
    content: ''; position: absolute; top: 0; left: -100%;
    width: 60%; height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
    transition: left 0.4s;
  }
  .btn-primary:hover::before { left: 150%; }
  .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 12px 32px var(--glow); }
  .btn-primary:active { transform: translateY(0); }

  .divider { display: flex; align-items: center; gap: 12px; margin: 22px 0; color: var(--muted); font-size: 11px; }
  .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--border); }

  .switch-note { font-size: 13px; color: var(--muted); text-align: center; margin-top: 20px; }
  .switch-note a { color: var(--accent); text-decoration: none; }
  .switch-note a:hover { text-decoration: underline; }

  ::-webkit-scrollbar { width: 4px; }
  ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }
  @media (max-width: 860px) {
    .left-panel { display: none; }
    .right-panel { width: 100%; min-width: unset; border-left: none; padding: 36px 24px; }
  }
</style>
</head>
<body>

<%-- Lấy thông báo lỗi / thành công từ Servlet --%>
<%
  String errorMsg   = (String) request.getAttribute("errorMsg");
  String successMsg = (String) request.getAttribute("successMsg");
  String savedEmail = (String) request.getAttribute("savedEmail");
  if (savedEmail == null) savedEmail = "";
%>

<!-- LEFT -->
<div class="left-panel">
  <div class="bg-gradient"></div>
  <div class="vinyl-art"></div>
  <div class="left-content">
    <a href="${pageContext.request.contextPath}/" class="logo">
      <div class="logo-icon">🎵</div>
      <span class="logo-text">MuLi</span>
    </a>
    <h1 class="left-headline">Âm nhạc<br>không có<br><span class="hl">giới hạn.</span></h1>
    <p class="left-sub">Khám phá hàng triệu bài hát, tạo playlist riêng, và theo dõi nghệ sĩ yêu thích — mọi lúc, mọi nơi.</p>
    <div class="stats-row">
      <div class="stat"><div class="stat-num">10M+</div><div class="stat-label">Bài hát</div></div>
      <div class="stat"><div class="stat-num">500K</div><div class="stat-label">Nghệ sĩ</div></div>
      <div class="stat"><div class="stat-num">HD</div><div class="stat-label">Chất lượng</div></div>
    </div>
  </div>
</div>

<!-- RIGHT -->
<div class="right-panel">
  <div class="form-title">Chào mừng trở lại 👋</div>
  <div class="form-sub">Đăng nhập để tiếp tục nghe nhạc</div>

  <%-- Hiển thị alert từ Servlet --%>
  <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert alert-error">⚠ <%= errorMsg %></div>
  <% } %>
  <% if (successMsg != null && !successMsg.isEmpty()) { %>
    <div class="alert alert-success">✓ <%= successMsg %></div>
  <% } %>

  <form action="${pageContext.request.contextPath}/LoginServlet" method="post" onsubmit="return validateLogin()">
    <div class="field">
      <label>Email</label>
      <div class="input-wrap">
        <span class="icon">✉</span>
        <input type="email" name="email" id="login-email"
               placeholder="hello@example.com"
               value="<%= savedEmail %>"
               required>
      </div>
    </div>

    <div class="field">
      <label>Mật khẩu</label>
      <div class="input-wrap">
        <span class="icon">🔒</span>
        <input type="password" name="password" id="login-password"
               placeholder="••••••••" required>
        <button type="button" class="toggle-pw" onclick="togglePw('login-password', this)">👁</button>
      </div>
    </div>

    <div class="remember-row">
      <label class="checkbox-label">
        <input type="checkbox" name="remember" value="true">
        <span class="custom-check"></span>
        Ghi nhớ đăng nhập
      </label>
      <a href="${pageContext.request.contextPath}/ForgotPasswordServlet" class="forgot-link">Quên mật khẩu?</a>
    </div>

    <button type="submit" class="btn-primary">Đăng nhập</button>
  </form>

  <div class="divider">hoặc</div>

  <p class="switch-note">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký ngay →</a></p>
</div>

<script>
  function togglePw(id, btn) {
    const inp = document.getElementById(id);
    const isText = inp.type === 'text';
    inp.type = isText ? 'password' : 'text';
    btn.textContent = isText ? '👁' : '🙈';
  }
  function validateLogin() {
    const email = document.getElementById('login-email').value.trim();
    const pass  = document.getElementById('login-password').value;
    if (!email || !pass) { alert('Vui lòng nhập đầy đủ thông tin.'); return false; }
    return true;
  }
</script>
</body>
</html>
