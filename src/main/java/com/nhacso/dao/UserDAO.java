package com.nhacso.dao;

import com.nhacso.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository // Khai báo lớp này là một Repository do Spring quản lý
@Transactional // Tự động quản lý đóng/mở Transaction (Commit/Rollback) cho tất cả các hàm ghi dữ liệu
public class UserDAO {

    @PersistenceContext // Spring tự động "bơm" EntityManager vào đây, không cần JpaUtil đóng/mở tay nữa
    private EntityManager em;

    /**
     * Tìm tất cả người dùng
     */
    public List<User> findAll() {
        String jpql = "SELECT u FROM User u";
        TypedQuery<User> query = em.createQuery(jpql, User.class);
        return query.getResultList();
    }

    /**
     * Tìm người dùng bằng ID (Đã sửa từ String sang Integer theo đúng Entity mới)
     */
    public User findById(Integer id) {
        return em.find(User.class, id);
    }

    /**
     * Tìm người dùng bằng Username
     */
    public User findByUsername(String username) {
        String jpql = "SELECT u FROM User u WHERE u.username = :username";
        try {
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("username", username);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null; // Không tìm thấy thì trả về null giống code cũ của bạn
        }
    }

    /**
     * Tìm người dùng bằng Email
     */
    public User findByEmail(String email) {
        String jpql = "SELECT u FROM User u WHERE u.email = :email";
        try {
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("email", email);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Tìm người dùng bằng Username HOẶC Email (Hàm này dùng ở LoginController)
     */
    public User findByUsernameOrEmail(String usernameOrEmail) {
        String jpql = "SELECT u FROM User u WHERE u.username = :input OR u.email = :input";
        try {
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("input", usernameOrEmail);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Thêm mới người dùng
     */
    public void create(User user) {
        em.persist(user); // Chỉ cần đúng 1 dòng, Spring tự lo Transaction và che giấu try-catch phức tạp
    }

    /**
     * Cập nhật thông tin người dùng
     */
    public void update(User user) {
        em.merge(user);
    }

    /**
     * Xóa người dùng bằng ID
     */
    public void delete(Integer id) {
        User user = findById(id);
        if (user != null) {
            em.remove(user);
        }
    }

    /**
     * Phân trang danh sách người dùng
     */
    public List<User> findWithPagination(int page, int pageSize) {
        String jpql = "SELECT u FROM User u";
        TypedQuery<User> query = em.createQuery(jpql, User.class);
        query.setFirstResult((page - 1) * pageSize);
        query.setMaxResults(pageSize);
        return query.getResultList();
    }

    /**
     * Đếm tổng số người dùng trong hệ thống
     */
    public long count() {
        String jpql = "SELECT COUNT(u) FROM User u";
        return em.createQuery(jpql, Long.class).getSingleResult();
    }
}
