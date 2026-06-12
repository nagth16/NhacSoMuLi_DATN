<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="admin-song-list">
  <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:20px;">
    <h2 style="font-size:22px;font-weight:800;">
      <c:choose>
        <c:when test="${not empty keyword}">Kết quả tìm kiếm: "${fn:escapeXml(keyword)}"</c:when>
        <c:otherwise>Nhạc hot</c:otherwise>
      </c:choose>
    </h2>
    <a href="${pageContext.request.contextPath}/admin/songs/create" style="display:inline-flex;align-items:center;gap:8px;height:36px;padding:0 20px;border-radius:100px;border:none;background:var(--accent);color:#000;font-size:13px;font-weight:700;text-decoration:none;transition:all .2s;"><i class="fas fa-plus"></i> Thêm nhạc hot</a>
  </div>

  <form action="${pageContext.request.contextPath}/admin/songs" method="get" style="margin-bottom:16px;display:flex;gap:8px;">
    <input type="text" name="q" value="${fn:escapeXml(keyword)}" placeholder="Tìm kiếm nhạc hot..." style="flex:1;max-width:360px;height:40px;padding:0 14px;border-radius:100px;border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
    <button type="submit" style="display:inline-flex;align-items:center;gap:6px;height:40px;padding:0 18px;border-radius:100px;border:none;background:var(--surface2);color:var(--text);font-size:13px;font-weight:600;cursor:pointer;transition:all .2s;"><i class="fas fa-search"></i> Tìm</button>
    <c:if test="${not empty keyword}">
      <a href="${pageContext.request.contextPath}/admin/songs" style="display:inline-flex;align-items:center;height:40px;padding:0 14px;border-radius:100px;border:1px solid var(--surface2);color:var(--muted);font-size:12px;font-weight:600;text-decoration:none;transition:all .2s;">Xóa</a>
    </c:if>
  </form>

  <div class="table-wrap">
    <table class="dark-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Tiêu đề</th>
          <th>Nghệ sĩ</th>
          <th>Album</th>
          <th>YouTube URL</th>
          <th>Lượt nghe</th>
          <th>Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${songs}" var="song">
          <tr class="dark-table-row">
            <td style="color:var(--muted);font-size:13px;">${song.songId}</td>
            <td>
              <div class="dark-table-song">
                <img class="dark-table-img" src="${song.coverImage}" alt="" onerror="this.style.display='none'">
                <div class="dark-table-song-info">
                  <strong>${fn:escapeXml(song.title)}</strong>
                </div>
              </div>
            </td>
            <td class="dark-table-muted">${fn:escapeXml(song.artistNames)}</td>
            <td class="dark-table-muted">${song.album != null ? fn:escapeXml(song.album.title) : '-'}</td>
            <td style="font-size:12px;color:var(--muted);max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
              <c:choose>
                <c:when test="${not empty song.youtubeUrl}">
                  <a href="${song.youtubeUrl}" target="_blank" style="color:var(--accent);">YouTube</a>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td style="font-size:13px;color:var(--muted);">${song.listensCount}</td>
            <td>
              <div style="display:flex;gap:8px;">
                <a href="${pageContext.request.contextPath}/admin/songs/edit?id=${song.songId}" style="display:inline-flex;align-items:center;gap:6px;height:30px;padding:0 12px;border-radius:100px;background:var(--accent);color:#000;font-size:12px;font-weight:600;text-decoration:none;transition:all .2s;"><i class="fas fa-pen"></i> Sửa</a>
                <a href="${pageContext.request.contextPath}/admin/songs/delete?id=${song.songId}" onclick="return confirm('Xóa nhạc hot «${fn:escapeXml(song.title)}»?')" style="display:inline-flex;align-items:center;gap:6px;height:30px;padding:0 12px;border-radius:100px;border:1px solid var(--muted);color:var(--muted);font-size:12px;font-weight:600;text-decoration:none;transition:all .2s;"><i class="fas fa-trash-can"></i> Xóa</a>
              </div>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
