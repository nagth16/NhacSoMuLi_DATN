package com.nhacso.dao;

import com.nhacso.entity.ListenHistory;
import com.nhacso.entity.Song;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class ListenHistoryDAO {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public ListenHistory save(ListenHistory history) {
        if (history.getHistoryId() == null) {
            em.persist(history);
            return history;
        }
        return em.merge(history);
    }

    public Optional<ListenHistory> findById(Long id) {
        return Optional.ofNullable(em.find(ListenHistory.class, id));
    }

    public List<ListenHistory> findByUserId(Integer userId) {
        return em.createQuery(
                        "SELECT lh FROM ListenHistory lh WHERE lh.user.userId = :userId ORDER BY lh.playedAt DESC",
                        ListenHistory.class)
                .setParameter("userId", userId)
                .getResultList();
    }


    public List<ListenHistory> findRecentByUserId(Integer userId, int limit) {
        return em.createQuery(
                        "SELECT lh FROM ListenHistory lh WHERE lh.user.userId = :userId ORDER BY lh.playedAt DESC",
                        ListenHistory.class)
                .setParameter("userId", userId)
                .setMaxResults(limit)
                .getResultList();
    }

    public List<ListenHistory> findByUserIdAndDateRange(Integer userId, LocalDateTime from, LocalDateTime to) {
        return em.createQuery("""
                        SELECT lh FROM ListenHistory lh
                        WHERE lh.user.userId = :userId
                          AND lh.playedAt BETWEEN :from AND :to
                        ORDER BY lh.playedAt DESC
                        """, ListenHistory.class)
                .setParameter("userId", userId)
                .setParameter("from", from)
                .setParameter("to", to)
                .getResultList();
    }

    public long countBySongId(Integer songId) {
        return em.createQuery(
                        "SELECT COUNT(lh) FROM ListenHistory lh WHERE lh.song.songId = :songId", Long.class)
                .setParameter("songId", songId)
                .getSingleResult();
    }

    public long countByUserId(Integer userId) {
        return em.createQuery(
                        "SELECT COUNT(lh) FROM ListenHistory lh WHERE lh.user.userId = :userId", Long.class)
                .setParameter("userId", userId)
                .getSingleResult();
    }

    public List<Object[]> findTopSongs(int limit) {
        return em.createQuery("""
                        SELECT lh.song, COUNT(lh)
                        FROM ListenHistory lh
                        GROUP BY lh.song
                        ORDER BY COUNT(lh) DESC
                        """, Object[].class)
                .setMaxResults(limit)
                .getResultList();
    }

    public List<Object[]> findTopSongsByUser(Integer userId, int limit) {
        return em.createQuery("""
                        SELECT lh.song, COUNT(lh)
                        FROM ListenHistory lh
                        WHERE lh.user.userId = :userId
                        GROUP BY lh.song
                        ORDER BY COUNT(lh) DESC
                        """, Object[].class)
                .setParameter("userId", userId)
                .setMaxResults(limit)
                .getResultList();
    }

    public boolean existsBySongIdAndUserId(Integer songId, Integer userId) {
        Long count = em.createQuery(
                        "SELECT COUNT(lh) FROM ListenHistory lh WHERE lh.song.songId = :songId AND lh.user.userId = :userId",
                        Long.class)
                .setParameter("songId", songId)
                .setParameter("userId", userId)
                .getSingleResult();
        return count > 0;
    }

    @Transactional
    public void delete(Long id) {
        ListenHistory lh = em.find(ListenHistory.class, id);
        if (lh != null) em.remove(lh);
    }

    @Transactional
    public void deleteByUserId(Integer userId) {
        em.createQuery("DELETE FROM ListenHistory lh WHERE lh.user.userId = :userId")
                .setParameter("userId", userId)
                .executeUpdate();
    }
}