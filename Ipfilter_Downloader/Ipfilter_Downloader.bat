@echo off
Rem 設定路徑

set IpFilterDir=C:\Dropbox\應用程式\BT
set CurlPath=C:\Dropbox\Apps\Cmder\bin

Rem 刪除舊dat
if exist %IpFilterDir%\ipfilter.dat (del %IpFilterDir%\ipfilter.dat)

Rem 下載、解壓和重新命名
%CurlPath%\curl http://upd.emule-security.org/ipfilter.zip -o %IpFilterDir%\ipfilter.zip
7z e %IpFilterDir%\ipfilter.zip -y -o%IpFilterDir%
ren %IpFilterDir%\guarding.p2p ipfilter.dat
del %IpFilterDir%\ipfilter.zip

exit