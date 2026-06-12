package com.nhacso.dao;

import com.nhacso.entity.Payment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class PaymentDAO {

    @PersistenceContext
    private EntityManager em;

    public void save(Payment payment) {
        if (payment.getPaymentId() == null) {
            em.persist(payment);
        } else {
            em.merge(payment);
        }
    }

    public Payment findById(Long id) {
        return em.find(Payment.class, id);
    }

    public Payment findByTransactionId(String transactionId) {
        try {
            return em.createQuery("SELECT p FROM Payment p WHERE p.transactionId = :tid", Payment.class)
                    .setParameter("tid", transactionId)
                    .getSingleResult();
        } catch (jakarta.persistence.NoResultException e) {
            return null;
        }
    }

    public List<Payment> findByUserId(Integer userId) {
        return em.createQuery(
                "SELECT p FROM Payment p WHERE p.user.userId = :uid ORDER BY p.createdAt DESC", Payment.class)
                .setParameter("uid", userId)
                .getResultList();
    }

    public List<Payment> findAll() {
        return em.createQuery("SELECT p FROM Payment p ORDER BY p.createdAt DESC", Payment.class)
                .getResultList();
    }

    public List<Payment> findByStatus(String status) {
        return em.createQuery("SELECT p FROM Payment p WHERE p.paymentStatus = :st ORDER BY p.createdAt DESC", Payment.class)
                .setParameter("st", status)
                .getResultList();
    }

    public Long countCompleted() {
        return em.createQuery("SELECT COUNT(p) FROM Payment p WHERE p.paymentStatus = 'COMPLETED'", Long.class)
                .getSingleResult();
    }

    public java.math.BigDecimal totalRevenue() {
        Double result = em.createQuery(
                "SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.paymentStatus = 'COMPLETED'", Double.class)
                .getSingleResult();
        return java.math.BigDecimal.valueOf(result);
    }

    public List<Object[]> monthlyRevenue() {
        return em.createQuery(
                "SELECT FUNCTION('YEAR', p.createdAt), FUNCTION('MONTH', p.createdAt), COUNT(p), COALESCE(SUM(p.amount), 0) " +
                "FROM Payment p WHERE p.paymentStatus = 'COMPLETED' " +
                "GROUP BY FUNCTION('YEAR', p.createdAt), FUNCTION('MONTH', p.createdAt) " +
                "ORDER BY FUNCTION('YEAR', p.createdAt) DESC, FUNCTION('MONTH', p.createdAt) DESC", Object[].class)
                .setMaxResults(12)
                .getResultList();
    }

    public List<Object[]> revenueByPlan() {
        return em.createQuery(
                "SELECT sp.planName, COUNT(p), COALESCE(SUM(p.amount), 0) " +
                "FROM Payment p JOIN p.subscriptionPlan sp " +
                "WHERE p.paymentStatus = 'COMPLETED' " +
                "GROUP BY sp.planName", Object[].class)
                .getResultList();
    }
}
