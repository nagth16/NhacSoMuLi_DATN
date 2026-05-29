package com.nhacso.dao;

import com.nhacso.entity.Song;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public class SongDAO {

    @PersistenceContext
    private EntityManager em;


    @Transactional
    public Song save(Song song) {
        if (song.getSongId() == null) {
            em.persist(song);
            return song;
        }
        return em.merge(song);
    }


    public Optional<Song> findById(Integer id) {
        return Optional.ofNullable(em.find(Song.class, id));
    }

    public List<Song> findAll() {
        return em.createQuery("SELECT s FROM Song s ORDER BY s.createdAt DESC", Song.class)
                .getResultList();
    }

    public List<Song> findByTitle(String keyword) {
        return em.createQuery(
                        "SELECT s FROM Song s WHERE LOWER(s.title) LIKE LOWER(:keyword) ORDER BY s.listensCount DESC",
                        Song.class)
                .setParameter("keyword", "%" + keyword + "%")
                .getResultList();
    }

    public List<Song> findByAlbumId(Integer albumId) {
        return em.createQuery(
                        "SELECT s FROM Song s WHERE s.album.albumId = :albumId ORDER BY s.songId",
                        Song.class)
                .setParameter("albumId", albumId)
                .getResultList();
    }

    public List<Song> findByArtistId(Integer artistId) {
        return em.createQuery(
                        "SELECT s FROM Song s JOIN s.artists a WHERE a.artistId = :artistId ORDER BY s.listensCount DESC",
                        Song.class)
                .setParameter("artistId", artistId)
                .getResultList();
    }

    public List<Song> findByGenreId(Integer genreId) {
        return em.createQuery(
                        "SELECT s FROM Song s JOIN s.genres g WHERE g.genreId = :genreId ORDER BY s.listensCount DESC",
                        Song.class)
                .setParameter("genreId", genreId)
                .getResultList();
    }

    public List<Song> findTopListened(int limit) {
        return em.createQuery(
                        "SELECT s FROM Song s ORDER BY s.listensCount DESC",
                        Song.class)
                .setMaxResults(limit)
                .getResultList();
    }

 
    @Transactional
    public void incrementListens(Integer songId) {
        em.createQuery("UPDATE Song s SET s.listensCount = s.listensCount + 1 WHERE s.songId = :songId")
                .setParameter("songId", songId)
                .executeUpdate();
    }
    
    @Transactional
    public void delete(Integer id) {
        Song song = em.find(Song.class, id);
        if (song != null) em.remove(song);
    }
}