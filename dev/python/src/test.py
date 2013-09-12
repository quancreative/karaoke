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
  
def logPlaylist(response):
    print('called logPlaylist')
    print(response)
    
def main():
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
    
#     mGui = Tk()
#     mGui.geometry("450x450")
#     mGui.title('My Karaoke')
    
#     p = vlc.MediaPlayer('../../../musics/test.VOB')
#     p.play()    
#     mGui.mainloop() # Only for Windows user for now

    
if __name__ == "__main__" : main();