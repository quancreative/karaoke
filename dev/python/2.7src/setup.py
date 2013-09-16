#!/usr/bin/python

from cx_Freeze import setup, Executable

setup(
      name = "karaoke",
      version = "0.1",
      description = "test",
      executables = [Executable("test.py")],
      )