<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.html" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.2/awesomplete.css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/awesomplete/1.1.2/awesomplete.js" async></script>
<title>Update Movie</title>
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
                <div class="dropdown-menu active" aria-labelledby="navbarDropdown">
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
            <li class="nav-item dropdown">
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
            <form class="form-inline mt-2 mb-2 float-right" action="movies.jsp">
                <input class="form-control mr-sm-2" type="search" name="moviename" placeholder="Movie Title"
                       aria-label="Search">
                <button class="btn btn-outline-dark my-2 my-sm-0 mr-1" type="submit">Search</button>
                <a class="btn btn-outline-danger" href="/backend/Logout">Logout</a>
            </form>
        </div>
    </div>
</nav>
<%@ page import="java.sql.*,org.apache.commons.lang3.StringEscapeUtils,java.util.ArrayList,com.spmovy.DatabaseUtils" %>
<%@ page import="com.spmovy.Utils" %>
<%
    int noActors = 0;
    int noGenres = 0;
    int movieid = 1;
    if (request.getParameter("id") == null) {
        response.sendRedirect("/admin/movies.jsp");
    } else {
        movieid = Integer.parseInt(request.getParameter("id"));
    }
    String title = "";
    String releasedate = "";
    String synopsis = "";
    int duration = 0;
    String imagepath = "";
    String status = "";
    ArrayList<String> genrelist = new ArrayList();
    ArrayList<String> actorlist = new ArrayList();
    DatabaseUtils db = Utils.getDatabaseUtils(response);
    ResultSet rs;
    try {
        rs = db.executeQuery("SELECT * FROM movie where ID=?", movieid);
        if (rs.next()) {
            out.print("<tr>");
            title = rs.getString("title");
            releasedate = String.valueOf(rs.getDate("releasedate"));
            synopsis = rs.getString("synopsis");
            duration = rs.getInt("duration");
            imagepath = rs.getString("imagepath");
            status = rs.getString("status");
        }
        // get actors
        rs = db.executeQuery("SELECT movie.title, actor.name from MovieActor inner join movie on MovieActor.movieID = movie.ID inner join actor on MovieActor.actorID = actor.ID where movie.id = ?",
                movieid);
        while (rs.next()) {
            actorlist.add(rs.getString(2));
        }
        noActors = actorlist.size();

        // get genres
        rs = db.executeQuery("select Genre.name from MovieGenre inner join movie on MovieGenre.movieID = movie.ID inner join Genre on MovieGenre.genreID = Genre.ID where movie.id=?", movieid);
        while (rs.next()) {
            genrelist.add(rs.getString(1));
        }
        noGenres = genrelist.size();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("/error.html");
    }
%>

<form method="post" action="/backend/admin/UpdateMovie">
    <div class="form-group row">
        <label class="col-sm-2 col-form-label">Title</label>
        <div class="col-md-3">
            <input class="form-control" type="text" name="title" value="<%= StringEscapeUtils.escapeHtml4(title) %>"
                   required>
        </div>
    </div>
    <div class="form-group row">
        <label class="col-sm-2 col-form-label">Release Date</label>
        <div class="col-md-3">
            <input class="form-control" type="date" name="releasedate" value="<%= releasedate %>" required>
        </div>
    </div>
    <div class="form-group row">
        <label class="col-sm-2 col-form-label">Synopsis</label>
        <div class="col-md-3">
            <textarea rows="6" class="form-control" type="text" name="synopsis"
                      required><%= StringEscapeUtils.escapeHtml4(synopsis) %></textarea>
        </div>
    </div>
    <div class="form-group row">
        <label class="col-sm-2 col-form-label">Duration (mins)</label>
        <div class="col-md-3">
            <input class="form-control" type="number" name="duration" value="<%= duration %>" required>
        </div>
    </div>
    <div class="form-group row">
        <label for="genres" class="col-sm-2 col-form-label">Genres</label>
        <div class="col-md-3" id="genres">
            <% for (int i = 0; i < noGenres; i++) {
                if (i == noGenres - 1) {
                    out.print("<input class=\"form-control awesomplete mb-2\" id=\"field" + (i + 1) + "\" name=\"genre\" list=\"GenreList\" value=\"" + genrelist.get(i) + "\">");
                } else {
                    out.print("<input class=\"form-control awesomplete mb-2\" id=\"field" + (i + 1) + "\" name=\"genre\" list=\"GenreList\" value=\"" + genrelist.get(i) + "\">");
                    out.print("<button id=\"remove" + (i + 1) + "\" class=\"btn btn-danger remove-me ml-2\" >-</button>");
                }
            }
            %>
            <button id="b1" class="btn add-more ml-1" type="button">+</button>
        </div>
        <input type="hidden" id="next" value="<%=noGenres%>"/>
    </div>
    <div class="form-group row">
        <label for="actors" class="col-sm-2 col-form-label">Actors</label>
        <div class="col-md-3" id="actors">
            <% for (int i = 0; i < noActors; i++) {
                if (i == noActors - 1) {
                    out.print("<input class=\"form-control awesomplete mb-2\" id=\"fieldz" + (i + 1) + "\" name=\"actor\" list=\"ActorList\" value=\"" + actorlist.get(i) + "\">");
                } else {
                    out.print("<input class=\"form-control awesomplete mb-2\" id=\"fieldz" + (i + 1) + "\" name=\"actor\" list=\"ActorList\" value=\"" + actorlist.get(i) + "\">");
                    out.print("<button id=\"remove" + (i + 1) + "\" class=\"btn btn-danger remove-me2 ml-2\" >-</button>");
                }
            }
            %>
            <button id="bt1" class="btn add-more2 ml-1" type="button">+</button>
        </div>
        <input type="hidden" id="next2" value="<%=noActors%>"/>
    </div>
    <div class="form-group row">
        <label class="col-sm-2 col-form-label">Image Path</label>
        <div class="col-md-3">
            <input class="form-control" type="text" name="imagepath"
                   value="<%= StringEscapeUtils.escapeHtml4(imagepath) %>" required>
        </div>
    </div>
    <div class="form-group row">
        <label class="col-sm-2 col-form-label">Status</label>
        <select name="status" class="custom-select col-md-3" required>
            <option <% if (status.equals("Coming Soon")) {
                out.print("selected=\"selected\"");
            } %> value="Coming Soon">Coming Soon
            </option>
            <option <% if (status.equals("Now Showing")) {
                out.print("selected=\"selected\"");
            } %> value="Now Showing">Now Showing
            </option>
            <option <% if (status.equals("Over")) {
                out.print("selected=\"selected\"");
            } %> value="Over">Over
            </option>
        </select>
    </div>
    <input type="hidden" name="id" value="<%= movieid %>">
    <div class="form-group row">
        <div class="col-sm-10">
            <button type="submit" class="btn btn-primary">Update Movie</button>
        </div>
    </div>
