package com.nhacso.dao;

import com.nhacso.entity.Song;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.List;

@Repository
@Transactional
public class UserLikeSongDAO {

    @PersistenceContext
    private EntityManager em;

    // =========================================================
    // PHẦN 1 — LIKE / UNLIKE
    // =========================================================

    public boolean likeSong(int userId, int songId) {
        if (isLiked(userId, songId)) {
            return false;
        }
        try {
            String sql = "INSERT INTO USER_LIKE_SONG (user_id, song_id) VALUES (?, ?)";
            int result = em.createNativeQuery(sql)
                    .setParameter(1, userId)
                    .setParameter(2, songId)
                    .executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean unlikeSong(int userId, int songId) {
        try {
            String sql = "DELETE FROM USER_LIKE_SONG WHERE user_id = ? AND song_id = ?";
            int result = em.createNativeQuery(sql)
                    .setParameter(1, userId)
                    .setParameter(2, songId)
                    .executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleLike(int userId, int songId) {
        if (isLiked(userId, songId)) {
            unlikeSong(userId, songId);
            return false;
        } else {
            likeSong(userId, songId);
            return true;
        }
    }

    // =========================================================
    // PHẦN 2 — KIỂM TRA TRẠNG THÁI
    // =========================================================

    @Transactional(readOnly = true)
    public boolean isLiked(int userId, int songId) {
        String sql = "SELECT COUNT(*) FROM USER_LIKE_SONG WHERE user_id = ? AND song_id = ?";
        Number count = (Number) em.createNativeQuery(sql)
                .setParameter(1, userId)
                .setParameter(2, songId)
                .getSingleResult();
        return count.intValue() > 0;
    }

    @Transactional(readOnly = true)
    @SuppressWarnings("unchecked")
    public List<Integer> getLikedSongIds(int userId) {
        String sql = "SELECT song_id FROM USER_LIKE_SONG WHERE user_id = ?";
        return em.createNativeQuery(sql).setParameter(1, userId).getResultList();
    }

    // =========================================================
    // PHẦN 3 — DANH SÁCH BÀI HÁT YÊU THÍCH (ĐÃ LÀM SẠCH SQL)
    // =========================================================

    private static final String SONG_COLS = """
            s.song_id, s.album_id,
            (SELECT STRING_AGG(a.name, ', ') FROM SONG_ARTIST sa JOIN ARTIST a ON a.artist_id = sa.artist_id WHERE sa.song_id = s.song_id) AS artistNames,
            s.cover_image, s.created_at, s.duration, s.file_url,
            (SELECT COUNT(*) FROM USER_LIKE_SONG uls2 WHERE uls2.song_id = s.song_id) AS likeCount,
            s.listens_count, s.stream_url, s.title, s.youtube_url
            """;

    // Helper: build a SELECT ... FROM query with SONG_COLS
    private String selectSongCols() {
        return "SELECT " + SONG_COLS;
    }

    /**
     * Lấy toàn bộ bài hát yêu thích của user
     */
    @Transactional(readOnly = true)
    @SuppressWarnings("unchecked")
    public List<Song> getLikedSongs(int userId) {
        String sql = selectSongCols() + """
                FROM USER_LIKE_SONG uls 
                JOIN SONG s ON uls.song_id = s.song_id 
                WHERE uls.user_id = ? 
                ORDER BY uls.liked_at DESC
                """;
        return em.createNativeQuery(sql, Song.class)
                .setParameter(1, userId)
                .getResultList();
    }

    /**
     * Lấy danh sách bài hát yêu thích có phân trang
     */
    @Transactional(readOnly = true)
    @SuppressWarnings("unchecked")
    public List<Song> getLikedSongsPaged(int userId, int page, int pageSize) {
        String sql = selectSongCols() + """
                FROM USER_LIKE_SONG uls 
                JOIN SONG s ON uls.song_id = s.song_id 
                WHERE uls.user_id = ? 
                ORDER BY uls.liked_at DESC 
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        int offset = (page - 1) * pageSize;
        return em.createNativeQuery(sql, Song.class)
                .setParameter(1, userId)
                .setParameter(2, offset)
                .setParameter(3, pageSize)
                .getResultList();
    }

    /**
     * Lấy bài hát yêu thích theo thể loại
     */
    @Transactional(readOnly = true)
    @SuppressWarnings("unchecked")
    public List<Song> getLikedSongsByGenre(int userId, int genreId) {
        String sql = selectSongCols() + """
                FROM USER_LIKE_SONG uls 
                JOIN SONG s ON uls.song_id = s.song_id 
                JOIN SONG_GENRE sg ON s.song_id = sg.song_id AND sg.genre_id = ? 
                WHERE uls.user_id = ? 
                ORDER BY uls.liked_at DESC
                """;
        return em.createNativeQuery(sql, Song.class)
                .setParameter(1, genreId)
                .setParameter(2, userId)
                .getResultList();
    }

    /**
     * Tìm kiếm trong danh sách yêu thích của User
     */
    @Transactional(readOnly = true)
    @SuppressWarnings("unchecked")
    public List<Song> searchLikedSongs(int userId, String keyword) {
        String sql = selectSongCols() + """
                FROM USER_LIKE_SONG uls 
                JOIN SONG s ON uls.song_id = s.song_id 
                WHERE uls.user_id = ? 
                AND (s.title LIKE ? OR s.song_id IN (
                    SELECT sa.song_id FROM SONG_ARTIST sa 
                    JOIN ARTIST a ON sa.artist_id = a.artist_id WHERE a.name LIKE ?
                ))
                ORDER BY uls.liked_at DESC
                """;
        String kw = "%" + keyword + "%";
        return em.createNativeQuery(sql, Song.class)
                .setParameter(1, userId)
                .setParameter(2, kw)
                .setParameter(3, kw)
                .getResultList();
    }

    // =========================================================
    // PHẦN 4 — THỐNG KÊ
    // =========================================================

    @Transactional(readOnly = true)
    public int countLikedSongs(int userId) {
        String sql = "SELECT COUNT(*) FROM USER_LIKE_SONG WHERE user_id = ?";
        Number count = (Number) em.createNativeQuery(sql)
                .setParameter(1, userId)
                .getSingleResult();
        return count.intValue();
    }

    @Transactional(readOnly = true)
    public int countLikesForSong(int songId) {
        String sql = "SELECT COUNT(*) FROM USER_LIKE_SONG WHERE song_id = ?";
        Number count = (Number) em.createNativeQuery(sql)
                .setParameter(1, songId)
                .getSingleResult();
        return count.intValue();
    }

    /**
     * Lấy danh sách TOP bài hát được yêu thích nhiều nhất hệ thống
     */
    @Transactional(readOnly = true)
    @SuppressWarnings("unchecked")
    public List<Song> getTopLikedSongs(int topN) {
        String sql = selectSongCols() + """
                FROM SONG s 
                LEFT JOIN USER_LIKE_SONG uls ON s.song_id = uls.song_id 
                GROUP BY s.song_id, s.title, s.duration, s.file_url, s.cover_image, s.album_id, s.listens_count, s.created_at 
                ORDER BY COUNT(uls.user_id) DESC, s.listens_count DESC
                """;
        return em.createNativeQuery(sql, Song.class)
                .setMaxResults(topN)
                .getResultList();
    }

    @Transactional(readOnly = true)
    public Timestamp getLikedAt(int userId, int songId) {
        String sql = "SELECT liked_at FROM USER_LIKE_SONG WHERE user_id = ? AND song_id = ?";
        try {
            return (Timestamp) em.createNativeQuery(sql)
                    .setParameter(1, userId)
                    .setParameter(2, songId)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }
}