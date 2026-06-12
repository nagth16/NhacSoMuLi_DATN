<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MuLi — Đăng ký</title>
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
.auth-wrap{width:100%;max-width:480px;padding:32px 24px}
.logo{display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:32px}
.logo svg{width:36px;height:36px;fill:var(--accent)}
.logo span{font-size:24px;font-weight:800;letter-spacing:-.5px}
.auth-card{background:var(--surface);border-radius:var(--radius);padding:32px}
.auth-title{font-size:28px;font-weight:700;text-align:center;margin-bottom:4px}
.auth-sub{font-size:14px;color:var(--muted);text-align:center;margin-bottom:24px}
.alert{padding:12px 14px;border-radius:var(--radius);font-size:13px;margin-bottom:20px;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(255,70,70,.1);border:1px solid rgba(255,70,70,.3);color:#ff6b6b}
.alert-success{background:rgba(29,185,84,.1);border:1px solid rgba(29,185,84,.3);color:var(--accent)}
.field{margin-bottom:14px}
label{display:block;font-size:13px;font-weight:600;color:var(--text);margin-bottom:5px}
input[type=text],input[type=email],input[type=password],input[type=date],select{width:100%;height:44px;background:rgba(255,255,255,.06);border:1px solid var(--surface2);border-radius:var(--radius);color:var(--text);font-family:inherit;font-size:14px;padding:0 12px;outline:none;transition:border-color .2s}
select{appearance:none;-webkit-appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23b3b3b3'%3E%3Cpath d='M7 10l5 5 5-5H7z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 10px center;background-size:14px;cursor:pointer;padding-right:32px}
input:focus,select:focus{border-color:var(--accent)}
input:disabled{opacity:.5;cursor:not-allowed}
input::placeholder{color:var(--dim)}
.field-row{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.otp-row{display:flex;gap:8px;align-items:center}
.otp-row input{flex:1}
.otp-row button{height:44px;padding:0 20px;border-radius:100px;border:none;background:var(--accent);color:#000;font-family:inherit;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;transition:all .15s}
.otp-row button:hover{background:var(--accent-hover)}
.otp-row button:disabled{opacity:.5;cursor:not-allowed;transform:none !important}
.otp-status{font-size:12px;margin-top:4px;min-height:18px;display:flex;align-items:center;gap:4px}
.section-label{font-size:13px;font-weight:700;color:var(--text);margin:16px 0 8px;padding-left:8px;border-left:3px solid var(--accent)}
.strength-wrap{margin-top:6px}
.strength-bars{display:flex;gap:4px}
.strength-bar{flex:1;height:3px;border-radius:2px;background:var(--surface2);transition:background .3s}
.strength-label{font-size:11px;color:var(--muted);margin-top:4px}
.checkbox-label{display:flex;align-items:flex-start;gap:8px;font-size:13px;color:var(--muted);cursor:pointer;line-height:1.4}
.checkbox-label input[type=checkbox]{display:none}
.custom-check{width:18px;height:18px;border:1px solid var(--surface2);border-radius:4px;background:rgba(255,255,255,.06);display:flex;align-items:center;justify-content:center;flex-shrink:0;margin-top:1px;transition:all .2s}
.checkbox-label input:checked+.custom-check{background:var(--accent);border-color:var(--accent)}
.custom-check::after{content:'\2713';color:#000;font-size:11px;font-weight:700;display:none}
.checkbox-label input:checked+.custom-check::after{display:block}
.checkbox-label a{color:var(--text);text-decoration:underline}
.btn-primary{width:100%;height:46px;border-radius:100px;background:var(--accent);border:none;color:#000;font-family:inherit;font-size:15px;font-weight:700;cursor:pointer;transition:all .15s;display:flex;align-items:center;justify-content:center;margin-top:14px}
.btn-primary:hover{background:var(--accent-hover);transform:scale(1.02)}
.btn-primary:active{transform:scale(1)}
.btn-primary:disabled{opacity:.5;cursor:not-allowed;transform:none !important}
.switch-note{font-size:14px;color:var(--muted);text-align:center;margin-top:18px}
.switch-note a{color:var(--text);font-weight:600;transition:color .15s}
.switch-note a:hover{color:var(--accent)}
@media(max-width:480px){.auth-wrap{padding:16px}.auth-card{padding:24px}.field-row{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="auth-wrap">
  <a href="${pageContext.request.contextPath}/" class="logo">
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 0C5.372 0 0 5.373 0 12s5.372 12 12 12 12-5.373 12-12S18.628 0 12 0zm5.507 17.31a.748.748 0 0 1-1.03.25c-2.821-1.725-6.372-2.114-10.557-1.158a.748.748 0 1 1-.333-1.459c4.579-1.047 8.509-.597 11.671 1.338a.748.748 0 0 1 .249 1.029zm1.47-3.267a.936.936 0 0 1-1.288.308C14.82 12.26 10.87 11.7 7.815 12.6a.936.936 0 0 1-.573-1.786c3.47-1.017 7.833-.453 10.843 1.64a.937.937 0 0 1 .892 1.589zm.127-3.401C15.533 8.38 10.36 8.19 7.235 9.126a1.124 1.124 0 1 1-.652-2.15c3.584-1.087 9.546-.877 13.313 1.454a1.125 1.125 0 0 1-1.792 1.212z"/></svg>
    <span>MuLi</span>
  </a>

  <div class="auth-card">
    <h1 class="auth-title">Đăng ký</h1>
    <p class="auth-sub">Tạo tài khoản và bắt đầu thưởng thức âm nhạc</p>

    <c:if test="${not empty errorMsg}">
      <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
    </c:if>
    <c:if test="${not empty successMsg}">
      <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMsg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateRegister()">
      <p class="section-label">Thông tin tài khoản</p>
      <div class="field">
        <label for="email">Email</label>
        <input type="email" name="email" id="email" placeholder="hello@example.com" value="${registerForm.email}" required>
      </div>
      <div class="field">
        <label for="otpCode">Mã xác thực</label>
        <div class="otp-row">
          <input type="text" name="otpCode" id="otpCode" placeholder="Nhập mã 6 số" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required disabled>
          <button type="button" id="sendCodeBtn" onclick="sendVerificationCode()">Gửi mã</button>
        </div>
        <div class="otp-status" id="otpStatus"></div>
      </div>
      <div class="field">
        <label for="password">Mật khẩu</label>
        <input type="password" name="password" id="password" placeholder="Tối thiểu 8 ký tự" required oninput="checkStrength(this.value)">
        <div class="strength-wrap">
          <div class="strength-bars">
            <div class="strength-bar" id="sb1"></div>
            <div class="strength-bar" id="sb2"></div>
            <div class="strength-bar" id="sb3"></div>
            <div class="strength-bar" id="sb4"></div>
          </div>
          <div class="strength-label" id="strength-text">Độ bảo mật mật khẩu</div>
        </div>
      </div>
      <div class="field">
        <label for="confirmPassword">Xác nhận mật khẩu</label>
        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu" required>
      </div>

      <p class="section-label">Thông tin cá nhân</p>
      <div class="field-row">
        <div class="field">
          <label for="firstName">Họ</label>
          <input type="text" name="firstName" id="firstName" placeholder="Nguyễn" value="${registerForm.firstName}" required>
        </div>
        <div class="field">
          <label for="lastName">Tên</label>
          <input type="text" name="lastName" id="lastName" placeholder="Văn A" value="${registerForm.lastName}" required>
        </div>
      </div>
      <div class="field-row">
        <div class="field">
          <label for="birthday">Ngày sinh</label>
          <input type="date" name="birthday" id="birthday">
        </div>
        <div class="field">
          <label for="gender">Giới tính</label>
          <select name="gender" id="gender">
            <option value="" disabled selected>Chọn...</option>
            <option value="male">Nam</option>
            <option value="female">Nữ</option>
            <option value="other">Khác</option>
          </select>
        </div>
      </div>
      <div class="field" style="margin-top:4px;">
        <label class="checkbox-label">
          <input type="checkbox" id="terms-check" required>
          <span class="custom-check"></span>
          <span>Tôi đồng ý với <a href="#">Điều khoản</a> và <a href="#">Chính sách bảo mật</a> của MuLi.</span>
        </label>
      </div>
      <button type="submit" class="btn-primary" id="registerBtn" disabled>Đăng ký</button>
    </form>

    <p class="switch-note">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
  </div>
</div>

<script>
var sendCooldownTimer = null;

function sendVerificationCode() {
  var email = document.getElementById('email').value.trim();
  if (!email) { setOtpStatus('Vui lòng nhập email trước.', 'error'); return; }
  var btn = document.getElementById('sendCodeBtn');
  btn.disabled = true;
  btn.textContent = 'Đang gửi...';
  setOtpStatus('Đang gửi mã xác thực...', '');
  var formData = new URLSearchParams();
  formData.append('email', email);
  fetch('${pageContext.request.contextPath}/register/send-code', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: formData.toString()
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.error) {
      setOtpStatus(data.error, 'error');
      btn.disabled = false;
      btn.textContent = 'Gửi mã';
    } else {
      setOtpStatus(data.message, 'success');
      document.getElementById('otpCode').disabled = false;
      document.getElementById('otpCode').focus();
      startOtpTimer();
      startSendCooldown(btn);
    }
  })
  .catch(function() {
    setOtpStatus('Lỗi kết nối. Vui lòng thử lại.', 'error');
    btn.disabled = false;
    btn.textContent = 'Gửi mã';
  });
}

function startSendCooldown(btn) {
  if (sendCooldownTimer) clearInterval(sendCooldownTimer);
  var sec = 60;
  btn.textContent = 'Gửi lại (' + sec + 's)';
  sendCooldownTimer = setInterval(function() {
    sec--;
    if (sec <= 0) {
      clearInterval(sendCooldownTimer);
      sendCooldownTimer = null;
      btn.disabled = false;
      btn.textContent = 'Gửi mã';
    } else {
      btn.textContent = 'Gửi lại (' + sec + 's)';
    }
  }, 1000);
}

function setOtpStatus(msg, type) {
  var el = document.getElementById('otpStatus');
  el.innerHTML = '';
  if (type === 'error') {
    el.innerHTML = '<i class="fas fa-times-circle" style="color:#ff6b6b"></i> ' + msg;
  } else if (type === 'success') {
    el.innerHTML = '<i class="fas fa-check-circle" style="color:var(--accent)"></i> ' + msg;
  } else {
    el.textContent = msg;
  }
}

function startOtpTimer() {
  var otpInput = document.getElementById('otpCode');
  otpInput.addEventListener('input', function() {
    var val = this.value.replace(/\D/g, '');
    this.value = val;
    if (val.length === 6) {
      document.getElementById('registerBtn').disabled = false;
      setOtpStatus('Đã nhập đủ mã. Nhấn "Đăng ký" để hoàn tất.', 'success');
    } else {
      document.getElementById('registerBtn').disabled = true;
    }
  });
}

function checkStrength(pw) {
  const bars = ['sb1','sb2','sb3','sb4'].map(id => document.getElementById(id));
  const txt = document.getElementById('strength-text');
  let score = 0;
  if (pw.length >= 8) score++;
  if (/[A-Z]/.test(pw)) score++;
  if (/[0-9]/.test(pw)) score++;
  if (/[^A-Za-z0-9]/.test(pw)) score++;
  const colors = ['#f15e6c','#f15e6c','#fbbf24','#36d9a0'];
  const labels = ['','Yếu','Trung bình','Mạnh','Rất mạnh'];
  const s = pw.length === 0 ? 0 : score;
  bars.forEach((b, i) => b.style.background = i < s ? (colors[s-1] || '#36d9a0') : '#282828');
  txt.textContent = s ? 'Độ bảo mật: ' + labels[s] : 'Độ bảo mật mật khẩu';
  txt.style.color = colors[s-1] || '#7a7a8c';
}

function validateRegister() {
  var pass = document.getElementById('password').value;
  var confirm = document.getElementById('confirmPassword').value;
  var terms = document.getElementById('terms-check').checked;
  var otp = document.getElementById('otpCode').value.trim();
  if (pass.length < 8) { alert('Mật khẩu phải có ít nhất 8 ký tự.'); return false; }
  if (pass !== confirm) { alert('Mật khẩu xác nhận không khớp.'); return false; }
  if (!terms) { alert('Vui lòng đồng ý với các điều khoản.'); return false; }
  if (otp.length !== 6) { alert('Vui lòng nhập mã xác thực 6 số.'); return false; }
  return true;
}
</script>
</body>
</html>
