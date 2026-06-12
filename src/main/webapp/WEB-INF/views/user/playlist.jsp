<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div style="max-width:480px;margin:0 auto 32px;padding:24px;background:var(--surface);border-radius:var(--radius-md);">
  <c:if test="${not empty errorMessage}">
    <div style="background:rgba(255,60,110,.1);border:1px solid rgba(255,60,110,.3);border-radius:8px;padding:12px 16px;color:#ff3c6e;font-size:13px;margin-bottom:20px;text-align:center;">${errorMessage}</div>
  </c:if>
  <form action="${pageContext.request.contextPath}/playlist/create" method="post" style="display:flex;gap:12px;align-items:flex-end;flex-wrap:wrap;">
    <div style="flex:1;min-width:200px;">
      <label style="display:block;font-size:12px;font-weight:600;color:var(--muted);margin-bottom:4px;" for="name">Tên playlist</label>
      <input type="text" id="name" name="name" value="${name}" placeholder="VD: Nhạc chill, V-Pop..." maxlength="150" required
             style="width:100%;height:40px;background:rgba(255,255,255,.04);border:1px solid var(--surface2);border-radius:8px;padding:0 12px;color:var(--text);font-family:inherit;font-size:13px;outline:none;transition:border-color .25s;">
    </div>
    <div style="flex:1;min-width:160px;">
      <label style="display:block;font-size:12px;font-weight:600;color:var(--muted);margin-bottom:4px;" for="description">Mô tả</label>
      <input type="text" id="description" name="description" value="${description}" placeholder="Mô tả ngắn..." maxlength="500"
             style="width:100%;height:40px;background:rgba(255,255,255,.04);border:1px solid var(--surface2);border-radius:8px;padding:0 12px;color:var(--text);font-family:inherit;font-size:13px;outline:none;transition:border-color .25s;">
    </div>
    <button type="submit" style="height:40px;padding:0 20px;border-radius:100px;background:var(--accent);border:none;color:#000;font-family:inherit;font-size:13px;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:6px;transition:all .2s;white-space:nowrap;">
      <i class="fas fa-plus"></i> Tạo
    </button>
  </form>
</div>

<c:choose>
  <c:when test="${empty playlists}">
    <div style="text-align:center;padding:60px 40px;background:var(--surface);border-radius:var(--radius-md);">
      <i class="fas fa-list-music" style="font-size:40px;color:var(--muted);margin-bottom:12px;"></i>
      <h3 style="margin-bottom:8px;font-size:16px;">Chưa có playlist nào</h3>
      <p style="color:var(--muted);font-size:13px;">Điền tên playlist ở trên để bắt đầu</p>
    </div>
  </c:when>
  <c:otherwise>
    <div class="album-grid">
      <c:forEach items="${playlists}" var="pl">
        <a href="${pageContext.request.contextPath}/playlist/detail?id=${pl.playlistId}" style="text-decoration:none;color:inherit;">
          <div class="card" style="padding:0;overflow:hidden;">
            <div style="width:100%;aspect-ratio:1;background:linear-gradient(135deg,var(--surface2),#000);display:flex;align-items:center;justify-content:center;font-size:48px;color:var(--muted);position:relative;">
              <i class="fas fa-music"></i>
              <div style="position:absolute;inset:0;background:rgba(0,0,0,.3);display:flex;align-items:center;justify-content:center;opacity:0;transition:opacity .2s;">
                <i class="fas fa-play-circle" style="font-size:40px;color:#fff;text-shadow:0 4px 16px rgba(0,0,0,.5);"></i>
              </div>
            </div>
            <div style="padding:16px;">
              <div class="card__title">${fn:escapeXml(pl.name)}</div>
              <div class="card__artist">${fn:escapeXml(pl.description)}</div>
              <div style="margin-top:10px;display:flex;align-items:center;justify-content:space-between;font-size:12px;color:var(--muted);padding-top:10px;border-top:1px solid var(--surface2);">
                <span><i class="fas fa-music"></i> ${pl.songCount} bài hát</span>
                <form action="${pageContext.request.contextPath}/playlist/delete" method="post" style="margin:0" onsubmit="return confirm('Xóa playlist &quot;${fn:escapeXml(pl.name)}&quot;?')" onclick="event.stopPropagation()">
                  <input type="hidden" name="id" value="${pl.playlistId}">
                  <button type="submit" style="background:none;border:none;color:var(--muted);cursor:pointer;padding:4px 8px;border-radius:6px;transition:all .2s;" title="Xóa playlist"><i class="fas fa-trash-can"></i></button>
                </form>
              </div>
            </div>
          </div>
        </a>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>
