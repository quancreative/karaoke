<!doctype html>
<html lang="en" ng-app>
<head>
    <meta charset="utf-8">
    <!-- Tells Internet Explorer to display content in the highest mode available. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Playlist</title>

    <link href="libraries/bootstrap/v3.0.0/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <!-- Bootstrap theme -->
    <link href="libraries/bootstrap/v3.0.0/css/bootstrap-theme.min.css" rel="stylesheet">

    <script src="libraries/angularjs/angular.min.js"></script>
    <script src="libraries/jquery/jquery-2.0.3.min.js"></script>
    <style>
        body {
            padding-top: 80px;
        }
    </style>
<body>

<header class="navbar navbar-inverse navbar-fixed-top bs-docs-nav" role="banner">
    <div class="container">
        <div class="navbar-header">
            <div class="row">
                <div class="col-xs-6 navbar-form">
                    <button id="switch-track" class="btn btn-inverse" type="button" ng-click="toggleTrack()">Toggle Track</button>
                    <!-- <button type="button" class="btn" ng-click="clearPlaylist()">Clear Playlist</button> -->
                </div>

                <div class="col-xs-6 navbar-form">
                    <button type="button" class="btn btn-inverse"><span class="glyphicon glyphicon-backward"></span></button>
                    <button type="button" class="btn btn-inverse" ng-click="forward()"><span class="glyphicon glyphicon-forward"></span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Callout for the old docs link -->
<div class="container" ng-controller="PlaylistCtrl">
    <div class="panel panel-info">
        <div class="panel-heading">Playlist</div>
        <ul class="list-group">
            <a href="#" class="list-group-item" ng-repeat="song in playlist">
                <button type="button" class="pull-right btn glyphicon glyphicon-remove" ng-click="removeSong(song.id)"></button>
                <h5 class="list-group-item-heading">{{song.title}}</h5>
                <p class="list-group-item-text">{{song.artist}}</p>
            </a>
        </ul>
    </div>
</div>
<!-- end .container -->

<script src="libraries/bootstrap/v3.0.0/js/bootstrap.min.js"></script>
<script src="js/songFileHelper.js"></script>
<script src='https://cdn.firebase.com/v0/firebase.js'></script>
<script src="js/songFileHelper.js"></script>
<script src="js/playlist.js"></script>
</body>
</html>
