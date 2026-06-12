package com.nhacso.dao;

import com.nhacso.entity.Song;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

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

    public List<Song> findAllWithArtists() {
        List<Song> result = em.createQuery(
                "SELECT s FROM Song s LEFT JOIN FETCH s.artists ORDER BY s.createdAt DESC",
                Song.class
        ).getResultList();
        // Dedup by songId to avoid duplicates from LEFT JOIN FETCH
        Map<Integer, Song> unique = new java.util.LinkedHashMap<>();
        for (Song song : result) {
            unique.putIfAbsent(song.getSongId(), song);
        }
        return new java.util.ArrayList<>(unique.values());
    }

    public List<Song> findByTitle(String keyword) {
        return em.createQuery(
                        "SELECT s FROM Song s WHERE LOWER(s.title) LIKE LOWER(:keyword) ORDER BY s.listensCount DESC",
                        Song.class)
                .setParameter("keyword", "%" + keyword + "%")
                .getResultList();
    }

    public List<Song> searchByKeyword(String keyword) {
        String sql = """
                SELECT s.song_id, s.album_id,
                  (SELECT STRING_AGG(a.name, ', ') FROM SONG_ARTIST sa JOIN ARTIST a ON a.artist_id = sa.artist_id WHERE sa.song_id = s.song_id) AS artistNames,
                  s.cover_image, s.created_at, s.duration, s.file_url,
                  (SELECT COUNT(*) FROM USER_LIKE_SONG uls WHERE uls.song_id = s.song_id) AS likeCount,
                  s.listens_count, s.stream_url, s.title, s.youtube_url
                FROM SONG s
                WHERE s.song_id IN (
                    SELECT s2.song_id FROM SONG s2
                    LEFT JOIN SONG_ARTIST sa ON s2.song_id = sa.song_id
                    LEFT JOIN ARTIST a ON sa.artist_id = a.artist_id
                    WHERE s2.title COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?
                       OR a.name COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?
                )
                ORDER BY s.listens_count DESC
                """;
        String kw = "%" + keyword + "%";
        return em.createNativeQuery(sql, Song.class)
                .setParameter(1, kw)
                .setParameter(2, kw)
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