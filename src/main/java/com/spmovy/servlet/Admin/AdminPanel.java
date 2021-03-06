package com.spmovy.servlet.Admin;

import com.spmovy.beans.ToptenJB;
import com.spmovy.beans.ToptenJBDB;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

@WebServlet("/admin/adminPanel")
public class AdminPanel extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<ToptenJB> beanlist = null;
        try {
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));
            Calendar cal = Calendar.getInstance();
            int curryear = Integer.parseInt(new SimpleDateFormat("yyyy").format(cal.getTime()));

            if (month > 12 || month < 1){
                request.setAttribute("inputformat", "invalidmonth");
            }
            else if (year < 2018 || year > curryear) {
                request.setAttribute("inputformat", "invalidyear");
            }

            else {
                ToptenJBDB beandb = new ToptenJBDB();
                beanlist = beandb.getcurrentMonthSales(month, year);
                if (beanlist.isEmpty()) {
                    request.setAttribute("nosales", "true");
                    request.setAttribute("month", month);
                    request.setAttribute("year", year);
                } else {
                    request.setAttribute("beanlist", beanlist);
                }
            }
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/admin/adminPanel.jsp");
            rd.forward(request, response);

            //catching for invalid inputs that are not integers
        } catch (NumberFormatException e) {
            request.setAttribute("inputformat", "invalidformat");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/admin/adminPanel.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/errors/error.html");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<ToptenJB> beanlist = null;
        try {
            Calendar cal = Calendar.getInstance();
            int currmonth = Integer.parseInt(new SimpleDateFormat("MM").format(cal.getTime()));
            int curryear = Integer.parseInt(new SimpleDateFormat("yyyy").format(cal.getTime()));

            ToptenJBDB beandb = new ToptenJBDB();
            beanlist = beandb.getcurrentMonthSales(currmonth, curryear);
            if (beanlist.isEmpty()) {
                request.setAttribute("nosales", "true");
                request.setAttribute("month", currmonth);
                request.setAttribute("year", curryear);
            } else {
                request.setAttribute("beanlist", beanlist);
            }
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/admin/adminPanel.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/errors/error.html");
        }
    }
}
