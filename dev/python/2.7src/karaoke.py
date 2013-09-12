#! /usr/bin/python

# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import quan
import vlc
import ctypes
from ctypes.util import find_library
from firebase.firebase import FirebaseApplication
import wx # 2.8
# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  


class Karaoke:
    def __init__(self):
        print('Pyhon version {}.{}.{}' . format(*sys.version_info))
        
        firebase = FirebaseApplication('https://karaoke.firebaseio.com', None)
        result = firebase.get('playlist', None, {'print' : 'pretty'})
        print result
        
        app = wx.App()
#     
        frame = wx.Frame(None, -1, 'Title simple.py', pos=wx.DefaultPosition, size=(550, 500))
        frame.Show()
#         
#         ctrlpanel = wx.Panel(frame, -1)
#         pause  = wx.Button(ctrlpanel, label="Pause")
#     
#         quan.testOuter()


#         p = vlc.MediaPlayer('../../../musics/test.VOB')
#         p.play()
        app.MainLoop()
        
        
    def test(self):
        print('test function')
    
def main():
    k = Karaoke()
    k.test()
    

if __name__ == "__main__" : main()