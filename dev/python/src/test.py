#!/usr/bin/python3

# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import xml.dom.minidom

from tkinter import *
from os import listdir
from os.path import isfile, join
from tkinter.tix import Tk

# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

def main():
    print('hello world')
    print('<h1>Hello World</h1>')
#     print('Pyhon version {}.{}.{}' . format(*sys.version_info))
    mGui = Tk()
    mGui.geometry("450x450")
    mGui.title('My Karaoke')
    mGui.mainloop() # Only for Windows user for now

if __name__ == "__main__" : main();