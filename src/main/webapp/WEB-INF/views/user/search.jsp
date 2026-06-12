<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty keyword}">
  <div style="text-align:center;padding:80px 40px;background:var(--surface);border-radius:var(--radius-md);">
    <i class="fas fa-search" style="font-size:48px;color:var(--muted);margin-bottom:16px;"></i>
    <h3 style="margin-bottom:8px;">Tìm kiếm bài hát</h3>
    <p style="color:var(--muted);">Nhập từ khóa vào ô tìm kiếm phía trên.</p>
  </div>
</c:if>

<c:if test="${not empty keyword}">
  <c:if test="${not empty ytError}">
    <div style="padding:10px 14px;border-radius:var(--radius-sm);background:rgba(255,50,50,.15);color:#ff6b6b;font-size:13px;margin-bottom:12px;">
      <i class="fas fa-exclamation-triangle"></i> YouTube: ${fn:escapeXml(ytError)}
    </div>
  </c:if>

  <c:if test="${empty searchResults and empty youtubeResults}">
    <div style="text-align:center;padding:60px 40px;background:var(--surface);border-radius:var(--radius-md);">
      <i class="fas fa-search" style="font-size:48px;color:var(--muted);margin-bottom:16px;"></i>
      <h3 style="margin-bottom:8px;">Không tìm thấy kết quả</h3>
      <p style="color:var(--muted);">Không có bài hát nào phù hợp với "<strong>${fn:escapeXml(keyword)}</strong>".</p>
    </div>
  </c:if>

  <c:if test="${not empty searchResults}">
    <div class="section">
      <div class="section-header">
        <h2><i class="fas fa-music" style="color:#1DB954;"></i> Kết quả từ thư viện</h2>
      </div>
      <div class="album-grid">
        <c:forEach items="${searchResults}" var="song">
          <div class="card" data-song-id="${song.songId}">
            <div class="card__art-wrap">
              <img class="card__art" src="${song.coverImage}" alt="${song.title}" loading="lazy" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22180%22 height=%22180%22%3E%3Crect width=%22180%22 height=%22180%22 fill=%22%23333%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 font-size=%2240%22 fill=%22%23555%22 text-anchor=%22middle%22 dy=%22.35em%22%3E%E2%99%AA%3C/text%3E%3C/svg%3E'">
              <div class="card__overlay"></div>
              <button class="card__play-btn" type="button" onclick="playSongFromCard(${song.songId})">&#9654;</button>
            </div>
            <div class="card__title">${fn:escapeXml(song.title)}</div>
            <div class="card__artist">${fn:escapeXml(song.artistNames)}</div>
            <button class="card__fav-btn" type="button" onclick="toggleFavCard(event, ${song.songId})" title="Yêu thích">&#9825;</button>
          </div>
        </c:forEach>
      </div>
    </div>
  </c:if>

  <c:if test="${not empty youtubeResults}">
    <div class="section">
      <div class="section-header">
        <h2><i class="fab fa-youtube" style="color:#FF0000;"></i> Kết quả từ YouTube</h2>
      </div>
      <div class="album-grid">
        <c:forEach items="${youtubeResults}" var="video" varStatus="st">
          <div class="card yt-card" tabindex="0" role="button"
               data-videoid="${fn:escapeXml(video.videoId)}"
               data-title="${fn:escapeXml(video.title)}"
               data-channel="${fn:escapeXml(video.channelTitle)}"
               data-thumb="${fn:escapeXml(video.thumbnailUrl)}">
            <div class="card__art-wrap">
              <img class="card__art" src="${video.thumbnailUrl}" alt="${fn:escapeXml(video.title)}" loading="lazy" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22180%22 height=%22180%22%3E%3Crect width=%22180%22 height=%22180%22 fill=%22%23333%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 font-size=%2240%22 fill=%22%23555%22 text-anchor=%22middle%22 dy=%22.35em%22%3E%E2%99%AA%3C/text%3E%3C/svg%3E'">
              <div class="card__overlay"></div>
              <button class="card__play-btn" type="button">&#9654;</button>
            </div>
            <div class="card__title">${fn:escapeXml(video.title)}</div>
            <div class="card__artist">${fn:escapeXml(video.channelTitle)}</div>
          </div>
        </c:forEach>
      </div>
    </div>
  </c:if>
</c:if>
