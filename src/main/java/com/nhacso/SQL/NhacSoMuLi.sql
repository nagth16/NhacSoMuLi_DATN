-- ============================================================
-- NHAC SO MULI - DATABASE SCRIPT (FULL)
-- ============================================================

-- 0. Xoa Database cu neu ton tai
USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'NhacSoMuli')
BEGIN
    ALTER DATABASE NhacSoMuli SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NhacSoMuli;
END
GO

-- 1. Tao Database
CREATE DATABASE NhacSoMuli;
GO
USE NhacSoMuli;
GO

-- 2. Bang USER (Nguoi dung / Khach hang)
CREATE TABLE [USER] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    [password] VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100),
    role VARCHAR(20) DEFAULT 'USER',
    status INT DEFAULT 1,
    premium BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 3. Bang ARTIST (Ca si / Nghe si)
CREATE TABLE ARTIST (
    artist_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    bio NVARCHAR(MAX),
    country NVARCHAR(50)
);
GO

-- 4. Bang ALBUM
CREATE TABLE ALBUM (
    album_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(150) NOT NULL,
    release_date DATE,
    cover_image NVARCHAR(500),
    artist_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Album_Artist FOREIGN KEY (artist_id) REFERENCES ARTIST(artist_id) ON DELETE SET NULL
);
GO

