@echo off
Rem �]�w���|

set IpFilterDataDir=C:\Dropbox\���ε{��\BT
set CurlPath=D:\Programs\curl\bin
set UnzipPath=C:\Program Files\7-Zip
set IpFilterUrl=http://upd.emule-security.org/ipfilter.zip

Rem �˴�
if not exist "%CurlPath%\curl.exe" echo �ФU��Crul�íק�}���������| https://curl.haxx.se/windows/ && pause && exit
if not exist "%UnzipPath%\7z.exe" echo �ФU��7z�íק�}���������| https://www.developershome.com/7-zip/ && pause && exit
if not exist "%IpFilterDataDir%" mkdir "%IpFilterDataDir%"
for /F "tokens=2 delims=/" %%i in ("%IpFilterUrl%") do (
  set TestUrl=%%i
)
ping %TestUrl%
IF ERRORLEVEL 1 ECHO Ipfilter �U�����}�L�k�ϥΡA�Эק�}�������}�����| && pause && exit

Rem �R����dat
if exist "%IpFilterDataDir%\ipfilter.dat" (del "%IpFilterDataDir%\ipfilter.dat")

Rem �U���B�����M���s�R�W
"%CurlPath%\curl" %IpFilterUrl% -o "%IpFilterDataDir%\ipfilter.zip"
"%UnzipPath%\7z.exe" e "%IpFilterDataDir%\ipfilter.zip" -o"%IpFilterDataDir%"
ren "%IpFilterDataDir%\guarding.p2p" ipfilter.dat
del "%IpFilterDataDir%\ipfilter.zip"

exit