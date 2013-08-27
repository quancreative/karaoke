function PlaylistCtrl($scope, $http, $templateCache) {
    var myDataRef = new Firebase('https://karaoke.firebaseio.com/playlist');

    $scope.playlist = [];

    var playlist = [];

    $scope.addSong = function (songSrc) {
        // For some reason AngularJS add $$hash to every push()
//        $scope.playlist.push({src: songSrc});
    }

    $scope.removeSong = function (id)
    {
        myDataRef.child(id).remove();
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

    // TODO: Need to refactor.
    $scope.toggleTrack = function(){
        myDataRef.once('value', function(dataSnapshot) {

            var index = 0;

            dataSnapshot.forEach(function(item){
                if (index === 0)
                {
                    var id = item.name();
                    var track = item.child('track').val() == 2 ? 1 : 2;

                    myDataRef.child(id).update({'track' : track});
                } else {
                    return false;
                }

                index ++;
            });

        });
    }

    $scope.forward = function() {
        // Remove first one on the list.
//        playlist.splice(0,1);
        var id = $scope.playlist[0].id;
//        console.log(id);
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
            var track = item.child('track').val();
            var songObj = songFileHelper.cleanup(songSrc);

            $scope.playlist.push({
                'id' : id,
                'src' : songObj.src,
                'title' : songObj.title,
                'artist' : songObj.artist,
                'track' : track
                });
        });

        // Update angular
        $scope.safeApply(function() {
        });

        // Init
        if (window.vlc != undefined) vlc.play($scope.playlist[0]);
    });
}

