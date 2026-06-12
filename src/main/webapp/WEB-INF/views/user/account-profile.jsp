<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
.profile-page{max-width:640px;margin:0 auto}
.profile-header{display:flex;align-items:center;gap:20px;padding:24px;background:var(--surface);border-radius:var(--radius-md);margin-bottom:20px}
.profile-avatar{width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,var(--accent),#169c46);display:flex;align-items:center;justify-content:center;font-size:32px;font-weight:700;color:#fff;flex-shrink:0}
.profile-info{min-width:0}
.profile-info h2{font-size:22px;font-weight:700}
.profile-info .meta{font-size:13px;color:var(--muted);margin-top:4px}
.profile-info .meta span{margin-right:16px}
.profile-section{background:var(--surface);border-radius:var(--radius-md);padding:24px;margin-bottom:16px}
.profile-section h3{font-size:16px;font-weight:700;margin-bottom:16px;padding-bottom:8px;border-bottom:1px solid var(--surface2)}
.profile-section .field{margin-bottom:14px}
.profile-section label{display:block;font-size:12px;font-weight:600;color:var(--muted);margin-bottom:4px;text-transform:uppercase;letter-spacing:.5px}
.profile-section input{width:100%;height:44px;background:rgba(255,255,255,.06);border:1px solid var(--surface2);border-radius:var(--radius);color:var(--text);font-family:inherit;font-size:14px;padding:0 12px;outline:none;transition:border-color .2s}
.profile-section input:focus{border-color:var(--accent)}
.profile-section input:disabled{opacity:.5}
.profile-section .readonly-field{color:var(--muted);padding:12px 0;font-size:14px}
.profile-section .row-2{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.btn-save{height:40px;padding:0 24px;border-radius:100px;background:var(--accent);border:none;color:#000;font-family:inherit;font-size:13px;font-weight:700;cursor:pointer;transition:all .15s}
.btn-save:hover{background:var(--accent-hover)}
.btn-save:active{transform:scale(.97)}
.pw-hint{font-size:12px;color:var(--dim);margin-top:6px}
</style>

<div class="profile-page">
  <c:if test="${not empty successMsg}">
    <div class="alert alert-success" style="padding:12px 14px;border-radius:var(--radius);font-size:13px;margin-bottom:16px;display:flex;align-items:center;gap:8px;background:rgba(29,185,84,.1);border:1px solid rgba(29,185,84,.3);color:var(--accent)"><i class="fas fa-check-circle"></i> ${successMsg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div class="alert alert-error" style="padding:12px 14px;border-radius:var(--radius);font-size:13px;margin-bottom:16px;display:flex;align-items:center;gap:8px;background:rgba(255,70,70,.1);border:1px solid rgba(255,70,70,.3);color:#ff6b6b"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
  </c:if>

  <div class="profile-header">
    <div class="profile-avatar">${fn:substring(profileUser.fullName, 0, 1)}</div>
    <div class="profile-info">
      <h2>${fn:escapeXml(profileUser.fullName)}</h2>
      <div class="meta">
        <span><i class="fas fa-envelope"></i> ${fn:escapeXml(profileUser.email)}</span>
        <span><i class="fas fa-user"></i> @${fn:escapeXml(profileUser.username)}</span>
        <span><i class="fas fa-calendar-alt"></i> Tham gia ${fn:escapeXml(profileUser.createdAt)}</span>
      </div>
    </div>
  </div>

  <div class="profile-section">
    <h3><i class="fas fa-edit"></i> Chỉnh sửa hồ sơ</h3>
    <form action="${pageContext.request.contextPath}/account/profile" method="post">
      <div class="field">
        <label>Họ và tên</label>
        <input type="text" name="fullName" value="${fn:escapeXml(profileUser.fullName)}" required>
      </div>
      <div class="field">
        <label>Email</label>
        <div class="readonly-field">${fn:escapeXml(profileUser.email)}</div>
      </div>
      <div class="row-2">
        <div class="field">
          <label>Tên đăng nhập</label>
          <div class="readonly-field">@${fn:escapeXml(profileUser.username)}</div>
        </div>
        <div class="field">
          <label>Vai trò</label>
          <div class="readonly-field">${fn:escapeXml(profileUser.role)}</div>
        </div>
      </div>
      <button type="submit" class="btn-save"><i class="fas fa-save"></i> Lưu thay đổi</button>
    </form>
  </div>

  <div class="profile-section">
    <h3><i class="fas fa-lock"></i> Đổi mật khẩu</h3>
    <c:if test="${not empty pwError}">
      <div class="alert alert-error" style="padding:12px 14px;border-radius:var(--radius);font-size:13px;margin-bottom:16px;display:flex;align-items:center;gap:8px;background:rgba(255,70,70,.1);border:1px solid rgba(255,70,70,.3);color:#ff6b6b"><i class="fas fa-exclamation-circle"></i> ${pwError}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/account/change-password" method="post" onsubmit="return validatePasswordForm()">
      <div class="field">
        <label>Mật khẩu hiện tại</label>
        <input type="password" name="currentPassword" id="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
      </div>
      <div class="row-2">
        <div class="field">
          <label>Mật khẩu mới</label>
          <input type="password" name="newPassword" id="newPassword" placeholder="Tối thiểu 8 ký tự" required minlength="8">
          <div class="pw-hint"><i class="fas fa-info-circle"></i> Ít nhất 8 ký tự, bao gồm chữ hoa, số và ký tự đặc biệt</div>
        </div>
        <div class="field">
          <label>Xác nhận mật khẩu mới</label>
          <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required minlength="8">
        </div>
      </div>
      <button type="submit" class="btn-save"><i class="fas fa-key"></i> Đổi mật khẩu</button>
    </form>
  </div>
</div>

<script>
function validatePasswordForm() {
  var current = document.getElementById('currentPassword').value.trim();
  var newPw = document.getElementById('newPassword').value;
  var confirm = document.getElementById('confirmPassword').value;
  if (!current) { alert('Vui lòng nhập mật khẩu hiện tại.'); return false; }
  if (newPw.length < 8) { alert('Mật khẩu mới phải có ít nhất 8 ký tự.'); return false; }
  if (newPw !== confirm) { alert('Mật khẩu xác nhận không khớp.'); return false; }
  return true;
}
</script>
