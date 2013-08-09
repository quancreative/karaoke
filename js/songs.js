function SongCtrl($scope, $http, $templateCache) {
    var myDataRef = new Firebase('https://karaoke.firebaseio.com/');
    $scope.test = 'Where the fuck is my shit?';
    $scope.playlist = [];

    var playlist = [];

    $scope.songs = [
        {
            src: 'Maid with the Flaxen Hair.mp3'
        },
        {
            src: "Kalimba.mp3"
        },
        {
            src: 'Sleep Away.mp3'
        }
    ];

    $scope.addSong = function (songSrc) {
        // For some reason AngularJS add $$hash to every push()
//        $scope.playlist.push({src: songSrc});

        playlist.push({'src' : songSrc});

        console.log(playlist);

        myDataRef.set({'playlist' : playlist});
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


    myDataRef.on('value', function(snapshot) {
        var message = snapshot.val();
        console.log(message.name, message.text);
    });


}

