@ECHO OFF
GOTO GetAdmin
:Start

ECHO 1.���s�M�g��L�GCapsLock �אּ �iCtrl�j�FCtrl �אּ�iEsc�j�FEsc �אּ�iCapslock�j
ECHO 2.�٭�
CHOICE /c:12 /m:"��ܥ\��"

IF errorlevel 2 (
    SET Str="Scancode Map"=-
    GOTO Start2
)
IF errorlevel 1 (
    SET Str="Scancode Map"=hex:00,00,00,00,00,00,00,00,04,00,00,00,01,00,1d,00,1d,00,3a,00,3a,00,01,00,00,00,00,00
)
:Start2

(
ECHO Windows Registry Editor Version 5.00
ECHO [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout]
ECHO %Str%
)>%TEMP%\CapsLockToCtrl.reg
regedit /s %TEMP%\CapsLockToCtrl.reg
DEL /Q %TEMP%\CapsLockToCtrl.reg
ECHO.
ECHO �ק粒���A�Э��s�}���C
PAUSE
EXIT


:GetAdmin
:: BatchGotAdmin (Run as Admin code starts)
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:: BatchGotAdmin (Run as Admin code ends)
:: Your codes should start from the following line
GOTO Start