package com.nhacso.dao;

import com.nhacso.entity.Genre;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public class GenreDAO {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Genre save(Genre genre) {
        if (genre.getGenreId() == null) {
            em.persist(genre);
            return genre;
        }
        return em.merge(genre);
    }

    public Optional<Genre> findById(Integer id) {
        return Optional.ofNullable(em.find(Genre.class, id));
    }

    public List<Genre> findAll() {
        return em.createQuery("SELECT g FROM Genre g ORDER BY g.genreName", Genre.class)
                .getResultList();
    }

    public Optional<Genre> findByName(String genreName) {
        List<Genre> result = em.createQuery(
                        "SELECT g FROM Genre g WHERE g.genreName = :name", Genre.class)
                .setParameter("name", genreName)
                .getResultList();
        return result.stream().findFirst();
    }

    public boolean existsByName(String genreName) {
        Long count = em.createQuery(
                        "SELECT COUNT(g) FROM Genre g WHERE g.genreName = :name", Long.class)
                .setParameter("name", genreName)
                .getSingleResult();
        return count > 0;
    }

    public List<Genre> findBySongId(Integer songId) {
        return em.createQuery(
                        "SELECT g FROM Genre g JOIN g.songs s WHERE s.songId = :songId ORDER BY g.genreName",
                        Genre.class)
                .setParameter("songId", songId)
                .getResultList();
    }

    @Transactional
    public void delete(Integer id) {
        Genre genre = em.find(Genre.class, id);
        if (genre != null) em.remove(genre);
    }
}