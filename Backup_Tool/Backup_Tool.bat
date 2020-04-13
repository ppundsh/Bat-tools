@echo off && SETLOCAL ENABLEDELAYEDEXPANSION 
:: �]�w�ƥ��ؼи�Ƨ�
SET BackOutputDir=D:\Backup

:: �]�w�ƥ����ظ��|
:: �W��,���|,�O�_�ư�catch
SET Dir[1]=Intel,C:\Intel\

goto test1
SET Dir[1]=FF,%APPDATA%\Mozilla\Firefox\Profiles\
SET Dir[2]=GC,%LOCALAPPDATA%\Google\Chrome\User Data\,1
SET Dir[3]=Vivaldi,%LOCALAPPDATA%\Vivaldi\User Data\,1
SET Dir[4]=Startup,%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\
SET Dir[5]=SshKey,%HomePath%\.ssh\
SET Dir[6]=RL2,%HomePath%\.rainlendar2\
SET Dir[7]=Vscode,%HomePath%\.vscode
SET Dir[8]=Intel,C:\Intel\
:test1

set UnzipPath=C:\Program Files\7-Zip

:: ~~~~���~~~
if not defined BackOutputDir SET BackOutputDir=.
if not exist "%UnzipPath%\7z.exe" echo �ФU���æw��7z�íק�}���������| https://www.developershome.com/7-zip/ && pause && exit


echo �`�G�ƥ��ɲ��ͪ�log�ɬ��٭�ɥ��n�ɮ�
echo 1.�ƥ�
echo 2.�٭�
choice /c:12 /m:"��ܥ\��"
if errorlevel 2 goto ChoiceData
if errorlevel 1 goto StartBackup
pause
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ �ƥ��{�� ~~~~~~~~~~~~~~~~~~~~~~
:StartBackup

:: �w�q���
FOR /F "tokens=1-3 delims=/ " %%a IN ("%date%") DO (SET _today=%%a%%b%%c)

:: �w�q�ɶ�
SET A=%TIME%
SET A_HOUR=%A:~0,2%
SET A_MINS=%A:~3,2%
SET A_SECS=%A:~6,2%

SET StartTime=%_today%_%A_HOUR: =%%A_MINS: =%%A_SECS: =%

title %StartTime% �ƥ�
mkdir "%BackOutputDir%\Backup"
echo ;%StartTime% �ƥ��}�l>"%BackOutputDir%\Backup\%StartTime%.log"


SET Index=1
set "unbackup="
:BackupCalcStart
if defined Dir[%Index%] (
for /F "tokens=1,2,3 delims=," %%i in ("!Dir[%Index%]!") do (
        SETLOCAL DISABLEDELAYEDEXPANSION
        if defined %%k set unbackup=-xr!catch
        "%UnzipPath%\7z.exe" a -tzip "%BackOutputDir%\Backup\%%i_%StartTime%.zip" "%%j*" %unbackup%
        SETLOCAL ENABLEDELAYEDEXPANSION
        echo %%i,%%j>>"%BackOutputDir%\Backup\%StartTime%.log"
    )
    SET /A Index=%Index%+1
    GOTO BackupCalcStart
)
pause
exit


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ �٭�{�� ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceData
cls
echo �ƥ���Ƨ������ɮצC��G
tree %BackOutputDir%\Backup\
echo.
set /p UserDate=�п�J�n�٭쪺���(�̤G���) :
echo.
if not exist %BackOutputDir%\Backup_%UserDate% echo �ƥ���Ƨ����L������A�Э��s��ܡC&& pause && goto ChoiceData
for /F "eol=; tokens=1,2 delims=," %%i in (%BackOutputDir%\Backup\%UserDate%.log) do (
    "%UnzipPath%\7z.exe" x "%BackOutputDir%\Backup\%%i_%UserDate%.zip" -o"%%j" -y
    )
pause