-- 5. Bang GENRE (The loai nhac)
CREATE TABLE GENRE (
    genre_id INT IDENTITY(1,1) PRIMARY KEY,
    genre_name NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- 6. Bang SONG (Bai hat)
CREATE TABLE SONG (
    song_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(150) NOT NULL,
    duration INT,
    file_url NVARCHAR(500) NOT NULL,
    stream_url NVARCHAR(1000),
    youtube_url NVARCHAR(500),
    cover_image NVARCHAR(500),
    album_id INT NULL,
    listens_count INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Song_Album FOREIGN KEY (album_id) REFERENCES ALBUM(album_id) ON DELETE SET NULL
);
GO

-- 7. Bang PLAYLIST (Danh sach phat ca nhan)
CREATE TABLE PLAYLIST (
    playlist_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(500),
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Playlist_User FOREIGN KEY (user_id) REFERENCES [USER](user_id) ON DELETE CASCADE
);
GO

-- 8. Bang trung gian SONG_ARTIST
CREATE TABLE SONG_ARTIST (
    song_id INT NOT NULL,
    artist_id INT NOT NULL,
    CONSTRAINT PK_Song_Artist PRIMARY KEY (song_id, artist_id),
    CONSTRAINT FK_SongArtist_Song FOREIGN KEY (song_id) REFERENCES SONG(song_id) ON DELETE CASCADE,
    CONSTRAINT FK_SongArtist_Artist FOREIGN KEY (artist_id) REFERENCES ARTIST(artist_id) ON DELETE CASCADE
);
GO

-- 9. Bang trung gian SONG_GENRE
CREATE TABLE SONG_GENRE (
    song_id INT NOT NULL,
    genre_id INT NOT NULL,
    CONSTRAINT PK_Song_Genre PRIMARY KEY (song_id, genre_id),
    CONSTRAINT FK_SongGenre_Song FOREIGN KEY (song_id) REFERENCES SONG(song_id) ON DELETE CASCADE,
    CONSTRAINT FK_SongGenre_Genre FOREIGN KEY (genre_id) REFERENCES GENRE(genre_id) ON DELETE CASCADE
);
GO

-- 10. Bang trung gian PLAYLIST_SONG
CREATE TABLE PLAYLIST_SONG (
    playlist_id INT NOT NULL,
    song_id INT NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Playlist_Song PRIMARY KEY (playlist_id, song_id),
    CONSTRAINT FK_PlaylistSong_Playlist FOREIGN KEY (playlist_id) REFERENCES PLAYLIST(playlist_id) ON DELETE CASCADE,
    CONSTRAINT FK_PlaylistSong_Song FOREIGN KEY (song_id) REFERENCES SONG(song_id) ON DELETE CASCADE
);
GO

-- 10b. Bang USER_LIKE_SONG (Bai hat yeu thich)
CREATE TABLE USER_LIKE_SONG (
    user_id INT NOT NULL,
    song_id INT NOT NULL,
    liked_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_User_Like_Song PRIMARY KEY (user_id, song_id),
    CONSTRAINT FK_UserLike_User FOREIGN KEY (user_id) REFERENCES [USER](user_id) ON DELETE CASCADE,
    CONSTRAINT FK_UserLike_Song FOREIGN KEY (song_id) REFERENCES SONG(song_id) ON DELETE CASCADE
);
GO

-- ============================================================
-- DU LIEU MAU - USER
-- ============================================================
INSERT INTO [USER] (username, [password], email, full_name, role, status, premium) VALUES
('admin1', 'hashed_pass_1', 'admin.muli1@nhacso.vn', N'Nguyen Hoang Long', 'ADMIN', 1, 1),
('admin2', 'hashed_pass_2', 'admin.muli2@nhacso.vn', N'Tran Thi Thanh Tuyen', 'ADMIN', 1, 1),
('admin3', 'hashed_pass_3', 'admin.muli3@nhacso.vn', N'Le Minh Khoi', 'ADMIN', 1, 1),
('admin4', 'hashed_pass_4', 'admin.muli4@nhacso.vn', N'Pham Bao Nam', 'ADMIN', 1, 1),
('admin5', 'hashed_pass_5', 'admin.muli5@nhacso.vn', N'Vu Hoang Yen', 'ADMIN', 1, 1),
('user01', 'user_pass_1', 'tung.nguyen@gmail.com', N'Nguyen Thanh Tung', 'USER', 1, 0),
('user02', 'user_pass_2', 'hoa.vu@gmail.com', N'Vu Thi Hoa', 'USER', 1, 0),
('user03', 'user_pass_3', 'dung.le@gmail.com', N'Le Van Dung', 'USER', 1, 0),
('user04', 'user_pass_4', 'linh.hoang@gmail.com', N'Hoang Thuy Linh', 'USER', 1, 0),
('user05', 'user_pass_5', 'khanh.pham@gmail.com', N'Pham Nam Khanh', 'USER', 1, 0),
('user06', 'user_pass_6', 'vy.tran@gmail.com', N'Tran Thao Vy', 'USER', 1, 0),
('user07', 'user_pass_7', 'minh.nguyen@gmail.com', N'Nguyen Quang Minh', 'USER', 1, 0),
('user08', 'user_pass_8', 'ha.pham@gmail.com', N'Pham Thu Ha', 'USER', 1, 0),
('user09', 'user_pass_9', 'quan.do@gmail.com', N'Do Anh Quan', 'USER', 1, 0),
('user10', 'user_pass_10', 'trang.le@gmail.com', N'Le Thu Trang', 'USER', 1, 0),
('user11', 'user_pass_11', 'phuc.hoang@gmail.com', N'Hoang Hong Phuc', 'USER', 1, 0),
('user12', 'user_pass_12', 'anh.nguyen@gmail.com', N'Nguyen Duc Anh', 'USER', 1, 0),
('user13', 'user_pass_13', 'mai.tuyet@gmail.com', N'Tuyet Mai', 'USER', 1, 0),
('user14', 'user_pass_14', 'son.lam@gmail.com', N'Lam Thanh Son', 'USER', 0, 0),
('user15', 'user_pass_15', 'huyen.dang@gmail.com', N'Dang Thanh Huyen', 'USER', 1, 0),
('redbee','redbee','redbee@gmail.com',N'Nguyen Huynh Minh Nhat','ADMIN',1,1);
GO

-- ============================================================
-- DU LIEU MAU - ARTIST
-- ============================================================
INSERT INTO ARTIST (name, bio, country) VALUES
(N'Son Tung M-TP', N'Ca si, nhac si nhac Pop hang dau Viet Nam.', N'Viet Nam'),
(N'Den Vau', N'Rapper mang phong cach moc mac, triet ly.', N'Viet Nam'),
(N'My Tam', N'Hoai mi toc nau, diva nhac Pop noi tieng.', N'Viet Nam'),
(N'Vu.', N'Hoang tu Indie Viet Nam voi chat giong tram am.', N'Viet Nam'),
(N'Hoang Thuy Linh', N'Noi tieng voi dong nhac Pop ket hop van hoa dan gian.', N'Viet Nam'),
(N'Charlie Puth', N'Ca si, nhac si, nha san xuat am nhac quoc te.', N'My'),
(N'Taylor Swift', N'Sieu sao nhac Pop va nhac dong que the gioi.', N'My'),
(N'GREY D', N'Hoang tu moi cua dong nhac RnB/Lo-fi Viet.', N'Viet Nam'),
(N'tlinh', N'Nu rapper, ca si GenZ day ca tinh.', N'Viet Nam'),
(N'SOOBIN', N'Nam ca si da tai thuoc to doi SpaceSpeakers.', N'Viet Nam'),
(N'Hoà Minzy', N'Nu ca si noi tieng voi hit Bac Bling, gay sot toan cau 2025.', N'Viet Nam'),
(N'HIEUTHUHAI', N'Rapper the he moi, noi bat voi phong cach Hip-hop duong pho.', N'Viet Nam'),
(N'Duong Domic', N'Ca si tre so huu hit Mat Ket Noi dinh dam.', N'Viet Nam'),
(N'Nguyen Hung', N'Ca si indie, giong hat moc mac gay bao voi Con Gi Dep Hon.', N'Viet Nam'),
(N'MAYDAYs', N'Nhom nhac indie tao nen hien tuong Phep Mau.', N'Viet Nam'),
(N'Phao', N'Nu rapper ca tinh, hit 2 Phut Hon.', N'Viet Nam'),
(N'J.ADE', N'Ca si kiem nhac si tre tai nang.', N'Viet Nam'),
(N'Huong My Bong', N'Nhac si, ca si Indie voi phong cach lang man.', N'Viet Nam'),
(N'Duyen Quynh', N'Ca si giong cao, noi bat voi Viet Tiep Cau Chuyen Hoa Binh.', N'Viet Nam'),
(N'Tung Duong', N'Ca si thuc luc, album Multiverse gay tieng vang.', N'Viet Nam'),
(N'14 Casper & Bon Nghiem', N'Bo doi R&B / Ballad voi hit Mot Doi.', N'Viet Nam'),
(N'RIO', N'Ca si tre the he moi, phong cach Pop tre trung.', N'Viet Nam'),
(N'Dangrangto', N'Rapper, ca si Gen Z voi flow doc dao.', N'Viet Nam'),
(N'Obito', N'Rapper tre, hit gay sot cong dong underground.', N'Viet Nam'),
(N'buitruonglinh', N'Ca si tre da nang, phong cach R&B / Pop.', N'Viet Nam'),
(N'Khoi Vu', N'Rapper, thanh vien HUSTLANG ROBBER.', N'Viet Nam'),
(N'Jaysonlei', N'Rapper, producer the he moi.', N'Viet Nam'),
(N'Mason Nguyen', N'Ca si, rapper thuoc HUSTLANG ROBBER.', N'Viet Nam'),
(N'Toc Tien', N'Ca si nu noi tieng, giong hat noi luc.', N'Viet Nam'),
(N'Erik', N'Nam ca si dien trai, hit Sau Tat Ca.', N'Viet Nam'),
(N'HUSTLANG ROBBER', N'Crew rap / nhac duong pho noi bat.', N'Viet Nam'),
(N'Lamoon', N'Ca si tre chat giong ngot ngao.', N'Viet Nam'),
(N'Khac Hung', N'Nhac si, ca si, producer tai nang.', N'Viet Nam'),
(N'Da LAB', N'Nhom nhac Indie / Pop noi tieng.', N'Viet Nam'),
(N'Rosé', N'Thanh vien BLACKPINK, hit solo APT. cung Bruno Mars.', N'Han Quoc'),
(N'Bruno Mars', N'Sieu sao nhac Pop / R&B toan cau.', N'My'),
(N'Lady Gaga', N'Huyen thoai nhac Pop, chu nhan hit Die With A Smile.', N'My'),
(N'Kendrick Lamar', N'Rapper huyen thoai, giai Pulitzer.', N'My'),
(N'SZA', N'Nu ca si R&B hang dau the gioi.', N'My'),
(N'Benson Boone', N'Ca si tre, hit Beautiful Things gay sot toan cau.', N'My'),
(N'Billie Eilish', N'Sieu sao nhac Pop the he moi.', N'My'),
(N'Teddy Swims', N'Ca si R&B / Soul voi hit Lose Control.', N'My'),
(N'Alex Warren', N'Ca si tre, hit Ordinary dinh dam.', N'My'),
(N'Sabrina Carpenter', N'Ca si, dien vien, hit Espresso.', N'My'),
(N'Chappell Roan', N'Nu ca si Pop doc dao, hit Pink Pony Club.', N'My'),
(N'Bad Bunny', N'Sieu sao Latin, nghe si duoc nghe nhieu nhat 2025.', N'Puerto Rico'),
(N'Playboi Carti', N'Rapper / ca si, hit Timeless cung The Weeknd.', N'My'),
(N'The Weeknd', N'Sieu sao R&B / Pop toan cau.', N'Canada'),
(N'Gracie Abrams', N'Ca si, nhac si tre, hit That''s So True.', N'My'),
(N'Charli XCX', N'Nu ca si Pop / Hyperpop, album Brat.', N'Anh'),
(N'Dua Lipa', N'Sieu sao nhac Pop toan cau.', N'Anh'),
(N'Coldplay', N'Ban nhac Rock / Pop huyen thoai nuoc Anh.', N'Anh'),
(N'Linkin Park', N'Ban nhac Rock / Nu-Metal huyen thoai.', N'My'),
(N'Shaboozey', N'Ca si Country / Rap, hit A Bar Song (Tipsy).', N'My'),
(N'Post Malone', N'Ca si, rapper da tai, hit I Had Some Help.', N'My'),
(N'Morgan Wallen', N'Sieu sao nhac Country My.', N'My'),
(N'HUNTR/X', N'Ca si nhac phim KPop Demon Hunters, hit Golden.', N'My'),
(N'Lola Young', N'Ca si Anh, giong hat day cam xuc.', N'Anh'),
(N'Sombr', N'Ca si tre noi len tu TikTok.', N'My'),
(N'David Guetta', N'DJ / Producer nhac Dance hang dau the gioi.', N'Phap'),
(N'OneRepublic', N'Ban nhac Pop / Rock noi tieng nuoc My.', N'My'),
(N'Ava Max', N'Nu ca si nhac Pop noi tieng.', N'My'),
(N'Tyla', N'Ca si tre nguoi Nam Phi, hit Push 2 Start.', N'Nam Phi'),
(N'TWICE', N'Nhom nhac nu K-Pop hang dau Han Quoc.', N'Han Quoc'),
(N'Jimin', N'Thanh vien BTS, ca si solo noi tieng.', N'Han Quoc'),
(N'JISOO', N'Thanh vien BLACKPINK, ca si solo.', N'Han Quoc'),
(N'The Marias', N'Ban nhac Indie / Psychedelic Pop.', N'My'),
(N'Saja Boys', N'Nhom nhac Pop moi noi.', N'My'),
(N'Ravyn Lenae', N'Nu ca si R&B / Soul tai nang.', N'My'),
(N'Megan Moroney', N'Ca si nhac Country My.', N'My'),
(N'Miley Cyrus', N'Sieu sao nhac Pop toan cau.', N'My'),
(N'PARTYNEXTDOOR', N'Ca si, nhac si R&B / Hip-hop.', N'Canada'),
(N'Drake', N'Rapper, ca si hang dau the gioi.', N'Canada');
GO

-- ============================================================
-- DU LIEU MAU - ALBUM
-- ============================================================
INSERT INTO ALBUM (title, release_date, cover_image, artist_id) VALUES
(N'Chung Ta', '2020-12-20', 'images/albums/chung_ta.jpg', 1),
(N'Dongvau (Show cua Den)', '2019-11-01', 'images/albums/show_cua_den.jpg', 2),
(N'Tam 9', '2017-12-03', 'images/albums/tam_9.jpg', 3),
(N'Mot Van Nam', '2022-09-08', 'images/albums/mot_van_nam.jpg', 4),
(N'Hoang', '2019-10-20', 'images/albums/hoang.jpg', 5),
(N'Link', '2022-08-11', 'images/albums/link.jpg', 5),
(N'Midnights', '2022-10-21', 'images/albums/midnights.jpg', 7),
(N'Bac Bling (Single)', '2025-03-01', 'images/albums/bac_bling.jpg', 11),
(N'Multiverse', '2024-11-15', 'images/albums/multiverse.jpg', 20),
(N'Phep Mau (Single)', '2025-02-14', 'images/albums/phep_mau.jpg', 15),
(N'Short n'' Sweet', '2024-08-23', 'images/albums/short_n_sweet.jpg', 44),
(N'HIT ME HARD AND SOFT', '2024-05-17', 'images/albums/hit_me_hard.jpg', 41),
(N'Fireworks & Rollerblades', '2024-04-05', 'images/albums/fireworks.jpg', 40),
(N'Debi Tirar Mas Fotos', '2025-01-05', 'images/albums/debi_tirar.jpg', 46),
(N'Brat', '2024-06-07', 'images/albums/brat.jpg', 50),
(N'The Rise and Fall of a Midwest Princess', '2023-09-22', 'images/albums/midwest_princess.jpg', 45),
(N'KPop Demon Hunters (OST)', '2025-06-01', 'images/albums/kpop_demon.jpg', 57),
(N'MAYDAY (EP)', '2025-03-20', 'images/albums/mayday_ep.jpg', 15);
GO

-- ============================================================
-- DU LIEU MAU - GENRE
-- ============================================================
INSERT INTO GENRE (genre_name) VALUES
(N'Pop'),
(N'Rap / Hip Hop'),
(N'Indie / Underground'),
(N'R&B'),
(N'Ballad'),
(N'Dance / Electronic'),
(N'Folk Pop (Dan gian duong dai)'),
(N'Lo-Fi');
GO

-- ============================================================
-- DU LIEU MAU - PLAYLIST
-- ============================================================
INSERT INTO PLAYLIST (name, description, user_id) VALUES
(N'Nhac Chill Cuoi Tuan', N'Danh sach phat giup ban thu gian sau tuan lam viec met moi.', 6),
(N'Lofi Gay Nghien', N'Hoc tap va lam viec cuc ky tap trung.', 6),
(N'V-Pop Hits Dinh Nhat', N'Tong hop nhac Viet dang thinh hanh.', 7),
(N'Tam Trang Buon', N'Nhung giai dieu cham vao cam xuc.', 8),
(N'Nhac Au My Bat Hu', N'Doi gio voi US-UK chat luong cao.', 9),
(N'Nhac Cua Toi', N'Playlist ca nhan rieng tu.', 10);
GO

PRINT '======================================================';
PRINT 'Database NhacSoMuli da duoc tao thanh cong!';
PRINT '======================================================';
GO

-- ============================================================
-- 11. Bang SUBSCRIPTION_PLAN (Goi Premium)
-- ============================================================
CREATE TABLE subscription_plan (
    plan_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    duration INT NOT NULL
);
GO

-- ============================================================
-- 12. Bang PAYMENT (Giao dich thanh toan)
-- ============================================================
CREATE TABLE payment (
    payment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id BIGINT NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    transaction_id VARCHAR(150) UNIQUE,
    CONSTRAINT FK_Payment_User FOREIGN KEY (user_id) REFERENCES [USER](user_id),
    CONSTRAINT FK_Payment_Plan FOREIGN KEY (plan_id) REFERENCES subscription_plan(plan_id)
);
GO

-- ============================================================
-- DU LIEU MAU - SUBSCRIPTION PLAN (Goi Premium)
-- ============================================================
INSERT INTO subscription_plan (plan_name, price, duration) VALUES
(N'Premium Tháng', 50000, 30),
(N'Premium Quý', 120000, 90),
(N'Premium Năm', 350000, 365);
GO
