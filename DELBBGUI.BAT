:: DELBBGUI.BAT
:: Remove BackBlaze icon from Registry and force quit from System Tray
::
::
@ECHO OFF

CLS
ECHO Deleting BackBlaze icon from Registry
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v Backblaze /f

ECHO Force quit the BackBlaze icon from system tray
taskkill /F /IM bzbui.exe

:END
ECHO.
ECHO Press SPACE to exit
PAUSE

:End of DELBBGUI.BAT