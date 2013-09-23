#!/usr/bin/python
# -*- coding: utf-8 -*-
# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import os
import vlc
import sys

import requests
import wx # 2.8

# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

class Karaoke(wx.Frame):
    
    def __init__(self, master=None):
        wx.Frame.__init__(self, None, pos=wx.DefaultPosition, size=(300, 300))
        
        self.currentSong = {'src' : 'musics/Vietnamese/Ai Lên Xứ Hoa Đào - Sơn Ca.VOB', 'track' : 2}
        
        self.Bind(wx.EVT_MENU, self.onExit, id=2)
        
        # Panels
        # Put everything togheter
        self.videopanel = wx.Panel(self, 1, style=wx.STAY_ON_TOP)
        self.videopanel.SetBackgroundColour(wx.BLACK)
        
        # The second panel holds controls
        ctrlpanel = wx.Panel(self, -1 )
        next  = wx.Button(ctrlpanel, label="Next")
        
        self.Bind(wx.EVT_BUTTON, self.onNext, next)
        
        sizer = wx.BoxSizer(wx.VERTICAL)
        sizer.Add(self.videopanel, 1, flag=wx.EXPAND | wx.TOP)
        sizer.Add(ctrlpanel, flag=wx.EXPAND | wx.BOTTOM)
        self.SetSizer(sizer)
        self.SetMinSize((350, 300))
        
        self.instance = vlc.Instance()
        self.player = self.instance.media_player_new()
        
        
        # VLC Events
        self.vlcEvents = self.player.event_manager()
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerEndReached, self.onEndReached)
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerVout, self.onMediaVout)
        
#         self.ToggleWindowStyle(wx.STAY_ON_TOP)
        
        # finally create the timer, which updates the timeslider
        self.timer = wx.Timer(self)
        self.Bind(wx.EVT_TIMER, self.onTimer, self.timer)
        self.timer.Start()
        
#         normalPath = os.path.normpath('../../../' + str(self.currentSong['src']))
#         self.player.set_media(self.instance.media_new(normalPath))
#         self.player.audio_set_track(self.currentSong['track'])
#         self.player.play()
        
    def onTimer(self, evt):
        
#         import json
#         fb = firebase.FirebaseApplication('https://karaoke.firebaseio.com', None)
#         result = fb.get('/playlist', None)
#         from json import JSONEncoder
#         songDict = json.dumps(result, cls=JSONEncoder)
        
        r = requests.get('https://karaoke.firebaseio.com/playlist.json', verify=False)
        songDict = r.json()

#         print songDict

        # Sort the list
        listSorted = sorted(songDict.keys())
        # Get the first song hash
        self.firstSongOjbKey = listSorted[0]
        # Get the first song data
        songObj = songDict[self.firstSongOjbKey]
        
#         unicodeSongObjSrc = songObj['src']
#         unicodeCurrentSongSrc = unicode(self.currentSong['src']) 
        
        if songObj['src'] != self.currentSong['src'] :
            # Play new song
            self.iniVLC(songObj)
        else :
            if songObj['track'] != self.currentSong['track'] :
                self.currentSong['track'] = songObj['track'] 
                self.player.audio_set_track(songObj['track'])
                
    def iniVLC(self, sObj):
        self.currentSong = sObj
        
        normalPath = os.path.normpath('../../../' + str(self.currentSong['src']))
#         songName = os.path.basename(normalPath)
#         self.master.title(str(songName))

        # Init VLC
        self.player.stop()
        
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerTimeChanged, self.onMediaTimeChanged)
        self.player.set_media(self.instance.media_new(normalPath))
        self.player.play()
    
    def onMediaVout(self, evt):
        if sys.platform == "linux2": # for Linux using the X Server
            self.player.set_xwindow(self.videopanel.GetHandle())
        elif sys.platform == "win32": # for Windows
            self.player.set_hwnd(self.videopanel.GetHandle())
        elif sys.platform == "darwin": # for MacOS
            self.player.set_agl(self.videopanel.GetHandle())
            
    def onMediaTimeChanged(self, evt):
        if self.player.audio_get_track() != int(self.currentSong['track']) :
            self.player.audio_set_track(self.currentSong['track'])
        else :
            self.vlcEvents.event_detach(vlc.EventType.MediaPlayerTimeChanged)
            
    def onEndReached(self, evt):
        self.deleteFistSong()
        print(evt)
        
    def deleteFistSong(self):
#         fb = firebase.FirebaseApplication('https://karaoke.firebaseio.com/', None, {'verify' : False})
#         fb.delete('/playlist', self.firstSongOjbKey)
        r = requests.delete('https://karaoke.firebaseio.com/playlist/' + self.firstSongOjbKey + '.json', verify=False)

    def onNext(self, evt):
        self.deleteFistSong()
                
    def onExit(self, evt):
        """Closes the window.
        """
        self.timer.Stop()
        self.Close()
                
def main():
    app = wx.PySimpleApp()
    k = Karaoke()
    k.Centre()
    k.Show()
    k.ToggleWindowStyle(wx.FRAME_FLOAT_ON_PARENT)
    app.MainLoop()
                    
if __name__ == "__main__" : main();