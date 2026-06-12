package com.nhacso.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "ARTIST")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Artist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "artist_id")
    private Integer artistId;

    @Column(nullable = false)
    private String name;

    private String bio;

    private String country;

    @OneToMany(mappedBy = "artist")
    @JsonIgnoreProperties({"artist", "songs"})
    private List<Album> albums;

    @ManyToMany(mappedBy = "artists")
    @JsonIgnoreProperties({"artists", "album"})
    private List<Song> songs;
}
