package com.nhacso.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "album")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Album {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "album_id")
    private Integer albumId;

    @Column(nullable = false)
    private String title;

    @Column(name = "release_date")
    private LocalDateTime releaseDate;

    @Column(name = "cover_image")
    private String coverImage;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "artist_id")
    @JsonIgnoreProperties({"albums", "songs"})
    private Artist artist;

    @OneToMany(mappedBy = "album")
    @JsonIgnoreProperties({"album", "artists", "genres"})
    private List<Song> songs;
}

