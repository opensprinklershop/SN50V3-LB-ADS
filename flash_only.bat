@echo off
rem Flasht die bereits gebaute Firmware (Make_out\DRAGINO-LRWAN-AT.bin) ohne Neubau auf den SN50V3-LB.
rem Aufruf: flash_only.bat [COM-Port]   (Standard: COM6)
setlocal
cd /d "%~dp0"
set PORT=%1
if "%PORT%"=="" set PORT=COM6
set BIN=Projects\Applications\DRAGINO-LRWAN-AT\Make_out\DRAGINO-LRWAN-AT.bin
if not exist "%BIN%" (echo FEHLER: %BIN% nicht gefunden. & pause & exit /b 1)
echo.
echo  1. Schalter auf dem Board auf ISP schieben
echo  2. RESET druecken
echo  3. Alle Programme schliessen, die %PORT% benutzen
echo.
pause
python build\scripts\tremo_loader.py --port %PORT% --baud 115200 flash 0x0800D000 "%BIN%"
if errorlevel 1 (echo. & echo FLASHEN FEHLGESCHLAGEN - ISP-Schalter, RESET und %PORT% pruefen.) else (echo. & echo FERTIG. Schalter zurueck auf FLASH schieben und RESET druecken.)
pause
