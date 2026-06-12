<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="admin-employees">
  <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:20px;">
    <h2 style="font-size:22px;font-weight:800;">
      Nhân viên
      <span style="font-size:14px;font-weight:400;color:var(--muted);">(${users.size()} tài khoản)</span>
    </h2>
  </div>

  <div class="table-wrap">
    <table class="dark-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Tên đăng nhập</th>
          <th>Họ tên</th>
          <th>Email</th>
          <th>Vai trò</th>
          <th>Premium</th>
          <th>Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${users}" var="u">
          <tr>
            <td>${u.userId}</td>
            <td>${fn:escapeXml(u.username)}</td>
            <td>${fn:escapeXml(u.fullName)}</td>
            <td>${fn:escapeXml(u.email)}</td>
            <td>
              <c:choose>
                <c:when test="${u.role eq 'ADMIN'}">
                  <span style="color:var(--accent);font-weight:600;">Admin</span>
                </c:when>
                <c:otherwise>User</c:otherwise>
              </c:choose>
            </td>
            <td>
              <span class="premium-badge ${u.premium ? 'premium-badge--active' : ''}"
                    data-user-id="${u.userId}"
                    data-premium="${u.premium}">
                ${u.premium ? 'Premium' : 'Thường'}
              </span>
            </td>
            <td>
              <button class="premium-toggle-btn" data-user-id="${u.userId}" data-premium="${u.premium}"
                      style="display:inline-flex;align-items:center;gap:6px;height:32px;padding:0 14px;border-radius:100px;border:none;background:var(--surface2);color:var(--text);font-size:12px;font-weight:600;cursor:pointer;transition:all .2s;">
                <i class="fas ${u.premium ? 'fa-crown' : 'fa-star'}"></i>
                ${u.premium ? 'Hủy Premium' : 'Kích hoạt Premium'}
              </button>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<style>
  .admin-employees .dark-table th:last-child,
  .admin-employees .dark-table td:last-child { text-align:center; }
  .premium-badge { display:inline-flex;align-items:center;gap:4px;padding:2px 10px;border-radius:100px;font-size:11px;font-weight:700;background:var(--surface2);color:var(--muted); }
  .premium-badge--active { background:rgba(255,215,0,.15);color:#ffd700; }
  .premium-toggle-btn:hover { background:var(--accent);color:#000; }
  .premium-toggle-btn:active { transform:scale(.95); }
</style>

<script>
document.addEventListener('click', function(e) {
  var btn = e.target.closest('.premium-toggle-btn');
  if (!btn) return;
  var userId = btn.getAttribute('data-user-id');
  var wasPremium = btn.getAttribute('data-premium') === 'true';
  btn.disabled = true;
  btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
  fetch('/api/users/' + userId + '/premium', { method: 'POST' })
    .then(function(r) { return r.json(); })
    .then(function(data) {
      var isPremium = data.premium;
      btn.setAttribute('data-premium', isPremium);
      btn.innerHTML = '<i class="fas ' + (isPremium ? 'fa-crown' : 'fa-star') + '"></i> ' + (isPremium ? 'Hủy Premium' : 'Kích hoạt Premium');
      btn.disabled = false;
      var badge = btn.closest('tr').querySelector('.premium-badge');
      if (badge) {
        badge.textContent = isPremium ? 'Premium' : 'Thường';
        badge.setAttribute('data-premium', isPremium);
        badge.classList.toggle('premium-badge--active', isPremium);
      }
    })
    .catch(function() {
      btn.innerHTML = '<i class="fas ' + (wasPremium ? 'fa-crown' : 'fa-star') + '"></i> ' + (wasPremium ? 'Hủy Premium' : 'Kích hoạt Premium');
      btn.disabled = false;
    });
});
</script>
