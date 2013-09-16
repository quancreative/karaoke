#! /usr/bin/python

# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import vlc
import ctypes
from ctypes.util import find_library
# from firebase.firebase import FirebaseApplication
import wx # 2.8
# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

# from firebase import firebase
# import requests
import grequests

from multiprocessing import Process, freeze_support

class Karaoke:
    
    def do_something(self, response):
        print response.status_code

    def __init__(self):
        print('Pyhon version {}.{}.{}' . format(*sys.version_info))
        
#         r = grequests.get('https://karaoke.firebaseio.com/playlist.json')
        result = {}
        def print_res(r):
            result[r.url] = True
            print r
            return r
        
        urls = ['https://karaoke.firebaseio.com/playlist.json']
        
        rs = (grequests.get(u, hooks=dict(response=print_res)) for u in urls)
        grequests.map(rs)
        
        
        
#         firebase = FirebaseApplication('https://karaoke.firebaseio.com',  authentication=None)
#         result = firebase.get_async('playlist', None, callback=self.log_user)
#         print result
        
#         app = wx.App()
#     
#         frame = wx.Frame(None, -1, 'Title simple.py', pos=wx.DefaultPosition, size=(550, 500))
#         frame.Show()
#         
#         ctrlpanel = wx.Panel(frame, -1)
#         pause  = wx.Button(ctrlpanel, label="Pause")
#     
#         quan.testOuter()


#         p = vlc.MediaPlayer('../../../musics/test.VOB')
#         p.play()
#         app.MainLoop()
        
    def log_user(self, response):
        print 'Update: '
        print response
            
    def test(self):
        print('test function')
    
    

if __name__ == "__main__" :
    freeze_support()
    k = Karaoke()