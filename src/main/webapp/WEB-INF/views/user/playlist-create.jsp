<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div style="max-width:480px;margin:0 auto;padding:32px;background:var(--surface);border-radius:var(--radius-md);">
  <c:if test="${not empty errorMessage}">
    <div style="background:rgba(255,60,110,.1);border:1px solid rgba(255,60,110,.3);border-radius:8px;padding:12px 16px;color:#ff3c6e;font-size:13px;margin-bottom:20px;text-align:center;">${errorMessage}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/playlist/create" method="post">
    <div style="margin-bottom:20px;">
      <label style="display:block;font-size:13px;font-weight:500;color:var(--muted);margin-bottom:6px;" for="name">Tên playlist</label>
      <input type="text" id="name" name="name" value="${name}" placeholder="VD: Nhạc chill, V-Pop hay nhất..." maxlength="150" required
             style="width:100%;height:46px;background:rgba(255,255,255,.04);border:1px solid var(--surface2);border-radius:8px;padding:0 14px;color:var(--text);font-family:inherit;font-size:14px;outline:none;transition:border-color .25s;">
    </div>
    <div style="margin-bottom:24px;">
      <label style="display:block;font-size:13px;font-weight:500;color:var(--muted);margin-bottom:6px;" for="description">Mô tả (không bắt buộc)</label>
      <textarea id="description" name="description" class="form-textarea" placeholder="Mô tả ngắn về playlist này..." maxlength="500"
                style="width:100%;min-height:100px;background:rgba(255,255,255,.04);border:1px solid var(--surface2);border-radius:8px;padding:12px 14px;color:var(--text);font-family:inherit;font-size:14px;outline:none;transition:border-color .25s;">${description}</textarea>
    </div>
    <button type="submit" style="width:100%;height:46px;border-radius:100px;background:var(--accent);border:none;color:#000;font-family:inherit;font-size:15px;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;transition:all .2s;">
      <i class="fas fa-plus"></i> Tạo playlist
    </button>
  </form>

  <a href="${pageContext.request.contextPath}/playlist" style="display:block;text-align:center;margin-top:16px;color:var(--muted);text-decoration:none;font-size:13px;transition:color .2s;">
    <i class="fas fa-arrow-left"></i> Quay lại
  </a>
</div>
