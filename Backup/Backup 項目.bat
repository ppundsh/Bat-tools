@echo off
FOR /F "tokens=1-3 delims=/ " %%a IN ("%date%") DO (SET _today=%%a%%b%%c)
echo %_today% 備份
7z a -tzip "D:\desktop\Backup_Profile_firefox_%_today%.zip" "%APPDATA%\Mozilla\Firefox\Profiles\*" -xr!catch
7z a -tzip "D:\desktop\Backup_Profile_chrome_%_today%.zip" "%LOCALAPPDATA%\Google\Chrome\User Data\*" -xr!catch
7z a -tzip "D:\desktop\Backup_Profile_Vivaldi_%_today%.zip" "%LOCALAPPDATA%\Vivaldi\User Data\*" -xr!catch
7z a -tzip "D:\desktop\Backup_Startup_%_today%.zip" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*"
7z a -tzip "D:\desktop\Backup_ssh_%_today%.zip" "%HomePath%\.ssh\*"
7z a -tzip "D:\desktop\Backup_rainlendar2_%_today%.zip" "%HomePath%\.rainlendar2\*"
7z a -tzip "D:\desktop\Backup_vscode_%_today%.zip" "%HomePath%\.vscode\*"
7z a -tzip "D:\desktop\Backup_Intel_%_today%.zip" "C:\Intel\*
pause