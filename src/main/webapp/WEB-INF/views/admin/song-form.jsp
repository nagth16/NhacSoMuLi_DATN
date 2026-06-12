<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="admin-song-form">
  <div style="margin-bottom:20px;">
    <a href="${pageContext.request.contextPath}/admin/songs" style="color:var(--muted);font-size:13px;font-weight:600;text-decoration:none;transition:color .15s;">&larr; Quay lại danh sách</a>
  </div>

  <div style="background:var(--surface);border-radius:var(--radius-md);padding:32px;max-width:720px;">
    <form action="${pageContext.request.contextPath}/admin/songs/save" method="post">
      <c:if test="${not empty song.songId}">
        <input type="hidden" name="songId" value="${song.songId}">
      </c:if>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div style="grid-column:1/-1;">
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Tiêu đề</label>
          <input type="text" name="title" value="${fn:escapeXml(song.title)}" required style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;transition:border .2s;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
        </div>

        <div>
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Thời lượng (giây)</label>
          <input type="number" name="duration" value="${song.duration}" style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
        </div>

        <div style="grid-column:1/-1;">
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">
            <i class="fab fa-youtube" style="color:#FF0000;"></i> Link YouTube
          </label>
          <input type="url" name="youtubeUrl" value="${fn:escapeXml(song.youtubeUrl)}" placeholder="https://www.youtube.com/watch?v=..." style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
          <p style="font-size:11px;color:var(--dim);margin-top:4px;">Dán link YouTube vào đây. Bài hát sẽ được phát từ YouTube khi người dùng ấn phát.</p>
        </div>

        <div>
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">File URL (fallback)</label>
          <input type="text" name="fileUrl" value="${fn:escapeXml(song.fileUrl)}" style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
        </div>

        <div>
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Stream URL</label>
          <input type="text" name="streamUrl" value="${fn:escapeXml(song.streamUrl)}" style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
        </div>

        <div style="grid-column:1/-1;">
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Ảnh bìa (URL)</label>
          <input type="text" name="coverImage" value="${fn:escapeXml(song.coverImage)}" style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
        </div>

        <div>
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Album</label>
          <select name="albumId" style="width:100%;height:42px;padding:0 14px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;cursor:pointer;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
            <option value="">-- Không có album --</option>
            <c:forEach items="${allAlbums}" var="album">
              <option value="${album.albumId}" ${song.album != null && song.album.albumId == album.albumId ? 'selected' : ''}>${fn:escapeXml(album.title)}</option>
            </c:forEach>
          </select>
        </div>

        <div>
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Nghệ sĩ</label>
          <div style="display:flex;flex-wrap:wrap;gap:6px;padding:8px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);">
            <c:forEach items="${allArtists}" var="artist">
              <label style="display:flex;align-items:center;gap:4px;font-size:12px;color:var(--text);cursor:pointer;padding:4px 8px;border-radius:4px;background:var(--surface2);transition:background .2s;" onmouseover="this.style.background='var(--accent)'" onmouseout="this.style.background='var(--surface2)'">
                <input type="checkbox" name="artistIds" value="${artist.artistId}" ${songArtistIds.contains(artist.artistId) ? 'checked' : ''} style="accent-color:var(--accent);">
                ${fn:escapeXml(artist.name)}
              </label>
            </c:forEach>
          </div>
        </div>

        <div style="grid-column:1/-1;">
          <label style="display:block;font-size:13px;font-weight:600;color:var(--muted);margin-bottom:6px;">Thể loại</label>
          <div style="display:flex;flex-wrap:wrap;gap:6px;padding:8px;border-radius:var(--radius-sm);border:1px solid var(--surface2);background:var(--bg);">
            <c:forEach items="${allGenres}" var="genre">
              <label style="display:flex;align-items:center;gap:4px;font-size:12px;color:var(--text);cursor:pointer;padding:4px 8px;border-radius:4px;background:var(--surface2);transition:background .2s;" onmouseover="this.style.background='var(--accent)'" onmouseout="this.style.background='var(--surface2)'">
                <input type="checkbox" name="genreIds" value="${genre.genreId}" ${songGenreIds.contains(genre.genreId) ? 'checked' : ''} style="accent-color:var(--accent);">
                ${fn:escapeXml(genre.genreName)}
              </label>
            </c:forEach>
          </div>
        </div>
      </div>

      <div style="margin-top:28px;display:flex;gap:12px;">
        <button type="submit" style="display:inline-flex;align-items:center;gap:8px;height:40px;padding:0 24px;border-radius:100px;border:none;background:var(--accent);color:#000;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;"><i class="fas fa-save"></i> Lưu thay đổi</button>
        <a href="${pageContext.request.contextPath}/admin/songs" style="display:inline-flex;align-items:center;gap:8px;height:40px;padding:0 24px;border-radius:100px;border:1px solid var(--muted);background:none;color:var(--text);font-size:14px;font-weight:600;text-decoration:none;cursor:pointer;transition:all .2s;">Hủy</a>
      </div>
    </form>
  </div>
</div>
