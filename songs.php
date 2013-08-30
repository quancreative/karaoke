<!doctype html>
<html lang="en" ng-app>
<head>
    <meta charset="utf-8">
    <!-- Tells Internet Explorer to display content in the highest mode available. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Songs</title>

    <!-- TODO: Clean up. This page is using both ver 2 and 3 of Glyphicon. -->
    <link href="libraries/bootstrap/v2.3.2/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="libraries/bootstrap/v2.3.2/css/bootstrap-responsive.css" rel="stylesheet">
    <!-- Doc: http://glyphicons.getbootstrap.com/ -->
    <link href="libraries/glyphicons/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">

    <link href="css/main.css" rel="stylesheet" media="screen">

    <script src="libraries/angularjs/angular.min.js"></script>
    <script src="libraries/jquery/jquery-2.0.3.min.js"></script>

<body class="page-song-bank" ng-controller="SongCtrl">

<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <button class="btn btn-inverse" type="button" ng-click="toggleTrack()">Toggle Track</button>
            <button class="btn btn-inverse pull-right" type="button" ng-click="forward()"><span class="glyphicon glyphicon-forward"></span></button>
        </div>
    </div>
</div>

<div id="main-content-container" class="container" >

    <ul class="nav nav-tabs">
        <li class="active"><a href="#">Vietnamese</a></li>
        <li><a href="#">English</a></li>
    </ul>

    <input type="text" class="search-query span5" ng-model="search" width="600px" placeholder="Search">
    <!-- <button type="button"  class="btn btn-small glyphicon glyphicon-remove"  ng-click="clearSearch()" ng-model-instant></button> -->
    <!-- <pre>Sorting predicate = {{predicate}}; reverse = {{reverse}}; class = {{class}}</pre> -->

    <table class="table table-hover table-condensed">
        <thead>
        <tr>
            <th>Add</th>
            <th>
                <a href="#" ng-click="predicate = 'title'; reverse=false; titleClass = 'glyphicon-arrow-down'; artistClass = '' ">Title <span class="glyphicon {{titleClass}}"></span>
                </a>
            </th>
            <th>
                <a href="#" ng-click="predicate = 'artist'; reverse=reverse; titleClass=''; artistClass='glyphicon-arrow-down'">Artist <span class="glyphicon {{artistClass}}"></a>
            </th>
        </tr>
        </thead>
        <tbody>
        <tr ng-repeat="song in songs | filter:search | orderBy:predicate:reverse">
            <td>
                <button type="button"   class="btn btn-small glyphicon {{song.class}}"  ng-click="addSong(song.src)" ng-model-instant>
                    <span class='hide'>{{song.songSrcNoDiacritics}}</span>
                </button>
            </td>
            <td>{{song.title}}</td>
            <td>{{song.artist}}</td>
        </tr>
        </tbody>
    </table>

</div>
<!-- end .container -->
<script src="libraries/bootstrap/v2.3.2/js/bootstrap.min.js"></script>
<script src='https://cdn.firebase.com/v0/firebase.js'></script>
<script src="js/songFileHelper.js"></script>
<script src="js/songs.js"></script>
</body>
</html>
