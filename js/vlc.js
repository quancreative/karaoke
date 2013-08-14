var vlc = (function () {

    var playlistScope = {};
    var playlistCtrl;

    var scope = {};

    var currentSongSrc;

    scope.play = function(songObj){

        if (playlistCtrl == null){
            //playlistCtrl = new PlaylistCtrl(playlistScope);
        }

        var originSongSrc = songObj.src;

        // Don't play if it's same song.
        if (currentSongSrc == originSongSrc)
        {
            return false;
        } else
        {
            currentSongSrc = originSongSrc;
        }

        var replaced = originSongSrc.replace(/ /g, '%20');
        createVLC('musics/' + replaced);
    }

    function getVLC(id) {
        var vlc = document.getElementById(id);
//    vlc.audio.toggleMute();
        return vlc;
    }

    function registerVLCEvent(event, handler) {
        var vlc = getVLC("vlc");
        if (vlc) {
            if (vlc.attachEvent) {
                // Microsoft
                vlc.attachEvent(event, handler);
            } else if (vlc.addEventListener) {
                // Mozilla: DOM level 2
                vlc.addEventListener(event, handler, false);
            } else {
                // DOM level 0
                vlc["on" + event] = handler;
            }
        }
    }

    // stop listening to event
    function unregisterVLCEvent(event, handler) {
        var vlc = getVLC("vlc");
        if (vlc) {
            if (vlc.detachEvent) {
                // Microsoft
                vlc.detachEvent(event, handler);
            } else if (vlc.removeEventListener) {
                // Mozilla: DOM level 2
                vlc.removeEventListener(event, handler, false);
            } else {
                // DOM level 0
                vlc["on" + event] = null;
            }
        }
    }

    // event callback function for testing
    function handleEvents(event) {
        if (!event)
            event = window.event; // IE

        if (event.target) {
            // Netscape based browser
            targ = event.target;
        } else if (event.srcElement) {
            // ActiveX
            targ = event.srcElement;
        } else {
            // No event object, just the value
//        alert("Event value" + event);
            return;
        }

        if (targ.nodeType == 3) // defeat Safari bug
            targ = targ.parentNode;
//    alert("Event " + event.type + " has fired from " + targ);
    }

// handle mouse grab event from video filter
    function handleMouseGrab(event, X, Y) {

        if (!event)
            event = window.event; // IE
//    alert("new position (" + X + "," + Y + ")");
    }

    function onVLCOpen(event) {
        console.log('onVLCOpen');
    }

    function onVLCError() {
        console.log('VLC has encountered an error!');
    }

    function onSongEnd() {
        console.log('Song Ended');
        angular.element(document.getElementById('playlist-content')).scope().forward();
    }

    function createVLC(songSrc) {
        console.log('createVLC, params : ' + songSrc);
        var html = '<embed type="application/x-vlc-plugin" pluginspage="http://www.videolan.org" ';
        html += 'id="vlc" width="100%" height="300px" target="' + songSrc + '"></embed>';
        html += '<object classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codebase="http://download.videolan.org/pub/videolan/vlc/last/win32/axvlc.cab"></object>'

        $('#vlc-content').empty();
        $('#vlc-content').html(html).ready(function () {
            console.log('VLC HTML is ready!');


            var vlc = getVLC("vlc");
//            vlc.audio.track = 'Track 2';
            console.log('isPlaying : ' + vlc.playlist.isPlaying);
            console.log('audio count : ' + vlc.audio.count);
            console.log('track : ' + vlc.audio.track);
            console.log('channel : ' + vlc.audio.channel);
            console.log('mute : ' + vlc.audio.mute);
            console.log('volume : ' + vlc.audio.volume);
            console.log('trackNumber : ' + vlc.mediaDescription.trackNumber);

            var audio = vlc.audio;

            console.log(vlc.mediaDescription.trackNumber);

//            for (var key in audio) {
//
//                alert("Key " + audio[key] + " is #" + key);
//
////                if (audio.hasOwnProperty(key)) {
////
////                }
//            }

            registerVLCEvents();
        });
    }

    function onPlyaerTimeChanged(event){
        var vlc = getVLC("vlc");
//            vlc.audio.track = 'Track 2';
        console.log('isPlaying : ' + vlc.playlist.isPlaying);
        console.log('audio count : ' + vlc.audio.count);
        console.log('track : ' + vlc.audio.track);
        console.log('channel : ' + vlc.audio.channel);
        console.log('mute : ' + vlc.audio.mute);
        console.log('volume : ' + vlc.audio.volume);
        console.log('trackNumber : ' + vlc.mediaDescription.trackNumber);



    }

    function registerVLCEvents() {
        //registerVLCEvent('MediaPlayerPaused', handleEvents);
        //registerVLCEvent('MediaPlayerForward', handleEvents);
        //registerVLCEvent('MediaPlayerBackward', handleEvents);

        // Register a bunch of callbacks.
        //registerVLCEvent('MediaPlayerNothingSpecial', handleEvents);
        registerVLCEvent('MediaPlayerOpening', onVLCOpen);
        registerVLCEvent('MediaPlayerEncounteredError', onVLCError);
        registerVLCEvent('MediaPlayerEndReached', onSongEnd);
        //registerVLCEvent('MediaPlayerBuffering', handleEvents);
//        registerVLCEvent('MediaPlayerPlaying', onPlaying);
        registerVLCEvent('MediaPlayerTimeChanged', onPlyaerTimeChanged);
        //registerVLCEvent('MediaPlayerPositionChanged', handleEvents);
        //registerVLCEvent('MediaPlayerSeekableChanged', handleEvents);
        //registerVLCEvent('MediaPlayerPausableChanged', handleEvents);
    }

    return scope;
})();
