@echo off && SETLOCAL ENABLEDELAYEDEXPANSION
Rem Harry 20200329
SET ver=ver3.101
GOTO GetAdmin
:Start
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ own area/ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Just follow the format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: Script Type 1: Clean up all [extension] files under slot C, each line is a separate script
SET "Ext[1]=.tmp,.syd,.---,.$$$,.@@@,.??$,.??~,.err,.prv"
SET "Ext[2]=.xlk,.diz,.dmp,._mp,.gid,.chk,.old,.wbk,.ftg,.fts"

:: Script Type 2: Direct execution of instructions
SET Command[1]=del /f /s /q %systemdrive%\mscreate.dir
SET Command[2]=del /f /s /q %systemdrive%\chklist.*
SET Command[3]=del /f /s /q %systemdrive%\recycled\*.*
SET Command[4]=del /f /s /q %systemdrive%\*.~*
SET Command[5]=del /f /s /q %windir%\*.bak
SET Command[6]=del /f /s /q %windir%\prefetch\*.*
SET Command[7]=del /s /f /q "%systemroot%\Temp\*.*"
SET Command[8]=del /f /s /q /a %systemdrive%\*.sqm
SET Command[9]=rd /s /q %windir%\temp 
SET Command[10]=md %windir%\temp
SET Command[11]=del /s /q "%systemdrive%\Program Files\Temp\*.*"
SET Command[12]=rd /s /q "%systemdrive%\d"

:: Script Type 3: Clean C:\Users\allprofiles\[rold]
SET "Path[1]=\Local Settings\Temporary Internet Files\"
SET "Path[2]=\appdata\recent\"
SET "Path[3]=\Local Settings\Temp\"
SET "Path[4]=\recent\"
SET "Path[5]=\appdata\Local\Google\Chrome\User Data\Default\Cache\"
SET "Path[6]=\appdata\AppData\Local\UCBrowser\User Data\Default\Cache\"

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ /own area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GOTO Start2

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
:Start2

:: Clear residual files
IF EXIST "%appdata%\IT_Clean_Tool" RD /S /Q "%appdata%\IT_Clean_Tool"

:: Create temporary folder
MKDIR %appdata%\IT_Clean_Tool\Count

:: Timing module START
SET "INSTR="
FOR %%I IN (%*) DO (
    SET "INSTR=!INSTR!%%I "
)
SET A=%TIME%

SET A_HOUR=%A:~0,2%
SET A_MINS=%A:~3,2%
SET A_SECS=%A:~6,2%
SET A_MSEC=%A:~9,2%
%INSTR%

:: Script start date and time
SET RunDate=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
SET RunDate=%RunDate: =0%_%A: =%

:: Execution log and startup system cleanup
ECHO Execution log:
FOR /F "tokens=1,2,3,4,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\software\ItCleanTool" ^| find /i "RunDate"') DO SET "RunDate_=%%k"

IF defined RunDate_ (
    START cleanmgr /sagerun:99
    ECHO Last execution time was %RunDate_%
    goto _SKIPSAVE
)

START cleanmgr /sageset:99
ECHO.
ECHO This is the first time to perform the settings. Please press any key to continue after setting up the disk cleaning tool cleaning items
SET "RunDate_=None"
ECHO.
pause
START cleanmgr
(
ECHO Windows Registry Editor Version 5.00
ECHO.
ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\ItCleanTool]
ECHO "Note"="This key is stored for record after the IT Clean Tool has been run"
ECHO "RunDate"="%RunDate%"
)>%appdata%\IT_Clean_Tool\ItCleanTool.reg
regedit /s %appdata%\IT_Clean_Tool\ItCleanTool.reg
DEL /Q %appdata%\IT_Clean_Tool\ItCleanTool.reg

:_SKIPSAVE

:: Record C-slot space before clearing
FOR /F "delims= tokens=1" %%a in ('fsutil volume diskfree c:') do set DiskFreeS=%%a

