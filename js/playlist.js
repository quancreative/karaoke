function PlaylistCtrl($scope, $http, $templateCache) {
    var myDataRef = new Firebase('https://karaoke.firebaseio.com/playlist');

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

    $scope.forward = function() {
        // Remove first one on the list.
//        playlist.splice(0,1);
        var id = $scope.playlist[0].id;
        console.log(id);
        myDataRef.child(id).remove();
    }

    $scope.clearPlaylist = function(){
        $scope.playlist = [];
    }
    myDataRef.on('value', function(snapshot) {

        playlist = [];
        $scope.playlist = [];

        snapshot.forEach(function(item){
//            console.log(item.name());
            var id = item.name();
            var songSrc = item.child('src').val();
            $scope.playlist.push({ 'id' : id, 'src' : songSrc});
        });


        // Update angular
        $scope.safeApply(function() {
        });

        vlc.play($scope.playlist[0]);

    });
}

