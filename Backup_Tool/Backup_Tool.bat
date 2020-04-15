@ECHO off && SETLOCAL ENABLEDELAYEDEXPANSION 

:: ~~~~~~~~~~~~~~~~ setting\ ~~~~~~~~~~~~~~~~~~
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
SET Dir[9]=Everything,%APPDATA%\Code\User\
SET Dir[10]=Intel,C:\Intel\
SET Dir[11]=Token2Shell,%USERPROFILE%\Documents\Token2Shell\
SET Dir[12]=PowerShell,%USERPROFILE%\Documents\WindowsPowerShell
 
:: 7zip���|
SET UnzipPath=C:\Program Files\7-Zip

:: �ƥ�wsl�W��
SET WslName=kali-linux

:: �ϥ� backup-start-menu-layout �ƥ��}�l�\���A�]�m BackupSML.exe �Ҧb��Ƨ����|
:: �p���ϥνФ��γ]�m
:: https://www.sordum.org/10997/backup-start-menu-layout-v1-3/
SET BackupSmlDir=D:\Programs\BackupSML

:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~


GOTO GetAdmin
:Start
:: ~~~~~~~~~~~~~~~~~~~~~~~~ ��ܶ}�l ~~~~~~~~~~~~~~~~~~~~~~~
TITLE �ƥ��P�٭�۩w���|
IF not defined BackOutputDir SET BackOutputDir=.\
ECHO �ƥ��ɮצs����|�G%BackOutputDir%
IF not exist "%UnzipPath%\7z.exe" ECHO �ФU���æw��7z�íק�}���������| https://www.developershome.com/7-zip/ && PAUSE && EXIT
IF defined BackupSmlDir (
    IF not exist "%BackupSmlDir%\BackupSML.exe" ECHO �нT�{�}�l�\���ƥ��n�� "%BackupSmlDir%\BackupSML.exe" �O�_�ॿ�`�}�ҡC && PAUSE && EXIT
    ECHO �}�l�\���ƥ��w�}�� "%BackupSmlDir%\BackupSML.exe" 
)
ECHO ~~~~~~
ECHO.
ECHO 1.�ƥ����|
ECHO 2.�ƥ����|�BWSL�B�w�]�}�ҵ{��
ECHO 3.�٭�
ECHO.
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
ECHO ;%StartTime% �ƥ�>"%BackOutputDir%\Backup\%StartTime%.ini"

SET Index=0
SET "unbackup="
:BackupCalcStart
SET /A Index=%Index%+1
IF defined Dir[%Index%] (
    for /F "tokens=1,2,3 delims=," %%i IN ("!Dir[%Index%]!") do (
        IF not exist %%j (
            ECHO ;���|���s�b�G%%i,%%j>>"%BackOutputDir%\Backup\%StartTime%.ini"
            GOTO BackupCalcStart
        )
        SETLOCAL DISABLEDELAYEDEXPANSION
        IF defined %%k SET unbackup=-xr!catch
        "%UnzipPath%\7z.exe" a -tzip "%BackOutputDir%\Backup\%%i_%StartTime%.zip" "%%j*" %unbackup%
        SETLOCAL ENABLEDELAYEDEXPANSION
        ECHO %%i,%%j>>"%BackOutputDir%\Backup\%StartTime%.ini"
    )
    GOTO BackupCalcStart
)

ECHO.
IF defined DataB_All (
    ECHO �ץXWSL %WslName%
    wsl --export %WslName% %BackOutputDir%\Backup\kali-linux_%StartTime%.tar
    ECHO ;WSL,%WslName%,%BackOutputDir%\Backup\kali-linux_%StartTime%.tar>>"%BackOutputDir%\Backup\%StartTime%.ini"
    ECHO.
    ECHO �ץX DefaultAppAssociations
    dism /online /Export-DefaultAppAssociations:"%BackOutputDir%\\Backup\\DefaultApplicationAssociations_%StartTime%.xml"
    ECHO ;DAA,DefaultApplicationAssociations,"%BackOutputDir%\\Backup\\DefaultApplicationAssociations_%StartTime%.xml">>"%BackOutputDir%\Backup\%StartTime%.ini"
)
:BackupEnd

IF defined BackupSmlDir (
    "%BackupSmlDir%\BackupSML.exe" /C "%BackOutputDir%\Backup\BackupSML_%StartTime%"
)

ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO �ƥ����G�G
ECHO.
TYPE "%BackOutputDir%\Backup\%StartTime%.ini"
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
PAUSE
EXIT


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ �٭�{�� ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceDataR
TITLE �٭�۩w���|
CLS
SET Index=0
ECHO �ƥ���Ƨ������ɮצC��G
FOR /F "tokens=1,2 delims=." %%i IN ('dir /b %BackOutputDir%\Backup\') do (
    IF %%j == ini (
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
TYPE "%BackOutputDir%\Backup\%UserDate%.ini"
ECHO ~~~~~~~~~~~~~~~~~~~~
ECHO.
PAUSE
ECHO.
ECHO %UserDate% �٭�>"%TEMP%\Restore_%UserDate%.log"

FOR /F "eol=; tokens=1,2 delims=," %%i IN (%BackOutputDir%\Backup\%UserDate%.ini) do (
    "%UnzipPath%\7z.exe" x "%BackOutputDir%\Backup\%%i_%UserDate%.zip" -o"%%j" -y
    ECHO %%i,%%j>>"%TEMP%\Restore_%UserDate%.log"
    IF not exist "%BackOutputDir%\Backup\%%i_%UserDate%.zip" ECHO �ƥ��ɤ��s�b:%%i,%%j>>"%TEMP%\Restore_%UserDate%.log"
)

FOR /F "eol=- tokens=1,2,3 delims=," %%i IN (%BackOutputDir%\Backup\%UserDate%.ini) do (
    IF "%%i" == ";WSL" (
        wsl --import %%j c:\WSL %%k
        ECHO ;WSL,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"
        IF not exist %%k" ECHO �ƥ��ɤ��s�b;WSL,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"

    )
    IF "%%i" == ";DAA" (
        dism /online /Import-DefaultAppAssociations:%%k
        ECHO ;DAA,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"
        IF not exist %%k" ECHO �ƥ��ɤ��s�b;WSL,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"
    )
)

IF defined BackupSmlDir (
    "%BackupSmlDir%\BackupSML.exe" /R "%BackOutputDir%\Backup\BackupSML_%UserDate%"
)

ECHO.
ECHO �٭쵲�G
TYPE "%TEMP%\Restore_%UserDate%.log"
DEL /s /f %TEMP%\Restore_%UserDate%.log

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
