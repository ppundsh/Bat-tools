@ECHO OFF && SETLOCAL ENABLEDELAYEDEXPANSION
Rem 設定路徑
:: ~~~~~~~~~~~~~~~~ setting/ ~~~~~~~~~~~~~~~~~~
:: ReleaseUrl=Github releases api 網址
:: DownloadDir=下載的資料夾
:: CurlPat=Curl.exe 所在的資料夾

SET ReleaseUrl[1]=https://api.github.com/repos/namazso/OpenHashTab/releases/latest
SET ReleaseUrl[2]=https://api.github.com/repos/felixse/FluentTerminal/releases/latest
SET DownloadDir=D:\
SET CurlPath=D:\Programs\curl\bin

:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~

Rem 檢測
IF NOT EXIST "%CurlPath%\curl.exe" ECHO 請下載Crul並修改腳本內的路徑 https://curl.haxx.se/windows/ && pause && exit
IF NOT EXIST "%DownloadDir%" MKDIR "%DownloadDir%"

SET Index=0
:DownloadCalcStart
SET /A Index=%Index%+1
if defined ReleaseUrl[%Index%] (
    ECHO !ReleaseUrl[%Index%]!
    "%CurlPath%\curl" -s GET !ReleaseUrl[%Index%]! >Temp[%Index%].json
    FOR /F "eol=; tokens=1,2,3 delims=:" %%i IN ( Temp[%Index%].json ) DO (
        SET TargetID=%%i
        SET TargetUrl=%%j:%%k
        SET TargetID2=!TargetID: =!
        SET TargetUrl2=!TargetUrl: =!
        IF !TargetID2! == "browser_download_url" (
            FOR /F "eol=; tokens=4,7,8 delims=/" %%a IN (!TargetUrl2!) DO (
                ECHO %%a %%b: !TargetUrl2!
                "%CurlPath%\curl" -sSL !TargetUrl2:"=! -o "%DownloadDir%\%%c"
                )            
        )
	)
    DEL /s /f Temp[%Index%].json
    ECHO.
    GOTO DownloadCalcStart
)
pause