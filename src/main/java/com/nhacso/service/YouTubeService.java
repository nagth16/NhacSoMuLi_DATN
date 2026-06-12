package com.nhacso.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Service
public class YouTubeService {

    private static final Logger log = LoggerFactory.getLogger(YouTubeService.class);

    @Value("${youtube.api.key}")
    private String apiKey;

    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final ObjectMapper mapper = new ObjectMapper();

    private static final List<String> NON_MUSIC_KEYWORDS = List.of(
        "tutorial", "hướng dẫn", "review", "gameplay", "gaming", "let's play",
        "news", "tin tức", "podcast", "interview", "phỏng vấn",
        "documentary", "how to", "cách làm", "recipe", "công thức",
        "trailer", "vlog", "challenge", "asmr", "funny", "comedy"
    );

    public List<YouTubeVideo> searchVideos(String query) {
        List<YouTubeVideo> result = new ArrayList<>();
        try {
            String musicQuery = query + " music";
            String url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q="
                    + URLEncoder.encode(musicQuery, StandardCharsets.UTF_8)
                    + "&type=video&videoCategoryId=10&maxResults=25&key=" + apiKey;

            log.info("YouTube search query='{}' url={}", query, url.replace(apiKey, "KEY_HIDDEN"));
            String body = get(url);
            log.debug("YouTube search response body: {}", body.substring(0, Math.min(500, body.length())));
            JsonNode root = mapper.readTree(body);
            JsonNode items = root.get("items");
            if (items == null) {
                log.warn("YouTube search returned no 'items' field. Response: {}", body.substring(0, Math.min(300, body.length())));
                return result;
            }

            log.info("YouTube search returned {} items", items.size());
            for (JsonNode item : items) {
                JsonNode id = item.get("id");
                JsonNode snippet = item.get("snippet");
                if (id == null || snippet == null) continue;

                String videoId = id.get("videoId") != null ? id.get("videoId").asText() : null;
                if (videoId == null) continue;

                String title = snippet.get("title") != null ? snippet.get("title").asText() : "";
                String channel = snippet.get("channelTitle") != null ? snippet.get("channelTitle").asText() : "";
                String thumbnail = snippet.get("thumbnails") != null
                        && snippet.get("thumbnails").get("high") != null
                        ? snippet.get("thumbnails").get("high").get("url").asText()
                        : "";
                String publishedAt = snippet.get("publishedAt") != null ? snippet.get("publishedAt").asText() : "";

                if (title.toLowerCase().contains("#shorts")) continue;

                String lower = title.toLowerCase();
                boolean isNonMusic = NON_MUSIC_KEYWORDS.stream().anyMatch(kw -> lower.contains(kw));
                if (isNonMusic) continue;

                YouTubeVideo v = new YouTubeVideo();
                v.setVideoId(videoId);
                v.setTitle(title);
                v.setChannelTitle(channel);
                v.setThumbnailUrl(thumbnail);
                v.setPublishedAt(publishedAt);
                result.add(v);
            }
        } catch (Exception e) {
            log.error("YouTube search failed for query='{}': {}", query, e.getMessage(), e);
            throw new RuntimeException("YouTube search failed: " + e.getMessage(), e);
        }
        return result;
    }

    public YouTubeVideo getVideoDetails(String videoId) {
        try {
            String url = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,snippet&id="
                    + videoId + "&key=" + apiKey;

            log.info("YouTube video details for id={}", videoId);
            String body = get(url);
            JsonNode root = mapper.readTree(body);
            JsonNode items = root.get("items");
            if (items == null || items.isEmpty()) return null;

            JsonNode item = items.get(0);
            JsonNode snippet = item.get("snippet");
            JsonNode contentDetails = item.get("contentDetails");
            if (snippet == null) return null;

            String title = snippet.get("title") != null ? snippet.get("title").asText() : "";
            String channel = snippet.get("channelTitle") != null ? snippet.get("channelTitle").asText() : "";

            String hqThumb = "";
            if (snippet.get("thumbnails") != null) {
                JsonNode thumbs = snippet.get("thumbnails");
                if (thumbs.get("maxres") != null) hqThumb = thumbs.get("maxres").get("url").asText();
                else if (thumbs.get("high") != null) hqThumb = thumbs.get("high").get("url").asText();
                else if (thumbs.get("default") != null) hqThumb = thumbs.get("default").get("url").asText();
            }

            int durationSeconds = 0;
            if (contentDetails != null && contentDetails.get("duration") != null) {
                durationSeconds = parseDuration(contentDetails.get("duration").asText());
            }

            YouTubeVideo v = new YouTubeVideo();
            v.setVideoId(videoId);
            v.setTitle(title);
            v.setChannelTitle(channel);
            v.setThumbnailUrl(hqThumb);
            v.setDurationSeconds(durationSeconds);
            return v;
        } catch (Exception e) {
            throw new RuntimeException("YouTube detail fetch failed: " + e.getMessage(), e);
        }
    }

    private String get(String url) throws Exception {
        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();
        HttpResponse<String> res = httpClient.send(req, HttpResponse.BodyHandlers.ofString());
        if (res.statusCode() != 200) {
            String err = res.body() != null ? res.body().substring(0, Math.min(500, res.body().length())) : "empty";
            log.error("YouTube API returned {}: {}", res.statusCode(), err);
            throw new RuntimeException("YouTube API error " + res.statusCode() + ": " + err);
        }
        return res.body();
    }

    private int parseDuration(String iso) {
        if (iso == null || iso.isEmpty()) return 0;
        int seconds = 0;
        try {
            String s = iso.replace("PT", "").replace("P", "");
            int h = 0, m = 0, sec = 0;
            int i = s.indexOf('H');
            if (i > 0) { h = Integer.parseInt(s.substring(0, i)); s = s.substring(i + 1); }
            i = s.indexOf('M');
            if (i > 0) { m = Integer.parseInt(s.substring(0, i)); s = s.substring(i + 1); }
            i = s.indexOf('S');
            if (i > 0) { sec = Integer.parseInt(s.substring(0, i)); }
            seconds = h * 3600 + m * 60 + sec;
        } catch (Exception ignored) {}
        return seconds;
    }

    public static class YouTubeVideo {
        private String videoId;
        private String title;
        private String channelTitle;
        private String thumbnailUrl;
        private int durationSeconds;
        private String publishedAt;

        public String getVideoId() { return videoId; }
        public void setVideoId(String videoId) { this.videoId = videoId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getChannelTitle() { return channelTitle; }
        public void setChannelTitle(String channelTitle) { this.channelTitle = channelTitle; }
        public String getThumbnailUrl() { return thumbnailUrl; }
        public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }
        public int getDurationSeconds() { return durationSeconds; }
        public void setDurationSeconds(int durationSeconds) { this.durationSeconds = durationSeconds; }
        public String getPublishedAt() { return publishedAt; }
        public void setPublishedAt(String publishedAt) { this.publishedAt = publishedAt; }
        public String getYoutubeUrl() { return "https://www.youtube.com/watch?v=" + videoId; }
        public String getDurationFormatted() {
            if (durationSeconds == 0) return "";
            int m = durationSeconds / 60;
            int s = durationSeconds % 60;
            return m + ":" + (s < 10 ? "0" : "") + s;
        }
    }
}
