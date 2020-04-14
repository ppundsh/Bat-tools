@ECHO OFF
Rem �]�w���|
:: ~~~~~~~~~~~~~~~~ setting/ ~~~~~~~~~~~~~~~~~~
:: IpFilterDataDir=IpFilter �ɮ׭n�U���쪺���|
:: CurlPath=Curl.exe �Ҧb����Ƨ�
:: UnzipPath=7z.exe �Ҧb����Ƨ�
:: IpFilterUrl=ipfilter�U�����}

SET IpFilterDataDir=C:\Dropbox\���ε{��\BT
SET CurlPath=D:\Programs\curl\bin
SET UnzipPath=C:\Program Files\7-Zip
SET IpFilterUrl=http://upd.emule-security.org/ipfilter.zip

:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~

Rem �˴�
IF NOT EXIST "%CurlPath%\curl.exe" ECHO �ФU��Crul�íק�}���������| https://curl.haxx.se/windows/ && pause && exit
IF NOT EXIST "%UnzipPath%\7z.exe" ECHO �ФU��7z�íק�}���������| https://www.developershome.com/7-zip/ && pause && exit
IF NOT EXIST "%IpFilterDataDir%" MKDIR "%IpFilterDataDir%"
FOR /F "tokens=2 delims=/" %%i IN ("%IpFilterUrl%") DO (
    SET TestUrl=%%i
)
ping %TestUrl%
IF ERRORLEVEL 1 ECHO Ipfilter �U�����}�L�k�ϥΡA�Эק�}�������}�����| && PAUSE && EXIT

Rem �R����dat
IF EXIST "%IpFilterDataDir%\ipfilter.dat" (DEL "%IpFilterDataDir%\ipfilter.dat")

Rem �U���B�����M���s�R�W
"%CurlPath%\curl" %IpFilterUrl% -o "%IpFilterDataDir%\ipfilter.zip"
"%UnzipPath%\7z.exe" e "%IpFilterDataDir%\ipfilter.zip" -o"%IpFilterDataDir%"
REN "%IpFilterDataDir%\guarding.p2p" ipfilter.dat
DEL "%IpFilterDataDir%\ipfilter.zip"

exit