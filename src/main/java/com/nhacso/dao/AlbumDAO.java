package com.nhacso.dao;

import com.nhacso.entity.Album;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public class AlbumDAO {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Album save(Album album) {
        if (album.getAlbumId() == null) {
            em.persist(album);
            return album;
        }
        return em.merge(album);
    }

    public Optional<Album> findById(Integer id) {
        return Optional.ofNullable(em.find(Album.class, id));
    }

    public List<Album> findAll() {
        return em.createQuery("SELECT a FROM Album a ORDER BY a.releaseDate DESC", Album.class)
                .getResultList();
    }

    public List<Album> findByTitle(String keyword) {
        return em.createQuery(
                        "SELECT a FROM Album a WHERE LOWER(a.title) LIKE LOWER(:keyword) ORDER BY a.releaseDate DESC",
                        Album.class)
                .setParameter("keyword", "%" + keyword + "%")
                .getResultList();
    }

    public List<Album> findByArtistId(Integer artistId) {
        return em.createQuery(
                        "SELECT a FROM Album a WHERE a.artist.artistId = :artistId ORDER BY a.releaseDate DESC",
                        Album.class)
                .setParameter("artistId", artistId)
                .getResultList();
    }

    public int countSongs(Integer albumId) {
        return ((Long) em.createQuery(
                        "SELECT COUNT(s) FROM Song s WHERE s.album.albumId = :albumId")
                .setParameter("albumId", albumId)
                .getSingleResult()).intValue();
    }

    @Transactional
    public void delete(Integer id) {
        Album album = em.find(Album.class, id);
        if (album != null) em.remove(album);
    }
}