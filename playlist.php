<!doctype html>
<html lang="en" ng-app>
<head>
    <meta charset="utf-8">
    <!-- Tells Internet Explorer to display content in the highest mode available. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Playlist</title>

    <link href="libraries/bootstrap/v2.3.2/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="libraries/glyphicons/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">
    <link href="css/main.css" rel="stylesheet" media="screen">

    <script src="libraries/angularjs/angular.min.js"></script>
    <script src="libraries/jquery/jquery-2.0.3.min.js"></script>
<body>

<div class="container" ng-controller="PlaylistCtrl">

    <section>
        <h2>Playlist</h2>
        <ul class="unstyled">
            <li class="song-added-{{song}}" ng-repeat="song in playlist">
                <button type="button" class="btn glyphicon-minus" ng-click="removeSong(song)"></button>
                {{song.src}}
            </li>
        </ul>

        <button type="button" class="btn" ng-click="clearPlaylist()">Clear Playlist</button>
    </section>

    <hr/>

    <input type="text" ng-model="search" class="search-query" placeholder="Search">
    <ul class="unstyled">
        <li ng-repeat="song in songs | filter:search">

            <button type="button" class="btn glyphicon glyphicon-plus" ng-click="addSong(song.src)"
            ng-model-instant></button>
            {{song.src}}
        </li>
    </ul>

</div>
<!-- end .container -->
<script src='https://cdn.firebase.com/v0/firebase.js'></script>
<script src="js/playlist.js"></script>
</body>
</html>
