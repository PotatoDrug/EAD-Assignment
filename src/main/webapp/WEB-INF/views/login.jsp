<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.spmovy.beans.UserJB" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<% UserJB user = (UserJB) session.getAttribute("user"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="/css/login.css">
    <script src="https://www.google.com/recaptcha/api.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="/image/favicon.ico" type="image/x-icon">
    <link rel="icon" href="/image/favicon.ico" type="image/x-icon">
    <title>SPMovy | Login</title>
</head>
<body class="text-center">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" role="navigation">
    <div class="container">
        <a class="navbar-brand" href="/">SPMovy</a>
        <button class="navbar-toggler border-0" type="button" data-toggle="collapse" data-target="#exCollapsingNavbar">
            &#9776;
        </button>
        <div class="collapse navbar-collapse" id="exCollapsingNavbar">
            <% if (user != null) { %>
            <ul class="nav navbar-nav">
                <li class="nav-item"><a href="/user/Profile" class="nav-link">Profile</a></li>
            </ul>
            <ul class="nav navbar-nav">
                <li class="nav-item"><a href="/user/Transactions" class="nav-link">Transactions</a></li>
            </ul>
            <ul class="nav navbar-nav">
                <li class="nav-item"><a href="/user/Checkout" class="nav-link">Checkout</a></li>
            </ul>
            <% } %>
            <ul class="nav navbar-nav flex-row justify-content-between ml-auto">
                <li class="dropdown order-1">
                        <% if (user == null) { %>
                <li class="nav-item"><a href="/Login" class="nav-link">Login</a></li>
                <% } else { %>
                <li class="dropdown order-1">
                    <button type="button" id="dropdownMenu1" data-toggle="dropdown"
                            class="btn btn-outline-secondary dropdown-toggle">
                        Welcome, <%= StringEscapeUtils.escapeHtml4(user.getName()) %><span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-right mt-2">
                        <li class="px-3 py-2"><a href="/backend/Logout">Logout</a></li>
                    </ul>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
<form class="form-signin" method="post" action="/Login">
    <img class="mb-4" src="../../image/movie.svg" alt="" width="72" height="72">
    <h1 class="h3 mb-3 font-weight-normal">Please login</h1>
    <label for="username" class="sr-only">Username</label>
    <input type="text" name="username" id="username" class="form-control" placeholder="Username" required autofocus>
    <label for="inputPassword" class="sr-only">Password</label>
    <input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" required>
    <div class="g-recaptcha" data-sitekey="6Ld5D1oUAAAAAGkPcZ6GpeTvFA15pYZLTD6b6hTA"></div>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
    <a class="mt-5 mb-3" href="/RegisterUser">Not registered? Click here.</a>
    <%
        String login = (String) request.getAttribute("login");
        if (login != null) {
            if (login.equals("failed")) {
                out.println("<p class=\"mt-5 mb-3 invalid-login\">You have entered an invalid ID/Password<p>");
            } else if (login.equals("Not")) {
                out.println("<p class=\"mt-5 mb-3 invalid-login\">Not logged in.<p>");
            } else if (login.equals("captcha")) {
                out.println("<p class=\"mt-5 mb-3 invalid-login\">Captcha Failed.<p>");
            }
        }
    %>
    <p class="mt-5 mb-3 text-muted">SPMovy &copy; 2018</p>
</form>
</body>
</html>