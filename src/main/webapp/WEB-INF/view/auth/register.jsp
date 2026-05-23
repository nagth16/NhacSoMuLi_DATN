<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MuLi — Đăng ký</title>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<style>
  :root {
    --green:      #1db954;
    --bg:         #000000;
    --surface:    #121212;
    --border:     #282828;
    --text:       #ffffff;
    --text-sub:   #a7a7a7;
    --text-muted: #6a6a6a;
    --input-bg:   #242424;
    --error:      #f15e6c;
  }
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    background: var(--bg);
    font-family: 'Be Vietnam Pro', sans-serif;
    color: var(--text);
    min-height: 100vh;
    display: flex;
    align-items: flex-start;
    justify-content: center;
    padding: 40px 24px;
  }

  .card {
    background: var(--surface);
    border-radius: 12px;
    width: 100%;
    max-width: 480px;
    padding: 48px 48px 40px;
  }

  .logo {
    display: flex; align-items: center; justify-content: center;
    gap: 10px; margin-bottom: 28px; text-decoration: none;
  }
  .logo svg { width: 36px; height: 36px; }
  .logo-text { font-size: 26px; font-weight: 800; color: #fff; letter-spacing: -0.5px; }

  h1 { font-size: 24px; font-weight: 700; text-align: center; margin-bottom: 28px; line-height: 1.3; }

  .btn-outline {
    width: 100%; padding: 13px 16px; background: transparent;
    border: 1px solid #535353; border-radius: 50px; color: var(--text);
    font-family: 'Be Vietnam Pro', sans-serif; font-size: 14px; font-weight: 600;
    cursor: pointer; transition: border-color 0.15s, transform 0.1s;
    display: flex; align-items: center; justify-content: center; gap: 10px;
    margin-bottom: 10px;
  }
  .btn-outline:hover { border-color: #fff; transform: scale(1.01); }
  .btn-outline svg { width: 20px; height: 20px; flex-shrink: 0; }

  .divider {
    display: flex; align-items: center; gap: 12px;
    margin: 20px 0 24px; color: var(--text-muted); font-size: 12px; font-weight: 500;
  }
  .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--border); }

  .section-label { font-size: 15px; font-weight: 700; color: var(--text); margin: 22px 0 14px; }

  .field { margin-bottom: 16px; }
  .field-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

  label { display: block; font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 6px; }

  .input-wrap { position: relative; }
  input[type=text], input[type=email], input[type=password], input[type=date] {
    width: 100%; background: var(--input-bg); border: 1px solid var(--border);
    border-radius: 6px; color: var(--text);
    font-family: 'Be Vietnam Pro', sans-serif; font-size: 14px; font-weight: 400;
    padding: 14px 44px 14px 16px; outline: none;
    transition: border-color 0.2s; -webkit-appearance: none;
  }
  input[type=date] { padding-right: 16px; }
  input:hover { border-color: #535353; }
  input:focus { border-color: #fff; }
  input::placeholder { color: var(--text-muted); }
  input[type=date]::-webkit-calendar-picker-indicator { filter: invert(0.5); cursor: pointer; }

  select {
    width: 100%; background: var(--input-bg); border: 1px solid var(--border);
    border-radius: 6px; color: var(--text);
    font-family: 'Be Vietnam Pro', sans-serif; font-size: 14px; font-weight: 400;
    padding: 14px 16px; outline: none; cursor: pointer;
    transition: border-color 0.2s; -webkit-appearance: none;
  }
  select:hover { border-color: #535353; }
  select:focus { border-color: #fff; }
  select option { background: #242424; }

  .toggle-pw {
    position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
    background: none; border: none; color: var(--text-muted);
    cursor: pointer; font-size: 16px; padding: 0;
    transition: color 0.2s; line-height: 1;
  }
  .toggle-pw:hover { color: var(--text); }

  /* Password strength */
  .strength-wrap { margin-top: 8px; }
  .strength-bars { display: flex; gap: 4px; }
  .strength-bar { flex: 1; height: 3px; border-radius: 2px; background: var(--border); transition: background 0.3s; }
  .strength-label { font-size: 11px; font-weight: 500; color: var(--text-muted); margin-top: 5px; }

  /* Checkbox */
  .checkbox-label {
    display: flex; align-items: flex-start; gap: 10px;
    font-size: 13px; font-weight: 400; color: var(--text-sub); cursor: pointer; line-height: 1.6;
  }
  .checkbox-label input[type=checkbox] { display: none; }
  .custom-check {
    width: 16px; height: 16px; flex-shrink: 0; margin-top: 2px;
    border: 1px solid #535353; border-radius: 3px; background: transparent;
    display: flex; align-items: center; justify-content: center; transition: all 0.15s;
  }
  .checkbox-label:hover .custom-check { border-color: #fff; }
  .checkbox-label input:checked + .custom-check { background: var(--green); border-color: var(--green); }
  .custom-check::after { content: '✓'; color: #000; font-size: 10px; font-weight: 700; display: none; }
  .checkbox-label input:checked + .custom-check::after { display: block; }
  .checkbox-label a { color: var(--green); text-decoration: none; font-weight: 600; }
  .checkbox-label a:hover { text-decoration: underline; }

  /* Alert */
  .alert {
    padding: 12px 16px; border-radius: 6px; font-size: 13px; font-weight: 500;
    margin-bottom: 20px; display: flex; align-items: flex-start; gap: 8px; line-height: 1.5;
  }
  .alert-error   { background: rgba(241,94,108,0.15); border: 1px solid rgba(241,94,108,0.4); color: #f87171; }
  .alert-success { background: rgba(29,185,84,0.12);  border: 1px solid rgba(29,185,84,0.4);  color: var(--green); }

  .btn-green {
    width: 100%; padding: 14px; background: var(--green);
    border: none; border-radius: 50px; color: #000;
    font-family: 'Be Vietnam Pro', sans-serif;
    font-size: 15px; font-weight: 700; cursor: pointer; letter-spacing: 0.5px; margin-top: 8px;
    transition: background 0.15s, transform 0.1s;
  }
  .btn-green:hover { background: #1ed760; transform: scale(1.02); }
  .btn-green:active { transform: scale(0.99); }

  .terms-text {
    font-size: 11px; color: var(--text-muted); text-align: center;
    margin-top: 14px; line-height: 1.7;
  }
  .terms-text a { color: var(--green); text-decoration: none; }
  .terms-text a:hover { text-decoration: underline; }

  .bottom-text {
    text-align: center; font-size: 14px; color: var(--text-muted);
    margin-top: 28px; padding-top: 24px; border-top: 1px solid var(--border); line-height: 1.6;
  }
  .bottom-text a { color: var(--text); font-weight: 600; text-decoration: underline; }
  .bottom-text a:hover { color: var(--green); }

  @media (max-width: 540px) {
    .card { padding: 36px 20px 32px; border-radius: 0; }
    body { padding: 0; }
    .field-row { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>

<div class="card">

  <a href="${pageContext.request.contextPath}/" class="logo">
    <svg viewBox="0 0 24 24" fill="#1db954" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm4.586 14.424a.623.623 0 0 1-.857.207c-2.348-1.435-5.304-1.76-8.785-.964a.623.623 0 1 1-.277-1.215c3.809-.87 7.076-.496 9.712 1.115a.623.623 0 0 1 .207.857zm1.223-2.722a.78.78 0 0 1-1.072.257c-2.687-1.652-6.785-2.131-9.965-1.166a.78.78 0 0 1-.973-.519.781.781 0 0 1 .52-.972c3.632-1.102 8.147-.568 11.233 1.328a.78.78 0 0 1 .257 1.072zm.105-2.835C14.692 8.95 9.375 8.775 6.297 9.71a.937.937 0 1 1-.543-1.793c3.532-1.072 9.404-.865 13.115 1.337a.937.937 0 0 1-.955 1.613z"/>
    </svg>
    <span class="logo-text">MuLi</span>
  </a>

  <h1>Đăng ký để nghe nhạc miễn phí</h1>

  <%-- Alert từ Spring Model --%>
  <c:if test="${not empty errorMsg}">
    <div class="alert alert-error">⚠ ${errorMsg}</div>
  </c:if>
  <c:if test="${not empty successMsg}">
    <div class="alert alert-success">✓ ${successMsg}</div>
  </c:if>

  <button class="btn-outline" type="button">
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
      <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
      <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
      <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
    </svg>
    Đăng ký với Google
  </button>

  <button class="btn-outline" type="button">
    <svg viewBox="0 0 24 24" fill="#1877F2" xmlns="http://www.w3.org/2000/svg">
      <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.234 2.686.234v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.49h-2.796V24C19.612 23.094 24 18.1 24 12.073z"/>
    </svg>
    Đăng ký với Facebook
  </button>

  <div class="divider">hoặc</div>

  <%-- action trỏ đến Spring Controller --%>
  <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateRegister()">

    <%-- Bỏ comment nếu dùng Spring Security CSRF --%>
    <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>

    <p class="section-label">Thông tin tài khoản</p>

    <div class="field">
      <label for="email">Địa chỉ email</label>
      <div class="input-wrap">
        <input type="email" name="email" id="email"
               placeholder="Nhập email của bạn"
               value="${registerForm.email}" required>
      </div>
    </div>

    <div class="field">
      <label for="password">Tạo mật khẩu</label>
      <div class="input-wrap">
        <input type="password" name="password" id="password"
               placeholder="Tạo mật khẩu" required
               oninput="checkStrength(this.value)">
        <button type="button" class="toggle-pw" onclick="togglePw('password', this)">👁</button>
      </div>
      <div class="strength-wrap">
        <div class="strength-bars">
          <div class="strength-bar" id="sb1"></div>
          <div class="strength-bar" id="sb2"></div>
          <div class="strength-bar" id="sb3"></div>
          <div class="strength-bar" id="sb4"></div>
        </div>
        <div class="strength-label" id="strength-text"></div>
      </div>
    </div>

    <div class="field">
      <label for="confirmPassword">Xác nhận mật khẩu</label>
      <div class="input-wrap">
        <input type="password" name="confirmPassword" id="confirmPassword"
               placeholder="Nhập lại mật khẩu" required>
        <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)">👁</button>
      </div>
    </div>

    <p class="section-label">Thông tin của bạn</p>

    <div class="field-row">
      <div class="field">
        <label for="firstName">Họ</label>
        <div class="input-wrap">
          <input type="text" name="firstName" id="firstName"
                 placeholder="Nguyễn"
                 value="${registerForm.firstName}" required>
        </div>
      </div>
      <div class="field">
        <label for="lastName">Tên</label>
        <div class="input-wrap">
          <input type="text" name="lastName" id="lastName"
                 placeholder="Văn A"
                 value="${registerForm.lastName}" required>
        </div>
      </div>
    </div>

    <div class="field-row">
      <div class="field">
        <label for="birthday">Ngày sinh</label>
        <input type="date" name="birthday" id="birthday"
               value="${registerForm.birthday}" required>
      </div>
      <div class="field">
        <label for="gender">Giới tính</label>
        <select name="gender" id="gender">
          <option value="" disabled
            <c:if test="${empty registerForm.gender}">selected</c:if>>Chọn...</option>
          <option value="male"
            <c:if test="${registerForm.gender == 'male'}">selected</c:if>>Nam</option>
          <option value="female"
            <c:if test="${registerForm.gender == 'female'}">selected</c:if>>Nữ</option>
          <option value="other"
            <c:if test="${registerForm.gender == 'other'}">selected</c:if>>Khác</option>
        </select>
      </div>
    </div>

    <div class="field" style="margin-top: 8px;">
      <label class="checkbox-label">
        <input type="checkbox" id="terms-check" required>
        <span class="custom-check"></span>
        Tôi đồng ý với
        <a href="${pageContext.request.contextPath}/terms">Điều khoản dịch vụ</a>
        và
        <a href="${pageContext.request.contextPath}/privacy">Chính sách bảo mật</a>
        của MuLi
      </label>
    </div>

    <div class="field">
      <label class="checkbox-label">
        <input type="checkbox" name="newsletter" value="true">
        <span class="custom-check"></span>
        Nhận thông báo về nhạc mới và ưu đãi từ MuLi
      </label>
    </div>

    <button type="submit" class="btn-green">Đăng ký</button>

    <p class="terms-text">
      Bằng cách đăng ký, bạn đồng ý với
      <a href="${pageContext.request.contextPath}/terms">Điều khoản</a> và
      <a href="${pageContext.request.contextPath}/privacy">Chính sách bảo mật</a> của MuLi.
    </p>
  </form>

  <p class="bottom-text">
    Đã có tài khoản?
    <a href="${pageContext.request.contextPath}/login">Đăng nhập tại đây</a>
  </p>
</div>

<script>
  function togglePw(id, btn) {
    const inp = document.getElementById(id);
    const isText = inp.type === 'text';
    inp.type = isText ? 'password' : 'text';
    btn.textContent = isText ? '👁' : '🙈';
  }

  function checkStrength(pw) {
    const bars   = ['sb1','sb2','sb3','sb4'].map(id => document.getElementById(id));
    const txt    = document.getElementById('strength-text');
    let score = 0;
    if (pw.length >= 8)           score++;
    if (/[A-Z]/.test(pw))         score++;
    if (/[0-9]/.test(pw))         score++;
    if (/[^A-Za-z0-9]/.test(pw))  score++;
    const colors = ['#f15e6c','#f15e6c','#fbbf24','#1db954'];
    const labels = ['','Yếu','Trung bình','Mạnh','Rất mạnh'];
    const s = pw.length === 0 ? 0 : score;
    bars.forEach((b, i) => b.style.background = i < s ? (colors[s-1] || '#1db954') : '#282828');
    txt.textContent = labels[s] || '';
    txt.style.color = colors[s-1] || '#6a6a6a';
  }

  function validateRegister() {
    const pass    = document.getElementById('password').value;
    const confirm = document.getElementById('confirmPassword').value;
    const terms   = document.getElementById('terms-check').checked;
    if (pass.length < 8)  { alert('Mật khẩu phải có ít nhất 8 ký tự.'); return false; }
    if (pass !== confirm)  { alert('Mật khẩu xác nhận không khớp.'); return false; }
    if (!terms)            { alert('Vui lòng đồng ý với điều khoản.'); return false; }
    return true;
  }
</script>
</body>
</html>
