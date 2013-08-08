var vlc = (function () {

    var me = {
        next : function(){

        }
    }

    function getVLC(id) {
        var vlc = document.getElementById(id);
//    vlc.audio.toggleMute();
        return vlc;
    }

    function registerVLCEvent(event, handler) {
        deb.trace('registerVLCEvent');
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
        deb.trace('unregisterVLCEvent');
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
        deb.trace('handleEvents');
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
        deb.trace('handleMouseGrab');
        if (!event)
            event = window.event; // IE
//    alert("new position (" + X + "," + Y + ")");
    }

    deb.trace(getVLC('vlc'));

    function onVLCOpen(event) {
        deb.trace('onVLCOpen');
    }

    function onVLCError(){
        deb.trace('MediaPlayerEncounteredError');
    }
//registerVLCEvent('MediaPlayerBuffering', handleEvents);
//registerVLCEvent('MediaPlayerPlaying', handleEvents);
//registerVLCEvent('MediaPlayerPaused', handleEvents);
//registerVLCEvent('MediaPlayerForward', handleEvents);
//registerVLCEvent('MediaPlayerBackward', handleEvents);

// Register a bunch of callbacks.
//registerVLCEvent('MediaPlayerNothingSpecial', handleEvents);
    registerVLCEvent('MediaPlayerOpening', onVLCOpen);
    registerVLCEvent('MediaPlayerEncounteredError', onVLCError);
//registerVLCEvent('MediaPlayerEndReached', handleEvents);
//registerVLCEvent('MediaPlayerTimeChanged', handleEvents);
//registerVLCEvent('MediaPlayerPositionChanged', handleEvents);
//registerVLCEvent('MediaPlayerSeekableChanged', handleEvents);
//registerVLCEvent('MediaPlayerPausableChanged', handleEvents);

    return me;
})();
