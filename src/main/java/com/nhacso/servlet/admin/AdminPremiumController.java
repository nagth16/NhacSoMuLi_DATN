package com.nhacso.servlet.admin;

import com.nhacso.dao.PaymentDAO;
import com.nhacso.dao.PlaylistDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;

@Controller
@RequestMapping("/admin/premium-revenue")
public class AdminPremiumController {

    private final PaymentDAO paymentDAO;
    private final PlaylistDAO playlistDAO;

    public AdminPremiumController(PaymentDAO paymentDAO, PlaylistDAO playlistDAO) {
        this.paymentDAO = paymentDAO;
        this.playlistDAO = playlistDAO;
    }

    @GetMapping
    public String revenuePage(HttpSession session, Model model) {
        Long totalTransactions = paymentDAO.countCompleted();
        BigDecimal totalRevenue = paymentDAO.totalRevenue();
        List<Object[]> monthlyStats = paymentDAO.monthlyRevenue();
        List<Object[]> planStats = paymentDAO.revenueByPlan();
        List<com.nhacso.entity.Payment> recentPayments = paymentDAO.findByStatus("COMPLETED");

        DecimalFormat df = new DecimalFormat("#,###");
        model.addAttribute("totalTransactions", totalTransactions);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("totalRevenueFormatted", df.format(totalRevenue));
        model.addAttribute("monthlyStats", monthlyStats);
        model.addAttribute("planStats", planStats);
        model.addAttribute("recentPayments", recentPayments.size() > 20 ? recentPayments.subList(0, 20) : recentPayments);
        model.addAttribute("currentPage", "admin/premium-revenue");
        model.addAttribute("pageTitle", "Doanh thu Premium");

        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        if (userId != null) {
            model.addAttribute("playlists", playlistDAO.getPlaylistsByUserId(userId));
        }
        return "user/home";
    }
}
