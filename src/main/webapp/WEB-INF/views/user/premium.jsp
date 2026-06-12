<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${not empty param.success}">
  <div style="padding:14px 18px;border-radius:var(--radius-sm);background:rgba(29,185,84,.15);color:#1db954;font-size:14px;font-weight:600;margin-bottom:20px;display:flex;align-items:center;gap:10px;">
    <i class="fas fa-check-circle" style="font-size:18px;"></i>
    Chúc mừng! Tài khoản của bạn đã được nâng cấp Premium. Tận hưởng trải nghiệm không quảng cáo!
  </div>
</c:if>
<c:if test="${not empty param.error}">
  <c:choose>
    <c:when test="${param.error eq 'expired'}">
      <div style="padding:14px 18px;border-radius:var(--radius-sm);background:rgba(255,50,50,.15);color:#ff6b6b;font-size:14px;font-weight:600;margin-bottom:20px;display:flex;align-items:center;gap:10px;">
        <i class="fas fa-clock" style="font-size:18px;"></i>
        Mã chuyển khoản đã hết hạn (10 phút). Vui lòng tạo mã mới.
      </div>
    </c:when>
    <c:otherwise>
      <div style="padding:14px 18px;border-radius:var(--radius-sm);background:rgba(255,50,50,.15);color:#ff6b6b;font-size:14px;font-weight:600;margin-bottom:20px;display:flex;align-items:center;gap:10px;">
        <i class="fas fa-exclamation-circle" style="font-size:18px;"></i>
        Giao dịch không hợp lệ. Vui lòng thử lại.
      </div>
    </c:otherwise>
  </c:choose>
</c:if>

<div class="premium-hero" style="text-align:center;padding:40px 20px;background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460);border-radius:var(--radius-md);margin-bottom:32px;">
  <i class="fas fa-crown" style="font-size:48px;color:#ffd700;margin-bottom:12px;"></i>
  <h2 style="font-size:28px;font-weight:800;margin:0 0 8px;">MuLi Premium</h2>
  <p style="color:var(--muted);font-size:15px;max-width:480px;margin:0 auto;">
    Trải nghiệm âm nhạc không giới hạn, <strong style="color:#fff;">không quảng cáo</strong>.
    Hỗ trợ nghệ sĩ yêu thích của bạn.
  </p>
</div>

<c:if test="${empty sessionScope.user}">
  <div style="text-align:center;padding:60px 20px;">
    <p style="font-size:16px;color:var(--muted);margin-bottom:16px;">Vui lòng đăng nhập để đăng ký Premium.</p>
    <a href="${pageContext.request.contextPath}/login" style="display:inline-flex;align-items:center;gap:8px;height:40px;padding:0 28px;border-radius:100px;background:var(--accent);color:#000;font-size:14px;font-weight:700;text-decoration:none;">Đăng nhập</a>
  </div>
</c:if>

