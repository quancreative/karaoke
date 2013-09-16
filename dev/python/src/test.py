#!/usr/bin/python3
# -*- coding: utf-8 -*-

# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import xml.dom.minidom
import vlc
import json

from tkinter import *
from os import listdir
from os.path import isfile, join
from tkinter.tix import Tk
import requests

import fb;
import operator

# from firebase import firebase
# from firebase import firebase
import quanfirebase
from collections import OrderedDict
from threading import Timer

# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

class Karaoke():
    
    def __init__(self):
        # Placeholder
#         self.currentSong = {'src' : 'musics/Vietnamese/Tre Productions - Nguoi Ay Va Toi Em Phai Cho Ai/Anh Co Quen Em - Cam Ly and VQL.vob', 'track' : 2}
        self.currentSong = {'src' : 'musics/Vietnamese/Ai Lên Xứ Hoa Đào - Sơn Ca.VOB', 'track' : 2}
        
        # Init GUI
        self.gui = Tk()
        self.gui.protocol("WM_DELETE_WINDOW", self.onDeleteWindow)
        self.gui.geometry("450x450")
        self.gui.title(self.currentSong['src'] + ' Track : ' + str(self.currentSong['track']))
        
        self.guiContainer = Frame(self.gui)
        self.guiContainer.pack()
        
        self.instance = vlc.Instance()
        self.player = self.instance.media_player_new()
        self.vlcEvents = self.player.event_manager()
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerEndReached, self.onEndReached)
#         self.player.set_media(self.instance.media_new('../../../' + self.currentSong['src']))
#         self.player.play()
        
        slider = Scale(self.gui,orient=HORIZONTAL,length=300,width=20,sliderlength=10,from_=0,to=1000,tickinterval=100)
        slider.pack()

        nextBtn = Button(self.guiContainer)
        nextBtn['text'] = "Next"
        nextBtn.bind("<Button-1>", self.onNextClick)
        nextBtn.pack()
        
        toggleTrackBtn = Button(self.guiContainer, text="Toggle Track", command=self.onToggleTrackBtnClick)
        toggleTrackBtn.pack()
        
        self.setencoding()
    #     print('Pyhon version {}.{}.{}' . format(*sys.version_info))
        def setInterval(func, sec):
            def funcWrapper():
                setInterval(func, sec)
                func()
            self.timer = Timer(sec, funcWrapper)
            self.timer.start()
            return self.timer
            
#         self.timer = setInterval(self.get_playlist, 2)
        
        self.iniVLC(self.currentSong)
        
        # Windows only thing    
        self.gui.mainloop() # Only for Windows user for now
        
    #     for key, value in songDict.items():
    #         print('')
    #         print(value['track'])
    #         print(value['src'])
        
    #     python_dict = json.loads(r.text)
        
#         qFb = quanfirebase.Firebase('https://karaoke.firebaseio.com')
    #     p = qFb.get()
    
    #     fb = firebase.FirebaseApplication('https://karaoke.firebaseio.com', None)
    #     fb.get_async('/playlist', None, 'print=pretty', logPlaylist)
        
#         mikeFb = fb.Firebase('https://karaoke.firebaseio.com')
#         playlist = mikeFb.child('/playlist')
        
    #     json.dump(result)
    #     print(json.dump('\\'))
        
    def get_playlist(self):
#         print('Running')
        r = requests.get('https://karaoke.firebaseio.com/playlist.json')
        songDict = r.json()
        # Sort the list
        listSorted = sorted(songDict.keys())
        # Get the first song hash
        firstSongOjbKey = listSorted[0]
        # Get the first song data
        songObj = songDict[firstSongOjbKey]
        
        if songObj['src'] != self.currentSong['src'] :
            # Play new song
            self.iniVLC(songObj)
        else :
            if songObj['track'] != self.currentSong['track'] :
                self.currentSong['track'] = songObj['track'] 
                self.player.audio_set_track(songObj['track'])
        
        return self.currentSong
    
    def iniVLC(self, sObj):
        self.currentSong = sObj
        
#         self.mediaListPlayer = vlc.MediaL
        
        # Init VLC
        print('type' , type(self.currentSong['src']))
        
        self.player.stop()
#         self.player.set_media(self.instance.media_new('../../../' + self.currentSong['src']))
        path = os.path.join('../../../', self.currentSong['src'])
        print('path : ' + path)
        self.player.set_media(self.instance.media_new(path))
        self.player.play()
        
#         if sys.platform == "linux2": # for Linux using the X Server
#             self.player.set_xwindow(guiContainer.winfo_id())
#         elif sys.platform == "win32": # for Windows
#             self.player.set_hwnd(guiContainer.winfo_id())
#         elif sys.platform == "darwin": # for MacOS
#             self.player.set_agl(guiContainer.winfo_id())
#         
        
    def onToggleTrackBtnClick(self):
        audioTrack = self.player.audio_get_track()
        trackNum = 1 if int(audioTrack) == 2 else 2
        self.player.audio_set_track(trackNum)
        print('onToggleTrackBtn click')
            
    def onNextClick(self, event):
        self.gui.destroy()
            
    def onEndReached(self, evt):
        print(evt)
            
    def onPlay(self, evt):
        print('onPlay')
        
    def onDeleteWindow(self):
        print('exit')
        self.gui.destroy()
        self.timer.cancel()
#         os.abort()
        sys.exit()
        
    def setencoding(self):
        """Set the string encoding used by the Unicode implementation.  The
        default is 'ascii', but if you're willing to experiment, you can
        change this."""
        encoding = "ascii" # Default value set by _PyUnicode_Init()
        if 0:
            # Enable to support locale aware default string encodings.
            import locale
            loc = locale.getdefaultlocale ()
            if loc[1]:
                encoding = loc[1]
            
        if 0:
            # Enable to switch off string to Unicode coercion and implicit
            # Unicode to string conversion.
            encoding = "undefined"
        if encoding != "ascii":
            # On Non-Unicode builds this will raise an AttributeError...
            sys.setdefaultencoding (encoding) # Needs Python Unicode

#     def logPlaylist(self, response):
#         print('called logPlaylist')
#         print(response)
                
def main():
    k = Karaoke()                
if __name__ == "__main__" : main();