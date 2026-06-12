<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="history-page">
  <c:if test="${empty histories}">
    <div style="text-align:center;padding:80px 40px;background:var(--surface);border-radius:var(--radius-md);">
      <i class="fas fa-history" style="font-size:48px;color:var(--muted);margin-bottom:16px;"></i>
      <h3 style="margin-bottom:8px;">Bạn chưa nghe bài hát nào</h3>
      <p style="color:var(--muted);">Hãy khám phá nhạc mới trên trang chủ.</p>
    </div>
  </c:if>

  <c:if test="${not empty histories}">
    <div class="table-wrap">
      <table class="dark-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Bài hát</th>
            <th>Nghệ sĩ</th>
            <th>Thời gian nghe</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${histories}" var="history" varStatus="loop">
            <tr class="dark-table-row" onclick="playSongFromCard(${history.song.songId})">
              <td>${loop.index + 1}</td>
              <td>
                <div class="dark-table-song">
                  <img src="${history.song.coverImage}" width="42" height="42" class="dark-table-img" loading="lazy" onerror="this.style.display='none'">
                  <div class="dark-table-song-info">
                    <strong>${fn:escapeXml(history.song.title)}</strong>
                  </div>
                </div>
              </td>
              <td class="dark-table-muted">${fn:escapeXml(history.song.artistNames)}</td>
              <td class="dark-table-muted">${history.playedAt}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>
</div>
