package controller.playlist;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "PlaylistLikeSongServlet", urlPatterns = {"/playlist/like-song", "/playlist/song/like"})
public class LikeSongServlet extends controller.song.LikeSongServlet {
}
