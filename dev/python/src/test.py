#!/usr/bin/python3

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
# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

class Karaoke():
          
    def __init__(self):
        
    #     print('Pyhon version {}.{}.{}' . format(*sys.version_info))
    
        r = requests.get('https://karaoke.firebaseio.com/playlist.json')

        
        songDict = r.json()
        # This method doesn't work but it's cool. Might needed later on
    #     OrderedDict(sorted(songDict.items(), key=lambda x: x[0]))
        
        # Sort the list
        listSorted = sorted(songDict.keys())
        # Get the first song hash
        firstSongOjbKey = listSorted[0]
        # Get the first song data
        songObj = songDict[firstSongOjbKey]
        
        songSrc = songObj['src']
        songTrack = songObj['track']
        
        print(songSrc) 
        
    #     for key, value in songDict.items():
    #         print('')
    #         print(value['track'])
    #         print(value['src'])
        
    #     python_dict = json.loads(r.text)
        
        qFb = quanfirebase.Firebase('https://karaoke.firebaseio.com')
    #     p = qFb.get()
    
    #     fb = firebase.FirebaseApplication('https://karaoke.firebaseio.com', None)
    #     fb.get_async('/playlist', None, 'print=pretty', logPlaylist)
        
        mikeFb = fb.Firebase('https://karaoke.firebaseio.com')
        playlist = mikeFb.child('/playlist')
        
    #     json.dump(result)
    #     print(json.dump('\\'))
        
        # Init GUI
        self.gui = Tk()
        self.gui.geometry("450x450")
        self.gui.title(songSrc + ' Track : ' + str(songTrack))
        
        guiContainer = Frame(self.gui)
        guiContainer.pack()
        
#         self.mediaListPlayer = vlc.MediaL
        
        # Init VLC
        self.player = vlc.MediaPlayer('../../../' + songSrc)
        
#         if sys.platform == "linux2": # for Linux using the X Server
#             self.player.set_xwindow(guiContainer.winfo_id())
#         elif sys.platform == "win32": # for Windows
#             self.player.set_hwnd(guiContainer.winfo_id())
#         elif sys.platform == "darwin": # for MacOS
#             self.player.set_agl(guiContainer.winfo_id())
#         
        self.vlcEvents = self.player.event_manager()
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerEndReached, self.onEndReached)
#         self.player.set_media('../../../' + songSrc)
        self.player.play()
        print(self.player.audio_get_track())
        
        slider = Scale(self.gui,orient=HORIZONTAL,length=300,width=20,sliderlength=10,from_=0,to=1000,tickinterval=100)
        slider.pack()

        nextBtn = Button(guiContainer)
        nextBtn['text'] = "Next"
        nextBtn.bind("<Button-1>", self.onNextClick)
        nextBtn.pack()
        
        toggleTrackBtn = Button(guiContainer, text="Toggle Track", command=self.onToggleTrackBtnClick)
        toggleTrackBtn.pack()
        
        # Windows only thing    
        self.gui.mainloop() # Only for Windows user for now
        
    
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

#     def logPlaylist(self, response):
#         print('called logPlaylist')
#         print(response)
        
def main():
    k = Karaoke()                
if __name__ == "__main__" : main();