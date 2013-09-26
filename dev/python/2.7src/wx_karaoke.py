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
    
    def __init__(self, master=None, Id=wx.ID_ANY, title="Untitled"):
        wx.Frame.__init__(self, None, Id, title, size=(300, 300))
        
        self.master = master
        self.currentSong = {'src' : 'musics/Vietnamese/Ai Lên X? Hoa Ðào - Son Ca.VOB'.decode('utf-8'), 'track' : 2}
        
#         print type('musics/Vietnamese/Ai Lên X? Hoa Ðào - Son Ca.VOB')
#         print type('musics/Vietnamese/Ai Lên X? Hoa Ðào - Son Ca.VOB'.decode('utf-8'))
        # <type 'unicode'>
        
        self.CreateStatusBar() # A Statusbar in the bottom of the window
        
        # Setting up the menu.
        fileMenu = wx.Menu()
        
        menuAbout = fileMenu.Append(wx.ID_ABOUT, "&About", " Information about this program")
        fileMenu.AppendSeparator()
        menuExit = fileMenu.Append(wx.ID_EXIT, "E&xit", " Terminate the program")
        
        # Creating the menubar.
        menuBar = wx.MenuBar()
        menuBar.Append(fileMenu, "&File")
        self.SetMenuBar(menuBar)
        
        # Panels
        # Put everything togheter
        self.videopanel = wx.Panel(self, 1, style=wx.STAY_ON_TOP)
        self.videopanel.SetBackgroundColour(wx.BLACK)
        
        # The second panel holds controls
        ctrlpanel = wx.Panel(self, -1 )
        next  = wx.Button(ctrlpanel, label="Next")
        
        self.instance = vlc.Instance()
        self.player = self.instance.media_player_new()
        
        # finally create the timer, which updates the timeslider
        self.timer = wx.Timer(self)
        
        # Set Events
        self.Bind(wx.EVT_MENU, self.onExit, id=2)
        self.Bind(wx.EVT_BUTTON, self.onNext, next)
        self.Bind(wx.EVT_MENU, self.onAbout, menuAbout)
        self.Bind(wx.EVT_MENU, self.onExit, menuExit)
        self.Bind(wx.EVT_TIMER, self.onTimer, self.timer)
        
        # VLC Events
        self.vlcEvents = self.player.event_manager()
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerEndReached, self.onEndReached)
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerVout, self.onMediaVout)
        
        #Layout sizers
        sizer = wx.BoxSizer(wx.VERTICAL)
        sizer.Add(self.videopanel, 1, flag=wx.EXPAND | wx.TOP)
        sizer.Add(ctrlpanel, flag=wx.EXPAND | wx.BOTTOM)
        self.SetSizer(sizer) # Tells the frame which sizer to use
#         self.SetAutoLayout(1) # Tells the frame to use the sizer to position and size the components.
#         sizer.Fit(self) # Tells the sizer to calculate the initial size and position for all its elements.
        self.SetMinSize((850, 600))
        
        self.Show(True) # Show the frame
        
#         self.ToggleWindowStyle(wx.STAY_ON_TOP)
        
        self.timer.Start()
        
#         normalPath = os.path.normpath('../../../' + str(self.currentSong['src']))
#         self.player.set_media(self.instance.media_new(normalPath))
#         self.player.audio_set_track(self.currentSong['track'])
#         self.player.play()
        
    def onTimer(self, evt):
        
        r = requests.get('https://karaoke.firebaseio.com/playlist.json', verify=False)
        songDict = r.json()

#         print songDict

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
        '''
        '''
                
    def iniVLC(self, sObj):
        self.currentSong = sObj
        
        normalPath = os.path.normpath('../../../' + (self.currentSong['src']).encode('utf-8').strip())
#         songName = os.path.basename(normalPath)
#         self.master.title(str(songName))

        # Init VLC
        self.player.stop()
        
        self.vlcEvents.event_attach(vlc.EventType.MediaPlayerTimeChanged, self.onMediaTimeChanged)
        self.player.set_media(self.instance.media_new(normalPath))
        self.player.play()
    
    def onMediaVout(self, evt):
#         self.master.SetTopWindow(self)
#         self.Show(True) # Show the frame
        print 'onMediaVout'
        # This will error out : main vout display error: Failed to set on top
#         if sys.platform == "linux2": # for Linux using the X Server
#             self.player.set_xwindow(self.videopanel.GetHandle())
#         elif sys.platform == "win32": # for Windows
#             self.player.set_hwnd(self.videopanel.GetHandle())
#         elif sys.platform == "darwin": # for MacOS
#             self.player.set_agl(self.videopanel.GetHandle())
            
#         self.Show(True) # Show the frame
            
    def onMediaTimeChanged(self, evt):
        if self.player.audio_get_track() != int(self.currentSong['track']) :
            self.player.audio_set_track(self.currentSong['track'])
        else :
            self.vlcEvents.event_detach(vlc.EventType.MediaPlayerTimeChanged)
            
    def onEndReached(self, evt):
        self.deleteFistSong()
        
    def deleteFistSong(self):
#         fb = firebase.FirebaseApplication('https://karaoke.firebaseio.com/', None, {'verify' : False})
#         fb.delete('/playlist', self.firstSongOjbKey)
        r = requests.delete('https://karaoke.firebaseio.com/playlist/' + self.firstSongOjbKey + '.json', verify=False)

    def onNext(self, evt):
        self.deleteFistSong()
        
    def onAbout(self, evt):
        # A message dialog box with an OK button. wx.OK is a standard ID in wxWidgets.
        dlg = wx.MessageDialog( self, "An experimental app", "About Karaoke", wx.OK)
        dlg.ShowModal() # Show it
        dlg.Destroy() # finally destroy it when finished.
                
    def onExit(self, evt):
        """Closes the window.
        """
        self.timer.Stop()
        self.Close(True) # Close the frame.
        
    def onOpen(self, evt):
        """ Open a file """
        self.dirName = ''
        dlg = wx.FileDialog(self, "Choose a file", self.dirname, "", "*.*", wx.OPEN)
        if dlg.ShowModal() == wx.ID_OK:
            self.filename = dlg.GetFilename()
            self.dirname = dlg.GetDirectory()
            f = open(os.path.join(self.dirname, self.filename), 'r')
            self.control.SetValue(f.read())
            f.close()
                
def main():
#     app = wx.PySimpleApp()
    app = wx.App(False) # Create a new app, don't redirect stdout/stderr to a window.
    k = Karaoke(app, wx.ID_ANY, "Hello World")
    k.ToggleWindowStyle(wx.FRAME_FLOAT_ON_PARENT)
    k.Show(True)
#     app.SetTopWindow(k)
    app.MainLoop()
                    
if __name__ == "__main__" : main();