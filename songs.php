<!doctype html>
<html lang="en" ng-app>
<head>
    <meta charset="utf-8">
    <!-- Tells Internet Explorer to display content in the highest mode available. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Songs</title>

    <link href="libraries/bootstrap/v2.3.2/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="libraries/glyphicons/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">
    <link href="css/main.css" rel="stylesheet" media="screen">

    <script src="libraries/angularjs/angular.min.js"></script>
    <script src="libraries/jquery/jquery-2.0.3.min.js"></script>
<body>

<div class="container" ng-controller="SongCtrl">


    <ul class="nav nav-tabs">
        <li class="active"><a href="#">All</a></li>
        <li><a href="#">By Title</a></li>
        <li><a href="#">By Artist</a></li>
    </ul>

    <input type="text" class="search-query span5" ng-model="search" width="600px" placeholder="Search">

    <table class="table table-hover table-condensed">
        <thead>
        <tr>
            <th>Add</th>
            <th>Title</th>
            <th>Artist</th>
        </tr>
        </thead>
        <tbody>
        <tr ng-repeat="song in songs | filter:search | orderBy:'name'">
            <td><button type="button" class="btn btn-small glyphicon glyphicon-plus" ng-click="addSong(song.src)" ng-model-instant></button></td>
            <td>{{song.title}}<span class='hide'>{{song.songSrcNoDiacritics}}</span></td>
            <td>{{song.artist}}</td>
        </tr>
        </tbody>
    </table>

</div>
<!-- end .container -->
<script src='https://cdn.firebase.com/v0/firebase.js'></script>
<script src="js/songs.js"></script>
</body>
</html>
