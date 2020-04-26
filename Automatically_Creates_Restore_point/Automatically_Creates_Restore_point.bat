@echo off && SETLOCAL ENABLEDELAYEDEXPANSION
Goto GetAdmin
:Start

::創建還原點間時間間隔限制
SET timeInterval=60
::任務名稱
SET taskName=Auto_Create_System_Restore

SET sLin==============================
SET appName=設定開機自動創建系統還原點

:ChoiceMenu
TITLE %appName%
ECHO %sLin%
ECHO %appName%
ECHO %sLin%
ECHO.
echo 系統還原點狀態
PowerShell -command "Get-ComputerRestorePoint"
ECHO 1.設定開機自動創建系統還原點(限制還原點時間間隔 %timeInterval% 分鐘)
ECHO 2.設定【限制還原點時間間隔】
ECHO 3.刪除手動添加的【限制還原時間間隔】與【開機自動創建還原點任務】
ECHO.
CHOICE /c:123 /m:"選擇功能"

IF errorlevel 3 (
    call :Task03 
)
IF errorlevel 2 (
    call :Task02
)
IF errorlevel 1 (
    call :Task01
)

:Task01
echo.
echo 0.1 添加機碼解除工作排程器對於系統還原的24小時內只能一次限制。
echo.
FOR /F "tokens=1,2,3,4,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" ^| find /i "SystemRestorePointCreationFrequency"') DO (
    SET CreationFrequency=%%k
    SET /A CreationFrequency=0x!CreationFrequency:~2!
)
if not defined CreationFrequency SET CreationFrequency=None
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t reg_dword /d %timeInterval% /f
IF %CreationFrequency%==None (echo 已設定建立系統還原點間隔時間限制為 %timeInterval% 分鐘) else (echo 原先建立系統還原點間隔時間限制為 %CreationFrequency% 分鐘，已修改為 %timeInterval% 分鐘)
echo.

echo 0.2 開啟系統保護 C:\。
echo.
PowerShell -command "&Enable-ComputerRestore -Drive 'C:\' "
IF ERRORLEVEL 1 goto check_fail

echo 0.3 新建排程。
echo.
SCHTASKS /Create /RL HIGHEST /RU SYSTEM /SC ONSTART /TN %taskName% /TR "powershell -ExecutionPolicy Bypass -Command Checkpoint-Computer -Description 'Restore_Point_Startup' -RestorePointType 'MODIFY_SETTINGS'
echo.
echo 開機自動建立還原點已設定完成，請按任意鍵退出 && pause >nul && exit

:Task02
ECHO.
ECHO 設定限制還原點時間間隔
ECHO 設定過短可能造成過早覆蓋掉舊的還原點，系統預設間隔24小時，此腳本預設 60 分鐘。
SET /P timeInterval=分鐘：
cls
GOTO ChoiceMenu

:Task03
ECHO.
ECHO 刪除手動添加的【限制還原時間間隔】機碼
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /f
echo.
schtasks /Delete /F /TN %taskName%
echo.
echo 已設定完成，請按任意鍵退出 && pause >nul && exit

::-------------------------------------------
:GetAdmin
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

goto Start