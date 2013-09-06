#! /usr/bin/python

# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import quan
import vlc
import ctypes
from ctypes.util import find_library

import wx # 2.8
# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

def main():
    print('hello world')
    print('<h1>Hello World</h1>')
    print('Pyhon version {}.{}.{}' . format(*sys.version_info))
    app = wx.App()

    frame = wx.Frame(None, -1, 'Title simple.py', pos=wx.DefaultPosition, size=(550, 500))
    frame.Show()
    
    ctrlpanel = wx.Panel(frame, -1 )
    pause  = wx.Button(ctrlpanel, label="Pause")

    
    quan.testOuter()
    p = vlc.MediaPlayer('../../../musics/test.VOB')
    p.play()
    app.MainLoop()
    


if __name__ == "__main__" : main();