package com.spmovy.servlet;

import com.spmovy.DatabaseUtils;
import com.spmovy.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;

@WebServlet("/backend/admin/DeleteTimeslot")
public class DeleteTimeslot extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        DatabaseUtils db = Utils.getDatabaseUtils(response);
        if (db == null) return;
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("/errors/error.html");
            return;
        }
        try {
            String date = request.getParameter("moviedate");
            String time = request.getParameter("movietime");
            int updateCount = db.executeUpdate("delete from timeslot where movietime=? and moviedate=? and movieID=?",
                    Time.valueOf(time),
                    Date.valueOf(date),
                    id);
            if (updateCount != 1) {
                response.sendRedirect("/errors/error.html");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/errors/error.html");
            return;
        } finally {
            db.closeConnection();
        }
        response.sendRedirect("/admin/timeslots.jsp?id="+id);
    }
}
