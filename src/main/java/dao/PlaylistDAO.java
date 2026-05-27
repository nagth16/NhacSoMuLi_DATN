package dao;

import entity.Playlist;
import entity.Song;
import entity.User;
import utils.JpaUtils;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import java.util.List;

public class PlaylistDAO {
    public Playlist create(String name, String description, Integer userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, userId);
            if (user == null) {
                throw new IllegalArgumentException("User khong ton tai.");
            }

            Playlist playlist = new Playlist();
            playlist.setName(name);
            playlist.setDescription(description);
            playlist.setUser(user);

            em.persist(playlist);
            em.getTransaction().commit();
            return playlist;
        } catch (RuntimeException ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    public Playlist findOwnedById(Integer playlistId, Integer userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Playlist p WHERE p.playlistId = :playlistId AND p.user.userId = :userId",
                            Playlist.class
                    )
                    .setParameter("playlistId", playlistId)
                    .setParameter("userId", userId)
                    .getSingleResult();
        } catch (NoResultException ex) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<Playlist> findByUser(Integer userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Playlist p WHERE p.user.userId = :userId ORDER BY p.createdAt DESC",
                            Playlist.class
                    )
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean addSong(Integer playlistId, Integer songId, Integer userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Playlist playlist = findOwnedById(em, playlistId, userId);
            Song song = em.find(Song.class, songId);
            if (playlist == null || song == null) {
                em.getTransaction().rollback();
                return false;
            }

            int exists = ((Number) em.createNativeQuery(
                            "SELECT COUNT(*) FROM PLAYLIST_SONG WHERE playlist_id = ? AND song_id = ?"
                    )
                    .setParameter(1, playlistId)
                    .setParameter(2, songId)
                    .getSingleResult()).intValue();
            if (exists == 0) {
                em.createNativeQuery("INSERT INTO PLAYLIST_SONG (playlist_id, song_id) VALUES (?, ?)")
                        .setParameter(1, playlistId)
                        .setParameter(2, songId)
                        .executeUpdate();
            }

            em.getTransaction().commit();
            return true;
        } catch (RuntimeException ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    public boolean removeSong(Integer playlistId, Integer songId, Integer userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Playlist playlist = findOwnedById(em, playlistId, userId);
            if (playlist == null || em.find(Song.class, songId) == null) {
                em.getTransaction().rollback();
                return false;
            }

            em.createNativeQuery("DELETE FROM PLAYLIST_SONG WHERE playlist_id = ? AND song_id = ?")
                    .setParameter(1, playlistId)
                    .setParameter(2, songId)
                    .executeUpdate();

            em.getTransaction().commit();
            return true;
        } catch (RuntimeException ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    private Playlist findOwnedById(EntityManager em, Integer playlistId, Integer userId) {
        List<Playlist> playlists = em.createQuery(
                        "SELECT p FROM Playlist p WHERE p.playlistId = :playlistId AND p.user.userId = :userId",
                        Playlist.class
                )
                .setParameter("playlistId", playlistId)
                .setParameter("userId", userId)
                .setMaxResults(1)
                .getResultList();
        return playlists.isEmpty() ? null : playlists.get(0);
    }
}