:: Set the number of independent scripts
SET SNUMB=0

CLS
TITLE SyS Clean Please wait, clearing system junk files......%ver%


:: Create stand-alone cleanup script/
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clear script type1/ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~ Delete all files with C: \ extension name [Variable% EXT *%] ~~~~~~~~~~~~~~~~~~
SET Ext_Index=1
:ExtLoopStart
if defined Ext[%Ext_Index%] (
    SET /A SNUMB=%SNUMB%+1
    ECHO Create SyS clean !SNUMB! Cleaning procedure
    (
        ECHO @echo off ^&^& SETLOCAL ENABLEDELAYEDEXPANSION
        ECHO set "sch=!Ext[%Ext_Index%]!"
        ECHO for %%%%a in (!Ext[%Ext_Index%]!^) do (
        SETLOCAL DISABLEDELAYEDEXPANSION
        SET sch_=!sch:%%%%a=  【%%%%a】  !
        SETLOCAL ENABLEDELAYEDEXPANSION
        ECHO title SyS Clean !SNUMB! !sch_!
        ECHO del /f /s /q C:\*%%%%a
        ECHO ^)
        ECHO echo "!SNUMB!"^>%appdata%\IT_Clean_Tool\Count\!SNUMB!.txt^&^&exit
    )>%appdata%\IT_Clean_Tool\Clean_tmp!SNUMB!.bat
    start "" "%appdata%\IT_Clean_Tool\Clean_tmp!SNUMB!.bat"
    SET /A Ext_Index=%Ext_Index%+1
    GOTO ExtLoopStart
)

setlocal enabledelayedexpansion
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ /Clear script type1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clear script type2/ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~ Sequential execution[Command[*]]command ~~~~~~~~~~~~~~~~~~~~~~
SET Com_Index=1
SET /A SNUMB=%SNUMB%+1
ECHO Create SyS clean %SNUMB% Cleaning procedure
:ComCalcStart
if defined Command[%Com_Index%] (
    SET Com_Total=%Com_Index%
    SET /A Com_Index=%Com_Index%+1
    GOTO ComCalcStart
)
(
ECHO @echo off
ECHO title SyS Clean %SNUMB% Done: 0 / Total: %Com_Total%
)>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
FOR /l %%a in (1 1 %Com_Total%) do (
    ECHO !Command[%%a]!>>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat>>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
    ECHO title SyS Clean %SNUMB% Done: %%a / Total: %Com_Total%>>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
)
(
ECHO echo "%SNUMB%"^>%appdata%\IT_Clean_Tool\Count\%SNUMB%.txt^&^&exit
)>>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
start "" "%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat"
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ /Clear script type2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Clear script type3/ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::~~~~~~~~~ all C:\Users\* The user folder and delete the specified folder file ~~~~~~~~~~~~
SET /A SNUMB=%SNUMB%+1
ECHO Create SyS clean %SNUMB% Cleaning procedure
(
ECHO @echo off ^&^& SETLOCAL ENABLEDELAYEDEXPANSION
ECHO echo Clear individual user temporary files
)>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
SET Pat_Index=1
:PatLoopStart
if defined Path[%Pat_Index%] (
    echo SET "Path[%Pat_Index%]_=!Path[%Pat_Index%]!">>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
    SET /A Pat_Index=%Pat_Index%+1
    GOTO PatLoopStart
)
(
ECHO SET Pat_Index_=1
ECHO :PatLoopStart_
ECHO if defined Path[%%Pat_Index_%%]_ (
ECHO     for /f "delims= " %%%%i in ('DIR /B /ON C:\users'^) do (
ECHO       title SyS Clean %SNUMB% Clean %%%%i temporary files
ECHO       del /f /s /q "C:\Users\%%%%i^!Path[%%Pat_Index_%%]_:~^!*.*"
ECHO       for /f "delims= " %%%%j in ('DIR /B /ON C:\users\%%%%i\AppData\Local\Mozilla\Firefox\Profiles'^) do (
ECHO         del /f /s /q "C:\users\%%%%i\AppData\Local\Mozilla\Firefox\Profiles\%%%%j\cache2\entries\*.*"
ECHO       ^)
ECHO     ^)
ECHO     SET /A Pat_Index_=%%Pat_Index_%%+1
ECHO     GOTO PatLoopStart_
ECHO ^)
ECHO echo "%SNUMB%"^>%appdata%\IT_Clean_Tool\Count\%SNUMB%.txt^&^&exit
)>>%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat
start "" "%appdata%\IT_Clean_Tool\Clean_tmp%SNUMB%.bat"
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ /Clear script type3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:: /Create stand-alone cleanup script
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO Please wait, clearing system junk files......
ECHO.


