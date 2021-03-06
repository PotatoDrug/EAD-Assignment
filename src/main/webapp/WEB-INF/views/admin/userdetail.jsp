<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/admin/header.html" %>
<%@ page import="com.spmovy.beans.UserJB" %>
<%@ page import="com.spmovy.beans.UserTransactionJB" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%
    UserJB userbean = (UserJB) request.getAttribute("userbean");
    ArrayList<UserTransactionJB> transactionlist = (ArrayList<UserTransactionJB>) request.getAttribute("transactionlist");
%>
<title>Users</title>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <a class="navbar-brand" href="/admin/adminPanel">SPMovy Admin</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true"
                   aria-expanded="false">
                    Movies
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/admin/movies.jsp">List Movies</a>
                    <a class="dropdown-item" href="/admin/addMovie.jsp">Add Movie</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true"
                   aria-expanded="false">
                    Genres
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/admin/genres.jsp">List Genres</a>
                    <a class="dropdown-item" href="/admin/addGenre.jsp">Add Genre</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true"
                   aria-expanded="false">
                    Actors
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/admin/actors.jsp">List Actors</a>
                    <a class="dropdown-item" href="/admin/addActor.jsp">Add Actor</a>
                </div>
            </li>
            <li class="nav-item dropdown active">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true"
                   aria-expanded="false">
                    Users
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/admin/Users">List Users</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true"
                   aria-expanded="false">
                    Account
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="/admin/changePassword.jsp">Change Password</a>
                </div>
            </li>
        </ul>
        <div class="w-50">
            <form class="form-inline mt-2 mb-2 float-right" action="/admin/Users">
                <input class="form-control mr-sm-2" name="username" type="search" placeholder="Users"
                       aria-label="Search">
                <button class="btn btn-outline-dark my-2 my-sm-0 mr-1" type="submit">Search</button>
                <a class="btn btn-outline-danger" href="/backend/Logout">Logout</a>
            </form>
        </div>
    </div>
</nav>
<h2>User Details</h2>
<table class="table">
    <tbody>
    <tr>
        <td><b>Username</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getUsername()) %>
        </td>
    </tr>
    <tr>
        <td><b>Role</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getRole()) %>
        </td>
    </tr>
    <tr>
        <td><b>Name</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getName()) %>
        </td>
    </tr>
    <tr>
        <td><b>Email</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getEmail()) %>
        </td>
    </tr>
    <tr>
        <td><b>Contact</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getContact()) %>
        </td>
    </tr>
    <tr>
        <td><b>Card Name</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getCardname()) %>
        </td>
    </tr>
    <tr>
        <td><b>Card Number</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getCreditcard()) %>
        </td>
    </tr>
    <tr>
        <td><b>CVV</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getCvv()) %>
        </td>
    </tr>
    <tr>
        <td><b>Expiry</b></td>
        <td><%= StringEscapeUtils.escapeHtml4(userbean.getExp()) %>
        </td>
    </tr>
    </tbody>
</table>
<h2>Transaction Details</h2>
<table class="table" style="table-layout: fixed;">
    <thead class="thead-dark">
    <tr>
        <th style="word-wrap: break-word;" scope="col">Transaction ID</th>
        <th style="word-wrap: break-word;" scope="col">Transaction Time</th>
        <th style="word-wrap: break-word;" scope="col">Ticket ID</th>
        <th style="word-wrap: break-word;" scope="col">Price</th>
        <th style="word-wrap: break-word;" scope="col">Seat</th>
        <th style="word-wrap: break-word;" scope="col">Movie Time</th>
        <th style="word-wrap: break-word;" scope="col">Movie Title</th>
    </tr>
    </thead>
    <tbody>
    <% for (UserTransactionJB transaction : transactionlist) { %>
    <tr>
        <td style="word-wrap: break-word;"><%= transaction.getID() %>
        </td>
        <td style="word-wrap: break-word;"><%= transaction.getAt() %>
        </td>
        <td style="word-wrap: break-word;"><%= transaction.getTicketID() %>
        </td>
        <td style="word-wrap: break-word;"><%= transaction.getPrice() %>
        </td>
        <td style="word-wrap: break-word;"><%= transaction.getHall_row() + transaction.getHall_column() %>
        </td>
        <td style="word-wrap: break-word;"><%= transaction.getMoviedate().toString() + " " + transaction.getMovietime().toString() %>
        </td>
        <td style="word-wrap: break-word;"><%= StringEscapeUtils.escapeHtml4(transaction.getMovietitle()) %>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>
<%@ include file="/admin/footer.html" %>
