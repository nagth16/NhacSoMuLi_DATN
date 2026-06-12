<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MuLi — Quên mật khẩu</title>
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
.auth-title{font-size:26px;font-weight:700;text-align:center;margin-bottom:4px}
.auth-sub{font-size:14px;color:var(--muted);text-align:center;margin-bottom:24px}
.alert{padding:12px 14px;border-radius:var(--radius);font-size:13px;margin-bottom:20px;display:flex;align-items:center;gap:8px}
.alert-error{background:rgba(255,70,70,.1);border:1px solid rgba(255,70,70,.3);color:#ff6b6b}
.alert-success{background:rgba(29,185,84,.1);border:1px solid rgba(29,185,84,.3);color:var(--accent)}
.step{display:none}
.step.active{display:block}
.field{margin-bottom:16px}
label{display:block;font-size:13px;font-weight:600;color:var(--text);margin-bottom:6px}
input[type=email],input[type=password],input[type=text]{width:100%;height:46px;background:rgba(255,255,255,.06);border:1px solid var(--surface2);border-radius:var(--radius);color:var(--text);font-family:inherit;font-size:14px;padding:0 14px;outline:none;transition:border-color .2s}
input:focus{border-color:var(--accent)}
input::placeholder{color:var(--dim)}
input:disabled{opacity:.5;cursor:not-allowed}
.otp-row{display:flex;gap:8px;align-items:center}
.otp-row input{flex:1;height:46px}
.otp-row button{height:46px;padding:0 20px;border-radius:100px;border:none;background:var(--accent);color:#000;font-family:inherit;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;transition:all .15s}
.otp-row button:hover{background:var(--accent-hover)}
.otp-row button:disabled{opacity:.5;cursor:not-allowed;transform:none !important}
.otp-status{font-size:12px;margin-top:4px;min-height:18px;display:flex;align-items:center;gap:4px}
.btn-primary{width:100%;height:46px;border-radius:100px;background:var(--accent);border:none;color:#000;font-family:inherit;font-size:15px;font-weight:700;cursor:pointer;transition:all .15s;display:flex;align-items:center;justify-content:center;margin-top:8px}
.btn-primary:hover{background:var(--accent-hover);transform:scale(1.02)}
.btn-primary:active{transform:scale(1)}
.btn-primary:disabled{opacity:.5;cursor:not-allowed;transform:none !important}
.switch-note{font-size:14px;color:var(--muted);text-align:center;margin-top:22px}
.switch-note a{color:var(--text);font-weight:600;transition:color .15s}
.switch-note a:hover{color:var(--accent)}
.pw-hint{font-size:12px;color:var(--dim);margin-top:4px}
@media(max-width:480px){.auth-wrap{padding:16px}.auth-card{padding:24px}}
</style>
</head>
<body>
<div class="auth-wrap">
  <a href="${pageContext.request.contextPath}/" class="logo">
    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 0C5.372 0 0 5.373 0 12s5.372 12 12 12 12-5.373 12-12S18.628 0 12 0zm5.507 17.31a.748.748 0 0 1-1.03.25c-2.821-1.725-6.372-2.114-10.557-1.158a.748.748 0 1 1-.333-1.459c4.579-1.047 8.509-.597 11.671 1.338a.748.748 0 0 1 .249 1.029zm1.47-3.267a.936.936 0 0 1-1.288.308C14.82 12.26 10.87 11.7 7.815 12.6a.936.936 0 0 1-.573-1.786c3.47-1.017 7.833-.453 10.843 1.64a.937.937 0 0 1 .892 1.589zm.127-3.401C15.533 8.38 10.36 8.19 7.235 9.126a1.124 1.124 0 1 1-.652-2.15c3.584-1.087 9.546-.877 13.313 1.454a1.125 1.125 0 0 1-1.792 1.212z"/></svg>
    <span>MuLi</span>
  </a>

  <div class="auth-card">
    <h1 class="auth-title">Quên mật khẩu</h1>
    <p class="auth-sub" id="stepDescription">Nhập email để nhận mã xác thực</p>

    <c:if test="${not empty errorMsg}">
      <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
    </c:if>

    <form id="resetForm" action="${pageContext.request.contextPath}/forgot-password/reset" method="post" onsubmit="return validateForm()" novalidate>

      <div class="step active" id="step1">
        <div class="field">
          <label for="email">Email</label>
          <input type="email" name="email" id="email" placeholder="hello@example.com" required>
        </div>
        <div class="otp-status" id="sendStatus"></div>
        <button type="button" class="btn-primary" id="sendCodeBtn" onclick="sendCode()">Gửi mã xác thực</button>
      </div>

      <div class="step" id="step2">
        <input type="hidden" name="email" id="hiddenEmail">
        <div class="field">
          <label for="otpCode">Mã xác thực</label>
          <div class="otp-row">
            <input type="text" name="otpCode" id="otpCode" placeholder="Nhập mã 6 số" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required>
            <button type="button" id="resendBtn" onclick="sendCode()">Gửi lại</button>
          </div>
          <div class="otp-status" id="otpStatus"></div>
        </div>
        <div class="field">
          <label for="newPassword">Mật khẩu mới</label>
          <input type="password" name="newPassword" id="newPassword" placeholder="Tối thiểu 8 ký tự" required minlength="8">
          <div class="pw-hint"><i class="fas fa-info-circle"></i> Ít nhất 8 ký tự, bao gồm chữ hoa, số và ký tự đặc biệt</div>
        </div>
        <div class="field">
          <label for="confirmPassword">Xác nhận mật khẩu</label>
          <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required minlength="8">
        </div>
        <button type="submit" class="btn-primary" id="resetBtn" disabled>Đặt lại mật khẩu</button>
      </div>

    </form>

    <p class="switch-note"><a href="${pageContext.request.contextPath}/login"><i class="fas fa-arrow-left"></i> Quay lại đăng nhập</a></p>
  </div>
</div>

<script>
var sendCooldownTimer = null;

function sendCode() {
  var email = document.getElementById('email').value.trim();
  if (!email) { setSendStatus('Vui lòng nhập email.', 'error'); return; }
  var btn = document.getElementById('sendCodeBtn');
  var resendBtn = document.getElementById('resendBtn');
  btn.disabled = true;
  if (resendBtn) resendBtn.disabled = true;
  setSendStatus('Đang gửi mã xác thực...', '');
  var formData = new URLSearchParams();
  formData.append('email', email);
  fetch('${pageContext.request.contextPath}/forgot-password/send-code', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: formData.toString()
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.error) {
      setSendStatus(data.error, 'error');
      btn.disabled = false;
      if (resendBtn) resendBtn.disabled = false;
    } else {
      setSendStatus(data.message, 'success');
      document.getElementById('email').disabled = true;
      document.getElementById('step1').classList.remove('active');
      document.getElementById('step2').classList.add('active');
      document.getElementById('hiddenEmail').value = email;
      document.getElementById('stepDescription').textContent = 'Nhập mã xác thực và mật khẩu mới';
      document.getElementById('otpCode').focus();
      startCooldown();
    }
  })
  .catch(function() {
    setSendStatus('Lỗi kết nối. Vui lòng thử lại.', 'error');
    btn.disabled = false;
    if (resendBtn) resendBtn.disabled = false;
  });
}

function startCooldown() {
  if (sendCooldownTimer) clearInterval(sendCooldownTimer);
  var btn = document.getElementById('resendBtn');
  var sec = 60;
  btn.disabled = true;
  btn.textContent = 'Gửi lại (' + sec + 's)';
  sendCooldownTimer = setInterval(function() {
    sec--;
    if (sec <= 0) {
      clearInterval(sendCooldownTimer);
      sendCooldownTimer = null;
      btn.disabled = false;
      btn.textContent = 'Gửi lại';
    } else {
      btn.textContent = 'Gửi lại (' + sec + 's)';
    }
  }, 1000);
}

function setSendStatus(msg, type) {
  var el = document.getElementById('sendStatus');
  el.innerHTML = '';
  if (type === 'error') {
    el.innerHTML = '<i class="fas fa-times-circle" style="color:#ff6b6b"></i> ' + msg;
  } else if (type === 'success') {
    el.innerHTML = '<i class="fas fa-check-circle" style="color:var(--accent)"></i> ' + msg;
  } else {
    el.textContent = msg;
  }
}

document.getElementById('otpCode').addEventListener('input', function() {
  var val = this.value.replace(/\D/g, '');
  this.value = val;
  if (val.length === 6) {
    document.getElementById('resetBtn').disabled = false;
  } else {
    document.getElementById('resetBtn').disabled = true;
  }
});

document.getElementById('email').addEventListener('keydown', function(e) {
  if (e.key === 'Enter') { e.preventDefault(); sendCode(); }
});

function validateForm() {
  var otp = document.getElementById('otpCode').value.trim();
  var pw = document.getElementById('newPassword').value;
  var confirm = document.getElementById('confirmPassword').value;
  if (otp.length !== 6) { alert('Vui lòng nhập mã xác thực 6 số.'); return false; }
  if (pw.length < 8) { alert('Mật khẩu mới phải có ít nhất 8 ký tự.'); return false; }
  if (pw !== confirm) { alert('Mật khẩu xác nhận không khớp.'); return false; }
  return true;
}
</script>
</body>
</html>
