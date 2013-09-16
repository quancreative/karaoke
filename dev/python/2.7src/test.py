#!/usr/bin/python3
# -*- coding: utf-8 -*-
# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import xml.dom.minidom
import vlc
import json

from os import listdir
from os.path import isfile, join
import requests

import operator
import wx # 2.8
from Tkinter import *

# from firebase import firebase
# from firebase import firebase
from collections import OrderedDict
from threading import Timer

# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

class Karaoke(Frame):
    
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack()
        # Placeholder
        self.currentSong = {'src' : 'musics/Vietnamese/Ai Lên Xứ Hoa Đào - Sơn Ca.VOB', 'track' : 2}
        
        # Init GUI
#         app = wx.App()
#         frame = wx.Frame(None, -1, 'Title simple.py', pos=wx.DefaultPosition, size=(550, 500))
#         frame.Show()
#         ctrlpanel = wx.Panel(frame, -1)
#         pause  = wx.Button(ctrlpanel, label="Pause")
        
        self.instance = vlc.Instance()
        self.player = self.instance.media_player_new()
        self.vlcEvents = self.player.event_manager()
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerEndReached, self.onEndReached)
        
        def setInterval(func, sec):
            def funcWrapper():
                setInterval(func, sec)
                func()
            self.timer = Timer(sec, funcWrapper)
            self.timer.start()
            return self.timer
            
        self.timer = setInterval(self.get_playlist, 2)

#         self.iniVLC(self.currentSong)

#         p = vlc.MediaPlayer('../../../musics/Vietnamese/Ai Lên Xứ Hoa Đào - Sơn Ca.VOB')
#         p.play()
#         app.MainLoop()
        
        # Init GUI
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
        print('Init ' + self.currentSong['src'])
        
        normalPath = os.path.normpath('../../../' + self.currentSong['src'])
        print normalPath
        self.player.stop()
        self.player.set_media(self.instance.media_new(normalPath))
        self.player.play()
        
#         path = os.path.join('../../../', self.currentSong['src'])
#         print('path : ' + path)
#         self.player.set_media(self.instance.media_new(path))
        
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
#         self.gui.destroy()
        self.timer.cancel()
#         os.abort()
        sys.exit()
        
                
def main():
    root = Tk()
    k = Karaoke(master = root)
    k.mainloop()
                    
if __name__ == "__main__" : main();