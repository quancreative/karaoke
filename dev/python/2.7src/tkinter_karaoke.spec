# -*- mode: python -*-
a = Analysis(['tkinter_karaoke.py'],
             pathex=['C:\\xampp\\htdocs\\workspace\\quan\\karaoke\\dev\\python\\2.7src'],
             hiddenimports=[],
             hookspath=None,
             runtime_hooks=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name='tkinter_karaoke.exe',
          debug=False,
          strip=None,
          upx=True,
          console=True )