<c:if test="${not empty sessionScope.user}">
  <c:if test="${sessionScope.premium eq true}">
    <div style="text-align:center;padding:40px 20px;background:var(--surface);border-radius:var(--radius-md);">
      <i class="fas fa-check-circle" style="font-size:56px;color:#1db954;margin-bottom:12px;"></i>
      <h3 style="font-size:22px;font-weight:700;margin:0 0 8px;">Bạn đã là thành viên Premium</h3>
      <p style="color:var(--muted);">Cảm ơn bạn đã đồng hành cùng MuLi!</p>
    </div>
  </c:if>

  <c:if test="${sessionScope.premium ne true}">
    <div class="premium-plans" style="display:flex;gap:20px;flex-wrap:wrap;justify-content:center;margin-bottom:32px;">
      <c:forEach items="${plans}" var="plan" varStatus="st">
        <div class="premium-plan-card" style="flex:1;min-width:240px;max-width:320px;background:var(--surface);border-radius:var(--radius-md);padding:28px 24px;text-align:center;border:1px solid var(--surface2);transition:all .25s;position:relative;${st.index == 1 ? 'border-color:#ffd700;box-shadow:0 0 30px rgba(255,215,0,.1);' : ''}">
          <c:if test="${st.index == 1}">
            <div style="position:absolute;top:-12px;left:50%;transform:translateX(-50%);background:linear-gradient(135deg,#ffd700,#f5a623);color:#000;font-size:11px;font-weight:800;padding:4px 16px;border-radius:100px;text-transform:uppercase;letter-spacing:1px;">Phổ biến</div>
          </c:if>
          <i class="fas fa-crown" style="font-size:32px;color:${st.index == 1 ? '#ffd700' : 'var(--muted)'};margin-bottom:12px;"></i>
          <h3 style="font-size:18px;font-weight:700;margin:0 0 4px;">${fn:escapeXml(plan.planName)}</h3>
          <div style="font-size:36px;font-weight:800;margin:12px 0;">
            ${plan.price.setScale(0)}<span style="font-size:14px;font-weight:400;color:var(--muted);">đ</span>
          </div>
          <p style="font-size:13px;color:var(--muted);margin:0 0 20px;">
            ${plan.duration >= 365 ? '1 năm' : plan.duration >= 90 ? '3 tháng' : plan.duration >= 30 ? '1 tháng' : plan.duration + ' ngày'}
          </p>
          <button class="premium-select-btn" data-plan-id="${plan.planId}" data-plan-name="${fn:escapeXml(plan.planName)}" data-amount="${plan.price.setScale(0)}"
                  style="width:100%;height:40px;border-radius:100px;border:none;background:${st.index == 1 ? 'linear-gradient(135deg,#ffd700,#f5a623)' : 'var(--accent)'};color:#000;font-size:14px;font-weight:700;cursor:pointer;transition:all .2s;">
            Đăng ký
          </button>
        </div>
      </c:forEach>
    </div>

    <div id="qr-section" style="display:none;text-align:center;padding:32px;background:var(--surface);border-radius:var(--radius-md);max-width:480px;margin:0 auto;">
      <h3 style="font-size:18px;font-weight:700;margin:0 0 4px;">Quét mã QR để thanh toán</h3>
      <p style="font-size:13px;color:var(--muted);margin:0 0 20px;">
        Sử dụng ứng dụng ngân hàng để quét mã
      </p>
      <div id="qr-image-wrap" style="background:#fff;border-radius:12px;padding:16px;display:inline-block;margin-bottom:16px;">
        <img id="qr-image" src="" alt="QR thanh toán" style="width:240px;height:240px;display:block;">
      </div>
      <div style="font-size:13px;color:var(--muted);margin-bottom:8px;">
        Nội dung chuyển khoản: <strong id="txn-ref" style="color:var(--accent);font-family:monospace;font-size:15px;"></strong>
      </div>
      <div style="font-size:13px;color:var(--muted);margin-bottom:16px;">
        Số tiền: <strong id="qr-amount" style="color:var(--text);font-size:18px;"></strong>
      </div>
      <div style="margin-bottom:16px;">
        <div id="payment-status" style="padding:12px 16px;border-radius:var(--radius-sm);background:rgba(255,215,0,.1);color:#ffd700;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px;justify-content:center;">
          <i class="fas fa-spinner fa-pulse"></i> &#272;ang ch&#7901; x&#225;c nh&#7853;n thanh to&#225;n...
        </div>
      </div>
      <div style="display:flex;gap:10px;justify-content:center;flex-wrap:wrap;">
        <button onclick="document.getElementById('qr-section').style.display='none';stopPaymentPolling=true" style="height:40px;padding:0 20px;border-radius:100px;border:1px solid var(--surface2);background:none;color:var(--muted);font-size:13px;cursor:pointer;">H&#7911;y</button>
      </div>
      <p style="font-size:12px;color:var(--muted);margin-top:16px;">
        <i class="fas fa-info-circle"></i> Qu&#233;t m&#227; QR v&#224; chuy&#7875;n kho&#7843;n. H&#7879; th&#7889;ng s&#7869; t&#7921; &#273;&#7897;ng k&#237;ch ho&#7841;t Premium sau khi nh&#7853;n &#273;&#432;&#7907;c thanh to&#225;n.
      </p>
    </div>
  </c:if>
</c:if>


<style>
  .premium-plan-card:hover{transform:translateY(-4px);border-color:var(--accent) !important;box-shadow:0 8px 32px rgba(0,0,0,.3) !important}
  .premium-select-btn:hover{transform:scale(1.03);box-shadow:0 4px 16px rgba(var(--accent-rgb),.3)}
  .premium-confirm-btn:hover{transform:scale(1.03);box-shadow:0 4px 16px rgba(29,185,84,.3)}
</style>


