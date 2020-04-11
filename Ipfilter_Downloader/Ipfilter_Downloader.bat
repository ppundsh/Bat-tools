@echo off
Rem 設定路徑

set IpFilterDir=C:\Dropbox\應用程式\BT
set CurlPath=D:\Programs\curl\bin
set UnzipPath=C:\Program Files\7-Zip
set Url=http://upd.emule-security.org/ipfilter.zip

Rem 檢測
if not exist "%CurlPath%\curl.exe" echo 請下載Crul並修改腳本內的路徑 https://curl.haxx.se/windows/ && pause && exit
if not exist "%UnzipPath%\7z.exe" echo 請下載7z並修改腳本內的路徑 https://www.developershome.com/7-zip/ && pause && exit
if not exist "%IpFilterDir%" mkdir "%IpFilterDir%"
ping %Url%
if %errorlevol% = 1 echo Ipfilter 下載網址無法使用，請修改腳本內網址的路徑 && pause && exit

Rem 刪除舊dat
if exist "%IpFilterDir%\ipfilter.dat" (del "%IpFilterDir%\ipfilter.dat")

Rem 下載、解壓和重新命名
start "" "%CurlPath%\curl" %Url% -o %IpFilterDir%\ipfilter.zip
start "" "%UnzipPath%\7z.exe" e %IpFilterDir%\ipfilter.zip -y -o%IpFilterDir%
ren %IpFilterDir%\guarding.p2p ipfilter.dat
del %IpFilterDir%\ipfilter.zip

exit