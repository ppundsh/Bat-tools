@ECHO OFF
:: ~~~~~~~~~~~~~~~~ setting/ ~~~~~~~~~~~~~~~~~~
:: DetectionTarget：放在隨身碟內，用來作為腳本判斷USB磁碟代號用的目標的資料夾或檔案。
:: AppDir：要啟動的APP路徑，不包含USB磁碟代號
SET DetectionTarget=git
SET AppDir=Programs\NTPClock.exe
:: ~~~~~~~~~~~~~~~~ /setting ~~~~~~~~~~~~~~~~~~
FOR %%i IN (c d e f g h i j k l m n o p q r s t u v w x y z) DO IF EXIST "%%i:\%DetectionTarget%" SET Usb=%%i
START "" "%Usb%:\%AppDir%" /anything
EXIT