package com.nhacso.dao;

import com.nhacso.entity.SubscriptionPlan;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class SubscriptionPlanDAO {

    @PersistenceContext
    private EntityManager em;

    public SubscriptionPlan findById(Long id) {
        return em.find(SubscriptionPlan.class, id);
    }

    public List<SubscriptionPlan> findAll() {
        return em.createQuery("SELECT s FROM SubscriptionPlan s ORDER BY s.price ASC", SubscriptionPlan.class)
                .getResultList();
    }
}
