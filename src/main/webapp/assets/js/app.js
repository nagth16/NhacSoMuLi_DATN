(function () {
    "use strict";

    const tracks = [
        {
            title: "Chill Vibes",
            artist: "Luna Vale",
            album: "Afterglow Avenue",
            releaseType: "Single",
            year: "2026",
            credits: "Luna Vale",
            duration: 222,
            cover: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Crect width='300' height='300' fill='%23333'/%3E%3Ctext x='50%25' y='50%25' font-size='96' fill='%23555' text-anchor='middle' dy='.35em'%3E%E2%99%AA%3C/text%3E%3C/svg%3E",
            line: "Soft drums, late lights, and a quiet city pulse."
        },
        {
            title: "Late Night Drive",
            artist: "Metro Signal",
            album: "Neon Roads",
            releaseType: "Single",
            year: "2025",
            credits: "Metro Signal",
            duration: 198,
            cover: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Crect width='300' height='300' fill='%23283593'/%3E%3Ctext x='50%25' y='50%25' font-size='96' fill='%235c6bc0' text-anchor='middle' dy='.35em'%3E%E2%99%AA%3C/text%3E%3C/svg%3E",
            line: "Headlights stretch across the road while the hook repeats."
        },
        {
            title: "Morning Energy",
            artist: "The Current",
            album: "First Light",
            releaseType: "Album",
            year: "2026",
            credits: "The Current",
            duration: 206,
            cover: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Crect width='300' height='300' fill='%231b5e20'/%3E%3Ctext x='50%25' y='50%25' font-size='96' fill='%2366bb6a' text-anchor='middle' dy='.35em'%3E%E2%99%AA%3C/text%3E%3C/svg%3E",
            line: "A bright rhythm built for first coffee and fast starts."
        },
        {
            title: "Deep Focus",
            artist: "Atlas Room",
            album: "Quiet Systems",
            releaseType: "Playlist",
            year: "2024",
            credits: "Atlas Room",
            duration: 268,
            cover: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Crect width='300' height='300' fill='%234a148c'/%3E%3Ctext x='50%25' y='50%25' font-size='96' fill='%23ab47bc' text-anchor='middle' dy='.35em'%3E%E2%99%AA%3C/text%3E%3C/svg%3E",
            line: "Minimal textures, steady bass, and no sharp corners."
        },
        {
            title: "Workout Mix",
            artist: "Nova Echo",
            album: "Pulse Set",
            releaseType: "Album",
            year: "2025",
            credits: "Nova Echo",
            duration: 235,
            cover: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Crect width='300' height='300' fill='%23b71c1c'/%3E%3Ctext x='50%25' y='50%25' font-size='96' fill='%23ef5350' text-anchor='middle' dy='.35em'%3E%E2%99%AA%3C/text%3E%3C/svg%3E",
            line: "Big drums and clipped synths for repeated motion."
        },
        {
            title: "Sunday Afternoon",
            artist: "June Harbor",
            album: "Window Weather",
            releaseType: "Single",
            year: "2026",
            credits: "June Harbor",
            duration: 246,
            cover: "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='300'%3E%3Crect width='300' height='300' fill='%23e65100'/%3E%3Ctext x='50%25' y='50%25' font-size='96' fill='%23ffa726' text-anchor='middle' dy='.35em'%3E%E2%99%AA%3C/text%3E%3C/svg%3E",
            line: "Warm guitar layers and slow air through open windows."
        }
    ];

    const state = {
        isPlaying: false,
        isShuffle: false,
        repeatMode: 0,
        isLiked: false,
        isMuted: false,
        volume: 80,
        queueIndex: 0,
        currentTime: 0,
        hasSelection: false,
        sideOpen: false
    };

    let timer = null;
    let audioContext = null;
    let oscillator = null;
    let gainNode = null;

    const $ = (id) => document.getElementById(id);

    function formatTime(secs) {
        if (Number.isNaN(secs) || secs < 0) {
            return "0:00";
        }
        const m = Math.floor(secs / 60);
        const s = Math.floor(secs % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    function updateRangeGradient(rangeEl, value, min, max) {
        if (!rangeEl) {
            return;
        }
        const pct = ((value - min) / (max - min)) * 100;
        rangeEl.style.background = "linear-gradient(to right, #1DB954 0%, #1DB954 " + pct + "%, #535353 " + pct + "%, #535353 100%)";
    }

    function currentTrack() {
        return tracks[state.queueIndex] || tracks[0];
    }

    function persistSelection() {
        try {
            window.localStorage.setItem("spotifyClone.selectedTrack", String(state.queueIndex));
        } catch (error) {
            // localStorage may be unavailable in private or restricted browser contexts.
        }
    }

    function persistSideOpen() {
        try {
            window.localStorage.setItem("spotifyClone.sideOpen", state.sideOpen ? "1" : "0");
        } catch (error) {
            // localStorage may be unavailable in private or restricted browser contexts.
        }
    }

    function syncUI() {
        const track = currentTrack();
        document.body.classList.toggle("has-selection", state.hasSelection);
        document.body.classList.toggle("side-open", state.sideOpen && state.hasSelection);
        const vinylDisc = $("vinyl-disc");
        const titleLink = $("player-title-link");
        const artistEl = $("player-artist");
        const heartBtn = $("heart-btn");
        const playPauseBtn = $("play-pause-btn");
        const shuffleBtn = $("shuffle-btn");
        const repeatBtn = $("repeat-btn");
        const seekBar = $("seek-bar");
        const currentTimeEl = $("current-time");
        const totalTimeEl = $("total-time");
        const volBtn = $("vol-btn");
        const volSlider = $("volume-slider");
        const heroArt = $("player-hero-art");
        const heroTitle = $("player-hero-title");
        const heroArtist = $("player-hero-artist");
        const lyricLine = $("lyric-line");
        const detailType = $("detail-release-type");
        const detailAlbum = $("detail-album");
        const detailMeta = $("detail-meta");
        const sideTitle = $("side-song-title");
        const sideArtist = $("side-song-artist");
        const sideArt = $("side-song-art");
        const sideLine = $("side-song-line");
        const creditArtist = $("credit-artist");
        const queueNext = $("queue-next-title");
        const queueNextArtist = $("queue-next-artist");
        const detailToggleBtn = $("detail-toggle-btn");

        if (titleLink) {
            titleLink.textContent = track.title;
            titleLink.href = "player.jsp?track=" + state.queueIndex;
        }
        if (artistEl) {
            artistEl.textContent = track.artist;
        }
        if (vinylDisc) {
            vinylDisc.style.backgroundImage = "url(\"" + track.cover + "\")";
            vinylDisc.style.animationPlayState = state.isPlaying ? "running" : "paused";
        }
        if (heroArt) {
            heroArt.style.backgroundImage = "url(\"" + track.cover + "\")";
            heroArt.style.backgroundSize = "cover";
        }
        if (heroTitle) {
            heroTitle.textContent = track.title;
        }
        if (heroArtist) {
            heroArtist.textContent = track.artist + " - " + track.year + " - " + track.album;
        }
        if (lyricLine) {
            lyricLine.textContent = track.line;
        }
        if (detailType) {
            detailType.textContent = track.releaseType;
        }
        if (detailAlbum) {
            detailAlbum.textContent = track.album;
        }
        if (detailMeta) {
            detailMeta.textContent = track.artist + " - " + track.year + " - " + track.releaseType;
        }
        if (sideTitle) {
            sideTitle.textContent = track.title;
        }
        if (sideArtist) {
            sideArtist.textContent = track.artist;
        }
        if (sideArt) {
            sideArt.style.backgroundImage = "url(\"" + track.cover + "\")";
        }
        if (sideLine) {
            sideLine.textContent = track.line;
        }
        if (creditArtist) {
            creditArtist.textContent = track.credits;
        }
        if (queueNext && queueNextArtist) {
            const next = tracks[(state.queueIndex + 1) % tracks.length];
            queueNext.textContent = next.title;
            queueNextArtist.textContent = next.artist;
        }
        if (detailToggleBtn) {
            detailToggleBtn.classList.toggle("active", state.sideOpen && state.hasSelection);
            detailToggleBtn.setAttribute("aria-label", state.sideOpen && state.hasSelection ? "Close song details" : "Open song details");
            detailToggleBtn.title = state.sideOpen && state.hasSelection ? "Close song details" : "Song details";
        }
        if (playPauseBtn) {
            playPauseBtn.innerHTML = state.isPlaying ? "&#9646;&#9646;" : "&#9654;";
            playPauseBtn.setAttribute("aria-label", state.isPlaying ? "Pause" : "Play");
            playPauseBtn.title = state.isPlaying ? "Pause" : "Play";
        }
        if (heartBtn) {
            heartBtn.innerHTML = state.isLiked ? "&#9829;" : "&#9825;";
            heartBtn.classList.toggle("liked", state.isLiked);
        }
        if (shuffleBtn) {
            shuffleBtn.classList.toggle("active", state.isShuffle);
        }
        if (repeatBtn) {
            repeatBtn.classList.toggle("active", state.repeatMode > 0);
        }
        if (currentTimeEl) {
            currentTimeEl.textContent = formatTime(state.currentTime);
        }
        if (totalTimeEl) {
            totalTimeEl.textContent = formatTime(track.duration);
        }
        if (seekBar) {
            const value = track.duration ? (state.currentTime / track.duration) * 100 : 0;
            seekBar.value = value;
            updateRangeGradient(seekBar, value, 0, 100);
        }
        if (volSlider) {
            volSlider.value = state.isMuted ? 0 : state.volume;
            updateRangeGradient(volSlider, volSlider.value, 0, 100);
        }
        if (volBtn) {
            volBtn.innerHTML = state.isMuted || state.volume === 0
                ? "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M3.63 3.63a.996.996 0 0 0 0 1.41L7.29 8.7 7 9H4a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h3l3.29 3.29c.63.63 1.71.18 1.71-.71v-4.17l4.18 4.18c-.49.37-1.02.68-1.6.91a1 1 0 1 0 .75 1.85 8.9 8.9 0 0 0 2.44-1.52l1.58 1.58a.996.996 0 1 0 1.41-1.41L5.05 3.63a.996.996 0 0 0-1.42 0z\"/></svg>"
                : "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M3 9v6h4l5 5V4L7 9H3zm13.5 3A4.5 4.5 0 0 0 14 7.97v8.05c1.48-.73 2.5-2.25 2.5-4.02zM14 3.23v2.06c2.89.86 5 3.54 5 6.71s-2.11 5.85-5 6.71v2.06c4.01-.91 7-4.49 7-8.77s-2.99-7.86-7-8.77z\"/></svg>";
        }

        document.querySelectorAll("[data-track-index]").forEach((el) => {
            el.classList.toggle("active", Number(el.dataset.trackIndex) === state.queueIndex);
        });
        document.querySelectorAll(".song-big-play, .song-album-art").forEach((el) => {
            el.dataset.trackIndex = String(state.queueIndex);
        });
    }

    function startTone() {
        try {
            if (!audioContext) {
                audioContext = new (window.AudioContext || window.webkitAudioContext)();
            }
            stopTone();
            oscillator = audioContext.createOscillator();
            gainNode = audioContext.createGain();
            oscillator.type = "sine";
            oscillator.frequency.value = 164 + state.queueIndex * 42;
            gainNode.gain.value = (state.isMuted ? 0 : state.volume) * 0.0008;
            oscillator.connect(gainNode);
            gainNode.connect(audioContext.destination);
            oscillator.start();
        } catch (error) {
            stopTone();
        }
    }

    function stopTone() {
        if (oscillator) {
            oscillator.stop();
            oscillator.disconnect();
            oscillator = null;
        }
        if (gainNode) {
            gainNode.disconnect();
            gainNode = null;
        }
    }

    function startTimer() {
        stopTimer();
        timer = window.setInterval(() => {
            state.currentTime += 1;
            if (state.currentTime >= currentTrack().duration) {
                if (state.repeatMode === 2) {
                    state.currentTime = 0;
                } else {
                    skipNext();
                }
            }
            syncUI();
        }, 1000);
    }

    function stopTimer() {
        if (timer) {
            window.clearInterval(timer);
            timer = null;
        }
    }

    function playTrack(index) {
        state.queueIndex = Math.max(0, Math.min(tracks.length - 1, Number(index) || 0));
        state.currentTime = 0;
        state.hasSelection = true;
        state.isPlaying = true;
        persistSelection();
        startTone();
        startTimer();
        syncUI();
    }

    function toggleSidePanel() {
        if (!state.hasSelection) {
            state.hasSelection = true;
            persistSelection();
        }
        state.sideOpen = !state.sideOpen;
        persistSideOpen();
        syncUI();
    }

    function togglePlay() {
        state.isPlaying = !state.isPlaying;
        if (state.isPlaying) {
            startTone();
            startTimer();
        } else {
            stopTone();
            stopTimer();
        }
        syncUI();
    }

    function skipPrev() {
        if (state.currentTime > 3) {
            state.currentTime = 0;
        } else {
            state.queueIndex = (state.queueIndex - 1 + tracks.length) % tracks.length;
            state.currentTime = 0;
        }
        if (state.isPlaying) {
            startTone();
        }
        syncUI();
    }

    function skipNext() {
        if (state.isShuffle) {
            state.queueIndex = Math.floor(Math.random() * tracks.length);
        } else {
            state.queueIndex = (state.queueIndex + 1) % tracks.length;
        }
        state.currentTime = 0;
        if (state.isPlaying) {
            startTone();
        }
        syncUI();
    }

    function handleSearch(query) {
        const term = query.trim().toLowerCase();
        document.querySelectorAll(".quickplay-card, .card, .playlist-item, .track-row").forEach((el) => {
            el.style.display = !term || el.textContent.toLowerCase().includes(term) ? "" : "none";
        });
    }

    function initGreeting() {
        const h = new Date().getHours();
        const el = $("greeting-text");
        if (!el) {
            return;
        }
        if (h >= 5 && h < 12) {
            el.textContent = "Good morning";
        } else if (h >= 12 && h < 18) {
            el.textContent = "Good afternoon";
        } else {
            el.textContent = "Good evening";
        }
    }

    function initTopbar() {
        const scroller = $("main-scroll");
        const topbar = document.querySelector(".topbar");
        if (!scroller || !topbar) {
            return;
        }
        scroller.addEventListener("scroll", () => {
            const scrolled = scroller.scrollTop > 48;
            if (topbar.classList.contains("detail-topbar")) {
                topbar.style.background = scrolled ? "rgba(0,0,0,.96)" : "#000";
                topbar.style.backdropFilter = scrolled ? "blur(12px)" : "none";
                return;
            }
            topbar.style.background = scrolled ? "rgba(18,18,18,.95)" : "linear-gradient(180deg,rgba(26,58,42,.95) 0%,transparent 100%)";
            topbar.style.backdropFilter = scrolled ? "blur(12px)" : "none";
        });
    }

    function bindEvents() {
        document.addEventListener("click", (event) => {
            const detailTarget = event.target.closest("[data-detail-track]");
            if (detailTarget) {
                event.preventDefault();
                state.queueIndex = Math.max(0, Math.min(tracks.length - 1, Number(detailTarget.dataset.detailTrack) || 0));
                state.hasSelection = true;
                persistSelection();
                window.location.href = "player.jsp?track=" + detailTarget.dataset.detailTrack;
                return;
            }

            const artworkTarget = event.target.closest(".quickplay-card img, .card__art, .playlist-item__art");
            if (artworkTarget) {
                const owner = artworkTarget.closest("[data-track-index]");
                if (owner) {
                    event.preventDefault();
                    state.queueIndex = Math.max(0, Math.min(tracks.length - 1, Number(owner.dataset.trackIndex) || 0));
                    state.hasSelection = true;
                    persistSelection();
                    window.location.href = "player.jsp?track=" + owner.dataset.trackIndex;
                    return;
                }
            }

            const trackTarget = event.target.closest("[data-track-index]");
            if (trackTarget && !event.target.closest("a[href*='player.jsp']")) {
                event.preventDefault();
                playTrack(trackTarget.dataset.trackIndex);
                return;
            }

            if (event.target.closest("#play-pause-btn")) {
                togglePlay();
                return;
            }
            if (event.target.closest("#prev-btn")) {
                skipPrev();
                return;
            }
            if (event.target.closest("#next-btn")) {
                skipNext();
                return;
            }
            if (event.target.closest("#shuffle-btn")) {
                state.isShuffle = !state.isShuffle;
                syncUI();
                return;
            }
            if (event.target.closest("#repeat-btn")) {
                state.repeatMode = (state.repeatMode + 1) % 3;
                syncUI();
                return;
            }
            if (event.target.closest("#heart-btn")) {
                state.isLiked = !state.isLiked;
                syncUI();
                return;
            }
            if (event.target.closest("#detail-toggle-btn")) {
                event.preventDefault();
                toggleSidePanel();
                return;
            }
            if (event.target.closest("#detail-close-btn")) {
                event.preventDefault();
                state.sideOpen = false;
                persistSideOpen();
                syncUI();
                return;
            }
            if (event.target.closest("#vol-btn")) {
                state.isMuted = !state.isMuted;
                if (gainNode) {
                    gainNode.gain.value = (state.isMuted ? 0 : state.volume) * 0.0008;
                }
                syncUI();
            }
        });

        const searchInput = $("search-input");
        if (searchInput) {
            searchInput.addEventListener("input", () => handleSearch(searchInput.value));
        }

        const seekBar = $("seek-bar");
        if (seekBar) {
            seekBar.addEventListener("input", () => {
                state.currentTime = Math.round((Number(seekBar.value) / 100) * currentTrack().duration);
                syncUI();
            });
        }

        const volSlider = $("volume-slider");
        if (volSlider) {
            volSlider.addEventListener("input", () => {
                state.volume = Number(volSlider.value);
                state.isMuted = state.volume === 0;
                if (gainNode) {
                    gainNode.gain.value = state.volume * 0.0008;
                }
                syncUI();
            });
        }

        document.addEventListener("keydown", (event) => {
            const tag = event.target.tagName;
            if (tag === "INPUT" || tag === "TEXTAREA") {
                return;
            }
            switch (event.code) {
                case "Space":
                    event.preventDefault();
                    togglePlay();
                    break;
                case "ArrowRight":
                    state.currentTime = Math.min(state.currentTime + 5, currentTrack().duration);
                    syncUI();
                    break;
                case "ArrowLeft":
                    state.currentTime = Math.max(state.currentTime - 5, 0);
                    syncUI();
                    break;
                case "KeyM":
                    state.isMuted = !state.isMuted;
                    syncUI();
                    break;
                default:
                    break;
            }
        });
    }

    function readInitialTrack() {
        const params = new URLSearchParams(window.location.search);
        let storedTrack = null;
        let storedSideOpen = null;
        try {
            storedTrack = window.localStorage.getItem("spotifyClone.selectedTrack");
            storedSideOpen = window.localStorage.getItem("spotifyClone.sideOpen");
        } catch (error) {
            storedTrack = null;
            storedSideOpen = null;
        }
        const hasQueryTrack = params.has("track");
        const isPlayerPage = document.body.dataset.page === "player";
        const track = Number(params.get("track") || storedTrack || document.body.dataset.initialTrack || 0);
        state.queueIndex = Number.isFinite(track) ? Math.max(0, Math.min(tracks.length - 1, track)) : 0;
        state.hasSelection = hasQueryTrack || isPlayerPage || storedTrack !== null;
        state.sideOpen = state.hasSelection && storedSideOpen === "1";
        if (state.hasSelection) {
            persistSelection();
        }
    }

    window.MusicPlayer = {
        play: function (_src, title, artist, coverUrl) {
            const existing = tracks.findIndex((track) => track.title === title && track.artist === artist);
            if (existing >= 0) {
                playTrack(existing);
                return;
            }
            tracks.push({ title: title || "Unknown title", artist: artist || "Unknown artist", cover: coverUrl || tracks[0].cover, duration: 210, line: "" });
            playTrack(tracks.length - 1);
        },
        setQueue: function (_tracks, startIndex) {
            playTrack(startIndex || 0);
        },
        pause: function () {
            state.isPlaying = false;
            stopTone();
            stopTimer();
            syncUI();
        },
        resume: togglePlay,
        toggle: togglePlay,
        next: skipNext,
        prev: skipPrev,
        getState: function () {
            return Object.assign({}, state, currentTrack());
        }
    };

    initGreeting();
    initTopbar();
    readInitialTrack();
    bindEvents();
    syncUI();
}());