:: Wait for independent cleanup script to complete
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ver|find "版本" >nul&&SET FindStr=個檔案||SET FindStr=File^(s^)
:_WAIT01
ECHO User list: 
DIR /B /ON C:\users
ECHO.
ECHO C slot is cleared：%DiskFreeS%
SET /P= ■<nul
for /L %%i in (1 1 30) do set /p a=■<nul&ping /n 1 127.0.0.1>nul
for /f %%i in ('dir "%appdata%\IT_Clean_Tool\Count" /a-h-s /s^| find "%FindStr%"') do (Set /A "TOTAL=%%i")
TITLE SyS Clean Please wait, clearing system junk files Done: %TOTAL% / Total: %SNUMB%......%ver%
cls
ECHO Clearing, progress Done: %TOTAL% / Total: %SNUMB%
ECHO.
ECHO Last execution time was%RunDate_%
ECHO.
IF %TOTAL% LSS %SNUMB% GOTO _WAIT01


:: Timing module END
:: ~~~~~~~~~~~~~~~~~
SET B=%TIME%


SET B_HOUR=%B:~0,2%
SET B_MINS=%B:~3,2%
SET B_SECS=%B:~6,2%
SET B_MSEC=%B:~9,2%

ECHO.
ECHO START TIME:%A%
ECHO END   TIME:%B%

SET /A C_MSEC=B_MSEC-A_MSEC
SET /A C_SECS=B_SECS-A_SECS
SET /A C_MINS=B_MINS-A_MINS
SET /A C_HOUR=B_HOUR-A_HOUR

IF %C_MSEC% LSS 0  SET /A C_MSEC+=100 & SET /A C_SECS-=1
IF %C_MSEC% LSS 10 SET C_MSEC=0%C_MSEC%

IF %C_SECS% LSS 0  SET /A C_SECS+=60  & SET /A C_MINS-=1
IF %C_SECS% LSS 10 SET C_SECS=0%C_SECS%

IF %C_MINS% LSS 0  SET /A C_MINS+=60  & SET /A C_HOUR-=1
IF %C_MINS% LSS 10 SET C_MINS=0%C_MINS%

IF %C_HOUR% LSS 0  SET /A C_HOUR+=24
IF %C_HOUR% LSS 10 SET C_HOUR=0%C_HOUR%

ECHO ELAPSE    :%C_HOUR%:%C_MINS%:%C_SECS%.%C_MSEC%

FOR /F "delims= tokens=1" %%a in ('fsutil volume diskfree c:') do set DiskFreeE=%%a
ECHO.
ECHO C slot before clean：%DiskFreeS%
ECHO C slot after clean：%DiskFreeE%

TITLE SYS Clean done......%C_HOUR%:%C_MINS%:%C_SECS%.%C_MSEC% %ver%
ENDLOCAL


:: Clean Temp files
:: ~~~~~~~~~~~~~~~~
RD /S /Q "%appdata%\IT_Clean_Tool"
ECHO.
ECHO All done
ECHO.& pause 