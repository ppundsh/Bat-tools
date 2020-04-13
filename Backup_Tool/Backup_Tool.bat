@echo off && SETLOCAL ENABLEDELAYEDEXPANSION 
:: 設定備份目標資料夾
SET BackOutputDir=D:\Backup

:: 設定備份項目路徑
:: 名稱,路徑,是否排除catch
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

:: ~~~~選擇~~~
if not defined BackOutputDir SET BackOutputDir=.
if not exist "%UnzipPath%\7z.exe" echo 請下載並安裝7z並修改腳本內的路徑 https://www.developershome.com/7-zip/ && pause && exit


echo 注：備份時產生的log檔為還原時必要檔案
echo 1.備份
echo 2.還原
choice /c:12 /m:"選擇功能"
if errorlevel 2 goto ChoiceData
if errorlevel 1 goto StartBackup
pause
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ 備份程序 ~~~~~~~~~~~~~~~~~~~~~~
:StartBackup

:: 定義日期
FOR /F "tokens=1-3 delims=/ " %%a IN ("%date%") DO (SET _today=%%a%%b%%c)

:: 定義時間
SET A=%TIME%
SET A_HOUR=%A:~0,2%
SET A_MINS=%A:~3,2%
SET A_SECS=%A:~6,2%

SET StartTime=%_today%_%A_HOUR: =%%A_MINS: =%%A_SECS: =%

title %StartTime% 備份
mkdir "%BackOutputDir%\Backup"
echo ;%StartTime% 備份開始>"%BackOutputDir%\Backup\%StartTime%.log"


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


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ 還原程序 ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceData
cls
echo 備份資料夾中的檔案列表：
tree %BackOutputDir%\Backup\
echo.
set /p UserDate=請輸入要還原的日期(十二位數) :
echo.
if not exist %BackOutputDir%\Backup_%UserDate% echo 備份資料夾中無此日期，請重新選擇。&& pause && goto ChoiceData
for /F "eol=; tokens=1,2 delims=," %%i in (%BackOutputDir%\Backup\%UserDate%.log) do (
    "%UnzipPath%\7z.exe" x "%BackOutputDir%\Backup\%%i_%UserDate%.zip" -o"%%j" -y
    )
pause