@ECHO off && SETLOCAL ENABLEDELAYEDEXPANSION 

:: ~~~~~~~~~~~~~~~~ setting\ ~~~~~~~~~~~~~~~~~~
:: 設定備份目標資料夾
SET BackOutputDir=D:\Backup

:: 設定備份項目路徑
:: 名稱,路徑,是否排除catch
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
 
:: 7zip路徑
SET UnzipPath=C:\Program Files\7-Zip

:: 備份wsl名稱
SET WslName=kali-linux

:: 使用 backup-start-menu-layout 備份開始功能表，設置 BackupSML.exe 所在資料夾路徑
:: 如不使用請不用設置
:: https://www.sordum.org/10997/backup-start-menu-layout-v1-3/
SET BackupSmlDir=D:\Programs\BackupSML

:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~


GOTO GetAdmin
:Start
:: ~~~~~~~~~~~~~~~~~~~~~~~~ 選擇開始 ~~~~~~~~~~~~~~~~~~~~~~~
TITLE 備份與還原自定路徑
IF not defined BackOutputDir SET BackOutputDir=.\
ECHO 備份檔案存放路徑：%BackOutputDir%
IF not exist "%UnzipPath%\7z.exe" ECHO 請下載並安裝7z並修改腳本內的路徑 https://www.developershome.com/7-zip/ && PAUSE && EXIT
IF defined BackupSmlDir (
    IF not exist "%BackupSmlDir%\BackupSML.exe" ECHO 請確認開始功能表備份軟體 "%BackupSmlDir%\BackupSML.exe" 是否能正常開啟。 && PAUSE && EXIT
    ECHO 開始功能表備份已開啟 "%BackupSmlDir%\BackupSML.exe" 
)
ECHO ~~~~~~
ECHO.
ECHO 1.備份路徑
ECHO 2.備份路徑、WSL、預設開啟程式
ECHO 3.還原
ECHO.
CHOICE /c:123 /m:"選擇功能"
IF errorlevel 3 GOTO ChoiceDataR
IF errorlevel 2 GOTO ChoiceBackup_All
IF errorlevel 1 GOTO ChoiceBackup_Path

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ 備份程序 ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceBackup_All
SET DataB_All=1

:ChoiceBackup_Path

:: 定義日期
FOR /F "tokens=1-3 delims=/ " %%a IN ("%date%") DO (SET _today=%%a%%b%%c)

:: 定義時間
SET A=%TIME%
SET A_HOUR=%A:~0,2%
SET A_MINS=%A:~3,2%
SET A_SECS=%A:~6,2%

SET StartTime=%_today%_%A_HOUR: =%%A_MINS: =%%A_SECS: =%

TITLE %StartTime% 備份
IF not exist "%BackOutputDir%\Backup" MKDIR "%BackOutputDir%\Backup"
ECHO ;%StartTime% 備份>"%BackOutputDir%\Backup\%StartTime%.ini"

SET Index=0
SET "unbackup="
:BackupCalcStart
SET /A Index=%Index%+1
IF defined Dir[%Index%] (
    for /F "tokens=1,2,3 delims=," %%i IN ("!Dir[%Index%]!") do (
        IF not exist %%j (
            ECHO ;路徑不存在：%%i,%%j>>"%BackOutputDir%\Backup\%StartTime%.ini"
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
    ECHO 匯出WSL %WslName%
    wsl --export %WslName% %BackOutputDir%\Backup\kali-linux_%StartTime%.tar
    ECHO ;WSL,%WslName%,%BackOutputDir%\Backup\kali-linux_%StartTime%.tar>>"%BackOutputDir%\Backup\%StartTime%.ini"
    ECHO.
    ECHO 匯出 DefaultAppAssociations
    dism /online /Export-DefaultAppAssociations:"%BackOutputDir%\\Backup\\DefaultApplicationAssociations_%StartTime%.xml"
    ECHO ;DAA,DefaultApplicationAssociations,"%BackOutputDir%\\Backup\\DefaultApplicationAssociations_%StartTime%.xml">>"%BackOutputDir%\Backup\%StartTime%.ini"
)
:BackupEnd

IF defined BackupSmlDir (
    "%BackupSmlDir%\BackupSML.exe" /C "%BackOutputDir%\Backup\BackupSML_%StartTime%"
)

ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO 備份結果：
ECHO.
TYPE "%BackOutputDir%\Backup\%StartTime%.ini"
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
PAUSE
EXIT


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ 還原程序 ~~~~~~~~~~~~~~~~~~~~~~
:ChoiceDataR
TITLE 還原自定路徑
CLS
SET Index=0
ECHO 備份資料夾中的檔案列表：
FOR /F "tokens=1,2 delims=." %%i IN ('dir /b %BackOutputDir%\Backup\') do (
    IF %%j == ini (
        SET /A Index=!Index!+1
        SET Item[!Index!]=%%i
        ECHO !Index!：%%i
        )
)
FOR /L %%a IN (1 1 %Index%) DO (
    SET choiceItem=!choiceItem!%%a
)

CHOICE /c:%choiceItem% /m:"選擇要還原的備份"
FOR /L %%i IN (%Index%,-1,1) DO (
    IF errorlevel %%i SET UserDate=!Item[%%i]! && GOTO StartR
)
:StartR
SET UserDate=%UserDate: =%
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~
ECHO 即將還原 %UserDate% ，內容:
ECHO.
TYPE "%BackOutputDir%\Backup\%UserDate%.ini"
ECHO ~~~~~~~~~~~~~~~~~~~~
ECHO.
PAUSE
ECHO.
ECHO %UserDate% 還原>"%TEMP%\Restore_%UserDate%.log"

FOR /F "eol=; tokens=1,2 delims=," %%i IN (%BackOutputDir%\Backup\%UserDate%.ini) do (
    "%UnzipPath%\7z.exe" x "%BackOutputDir%\Backup\%%i_%UserDate%.zip" -o"%%j" -y
    ECHO %%i,%%j>>"%TEMP%\Restore_%UserDate%.log"
    IF not exist "%BackOutputDir%\Backup\%%i_%UserDate%.zip" ECHO 備份檔不存在:%%i,%%j>>"%TEMP%\Restore_%UserDate%.log"
)

FOR /F "eol=- tokens=1,2,3 delims=," %%i IN (%BackOutputDir%\Backup\%UserDate%.ini) do (
    IF "%%i" == ";WSL" (
        wsl --import %%j c:\WSL %%k
        ECHO ;WSL,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"
        IF not exist %%k" ECHO 備份檔不存在;WSL,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"

    )
    IF "%%i" == ";DAA" (
        dism /online /Import-DefaultAppAssociations:%%k
        ECHO ;DAA,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"
        IF not exist %%k" ECHO 備份檔不存在;WSL,%%j,%%k>>"%TEMP%\Restore_%UserDate%.log"
    )
)

IF defined BackupSmlDir (
    "%BackupSmlDir%\BackupSML.exe" /R "%BackOutputDir%\Backup\BackupSML_%UserDate%"
)

ECHO.
ECHO 還原結果
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
