#!/usr/bin/python
# -*- coding: utf-8 -*-
# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import os
import vlc

import requests

from Tkinter import *

# from firebase import firebase
from firebase import firebase
from threading import Timer

# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

class Karaoke(Frame):
    
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.pack(fill=BOTH, expand=1)
        self.master.protocol("WM_DELETE_WINDOW", self.onDeleteWindow)
#         self.pack()

        # Placeholder
        self.currentSong = {'src' : 'musics/Vietnamese/Ai Lên Xứ Hoa Đào - Sơn Ca.VOB', 'track' : 2}
#         self.currentSong = {'src' : 'musics/Vietnamese/60 Năm Cuộc Đời - Christiane Le.VOB', 'track' : 2}
                                     
        # Init GUI
#         self.nextBtn = Button(self)
#         self.nextBtn['text'] = "Next"
#         self.nextBtn['command'] = self.onNextClick
#         self.nextBtn.pack({'side' : 'left'})\
        
        self.instance = vlc.Instance()
        self.player = self.instance.media_player_new()
        
        if sys.platform == "linux2": # for Linux using the X Server
            self.player.set_xwindow(self.winfo_id())
        elif sys.platform == "win32": # for Windows
            self.player.set_hwnd(self.winfo_id())
        elif sys.platform == "darwin": # for MacOS
            self.player.set_agl(self.winfo_id())

        # VLC Events
        self.vlcEvents = self.player.event_manager()
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerEndReached, self.onEndReached)
        
        self.resizeWindow()
#         
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
        
    def get_playlist(self):
#         print('Running')
        r = requests.get('https://karaoke.firebaseio.com/playlist.json')
        songDict = r.json()
        # Sort the list
        listSorted = sorted(songDict.keys())
        # Get the first song hash
        self.firstSongOjbKey = listSorted[0]
        # Get the first song data
        songObj = songDict[self.firstSongOjbKey]
        
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
        
        normalPath = os.path.normpath('../../../' + str(self.currentSong['src']))
#         songName = os.path.basename(normalPath)
#         self.master.title(str(songName))
                
        # Init VLC
        self.player.stop()
        self.player.set_media(self.instance.media_new(normalPath))
        self.player.audio_set_track(self.currentSong['track'])
        self.player.play()
        
    def resizeWindow(self):
        width = 1920
        height = 1080
        
        screenWidth = self.master.winfo_screenwidth()
        screenHeight = self.master.winfo_screenheight()
        
        self.master.geometry('%dx%d+%d+%d' % (width, height, 0, 0))
        
    def onToggleTrackBtnClick(self):
        audioTrack = self.player.audio_get_track()
        trackNum = 1 if int(audioTrack) == 2 else 2
        self.player.audio_set_track(trackNum)
        print('onToggleTrackBtn click')
            
    def onNextClick(self):
        self.deleteFistSong()
            
    def onEndReached(self, evt):
        self.deleteFistSong()
        print(evt)
        
    def deleteFistSong(self):
        fb = firebase.FirebaseApplication('https://karaoke.firebaseio.com/', None)
        fb.delete('/playlist', self.firstSongOjbKey)
        
    def onPlay(self, evt):
        print('onPlay')
        
    def onDeleteWindow(self):
        self.timer.cancel()
        self.player.stop()
        self.quit()
#         self.destroy()
#         os.abort()
#         sys.exit()
        
                
def main():
    root = Tk()
    root.geometry("250x150")
    k = Karaoke(master = root)
    k.mainloop()
    root.destroy()
                    
if __name__ == "__main__" : main();