@ECHO OFF
:: ~~~~~~~~~~~~~~~~ setting/ ~~~~~~~~~~~~~~~~~~
SET Ip=172.16.100.11
SET Mask=255.255.255.0
SET Gw=172.16.100.254
SET Dns=
:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~

netsh interface ip set address "�A�Ӻ���" static %Ip% %Mask% %Gw%
IF defined %Dns% (
    netsh interface ip set dns "�A�Ӻ���" static %Dns%
)
::
ECHO �w�NIP�a�}�]���G%IP%,DNS�G%Dns%
PAUSE