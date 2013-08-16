<!doctype html>
<html lang="en" ng-app>
<head>
    <meta charset="utf-8">
    <!-- Tells Internet Explorer to display content in the highest mode available. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Songs</title>

    <link href="libraries/bootstrap/v2.3.2/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <!-- Doc: http://glyphicons.getbootstrap.com/ -->
    <link href="libraries/glyphicons/css/bootstrap-glyphicons.css" rel="stylesheet" media="screen">

    <link href="css/main.css" rel="stylesheet" media="screen">

    <script src="libraries/angularjs/angular.min.js"></script>
    <script src="libraries/jquery/jquery-2.0.3.min.js"></script>

<body class="page-song-bank">

<div class="container" ng-controller="SongCtrl">
    <h3>Song Bank</h3>
    <ul class="nav nav-tabs">
        <li class="active"><a href="#">Vietnamese</a></li>
        <li><a href="#">English</a></li>
    </ul>

    <input type="text" class="search-query span5" ng-model="search" width="600px" placeholder="Search">
    <!--    <pre>Sorting predicate = {{predicate}}; reverse = {{reverse}}; class = {{class}}</pre> -->

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
                <button type="button"   class="btn btn-small glyphicon {{song.class}}"  ng-click="addSong($index)" ng-model-instant>
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
<script src='https://cdn.firebase.com/v0/firebase.js'></script>
<script src="js/songs.js"></script>
</body>
</html>