</form>
<form class="pt-0 pb-2 mb-4" style="border-bottom:#969696 1px solid" method="post" action="/backend/admin/DeleteMovie">
    <input type="hidden" name="table" value="movie">
    <input type="hidden" name="id" value="<%=movieid%>">
    <input class="btn btn-danger" type="submit" value="Delete">
</form>
<h3 class="ml-4">Movie Poster Upload:</h3>
<p class="ml-4">Select an image file to upload:</p><br/>
<form class="pt-0 mb-2" method="post" enctype="multipart/form-data" id="fileUploadForm">
    <input type="file" name="file" id="imgInp" multiple="true"/>
    <img id="imgPreview" src="<%= imagepath %>" alt="Movie Poster" /><br/><br/>
    <input type="submit" class="btn btn-outline-success" value="Upload Movie Poster" id="btnSubmit"/>
</form>
<datalist id="GenreList">
    <%
        ArrayList<String> completegenrelist = new ArrayList();
        try {
            rs = db.executeQuery("SELECT name from Genre");
            while (rs.next()) {
                completegenrelist.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/errors/error.html");
            return;
        }
        for (String genre : completegenrelist) {
            out.print("<option>" + genre + "</option>");
        }
    %>
</datalist>
<datalist id="ActorList">
    <%
        ArrayList<String> completeactorlist = new ArrayList();
        try {
            rs = db.executeQuery("SELECT Name from actor");
            while (rs.next()) {
                completeactorlist.add(rs.getString("Name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/errors/error.html");
            return;
        } finally {
            db.closeConnection();
        }
        for (String actor : completeactorlist) {
            out.print("<option>" + actor + "</option>");
        }
    %>
</datalist>
</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
        integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"
        defer></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
        integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"
        defer></script>
<script src="/js/dynamicfields.js" defer></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>
    var path;
    $(document).ready(function () {

        $("#btnSubmit").click(function (event) {

            //stop submit the form, we will post it manually.
            event.preventDefault();

            // Get form
            var form = $('#fileUploadForm')[0];

            // Create an FormData object
            var data = new FormData(form);

            // disabled the submit button
            $("#btnSubmit").prop("disabled", true);
            $.ajax({
                type: "POST",
                enctype: 'multipart/form-data',
                url: "https://cdn.spmovy.xyz/upload",
                headers: {"token": "jwqIVxAJxBbe8iobMiyY4B1snIW7CSm9FNyfpjTrzdo389sQjvv9cF7x3AGDfDlj"},
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                success: function (data) {

                    $("#result").text(data);
                    var x = JSON.parse(data).files.file.path.split('/');
                    path = x[x.length - 1];
                    $.ajax({
                        type: 'POST',
                        url: "/backend/admin/UpdateMovieImagePath",
                        data: {
                            'id': '<%=movieid%>',
                            'path': path
                        },
                        success: function (msg) {
                            alert(msg);
                        }
                    });
                    $("#btnSubmit").prop("disabled", false);

                },
                error: function (e) {
                    $("#result").text(e.responseText);
                    console.log("ERROR : ", e);
                    $("#btnSubmit").prop("disabled", false);
                }
            });
        });
    });
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#imgPreview').attr('src', e.target.result);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imgInp").change(function(){
        readURL(this);
    });

</script>
</html>