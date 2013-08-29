#!/usr/bin/python3

# Find module: http://docs.python.org/py3k/library/index.html
# Third party module: http://pypi.python.org/pypi

import sys
import os
import xml.dom.minidom


from os import listdir
from os.path import isfile, join

# http://www.crummy.com/software/BeautifulSoup/
# After downloading the package and cmd to the director with the install script (setup.py), run: ..>\Python33\python setup.py install
# Doc: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
# from bs4 import BeautifulSoup  

def main():
#     print('Pyhon version {}.{}.{}' . format(*sys.version_info))
    
#     print(os.getenv('PATH')) # Get the environment path variable
#     print(os.getcwd())

    relativePath = "../../../musics"
#     rootPath = "C:/xampp/htdocs/workspace/quan/karaoke/musics"
#     rootPath = "G:/xampp/htdocs/workspace/quan/karaoke/musics"

#     files = [ file for file in listdir(path) if isfile(join(path, file))]
    songs = []
    
    # Get all of the files in directory and subdirectory
    for path, subdirs, files in os.walk(relativePath):
        for name in files:
            file = os.path.join(path, name)
            (filepath, filename) = os.path.split(file)
            (shortname, extension) = os.path.splitext(filename)
            if str(extension).lower() in ('.mkv' , '.vob'):
                # Remove full path and clean up
                relativeFile = file.replace(relativePath + "\\", '')
                
                # Relace Microsoft back slash to Unix forward slash
                relativeFile = relativeFile.replace('\\', '/')
                
                #Add to Array
                songs.append('musics/' +relativeFile);
#                 print(relativeFile)
        
    import xml.etree.cElementTree as ET
    
    songXML = '../../../xml/songs.xml'
    
    root = ET.Element("songs")
    root.set("folder", "musics")
    
    for song in songs:
        fileElem = ET.SubElement(root, "file")
#         unencodeFile = BeautifulSoup(file)
#         print(unencodeFile)
        fileElem.text = song
        
    tree = ET.ElementTree(root)
    tree.write(songXML, encoding = "UTF-8", xml_declaration = True)

    # Beautify XML
    songFile = xml.dom.minidom.parse(songXML)
    pretty_xml_as_string = songFile.toprettyxml()
    
    outfile = open(songXML, encoding='utf-8', mode='w+');
    outfile.write(pretty_xml_as_string)
    
    print('! Done !')   
    
def getWebpage():
    import urllib.request
    page = urllib.request.urlopen('http://www.quan-ngo.com/karaoke')
    for line in page: print(str(line, encoding = 'utf_8'), end = '')

if __name__ == "__main__" : main();