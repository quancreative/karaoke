<!doctype html>
<html lang="en" ng-app>
<head>
    <meta charset="utf-8">
    <!-- Tells Internet Explorer to display content in the highest mode available. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Playlist</title>

    <link href="libraries/bootstrap/v2.3.2/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="libraries/bootstrap/v2.3.2/css/bootstrap-responsive.css" rel="stylesheet">
    <!-- Doc: http://glyphicons.getbootstrap.com/ -->
    <link href="libraries/glyphicons/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">

    <script src="libraries/angularjs/angular.min.js"></script>
    <script src="libraries/jquery/jquery-2.0.3.min.js"></script>
<body>

<div class="container">
    <section id="playlist-content" ng-controller="PlaylistCtrl">

        <button id="switch-track" type="button" class="btn">Toggle Track</button>
        <!-- <button type="button" class="btn" ng-click="clearPlaylist()">Clear Playlist</button> -->
        <button type="button" class="btn btn-ttc"><span class="glyphicon glyphicon-backward"></span></button>
        <button type="button" class="btn btn-ttc" ng-click="forward()"><span class="glyphicon glyphicon-forward"></span>
        </button>

        <h6>Playlist</h6>
        <ul class="media-list">
            <li class="media" ng-repeat="song in playlist">
                <button type="button" class="pull-left glyphicon-minus" ng-click="removeSong(song.id)"></button>
                <div class="media-body">
                    <h5 class="media-heading">{{song.title}}</h5>
                    {{song.artist}}
                    <a href="musics/{{song.src}}" target="_blank">Open</a>
                </div>
            </li>
        </ul>
    </section>
</div>
<!-- end .container -->
<script src='https://cdn.firebase.com/v0/firebase.js'></script>
<script src="js/songFileHelper.js"></script>
<script src="js/playlist.js"></script>
</body>
</html>
