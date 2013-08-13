function SongCtrl($scope, $http, $templateCache) {

//    var playlistScope = {}, playlist = new PlaylistCtrl(playlistScope);
    var myDataRef = new Firebase('https://karaoke.firebaseio.com/playlist');
    $scope.songs = [
        {
            src: 'Người Đến Từ Triều Châu - Quang Linh.VOB'
        },
        {
            src: "Xin Còn Gọi Tên Nhau - Ngọc Lan_NDBD3.mkv"
        },
        {
            src: 'D - Side Invisible.mp3'
        }
    ];

    var test = [
        {
            src: 'Người Đến Từ Triều Châu - Quang Linh.VOB'
        },
        {
            src: "Xin Còn Gọi Tên Nhau - Ngọc Lan_NDBD3.mkv"
        },
        {
            src: 'D - Side Invisible.mp3'
        }
    ];

    $scope.addSong = function (songSrc) {
        myDataRef.push({'src' : songSrc});
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

