<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="admin-premium-revenue">
  <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:24px;">
    <h2 style="font-size:22px;font-weight:800;">Doanh thu Premium</h2>
  </div>

  <div style="display:flex;gap:16px;flex-wrap:wrap;margin-bottom:28px;">
    <div style="flex:1;min-width:200px;padding:20px;background:var(--surface);border-radius:var(--radius-md);text-align:center;">
      <div style="font-size:12px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;">Tong giao dich</div>
      <div style="font-size:32px;font-weight:800;">${totalTransactions}</div>
    </div>
    <div style="flex:1;min-width:200px;padding:20px;background:var(--surface);border-radius:var(--radius-md);text-align:center;">
      <div style="font-size:12px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;">Tong doanh thu</div>
      <div style="font-size:32px;font-weight:800;color:#ffd700;">${totalRevenueFormatted}<span style="font-size:16px;">d</span></div>
    </div>
  </div>

  <div style="display:flex;gap:20px;flex-wrap:wrap;">
    <div style="flex:2;min-width:300px;">
      <h3 style="font-size:15px;font-weight:700;margin:0 0 12px;">Doanh thu theo thang</h3>
      <div class="table-wrap">
        <table class="dark-table">
          <thead>
            <tr><th>Thang</th><th>So giao dich</th><th>Doanh thu</th></tr>
          </thead>
          <tbody>
            <c:forEach items="${monthlyStats}" var="row">
              <tr>
                <td>Thang ${row[1]}/${row[0]}</td>
                <td>${row[2]}</td>
                <td><fmt:formatNumber value="${row[3]}" pattern="#,###"/>d</td>
              </tr>
            </c:forEach>
            <c:if test="${empty monthlyStats}">
              <tr><td colspan="3" style="text-align:center;color:var(--muted);">Chua co du lieu</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>

    <div style="flex:1;min-width:250px;">
      <h3 style="font-size:15px;font-weight:700;margin:0 0 12px;">Theo goi Premium</h3>
      <div class="table-wrap">
        <table class="dark-table">
          <thead>
            <tr><th>Goi</th><th>Luot mua</th><th>Doanh thu</th></tr>
          </thead>
          <tbody>
            <c:forEach items="${planStats}" var="row">
              <tr>
                <td>${fn:escapeXml(row[0])}</td>
                <td>${row[1]}</td>
                <td><fmt:formatNumber value="${row[2]}" pattern="#,###"/>d</td>
              </tr>
            </c:forEach>
            <c:if test="${empty planStats}">
              <tr><td colspan="3" style="text-align:center;color:var(--muted);">Chua co du lieu</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div style="margin-top:28px;">
    <h3 style="font-size:15px;font-weight:700;margin:0 0 12px;">Giao dich moi nhat</h3>
    <div class="table-wrap">
      <table class="dark-table">
        <thead>
          <tr><th>Nguoi dung</th><th>Goi</th><th>So tien</th><th>Ngay</th></tr>
        </thead>
        <tbody>
          <c:forEach items="${recentPayments}" var="pm">
            <tr>
              <td>${fn:escapeXml(pm.user.username)}</td>
              <td>${fn:escapeXml(pm.subscriptionPlan.planName)}</td>
              <td><fmt:formatNumber value="${pm.amount}" pattern="#,###"/>d</td>
              <td style="font-size:12px;color:var(--muted);">${pm.createdAt.toLocalDate()}</td>
            </tr>
          </c:forEach>
          <c:if test="${empty recentPayments}">
            <tr><td colspan="4" style="text-align:center;color:var(--muted);">Chua co giao dich</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>