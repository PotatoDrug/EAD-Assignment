<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String driverName = "com.mysql.jdbc.Driver";
    Class.forName(driverName);
    String url = "jdbc:mysql://52.74.214.114/spmovy?autoReconnect=true&verifyServerCertificate=false&useSSL=true";

    try {
        Connection connection = DriverManager.getConnection(url, "spmovy", "15Pb6pc%$8!@P^NR$h@5rLM84gJvR2u1p72F^3");
        PreparedStatement prepared = connection.prepareStatement("UPDATE actor SET Name=?, description=? WHERE ID=?");
        prepared.setString(1, name);
        prepared.setString(2, description);
        prepared.setInt(3, id);
        prepared.executeUpdate();
        connection.close();
        response.sendRedirect("/admin/actors.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>