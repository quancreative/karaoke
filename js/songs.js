function SongCtrl($scope, $http, $templateCache) {
	// Big thanks to http://web.archive.org/web/20120701052005/http://lehelk.com/2011/05/06/script-to-remove-diacritics/


//    var playlistScope = {}, playlist = new PlaylistCtrl(playlistScope);
    var fbPlaylist = new Firebase('https://karaoke.firebaseio.com/playlist');
    $scope.songs = [ ];
    $scope.predicate = 'title';
    $scope.titleClass = 'glyphicon-arrow-down';

    /*
     fbPlaylist.once('value', function(snapshot) {
        console.log('fbPlaylist : ' + snapshot.val());
        if (snapshot.val() === null)
        {

        }
    });
     */

    $scope.addSong = function (songSrc) {
        // Need to use songSrc to lookup in the $scope.songs.
        // Note: $id and $index will return different result if user uses search or filter
        var songObj;
        for (songNum in $scope.songs){
            if ($scope.songs[songNum].src === songSrc)
            {
                songObj = $scope.songs[songNum];
//                console.log('found');
            }
        }

//        var songObj = $scope.songs[index];
        songObj.class = 'btn-success glyphicon-ok';
        fbPlaylist.push({'src' : songObj.src});
    }

    $scope.clearSearch = function(){
        $scope.search = '';
    }


    $http({
        method: 'GET',
        url: 'xml/songs.xml',
        cache: $templateCache
    }).success(function (data, status) {
            $scope.status = status;
            $scope.data = data;
            console.log("Success loading song.xml.");

            var xmlDoc = $.parseXML($scope.data);
            parseXML(xmlDoc);

        }).error(function (data, status) {
            $scope.data = data || "Request failed";
            $scope.status = status;
        });

    function parseXML(xmlDoc){
        $scope.$xml = $(xmlDoc);
        var $song = $scope.$xml.find('file');
        for (var i = 0; i < $song.length; i++) {
//            var songSrc = $song[i].childNodes[0].nodeValue;
            var songSrc = $($song[i]).text();
//            console.log(songSrc);

            var songObj = songFileHelper.cleanup(songSrc);

            $scope.songs.push({ 'title' : songObj.title, 'artist' : songObj.artist, 'src' : songObj.src, 'songSrcNoDiacritics' : songObj.songSrcNoDiacritics, 'class' : 'glyphicon-plus' });
        }

    }
}

Array.prototype.remove = function(v) {
    return $.grep(this, function(e) {
        return e !== v;
    });
};
//var test = [2, 3 ,4 ,5 ,7 ,9, 1];
//console.log('test : ' + test.remove(3));
