package com.spmovy.servlet.Admin;

import com.spmovy.DatabaseUtils;
import com.spmovy.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;

@WebServlet("/backend/admin/UpdateMovie")
public class UpdateMovie extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id, duration;
        try {
            id = Integer.parseInt(request.getParameter("id"));
            duration = Integer.parseInt(request.getParameter("duration"));
        } catch (NumberFormatException e) {
            response.sendRedirect("/errors/error.html");
            return;
        }
        String title = request.getParameter("title");
        String releasedate = request.getParameter("releasedate");
        String synopsis = request.getParameter("synopsis");
        String imagepath = request.getParameter("imagepath");
        String status = request.getParameter("status");
        String[] genres = request.getParameterValues("genre");
        String[] actors = request.getParameterValues("actor");
        // redirect there are missing fields
        if (genres == null || actors == null || title == null || releasedate == null
                || synopsis == null || imagepath == null || status == null) {
            response.sendRedirect("/errors/error.html");
            return;
        }
        DatabaseUtils db = Utils.getDatabaseUtils(response);
        if (db == null) return;  // return if database connection failed
        try {
            int updateCount = db.executeUpdate("UPDATE movie SET title=?, releasedate=?, synopsis=?, duration=?, imagepath=?, status=? WHERE ID=?",
                    title,
                    Date.valueOf(releasedate),
                    synopsis,
                    duration,
                    imagepath,
                    status,
                    id);
            if (updateCount != 1) {
                response.sendRedirect("/errors/error.html");
                return;
            }
            Connection connection = db.getConnection();
            // get movie id
            ResultSet movieIDResult = db.executeQuery("SELECT ID FROM movie WHERE title=? and releasedate=?",
                    title,
                    java.sql.Date.valueOf(releasedate));
            movieIDResult.next();
            int movieid = movieIDResult.getInt("ID");
            // get list of current genres/actors
            ArrayList<Integer> currentGenres = getcList(db.executeQuery("SELECT genreID FROM MovieGenre WHERE movieID=?", movieid));
            ArrayList<Integer> currentActors = getcList(db.executeQuery("SELECT actorID FROM MovieActor WHERE movieID=?", movieid));
            // prepare prepared statements
            PreparedStatement getGenreID = connection.prepareStatement("SELECT ID FROM Genre WHERE name=?");
            PreparedStatement getActorID = connection.prepareStatement("SELECT ID FROM actor WHERE name=?");
            PreparedStatement insertGenre = connection.prepareStatement("insert into MovieGenre values (?, ?)");
            PreparedStatement insertActor = connection.prepareStatement("insert into MovieActor values (?, ?)");
            PreparedStatement deleteGenre = connection.prepareStatement("DELETE FROM MovieGenre WHERE movieID=? AND genreID=?");
            PreparedStatement deleteActor = connection.prepareStatement("DELETE FROM MovieActor WHERE movieID=? AND actorID=?");
            insertGenre.setInt(1, movieid);
            insertActor.setInt(1, movieid);
            deleteGenre.setInt(1, movieid);
            deleteActor.setInt(1, movieid);
            updateManytoMany(genres, currentGenres, getGenreID, insertGenre, deleteGenre);
            updateManytoMany(actors, currentActors, getActorID, insertActor, deleteActor);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/errors/error.html");
            return;
        } finally {
            db.closeConnection();
        }
        response.sendRedirect(request.getHeader("referer"));
    }

    /**
     * This method adds new actors/genres for the movie and deletes actors/genres for movie that are not in the list of actors/genres submitted by the user.
     *
     * @param list       List of actors/genres submitted by the user
     * @param cList      Current list of actors/genres
     * @param getID      PreparedStatement to get ID of actor/genre
     * @param insertStmt PreparedStatement to insert actor/genre
     * @param deleteStmt PreparedStatement to delete actor/genre
     * @throws SQLException
     */
    private void updateManytoMany(String[] list, ArrayList<Integer> cList, PreparedStatement getID, PreparedStatement insertStmt, PreparedStatement deleteStmt) throws SQLException {
        // add actors/genres for movie
        for (String item : list) {
            getID.setString(1, item);
            ResultSet rs = getID.executeQuery();
            if (rs.next()) {
                int tmpID = rs.getInt("ID");
                if (cList.contains(tmpID)) {
                    cList.remove(Integer.valueOf(tmpID));
                } else {
                    insertStmt.setInt(2, tmpID);
                    insertStmt.executeUpdate();
                }
            }
        }
        // delete actors/genres for movie
        for (int deleteid : cList) {
            deleteStmt.setInt(2, deleteid);
            deleteStmt.executeUpdate();
        }
    }

    /**
     * get list of IDs from the result set
     *
     * @param rs ResultSet of IDs
     * @return ArrayList of the IDs of current actors/genres
     * @throws SQLException
     */
    private ArrayList<Integer> getcList(ResultSet rs) throws SQLException {
        ArrayList<Integer> cList = new ArrayList<>();
        while (rs.next()) {
            cList.add(rs.getInt(1));
        }
        return cList;
    }
}
