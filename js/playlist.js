function PlaylistCtrl($scope, $http, $templateCache) {

    $scope.test = 'Where the fuck is my shit?';
    $scope.songs = [
        {
            src: 'Maid with the Flaxen Hair.mp3',
            played: false,
            added: false
        },
        {
            src: "Kalimba.mp3",
            played: false,
            added: false
        },
        {
            src: 'Sleep Away.mp3',
            played: false,
            added: false
        }
    ];

    $scope.playlist = [
    ];

    $scope.addSong = function (songSrc) {
        $scope.playlist.push({src: songSrc, played: false});
    }

    $scope.removeSong = function (rmSong)
    {
        var oldPlaylist = $scope.playlist;
        $scope.playlist = [];

        angular.forEach(oldPlaylist, function(song){

            if (song != rmSong)
            {
                $scope.playlist.push(song);
            }
        });
    }

    $scope.clearPlaylist = function(){
        $scope.playlist = [];
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
            $scope.$xml = $(xmlDoc);
            var $song = $scope.$xml.find('file');
            for (var i = 0; i < $song.length; i++) {
            }

    }).error(function (data, status) {
        $scope.data = data || "Request failed";
        $scope.status = status;
    });
}

var myDataRef = new Firebase('https://karaoke.firebaseio.com/');
myDataRef.on('child_added', function(snapshot) {
    var message = snapshot.val();
    console.log(message.name, message.text);
});
myDataRef.set({name: 'quan', text: 'testing'});