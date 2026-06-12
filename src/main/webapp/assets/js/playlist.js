document.addEventListener("click", function (e) {

  var addBtn = e.target.closest(".add-song-btn");
  if (addBtn) {
    var playlistId = addBtn.dataset.playlistId;
    var songId = addBtn.dataset.songId;
    fetch("/playlist/add-song", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "playlistId=" + playlistId + "&songId=" + songId
    }).then(function (r) {
      if (r.ok) {
        addBtn.disabled = true;
        addBtn.textContent = "\u0110\xE3 th\xEAm";
        addBtn.style.background = "var(--surface2)";
        addBtn.style.color = "var(--accent)";
        addBtn.style.cursor = "default";
      } else {
        alert("Kh\xF4ng th\u1EC3 th\xEAm b\xE0i h\xE1t");
      }
    }).catch(function () {
      alert("\u0110\xE3 x\u1EA3y ra l\u1ED7i");
    });
    return;
  }

  var removeBtn = e.target.closest(".remove-song-btn");
  if (removeBtn) {
    if (!confirm("B\u1EA1n c\xF3 ch\u1EAFc mu\u1ED1n x\xF3a b\xE0i h\xE1t?")) return;
    var playlistId2 = removeBtn.dataset.playlistId;
    var songId2 = removeBtn.dataset.songId;
    fetch("/playlist/remove-song", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "playlistId=" + playlistId2 + "&songId=" + songId2
    }).then(function (r) {
      if (r.ok) {
        var row = removeBtn.closest("tr");
        if (row) row.remove();
      } else {
        alert("Kh\xF4ng th\u1EC3 x\xF3a b\xE0i h\xE1t");
      }
    }).catch(function () {
      alert("\u0110\xE3 x\u1EA3y ra l\u1ED7i");
    });
    return;
  }

});

