package com.nhacso.dao;

import com.nhacso.entity.Playlist;
import com.nhacso.entity.Song;
import com.nhacso.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository // Đăng ký lớp này là một Bean Component do Spring quản lý tầng dữ liệu
@Transactional // Tự động đóng/mở và xử lý Rollback Transaction (Giao dịch) tự động
public class PlaylistDAO {

    @PersistenceContext // Spring tự động tiêm EntityManager vào (Không cần DBConnection nữa)
    private EntityManager em;

    // =====================================================
    // 1. Lấy danh sách playlist theo user_id (Sắp xếp mới nhất)
    // =====================================================
    @Transactional(readOnly = true)
    public List<Playlist> getPlaylistsByUserId(int userId) {
        String jpql = "SELECT p FROM Playlist p WHERE p.user.userId = :userId ORDER BY p.createdAt DESC";
        return em.createQuery(jpql, Playlist.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    // =====================================================
    // 2. Tạo playlist mới (Trả về ID vừa tạo)
    // =====================================================
    public int createPlaylist(Playlist playlist) {
        try {
            // Lưu đối tượng xuống DB bằng JPA
            em.persist(playlist);
            // Sau khi persist thành công, JPA tự động nạp ID do DB sinh vào đối tượng
            return playlist.getPlaylistId();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // =====================================================
    // 3. Lấy playlist theo ID
    // =====================================================
    @Transactional(readOnly = true)
    public Playlist getPlaylistById(int id) {
        return em.find(Playlist.class, id); // Hàm tìm kiếm theo Khóa chính siêu ngắn của JPA
    }

    // =====================================================
    // 4. Cập nhật playlist
    // =====================================================
    public boolean updatePlaylist(Playlist playlist) {
        try {
            em.merge(playlist); // Hàm cập nhật dữ liệu tự động của JPA
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =====================================================
    // 5. User tự xóa playlist của mình
    // =====================================================
    public boolean deletePlaylist(int playlistId, int userId) {
        try {
            String jpql = "SELECT p FROM Playlist p WHERE p.playlistId = :playlistId AND p.user.userId = :userId";
            Playlist playlist = em.createQuery(jpql, Playlist.class)
                    .setParameter("playlistId", playlistId)
                    .setParameter("userId", userId)
                    .getSingleResult();

            if (playlist != null) {
                em.remove(playlist); // Xóa đối tượng khỏi DB
                return true;
            }
        } catch (NoResultException e) {
            // Không tìm thấy playlist phù hợp với cặp ID này
            return false;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =====================================================
    // 6. Admin xóa bất kỳ playlist nào
    // =====================================================
    public boolean deletePlaylistByAdmin(int playlistId) {
        try {
            Playlist playlist = em.find(Playlist.class, playlistId);
            if (playlist != null) {
                em.remove(playlist);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =====================================================
    // 7. Kiểm tra quyền sở hữu Playlist
    // =====================================================
    @Transactional(readOnly = true)
    public boolean isOwner(int playlistId, int userId) {
        String jpql = "SELECT COUNT(p) FROM Playlist p WHERE p.playlistId = :playlistId AND p.user.userId = :userId";
        Long count = em.createQuery(jpql, Long.class)
                .setParameter("playlistId", playlistId)
                .setParameter("userId", userId)
                .getSingleResult();
        return count > 0;
    }

    // =====================================================
    // 8. Thêm bài hát vào bảng trung gian (Dùng Native Query)
    // =====================================================
    public boolean addSongToPlaylist(int playlistId, int songId) {
        try {
            // Nếu dùng quan hệ @ManyToMany chuẩn thì code sẽ khác, nhưng để giữ nguyên logic
            // không làm ảnh hưởng các file khác của bạn, mình dùng Native Query tương tác bảng trung gian:
            String sql = "INSERT INTO PLAYLIST_SONG(playlist_id, song_id) VALUES (?, ?)";
            int result = em.createNativeQuery(sql)
                    .setParameter(1, playlistId)
                    .setParameter(2, songId)
                    .executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =====================================================
    // 9. Xóa bài hát khỏi bảng trung gian
    // =====================================================
    public boolean removeSongFromPlaylist(int playlistId, int songId) {
        try {
            String sql = "DELETE FROM PLAYLIST_SONG WHERE playlist_id = ? AND song_id = ?";
            int result = em.createNativeQuery(sql)
                    .setParameter(1, playlistId)
                    .setParameter(2, songId)
                    .executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =====================================================
    // 10. Kiểm tra bài hát đã có trong playlist chưa
    // =====================================================
    @Transactional(readOnly = true)
    public boolean isSongInPlaylist(int playlistId, int songId) {
        String sql = "SELECT COUNT(*) FROM PLAYLIST_SONG WHERE playlist_id = ? AND song_id = ?";
        Number count = (Number) em.createNativeQuery(sql)
                .setParameter(1, playlistId)
                .setParameter(2, songId)
                .getSingleResult();
        return count.intValue() > 0;
    }

    // =====================================================
    // 11. Đếm số lượng bài hát có trong playlist
    // =====================================================
    @Transactional(readOnly = true)
    public int countSongsInPlaylist(int playlistId) {
        String sql = "SELECT COUNT(*) FROM PLAYLIST_SONG WHERE playlist_id = ?";
        Number count = (Number) em.createNativeQuery(sql)
                .setParameter(1, playlistId)
                .getSingleResult();
        return count.intValue();
    }

    // =====================================================
    // 12. Lấy danh sách bài hát thuộc playlist (INNER JOIN)
    // =====================================================
    @Transactional(readOnly = true)
    public List<Song> getSongsByPlaylistId(int playlistId) {
        String jpql = "SELECT s FROM Playlist p JOIN p.songs s WHERE p.playlistId = :playlistId";
        return em.createQuery(jpql, Song.class)
                .setParameter("playlistId", playlistId)
                .getResultList();
    }

    // =====================================================
    // 13. Tìm kiếm danh sách playlist theo từ khóa tên
    // =====================================================
    @Transactional(readOnly = true)
    public List<Playlist> searchPlaylists(String keyword, int userId) {
        String jpql = "SELECT p FROM Playlist p WHERE p.user.userId = :userId AND p.name LIKE :keyword";
        return em.createQuery(jpql, Playlist.class)
                .setParameter("userId", userId)
                .setParameter("keyword", "%" + keyword + "%")
                .getResultList();
    }

    // =====================================================
    // 14. Kiểm tra tên playlist đã tồn tại cho user chưa
    // =====================================================
    @Transactional(readOnly = true)
    public boolean isNameTaken(String name, int userId) {
        String jpql = "SELECT COUNT(p) FROM Playlist p WHERE p.user.userId = :userId AND p.name = :name";
        Long count = em.createQuery(jpql, Long.class)
                .setParameter("userId", userId)
                .setParameter("name", name)
                .getSingleResult();
        return count > 0;
    }
}