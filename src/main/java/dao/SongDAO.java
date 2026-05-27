package dao;

import entity.Song;
import utils.JpaUtils;

import javax.persistence.EntityManager;
import java.util.List;

public class SongDAO {
    public Song findById(Integer songId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return songId == null ? null : em.find(Song.class, songId);
        } finally {
            em.close();
        }
    }

    public List<Song> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Song s ORDER BY s.title", Song.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
