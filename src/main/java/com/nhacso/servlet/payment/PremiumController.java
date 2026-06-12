package com.nhacso.servlet.payment;

import com.nhacso.dao.PaymentDAO;
import com.nhacso.dao.PlaylistDAO;
import com.nhacso.dao.SubscriptionPlanDAO;
import com.nhacso.dao.UserDAO;
import com.nhacso.entity.Payment;
import com.nhacso.entity.SubscriptionPlan;
import com.nhacso.entity.User;
import com.nhacso.service.VietQRService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@Controller
public class PremiumController {

    private final SubscriptionPlanDAO planDAO;
    private final PaymentDAO paymentDAO;
    private final UserDAO userDAO;
    private final PlaylistDAO playlistDAO;
    private final VietQRService vietQRService;

    public PremiumController(SubscriptionPlanDAO planDAO, PaymentDAO paymentDAO,
                             UserDAO userDAO, PlaylistDAO playlistDAO,
                             VietQRService vietQRService) {
        this.planDAO = planDAO;
        this.paymentDAO = paymentDAO;
        this.userDAO = userDAO;
        this.playlistDAO = playlistDAO;
        this.vietQRService = vietQRService;
    }

    @GetMapping("/premium")
    public String premiumPage(HttpSession session, Model model) {
        List<SubscriptionPlan> plans = planDAO.findAll();
        model.addAttribute("plans", plans);

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }

        model.addAttribute("pageTitle", "MuLi Premium");
        model.addAttribute("currentPage", "user/premium");
        return "user/home";
    }

    @PostMapping("/premium/create-qr")
    @ResponseBody
    public Object createQr(@RequestParam("planId") Long planId, HttpSession session) {
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) return java.util.Map.of("error", "Vui lòng đăng nhập");

        SubscriptionPlan plan = planDAO.findById(planId);
        if (plan == null) return java.util.Map.of("error", "Gói không hợp lệ");

        String txnRef = vietQRService.generateTransactionRef();
        String amount = plan.getPrice().setScale(0, java.math.RoundingMode.DOWN).toString();
        String username = (String) session.getAttribute("username");
        String planName = plan.getPlanName().replaceAll("\\s+", ""); // bo khoang trang
        String addInfo = "MULI " + username + " " + planName + " " + amount;
        String qrUrl = vietQRService.generateQrImageUrl(amount, txnRef, addInfo);

        User user = userDAO.findById(userId);

        Payment payment = Payment.builder()
                .user(user)
                .subscriptionPlan(plan)
                .amount(plan.getPrice())
                .paymentStatus("PENDING")
                .paymentMethod("VIETQR")
                .transactionId(txnRef)
                .build();
        paymentDAO.save(payment);

        return java.util.Map.of(
                "qrUrl", qrUrl,
                "transactionRef", txnRef,
                "amount", amount,
                "addInfo", addInfo,
                "bankAccount", vietQRService.generateQrImageUrl(amount, txnRef).split("/")[4].split("-")[1],
                "bankName", "Xem trong app"
        );
    }

    @PostMapping("/premium/confirm")
    public String confirmPayment(@RequestParam("transactionId") String transactionId, HttpSession session) {
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) return "redirect:/login";

        Payment payment = paymentDAO.findByTransactionId(transactionId);
        if (payment == null || !payment.getUser().getUserId().equals(userId)) {
            return "redirect:/premium?error=invalid";
        }
        if (!"PENDING".equals(payment.getPaymentStatus())) {
            return "redirect:/premium?error=done";
        }

        long elapsed = java.time.Duration.between(payment.getCreatedAt(), java.time.LocalDateTime.now()).getSeconds();
        if (elapsed >= 600) {
            payment.setPaymentStatus("EXPIRED");
            paymentDAO.save(payment);
            return "redirect:/premium?error=expired";
        }

        payment.setPaymentStatus("COMPLETED");
        paymentDAO.save(payment);

        User user = userDAO.findById(userId);
        user.setPremium(true);
        userDAO.update(user);
        session.setAttribute("premium", true);

        return "redirect:/premium?success=ok";
    }

    private static final long EXPIRE_SECONDS = 600; // 10 phut
    private static final long AUTO_CONFIRM_SECONDS = 15;

    @GetMapping("/premium/payment-status")
    @ResponseBody
    public Object checkPaymentStatus(@RequestParam("transactionId") String transactionId, HttpSession session) {
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId == null) return java.util.Map.of("error", "no_session");

        Payment payment = paymentDAO.findByTransactionId(transactionId);
        if (payment == null) return java.util.Map.of("error", "not_found");
        if (!payment.getUser().getUserId().equals(userId)) return java.util.Map.of("error", "invalid_user");

        if ("PENDING".equals(payment.getPaymentStatus())) {
            long elapsed = java.time.Duration.between(payment.getCreatedAt(), java.time.LocalDateTime.now()).getSeconds();

            // Het han 10 phut
            if (elapsed >= EXPIRE_SECONDS) {
                payment.setPaymentStatus("EXPIRED");
                paymentDAO.save(payment);
                return java.util.Map.of("status", "EXPIRED", "elapsed", elapsed);
            }

            // Mo phong bank callback: tu dong xac nhan sau 15s
            if (elapsed >= AUTO_CONFIRM_SECONDS) {
                payment.setPaymentStatus("COMPLETED");
                paymentDAO.save(payment);

                User user = userDAO.findById(userId);
                user.setPremium(true);
                userDAO.update(user);
                session.setAttribute("premium", true);

                return java.util.Map.of("status", "COMPLETED", "premium", true);
            }

            return java.util.Map.of("status", "PENDING", "elapsed", elapsed, "expiresIn", EXPIRE_SECONDS - elapsed);
        }

        return java.util.Map.of("status", payment.getPaymentStatus(),
                "premium", "COMPLETED".equals(payment.getPaymentStatus()));
    }
}
