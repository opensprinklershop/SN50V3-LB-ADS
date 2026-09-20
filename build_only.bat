@echo off
rem Baut die Firmware neu (ohne zu flashen). Danach flash_only.bat ausfuehren.
rem Benoetigt: Git Bash, mingw32-make im PATH, Toolchain unter tools\toolchain (wie flash_firmware.ps1).
setlocal
cd /d "%~dp0"
set GITBASH=C:\Program Files\Git\bin\bash.exe
set BIN=Projects\Applications\DRAGINO-LRWAN-AT\Make_out\DRAGINO-LRWAN-AT.bin
if not exist "%GITBASH%" (echo FEHLER: Git Bash nicht gefunden: %GITBASH% & pause & exit /b 1)
if not exist "tools\toolchain\bin\arm-none-eabi-gcc.exe" (echo FEHLER: Toolchain fehlt - einmal flash_firmware.ps1 ausfuehren. & pause & exit /b 1)

echo === Baue Firmware ===
"%GITBASH%" -c "export TREMO_SDK_PATH=$(pwd); export PATH=$TREMO_SDK_PATH/tools/toolchain/bin:$PATH; cd Projects/Applications/DRAGINO-LRWAN-AT && mingw32-make.exe clean; mingw32-make.exe"
if errorlevel 1 (echo. & echo BUILD FEHLGESCHLAGEN - Fehlermeldungen oben pruefen. & pause & exit /b 1)
if not exist "%BIN%" (echo. & echo BUILD FEHLGESCHLAGEN - %BIN% wurde nicht erzeugt. & pause & exit /b 1)

rem Sicherheitscheck: Firmware ab 0x0800D000 darf den Key-Sektor 0x0803E000 nicht erreichen (max. 200704 Bytes)
for %%A in ("%BIN%") do set SIZE=%%~zA
echo.
echo Binary: %BIN%  (%SIZE% Bytes, erlaubt ^< 200704)
if %SIZE% GEQ 200704 (echo FEHLER: Firmware zu gross - NICHT flashen! & pause & exit /b 1)

findstr /m /c:"SMT50" "%BIN%" >nul
if errorlevel 1 (echo WARNUNG: AT+SMT50 ist im Binary nicht enthalten.) else (echo OK: AT+SMT50 ist im Binary enthalten.)
echo.
echo FERTIG. Jetzt flash_only.bat [COM-Port] ausfuehren.
pause
