@echo off && SETLOCAL ENABLEDELAYEDEXPANSION
Goto GetAdmin
:Start

::�Ы��٭��I���ɶ����j����
SET timeInterval=60
::���ȦW��
SET taskName=Auto_Create_System_Restore

SET sLin==============================
SET appName=�]�w�}���۰ʳЫبt���٭��I

:ChoiceMenu
TITLE %appName%
ECHO %sLin%
ECHO %appName%
ECHO %sLin%
ECHO.
echo �t���٭��I���A
PowerShell -command "Get-ComputerRestorePoint"
ECHO 1.�]�w�}���۰ʳЫبt���٭��I(�����٭��I�ɶ����j %timeInterval% ����)
ECHO 2.�]�w�i�����٭��I�ɶ����j�j
ECHO 3.�R����ʲK�[���i�����٭�ɶ����j�j�P�i�}���۰ʳЫ��٭��I���ȡj
ECHO.
CHOICE /c:123 /m:"��ܥ\��"

IF errorlevel 3 (
    call :Task03 
)
IF errorlevel 2 (
    call :Task02
)
IF errorlevel 1 (
    call :Task01
)

:Task01
echo.
echo 0.1 �K�[���X�Ѱ��u�@�Ƶ{�����t���٭쪺24�p�ɤ��u��@������C
echo.
FOR /F "tokens=1,2,3,4,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" ^| find /i "SystemRestorePointCreationFrequency"') DO (
    SET CreationFrequency=%%k
    SET /A CreationFrequency=0x!CreationFrequency:~2!
)
if not defined CreationFrequency SET CreationFrequency=None
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t reg_dword /d %timeInterval% /f
IF %CreationFrequency%==None (echo �w�]�w�إߨt���٭��I���j�ɶ���� %timeInterval% ����) else (echo ����إߨt���٭��I���j�ɶ���� %CreationFrequency% �����A�w�קאּ %timeInterval% ����)
echo.

echo 0.2 �}�Ҩt�ΫO�@ C:\�C
echo.
PowerShell -command "&Enable-ComputerRestore -Drive 'C:\' "
IF ERRORLEVEL 1 goto check_fail

echo 0.3 �s�رƵ{�C
echo.
SCHTASKS /Create /RL HIGHEST /RU SYSTEM /SC ONSTART /TN %taskName% /TR "powershell -ExecutionPolicy Bypass -Command Checkpoint-Computer -Description 'Restore_Point_Startup' -RestorePointType 'MODIFY_SETTINGS'
echo.
echo �}���۰ʫإ��٭��I�w�]�w�����A�Ы����N��h�X && pause >nul && exit

:Task02
ECHO.
ECHO �]�w�����٭��I�ɶ����j
ECHO �]�w�L�u�i��y���L���л\���ª��٭��I�A�t�ιw�]���j24�p�ɡA���}���w�] 60 �����C
SET /P timeInterval=�����G
cls
GOTO ChoiceMenu

:Task03
ECHO.
ECHO �R����ʲK�[���i�����٭�ɶ����j�j���X
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /f
echo.
schtasks /Delete /F /TN %taskName%
echo.
echo �w�]�w�����A�Ы����N��h�X && pause >nul && exit

::-------------------------------------------
:GetAdmin
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

goto Start