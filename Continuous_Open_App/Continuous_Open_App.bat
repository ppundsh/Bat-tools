@ECHO off && SETLOCAL ENABLEDELAYEDEXPANSION 
:: ~~~~~~~~~~~~~~~~ setting\ ~~~~~~~~~~~~~~~~~~
:: App[X]=name,path,pause(0=disable)

SET App[1]=7z.exe,C:\Program Files\7-Zip,0
SET App[2]=mpc-be64.exe,C:\Program Files\MPC-BE x64,1
SET App[3]=anki.exe,C:\Program Files\Anki,0

:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~

SET Index=0
:StartupCalcStart
SET /A Index=%Index%+1
IF defined App[%Index%] (
    FOR /F "eol=; tokens=1,2,3 delims=," %%i IN ("!App[%Index%]!") DO (
	SET "Dir=%%j\%%i"
	IF not exist "!Dir:\\=\!" ECHO %%i 路徑不存在。&& GOTO StartupCalcStart
	tasklist /FI "IMAGENAME eq %%i" /FO CSV > %TEMP%\search.log
	FOR /F %%A IN (%TEMP%\search.log) DO (
		IF %%A == 資訊: (
			START "" "!Dir:\\=\!"
			ECHO ...%%i 開啟中... 
		    )
		IF %%k==1 PAUSE
		)
	)
    GOTO StartupCalcStart
)
DEL /s /f %TEMP%\search.log
exit