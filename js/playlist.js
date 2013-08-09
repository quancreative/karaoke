function PlaylistCtrl($scope, $http, $templateCache) {
    var myDataRef = new Firebase('https://karaoke.firebaseio.com/');
    $scope.test = 'Where the fuck is my shit?';
    $scope.playlist = [];

    var playlist = [];

    $scope.addSong = function (songSrc) {
        // For some reason AngularJS add $$hash to every push()
//        $scope.playlist.push({src: songSrc});
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

    $scope.forward = function() {
        // Remove first one on the list.
        playlist.splice(0,1);

        myDataRef.child('playlist').child('src').remove();

        update();
    }

    $scope.clearPlaylist = function(){
        $scope.playlist = [];
    }
    myDataRef.on('value', function(snapshot) {
        var data = snapshot.val();

        // Note: playlist may not be in numerical order.
        playlist = data.playlist;

        $scope.playlist = [];

        // This will put it in numerical order.
        angular.forEach(playlist, function(songObj){
            $scope.playlist.push(songObj);
        });
//        console.log($scope.playlist);

        // Update angular
        $scope.safeApply(function() { });

        vlc.play($scope.playlist[0]);

    });

    $scope.safeApply = function(fn) {
        var phase = this.$root.$$phase;
        if(phase == '$apply' || phase == '$digest') {
            if(fn && (typeof(fn) === 'function')) {
                fn();
            }
        } else {
            this.$apply(fn);
        }
    };

    function update(){

    }
}

