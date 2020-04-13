@ECHO off && SETLOCAL ENABLEDELAYEDEXPANSION 
:: �]�w�ƥ��ؼи�Ƨ�
SET BackOutputDir=D:\Backup

:: �]�w�ƥ����ظ��|
:: �W��,���|,�O�_�ư�catch
SET Dir[1]=FF,%APPDATA%\Mozilla\Firefox\Profiles\
SET Dir[2]=GC,%LOCALAPPDATA%\Google\Chrome\User Data\,1
SET Dir[3]=Vivaldi,%LOCALAPPDATA%\Vivaldi\User Data\,1
SET Dir[4]=Startup,%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\
SET Dir[5]=SshKey,%HomePath%\.ssh\
SET Dir[6]=RL2,%HomePath%\.rainlendar2\
SET Dir[7]=Vscode1,%USERPROFILE%\.vscode\extensions\
SET Dir[8]=Vscode2,%APPDATA%\Code\User\
SET Dir[9]=Intel,C:\Intel\
 
:: 7zip���|
SET UnzipPath=C:\Program Files\7-Zip

:: �ƥ�wsl�W��
SET WslName=kali-linux

GOTO GetAdmin
:Start
:: ~~~~~~~~~~~~~~~~~~~~~~~~ ��ܶ}�l ~~~~~~~~~~~~~~~~~~~~~~~
TITLE �ƥ��P�٭�۩w���|
IF not defined BackOutputDir SET BackOutputDir=.
IF not exist "%UnzipPath%\7z.exe" ECHO �ФU���æw��7z�íק�}���������| https://www.developershome.com/7-zip/ && PAUSE && EXIT


ECHO �`�G�ƥ��ɲ��ͪ�log�ɬ��٭�ɥ��n�ɮ�
ECHO 1.�ƥ����|
ECHO 2.�ƥ����|�BWSL�B�w�]�}�ҵ{��
ECHO 3.�٭�
CHOICE /c:123 /m:"��ܥ\��"
IF errorlevel 3 GOTO ChoiceDataR
IF errorlevel 2 GOTO ChoiceBackup_All
IF errorlevel 1 GOTO ChoiceBackup_Path

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ �ƥ��{�� ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceBackup_All
SET DataB_All=1

:ChoiceBackup_Path

:: �w�q���
FOR /F "tokens=1-3 delims=/ " %%a IN ("%date%") DO (SET _today=%%a%%b%%c)

:: �w�q�ɶ�
SET A=%TIME%
SET A_HOUR=%A:~0,2%
SET A_MINS=%A:~3,2%
SET A_SECS=%A:~6,2%

SET StartTime=%_today%_%A_HOUR: =%%A_MINS: =%%A_SECS: =%

TITLE %StartTime% �ƥ�
IF not exist "%BackOutputDir%\Backup" MKDIR "%BackOutputDir%\Backup"
ECHO ;%StartTime% �ƥ�>"%BackOutputDir%\Backup\%StartTime%.log"

SET Index=0
SET "unbackup="
:BackupCalcStart
SET /A Index=%Index%+1
IF defined Dir[%Index%] (
    for /F "tokens=1,2,3 delims=," %%i IN ("!Dir[%Index%]!") do (
        IF not exist %%j (
            ECHO ;���|���s�b�G%%i,%%j>>"%BackOutputDir%\Backup\%StartTime%.log"
            GOTO BackupCalcStart
        )
        SETLOCAL DISABLEDELAYEDEXPANSION
        IF defined %%k SET unbackup=-xr!catch
        "%UnzipPath%\7z.exe" a -tzip "%BackOutputDir%\Backup\%%i_%StartTime%.zip" "%%j*" %unbackup%
        SETLOCAL ENABLEDELAYEDEXPANSION
        ECHO %%i,%%j>>"%BackOutputDir%\Backup\%StartTime%.log"
    )
    GOTO BackupCalcStart
)

ECHO.
IF defined DataB_All (
    ECHO �ץXWSL %WslName%
    wsl --export %WslName% %BackOutputDir%\Backup\kali-linux_%StartTime%.tar
    ECHO ;WSL,%WslName%,%BackOutputDir%\Backup\kali-linux_%StartTime%.tar>>"%BackOutputDir%\Backup\%StartTime%.log"
    ECHO.
    ECHO �ץX DefaultAppAssociations
    dism /online /Export-DefaultAppAssociations:%BackOutputDir%\Backup\DefaultApplicationAssociations_%StartTime%.xml
    ECHO ;DAA,DefaultApplicationAssociations,%BackOutputDir%\Backup\DefaultApplicationAssociations_%StartTime%.tar>>"%BackOutputDir%\Backup\%StartTime%.log"

)
:BackupEnd
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO �ƥ����G�G
ECHO.
TYPE "%BackOutputDir%\Backup\%StartTime%.log"
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
PAUSE
EXIT


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ �٭�{�� ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceDataR
TITLE �٭�۩w���|
CLS
SET Index=0
ECHO �ƥ���Ƨ������ɮצC���G
FOR /F "tokens=1,2 delims=." %%i IN ('dir /b %BackOutputDir%\Backup\') do (
    IF %%j == log (
        SET /A Index=!Index!+1
        SET Item[!Index!]=%%i
        ECHO !Index!�G%%i
        )
)
FOR /L %%a IN (1 1 %Index%) DO (
    SET choiceItem=!choiceItem!%%a
)

CHOICE /c:%choiceItem% /m:"��ܭn�٭쪺�ƥ�"
FOR /L %%i IN (%Index%,-1,1) DO (
    IF errorlevel %%i SET UserDate=!Item[%%i]! && GOTO StartR
)
:StartR
SET UserDate=%UserDate: =%
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~
ECHO �Y�N�٭� %UserDate% �A���e:
ECHO.
TYPE %BackOutputDir%\Backup\%UserDate%.log
ECHO ~~~~~~~~~~~~~~~~~~~~
ECHO.
PAUSE
ECHO.

FOR /F "eol=; tokens=1,2 delims=," %%i IN (%BackOutputDir%\Backup\%UserDate%.log) do (
    "%UnzipPath%\7z.exe" x "%BackOutputDir%\Backup\%%i_%UserDate%.zip" -o"%%j" -y
    )

FOR /F "eol=- tokens=1,2,3 delims=," %%i IN (%BackOutputDir%\Backup\%UserDate%.log) do (
    IF "%%i" == ";WSL" (
        wsl --import %%j c:\WSL %%k
    )
    IF "%%i" == ";DAA" (
        dism /online /Import-DefaultAppAssociations:%%k
    )
    ) 
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