package dao;

import entity.User;
import utils.JpaUtils;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import java.util.List;

public class UserDAO {

    public User findByUsername(String username) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE lower(u.username) = lower(:username)",
                            User.class
                    )
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException ex) {
            return null;
        } finally {
            em.close();
        }
    }

    public User findByEmail(String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT u FROM User u WHERE lower(u.email) = lower(:email)",
                            User.class
                    )
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException ex) {
            return null;
        } finally {
            em.close();
        }
    }

    public User findByUsernameOrEmail(String loginValue) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            List<User> users = em.createQuery(
                            "SELECT u FROM User u " +
                                    "WHERE lower(u.username) = lower(:loginValue) " +
                                    "OR lower(u.email) = lower(:loginValue)",
                            User.class
                    )
                    .setParameter("loginValue", loginValue)
                    .setMaxResults(1)
                    .getResultList();
            return users.isEmpty() ? null : users.get(0);
        } finally {
            em.close();
        }
    }

    public User create(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
            return user;
        } catch (RuntimeException ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }
}
