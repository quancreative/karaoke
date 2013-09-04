#!/usr/bin/python3

from cx_Freeze import setup, Executable

setup(
      name = "karaoke",
      version = "0.1",
      description = "test",
      executables = [Executable("test.py")],
      )