package com.spmovy.servlet;

import com.spmovy.DatabaseUtils;
import com.spmovy.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/backend/admin/Delete")
public class Delete extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String table = request.getParameter("table");
        if (table == null) {
            response.sendRedirect("/errors/error.html");
            return;
        }
        DatabaseUtils db = Utils.getDatabaseUtils(response);
        if (db == null) return; // return if database connection failed
        if (Utils.deleteID(request, response, db, table) == false) return;
        if (request.getHeader("referer") == null) {
            response.sendRedirect("/admin/adminPanel.jsp");
        } else {
            response.sendRedirect(request.getHeader("referer"));
        }
    }
}