// Search songs + YouTube for add-song modal
var searchTimer = null;
document.addEventListener("input", function (e) {
  if (e.target.id !== "addSongSearch") return;
  clearTimeout(searchTimer);
  var q = e.target.value.trim();
  var container = document.getElementById("addSongResults");
  if (q.length < 1) {
    container.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--muted);font-size:14px;">Nhập từ khóa để tìm kiếm bài hát</div>';
    return;
  }
  searchTimer = setTimeout(function () {
    container.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--muted);font-size:14px;"><i class="fas fa-spinner fa-pulse"></i> Đang tìm kiếm...</div>';
    var localUrl = "/api/songs/search?q=" + encodeURIComponent(q);
    var ytUrl = "/api/songs/yt-search?q=" + encodeURIComponent(q);
    Promise.all([
      fetch(localUrl).then(function (r) { return r.ok ? r.json() : []; }).catch(function () { return []; }),
      fetch(ytUrl).then(function (r) { return r.ok ? r.json() : []; }).catch(function () { return []; })
    ]).then(function (results) {
      var songs = results[0] || [];
      var ytVideos = results[1] || [];
      var modal = document.getElementById("addSongModal");
      var _playlistId = modal ? parseInt(modal.dataset.playlistId) : null;
      var _songsInPlaylist = modal ? JSON.parse(modal.dataset.songsInPlaylist || "[]") : [];
      var html = "";

      // Local songs section
      if (songs.length > 0) {
        html += '<div style="grid-column:1/-1;font-size:13px;font-weight:700;color:var(--muted);padding:8px 4px 4px;"><i class="fas fa-music" style="color:#1DB954;"></i> Từ thư viện</div>';
        for (var i = 0; i < songs.length; i++) {
          var s = songs[i];
          var inPlaylist = _songsInPlaylist.indexOf(s.songId) !== -1;
          var cover = s.coverImage || "";
          var title = s.title || "";
          var artist = s.artistNames || "";
          if (inPlaylist) {
            html += '<div style="background:var(--surface2);border-radius:8px;padding:8px;opacity:.5;text-align:left;">';
            html += '<div style="width:100%;aspect-ratio:1;border-radius:4px;background-size:cover;background-position:center;background-image:url(' + cover + ');margin-bottom:8px;background-color:#333;"></div>';
            html += '<div style="font-size:13px;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + title + '</div>';
            html += '<div style="font-size:11px;color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + artist + '</div>';
            html += '<div style="font-size:10px;color:var(--accent);margin-top:4px;">Đã có trong playlist</div></div>';
          } else {
            html += '<button type="button" class="add-song-btn" data-playlist-id="' + _playlistId + '" data-song-id="' + s.songId + '" style="background:var(--surface2);border:none;border-radius:8px;padding:8px;cursor:pointer;text-align:left;transition:background .2s;width:100%;" onmouseover="this.style.background=\'var(--accent)\'" onmouseout="this.style.background=\'var(--surface2)\'">';
            html += '<div style="width:100%;aspect-ratio:1;border-radius:4px;background-size:cover;background-position:center;background-image:url(' + cover + ');margin-bottom:8px;background-color:#333;"></div>';
            html += '<div style="font-size:13px;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + title + '</div>';
            html += '<div style="font-size:11px;color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + artist + '</div>';
            html += '<div style="font-size:10px;color:var(--accent);margin-top:4px;">+ Thêm</div></button>';
          }
        }
      }

      // YouTube section
      if (ytVideos.length > 0) {
        html += '<div style="grid-column:1/-1;font-size:13px;font-weight:700;color:var(--muted);padding:16px 4px 4px;"><i class="fab fa-youtube" style="color:#FF0000;"></i> Từ YouTube</div>';
        for (var i = 0; i < ytVideos.length; i++) {
          var v = ytVideos[i];
          var ytId = v.videoId || "";
          var vTitle = v.title || "";
          var vChannel = v.channelTitle || "";
          var vThumb = v.thumbnailUrl || "";
          // Check if this YouTube URL already exists in playlist songs
          var ytUrl = "https://www.youtube.com/watch?v=" + ytId;
          html += '<button type="button" class="add-yt-song-btn" data-playlist-id="' + _playlistId + '" data-videoid="' + ytId + '" data-title="' + vTitle.replace(/'/g, "\\'") + '" data-channel="' + vChannel.replace(/'/g, "\\'") + '" data-thumb="' + vThumb + '" style="background:var(--surface2);border:none;border-radius:8px;padding:8px;cursor:pointer;text-align:left;transition:background .2s;width:100%;" onmouseover="this.style.background=\'var(--accent)\'" onmouseout="this.style.background=\'var(--surface2)\'">';
          html += '<div style="width:100%;aspect-ratio:1;border-radius:4px;background-size:cover;background-position:center;background-image:url(' + vThumb + ');margin-bottom:8px;background-color:#333;"></div>';
          html += '<div style="font-size:13px;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + vTitle + '</div>';
          html += '<div style="font-size:11px;color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + vChannel + '</div>';
          html += '<div style="font-size:10px;color:#FF0000;margin-top:4px;">+ Thêm từ YouTube</div></button>';
        }
      }

      if (!songs.length && !ytVideos.length) {
        html = '<div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--muted);font-size:14px;">Không tìm thấy kết quả</div>';
      }

      container.innerHTML = html;
    }).catch(function () {
      container.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:40px;color:#ff6b6b;font-size:14px;">Lỗi khi tìm kiếm</div>';
    });
  }, 300);
});

// Handle "Add from YouTube" button click
document.addEventListener("click", function (e) {
  var btn = e.target.closest(".add-yt-song-btn");
  if (!btn) return;
  var playlistId = btn.dataset.playlistId;
  var videoId = btn.dataset.videoid;
  var title = btn.dataset.title;
  var channel = btn.dataset.channel;
  var thumb = btn.dataset.thumb;
  var formData = new URLSearchParams();
  formData.append("playlistId", playlistId);
  formData.append("videoId", videoId);
  formData.append("title", title);
  formData.append("channelTitle", channel);
  formData.append("thumbnailUrl", thumb);
  fetch("/playlist/add-youtube-song", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: formData.toString()
  }).then(function (r) { return r.json(); })
  .then(function (data) {
    if (data.success) {
      btn.disabled = true;
      btn.textContent = "";
      btn.innerHTML = '<div style="width:100%;aspect-ratio:1;border-radius:4px;background-size:cover;background-position:center;background-image:url(' + thumb + ');margin-bottom:8px;background-color:#333;"></div><div style="font-size:13px;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + title + '</div><div style="font-size:11px;color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">' + channel + '</div><div style="font-size:10px;color:var(--accent);margin-top:4px;">Đã thêm</div>';
      btn.style.background = "var(--surface2)";
      btn.style.cursor = "default";
      btn.style.opacity = "0.5";
      btn.classList.remove("add-yt-song-btn");
      // Reload page after short delay to show song in playlist
      setTimeout(function () { window.location.reload(); }, 1500);
    } else {
      alert("Lỗi: " + (data.error || "Không thể thêm bài hát"));
    }
  }).catch(function () {
    alert("Đã xảy ra lỗi khi thêm bài hát từ YouTube");
  });
});
