@ECHO OFF
:: ~~~~~~~~~~~~~~~~ setting/ ~~~~~~~~~~~~~~~~~~
SET Ip=172.16.100.11
SET Mask=255.255.255.0
SET Gw=172.16.100.254
SET Dns=
:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~

netsh interface ip set address "乙太網路" static %Ip% %Mask% %Gw%
IF defined %Dns% (
    netsh interface ip set dns "乙太網路" static %Dns%
)
::
ECHO 已將IP地址設為：%IP%,DNS：%Dns%
PAUSE