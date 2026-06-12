<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="admin-youtube-import">
  <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:20px;">
    <h2 style="font-size:22px;font-weight:800;">Import từ YouTube</h2>
  </div>

  <c:if test="${not empty param.imported}">
    <div style="padding:14px 18px;border-radius:var(--radius-sm);background:var(--accent);color:#000;font-weight:600;margin-bottom:16px;">
      <i class="fas fa-check-circle"></i> Đã import thành công <strong>${param.imported}</strong> bài hát!
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/admin/youtube-import/search" method="post" style="margin-bottom:20px;display:flex;gap:8px;">
    <input type="text" name="q" value="${fn:escapeXml(query)}" placeholder="Tìm kiếm trên YouTube..." required style="flex:1;max-width:500px;height:42px;padding:0 16px;border-radius:100px;border:1px solid var(--surface2);background:var(--bg);color:var(--text);font-size:14px;outline:none;" onfocus="this.style.borderColor='var(--accent)'" onblur="this.style.borderColor=''">
    <button type="submit" style="display:inline-flex;align-items:center;gap:6px;height:42px;padding:0 22px;border-radius:100px;border:none;background:var(--accent);color:#000;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;"><i class="fab fa-youtube"></i> Tìm trên YouTube</button>
  </form>

  <c:if test="${not empty results}">
    <p style="color:var(--muted);margin-bottom:12px;">Tìm thấy ${fn:length(results)} kết quả cho "<strong>${fn:escapeXml(query)}</strong>"</p>

    <form action="${pageContext.request.contextPath}/admin/youtube-import/import" method="post" id="importForm" onsubmit="return confirm('Import các bài hát đã chọn vào database?')">
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px;margin-bottom:20px;">
        <c:forEach items="${results}" var="video" varStatus="st">
          <label class="yt-card" style="display:block;background:var(--surface);border-radius:var(--radius-md);overflow:hidden;cursor:pointer;transition:box-shadow .2s,transform .15s;position:relative;border:2px solid transparent;" onmouseover="this.style.boxShadow='0 4px 20px rgba(0,0,0,.4)'" onmouseout="this.style.boxShadow='none'">
            <input type="checkbox" name="videoIds" value="${fn:escapeXml(video.videoId)}" style="position:absolute;top:10px;right:10px;width:20px;height:20px;accent-color:var(--accent);z-index:1;cursor:pointer;">
            <div style="position:relative;padding-top:56%;background:var(--bg);">
              <img src="${fn:escapeXml(video.thumbnailUrl)}" alt="" style="position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;" loading="lazy" onerror="this.style.display='none'">
              <c:if test="${video.durationSeconds > 0}">
                <span style="position:absolute;bottom:6px;right:6px;background:rgba(0,0,0,.8);color:#fff;font-size:11px;font-weight:600;padding:2px 6px;border-radius:4px;">${video.durationFormatted}</span>
              </c:if>
            </div>
            <div style="padding:10px 12px 12px;">
              <div style="font-size:13px;font-weight:600;line-height:1.3;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;margin-bottom:4px;">${fn:escapeXml(video.title)}</div>
              <div style="font-size:11px;color:var(--muted);">${fn:escapeXml(video.channelTitle)}</div>
            </div>
          </label>
        </c:forEach>
      </div>

      <div style="display:flex;gap:8px;">
        <button type="submit" id="importBtn" style="display:inline-flex;align-items:center;gap:8px;height:42px;padding:0 24px;border-radius:100px;border:none;background:var(--accent);color:#000;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Đang import...';document.getElementById('importForm').submit()">
          <i class="fas fa-download"></i> Import đã chọn
        </button>
      </div>
    </form>
  </c:if>

  <c:if test="${empty results && empty query}">
    <div style="text-align:center;padding:60px 40px;background:var(--surface);border-radius:var(--radius-md);margin-top:12px;">
      <i class="fab fa-youtube" style="font-size:52px;color:var(--muted);margin-bottom:16px;"></i>
      <h3 style="margin-bottom:8px;">Import bài hát từ YouTube</h3>
      <p style="color:var(--muted);max-width:480px;margin:0 auto;line-height:1.6;">
        Nhập tên bài hát hoặc nghệ sĩ ở ô tìm kiếm phía trên.<br>
        YouTube Data API sẽ trả về kết quả, bạn chọn bài muốn import và bấm "Import đã chọn".<br>
        Tự động tạo bài hát, nghệ sĩ (nếu chưa có) và gán dữ liệu vào database.
      </p>
    </div>
  </c:if>
</div>
