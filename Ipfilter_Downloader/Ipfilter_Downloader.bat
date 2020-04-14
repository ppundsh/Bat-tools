@ECHO OFF
Rem 設定路徑
:: ~~~~~~~~~~~~~~~~ setting/ ~~~~~~~~~~~~~~~~~~
:: IpFilterDataDir=IpFilter 檔案要下載到的路徑
:: CurlPath=Curl.exe 所在的資料夾
:: UnzipPath=7z.exe 所在的資料夾
:: IpFilterUrl=ipfilter下載網址

SET IpFilterDataDir=C:\Dropbox\應用程式\BT
SET CurlPath=D:\Programs\curl\bin
SET UnzipPath=C:\Program Files\7-Zip
SET IpFilterUrl=http://upd.emule-security.org/ipfilter.zip

:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~

Rem 檢測
IF NOT EXIST "%CurlPath%\curl.exe" ECHO 請下載Crul並修改腳本內的路徑 https://curl.haxx.se/windows/ && pause && exit
IF NOT EXIST "%UnzipPath%\7z.exe" ECHO 請下載7z並修改腳本內的路徑 https://www.developershome.com/7-zip/ && pause && exit
IF NOT EXIST "%IpFilterDataDir%" MKDIR "%IpFilterDataDir%"
FOR /F "tokens=2 delims=/" %%i IN ("%IpFilterUrl%") DO (
    SET TestUrl=%%i
)
ping %TestUrl%
IF ERRORLEVEL 1 ECHO Ipfilter 下載網址無法使用，請修改腳本內網址的路徑 && PAUSE && EXIT

Rem 刪除舊dat
IF EXIST "%IpFilterDataDir%\ipfilter.dat" (DEL "%IpFilterDataDir%\ipfilter.dat")

Rem 下載、解壓和重新命名
"%CurlPath%\curl" %IpFilterUrl% -o "%IpFilterDataDir%\ipfilter.zip"
"%UnzipPath%\7z.exe" e "%IpFilterDataDir%\ipfilter.zip" -o"%IpFilterDataDir%"
REN "%IpFilterDataDir%\guarding.p2p" ipfilter.dat
DEL "%IpFilterDataDir%\ipfilter.zip"

exit