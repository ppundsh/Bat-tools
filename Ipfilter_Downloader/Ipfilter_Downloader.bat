@echo off
Rem �]�w���|

set IpFilterDir=C:\Dropbox\���ε{��\BT
set CurlPath=D:\Programs\curl\bin
set UnzipPath=C:\Program Files\7-Zip
set Url=http://upd.emule-security.org/ipfilter.zip

Rem �˴�
if not exist "%CurlPath%\curl.exe" echo �ФU��Crul�íק�}���������| https://curl.haxx.se/windows/ && pause && exit
if not exist "%UnzipPath%\7z.exe" echo �ФU��7z�íק�}���������| https://www.developershome.com/7-zip/ && pause && exit
if not exist "%IpFilterDir%" mkdir "%IpFilterDir%"
ping %Url%
if %errorlevol% = 1 echo Ipfilter �U�����}�L�k�ϥΡA�Эק�}�������}�����| && pause && exit

Rem �R����dat
if exist "%IpFilterDir%\ipfilter.dat" (del "%IpFilterDir%\ipfilter.dat")

Rem �U���B�����M���s�R�W
start "" "%CurlPath%\curl" %Url% -o %IpFilterDir%\ipfilter.zip
start "" "%UnzipPath%\7z.exe" e %IpFilterDir%\ipfilter.zip -y -o%IpFilterDir%
ren %IpFilterDir%\guarding.p2p ipfilter.dat
del %IpFilterDir%\ipfilter.zip

exit