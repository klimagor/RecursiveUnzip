@echo off
setlocal

REM Get the full path of the folder this script is in
set "SCRIPT_DIR=%~dp0"
set "PS1_PATH=%SCRIPT_DIR%recursive-unzip.ps1"

REM Escape backslashes and quotes for registry format
set "PS1_PATH_ESC=%PS1_PATH:\=\\%"
set "PS1_PATH_ESC=%PS1_PATH_ESC:"=\"%"

REM Create a temporary .reg file
set "REGFILE=%TEMP%\recursive-unzip.reg"

> "%REGFILE%" echo Windows Registry Editor Version 5.00
>> "%REGFILE%" echo.
>> "%REGFILE%" echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.zip\shell\RecursiveUnzip]
>> "%REGFILE%" echo @="Extract All Recursively"
>> "%REGFILE%" echo.
>> "%REGFILE%" echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.zip\shell\RecursiveUnzip\command]
>> "%REGFILE%" echo @="powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"%PS1_PATH_ESC%\" \"%%1\""

REM Apply the registry file
regedit /s "%REGFILE%"

echo.
echo Context menu added pointing to:
echo   %PS1_PATH%
echo.
pause
