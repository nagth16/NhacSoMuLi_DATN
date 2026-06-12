<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="playlist-detail-page">
  <div style="display:flex;gap:24px;margin-bottom:32px;align-items:flex-end;flex-wrap:wrap;">
    <div style="width:200px;height:200px;border-radius:8px;background:linear-gradient(135deg,var(--surface2),#000);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:64px;color:var(--muted);box-shadow:0 8px 32px rgba(0,0,0,.5);">
      <i class="fas fa-music"></i>
    </div>
    <div style="min-width:0;flex:1;">
      <p style="font-size:12px;font-weight:700;color:var(--muted);letter-spacing:1px;text-transform:uppercase;margin-bottom:8px;">Playlist</p>
      <h1 style="font-size:clamp(28px,4vw,48px);font-weight:800;margin:0 0 8px;word-break:break-word;">${fn:escapeXml(playlist.name)}</h1>
      <p style="color:var(--muted);margin-bottom:8px;">${fn:escapeXml(playlist.description)}</p>
      <p style="font-size:14px;color:var(--muted);">${songs.size()} bài hát</p>
      <div style="margin-top:16px;display:flex;gap:12px;">
        <button type="button" onclick="document.getElementById('addSongModal').style.display='flex'" style="display:inline-flex;align-items:center;gap:8px;height:34px;padding:0 16px;border-radius:100px;border:none;background:var(--accent);color:#000;font-size:13px;font-weight:600;cursor:pointer;transition:all .2s;"><i class="fas fa-plus"></i> Thêm bài hát</button>
        <form action="${pageContext.request.contextPath}/playlist/delete" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa playlist này?')">
          <input type="hidden" name="id" value="${playlist.playlistId}">
          <button type="submit" style="display:inline-flex;align-items:center;gap:8px;height:34px;padding:0 16px;border-radius:100px;border:1px solid var(--muted);background:none;color:var(--text);font-size:13px;font-weight:600;cursor:pointer;transition:all .2s;"><i class="fas fa-trash-can"></i> Xóa playlist</button>
        </form>
      </div>
    </div>
  </div>

  <c:if test="${empty songs}">
    <div style="text-align:center;padding:60px 40px;background:var(--surface);border-radius:var(--radius-md);">
      <i class="fas fa-music" style="font-size:40px;color:var(--muted);margin-bottom:12px;"></i>
      <h3 style="margin-bottom:8px;">Playlist chưa có bài hát nào</h3>
      <p style="color:var(--muted);">Hãy thêm bài hát từ trang chủ.</p>
    </div>
  </c:if>

  <c:if test="${not empty songs}">
    <div class="section">
      <div class="album-grid">
        <c:forEach items="${songs}" var="song" varStatus="loop">
          <div class="card" data-song-id="${song.songId}">
            <div class="card__art-wrap">
              <img class="card__art" src="${song.coverImage}" alt="${song.title}" loading="lazy" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22180%22 height=%22180%22%3E%3Crect width=%22180%22 height=%22180%22 fill=%22%23333%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 font-size=%2240%22 fill=%22%23555%22 text-anchor=%22middle%22 dy=%22.35em%22%3E%E2%99%AA%3C/text%3E%3C/svg%3E'">
              <div class="card__overlay"></div>
              <button class="card__play-btn" type="button" onclick="playSongFromCard(${song.songId})">&#9654;</button>
            </div>
            <div class="card__title">${fn:escapeXml(song.title)}</div>
            <div class="card__artist">${fn:escapeXml(song.artistNames)}</div>
            <button class="card__fav-btn" type="button" onclick="toggleFavCard(event, ${song.songId})" title="Yêu thích">&#9825;</button>
            <div style="display:flex;justify-content:space-between;align-items:center;font-size:12px;color:var(--muted);margin-top:4px">
              <span>${playlistDetailController.formatDuration(song.duration)}</span>
              <form action="${pageContext.request.contextPath}/playlist/remove-song" method="post" onclick="event.stopPropagation()">
                <input type="hidden" name="playlistId" value="${playlist.playlistId}">
                <input type="hidden" name="songId" value="${song.songId}">
                <button type="submit" title="Xóa khỏi playlist" style="background:none;border:none;color:var(--muted);cursor:pointer;padding:4px;font-size:13px;transition:color .15s;">&times;</button>
              </form>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>
  </c:if>
</div>

<div id="addSongModal" data-playlist-id="${playlist.playlistId}" data-songs-in-playlist="[<c:forEach items="${songs}" var="s" varStatus="st">${s.songId}${st.last ? '' : ','}</c:forEach>]" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:999;align-items:flex-start;justify-content:center;padding-top:60px;" onclick="if(event.target===this)this.style.display='none'">
  <div style="background:var(--surface);border-radius:12px;padding:24px;width:90%;max-width:650px;max-height:80vh;overflow-y:auto;">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
      <h2 style="font-size:20px;font-weight:700;">Thêm bài hát vào playlist</h2>
      <button onclick="document.getElementById('addSongModal').style.display='none'" style="background:none;border:none;color:var(--muted);font-size:28px;cursor:pointer;line-height:1;">&times;</button>
    </div>
    <div style="position:relative;margin-bottom:16px;">
      <i class="fas fa-search" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--muted);font-size:14px;"></i>
      <input type="text" id="addSongSearch" placeholder="Tìm kiếm bài hát..." autocomplete="off" style="width:100%;height:38px;border-radius:8px;border:1px solid var(--surface2);background:var(--surface2);color:var(--text);font-size:14px;padding:0 12px 0 36px;outline:none;transition:border .2s;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor='var(--surface2)'">
    </div>
    <div id="addSongResults" style="display:grid;grid-template-columns:repeat(auto-fill,minmax(155px,1fr));gap:12px;min-height:100px;">
      <div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--muted);font-size:14px;" id="addSongEmpty">Nhập từ khóa để tìm kiếm bài hát</div>
    </div>
  </div>
</div>


