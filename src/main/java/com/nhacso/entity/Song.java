package com.nhacso.entity;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;


@Entity
@Table(name = "SONG")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Song {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "song_id")
    private Integer songId;

    @Column(nullable = false)
    private String title;

    private Integer duration;

    @Column(name = "file_url", nullable = false)
    private String fileUrl;

    @Column(name = "cover_image")
    private String coverImage;

    @Column(name = "stream_url")
    private String streamUrl;

    @Column(name = "youtube_url")
    private String youtubeUrl;

    @Column(name = "listens_count")
    private Integer listensCount;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "album_id")
    @JsonIgnoreProperties("songs")
    private Album album;

    @ManyToMany
    @JoinTable(
            name = "SONG_ARTIST",
            joinColumns = @JoinColumn(name = "song_id"),
            inverseJoinColumns = @JoinColumn(name = "artist_id")
    )
    @JsonIgnoreProperties({"songs", "albums"})
    private List<Artist> artists;

    @ManyToMany
    @JoinTable(
            name = "SONG_GENRE",
            joinColumns = @JoinColumn(name = "song_id"),
            inverseJoinColumns = @JoinColumn(name = "genre_id")
    )
    @JsonIgnoreProperties("songs")
    private List<Genre> genres;

    // 1. Tự động gộp tên ca sĩ thành chuỗi cách nhau bằng dấu phẩy
    @org.hibernate.annotations.Formula("(SELECT STRING_AGG(a.name, ', ') FROM SONG_ARTIST sa JOIN ARTIST a ON sa.artist_id = a.artist_id WHERE sa.song_id = song_id)")
    private String artistNames;

    // 2. Tự động đếm tổng số lượt like của bài hát này
    @org.hibernate.annotations.Formula("(SELECT COUNT(*) FROM USER_LIKE_SONG uls WHERE uls.song_id = song_id)")
    private Integer likeCount;
}

