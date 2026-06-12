package com.nhacso.entity;

import lombok.*;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "PLAYLIST")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@ToString(exclude = {"songs", "user"})
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Playlist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "playlist_id")
    @EqualsAndHashCode.Include
    private int playlistId;

    @Column(name = "name", nullable = false, length = 150)
    private String name;

    @Column(name = "description", length = 500)
    private String description;

    // =====================================================
    // THAY ĐỔI QUAN TRỌNG: Map đối tượng thay vì lưu int userId
    // =====================================================
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Một playlist thuộc về 1 đối tượng User cụ thể

    // Đánh dấu để Hibernate không tự ý chèn null vào cột này khi tạo mới,
    // nhằm nhường quyền sinh thời gian cho DEFAULT GETDATE() dưới SQL Server
    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    // Quan hệ Nhiều - Nhiều (Many-to-Many) với bảng SONG qua bảng trung gian PLAYLIST_SONG
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "PLAYLIST_SONG",
            joinColumns = @JoinColumn(name = "playlist_id"),
            inverseJoinColumns = @JoinColumn(name = "song_id")
    )
    private Set<Song> songs = new HashSet<>();

    @org.hibernate.annotations.Formula("(SELECT COUNT(*) FROM PLAYLIST_SONG ps WHERE ps.playlist_id = playlist_id)")
    private Integer songCount;
}