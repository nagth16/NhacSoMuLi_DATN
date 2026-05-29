package com.nhacso.dao;

import com.nhacso.entity.Artist;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public class ArtistDAO {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Artist save(Artist artist) {
        if (artist.getArtistId() == null) {
            em.persist(artist);
            return artist;
        }
        return em.merge(artist);
    }

    public Optional<Artist> findById(Integer id) {
        return Optional.ofNullable(em.find(Artist.class, id));
    }

    public List<Artist> findAll() {
        return em.createQuery("SELECT a FROM Artist a ORDER BY a.name", Artist.class)
                .getResultList();
    }

    public List<Artist> findByName(String keyword) {
        return em.createQuery(
                        "SELECT a FROM Artist a WHERE LOWER(a.name) LIKE LOWER(:keyword) ORDER BY a.name",
                        Artist.class)
                .setParameter("keyword", "%" + keyword + "%")
                .getResultList();
    }

    public List<Artist> findByCountry(String country) {
        return em.createQuery(
                        "SELECT a FROM Artist a WHERE a.country = :country ORDER BY a.name",
                        Artist.class)
                .setParameter("country", country)
                .getResultList();
    }

    public List<Artist> findBySongId(Integer songId) {
        return em.createQuery(
                        "SELECT a FROM Artist a JOIN a.songs s WHERE s.songId = :songId ORDER BY a.name",
                        Artist.class)
                .setParameter("songId", songId)
                .getResultList();
    }

    @Transactional
    public void delete(Integer id) {
        Artist artist = em.find(Artist.class, id);
        if (artist != null) em.remove(artist);
    }
}