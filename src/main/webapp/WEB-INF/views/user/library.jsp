<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty librarySongs}">
  <div style="grid-column:1/-1;text-align:center;padding:80px 40px;background:var(--surface);border-radius:var(--radius-md);">
    <i class="fas fa-book" style="font-size:48px;color:var(--muted);margin-bottom:16px;"></i>
    <h3 style="margin-bottom:8px;">Thư viện trống</h3>
    <p style="color:var(--muted);">Chưa có bài hát nào trong thư viện.</p>
  </div>
</c:if>

<c:if test="${not empty librarySongs}">
  <div class="section">
    <div class="album-grid">
      <c:forEach items="${librarySongs}" var="song">
        <div class="card" data-song-id="${song.songId}">
          <div class="card__art-wrap">
            <img class="card__art" src="${song.coverImage}" alt="${song.title}" loading="lazy" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22180%22 height=%22180%22%3E%3Crect width=%22180%22 height=%22180%22 fill=%22%23333%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 font-size=%2240%22 fill=%22%23555%22 text-anchor=%22middle%22 dy=%22.35em%22%3E%E2%99%AA%3C/text%3E%3C/svg%3E'">
            <div class="card__overlay"></div>
            <button class="card__play-btn" type="button" onclick="playSongFromLibrary(${song.songId})">&#9654;</button>
          </div>
          <div class="card__title">${fn:escapeXml(song.title)}</div>
          <div class="card__artist">${fn:escapeXml(song.artistNames)}</div>
          <button class="card__fav-btn" type="button" onclick="toggleFavCard(event, ${song.songId})" title="Yêu thích">&#9825;</button>
        </div>
      </c:forEach>
    </div>
  </div>
</c:if>
