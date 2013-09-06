#! /usr/bin/python


import os
import sys

__version__ = "0.1"

class cool():
    print('cool')

    def testInner(self):
        print('test inner')
    
def testOuter():
    print('test outer')
    
if __name__ == "__main__" : cool();