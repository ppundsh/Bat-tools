@echo off
Rem 設定路徑

set IpFilterDataDir=C:\Dropbox\應用程式\BT
set CurlPath=D:\Programs\curl\bin
set UnzipPath=C:\Program Files\7-Zip
set IpFilterUrl=http://upd.emule-security.org/ipfilter.zip

Rem 檢測
if not exist "%CurlPath%\curl.exe" echo 請下載Crul並修改腳本內的路徑 https://curl.haxx.se/windows/ && pause && exit
if not exist "%UnzipPath%\7z.exe" echo 請下載7z並修改腳本內的路徑 https://www.developershome.com/7-zip/ && pause && exit
if not exist "%IpFilterDataDir%" mkdir "%IpFilterDataDir%"
for /F "tokens=2 delims=/" %%i in ("%IpFilterUrl%") do (
  set TestUrl=%%i
)
ping %TestUrl%
IF ERRORLEVEL 1 ECHO Ipfilter 下載網址無法使用，請修改腳本內網址的路徑 && pause && exit

Rem 刪除舊dat
if exist "%IpFilterDataDir%\ipfilter.dat" (del "%IpFilterDataDir%\ipfilter.dat")

Rem 下載、解壓和重新命名
"%CurlPath%\curl" %IpFilterUrl% -o "%IpFilterDataDir%\ipfilter.zip"
"%UnzipPath%\7z.exe" e "%IpFilterDataDir%\ipfilter.zip" -o"%IpFilterDataDir%"
ren "%IpFilterDataDir%\guarding.p2p" ipfilter.dat
del "%IpFilterDataDir%\ipfilter.zip"

exit