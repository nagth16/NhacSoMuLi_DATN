package com.nhacso.dao;

import com.nhacso.entity.VerificationCode;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Repository
@Transactional
public class VerificationCodeDAO {

    @PersistenceContext
    private EntityManager em;

    public void save(VerificationCode vc) {
        em.persist(vc);
    }

    public VerificationCode findValidCode(String email, String code) {
        String jpql = "SELECT v FROM VerificationCode v WHERE v.email = :email AND v.code = :code AND v.verified = false AND v.expiresAt > :now ORDER BY v.createdAt DESC";
        TypedQuery<VerificationCode> query = em.createQuery(jpql, VerificationCode.class);
        query.setParameter("email", email);
        query.setParameter("code", code);
        query.setParameter("now", LocalDateTime.now());
        query.setMaxResults(1);
        try {
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public void markVerified(Long id) {
        VerificationCode vc = em.find(VerificationCode.class, id);
        if (vc != null) {
            vc.setVerified(true);
            em.merge(vc);
        }
    }

    public void invalidatePreviousCodes(String email) {
        String jpql = "UPDATE VerificationCode v SET v.verified = true WHERE v.email = :email AND v.verified = false";
        em.createQuery(jpql).setParameter("email", email).executeUpdate();
    }

    public void deleteExpired() {
        String jpql = "DELETE FROM VerificationCode v WHERE v.expiresAt < :now";
        em.createQuery(jpql).setParameter("now", LocalDateTime.now()).executeUpdate();
    }
}
