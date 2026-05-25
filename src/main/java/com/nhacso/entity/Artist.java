package com.nhacso.entity;

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
    private List<Album> albums;

    @ManyToMany(mappedBy = "artists")
    private List<Song> songs;
}
