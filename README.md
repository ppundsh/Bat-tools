# Bat tools

介紹

本專案為個人使用的幾個腳本，基於BAT寫成。

----

## Clean2

clean2 - Multi-Process 系統清理腳本，內建三種類型。

* 類型1.清理副檔名，設定檔中的每一行均會由單獨腳本運行清理。
* 類型2.整體由單一腳本負責，依序執行命令
* 類型3.整體由單一腳本負責，對win10使用，清理每一個個人設定檔中的指定位置。

首次執行時會在機碼寫入時間資訊，並啟用磁碟清理工具設定程序，未來會按照首次設定直接自動運行。

----

## Ipfilter_Downloader

下載 ipfilter 並解壓縮且更名，可搭配系統排程供 qBittorent 使用。

* 需設定 IpFilter 檔案要下載到的路徑。
* 需搭配 Curl 和 7zip 使用，下載與安裝後於腳本內設定這兩個工具的位置。

----

## Backup_Tool

高度客製化的備份與還原工具，可選擇只備份自訂的路徑，或備份路徑、WSL、系統預設開啟程式

參數選項
* BackOutputDir=設定備份資料夾路徑
* SET Dir[X]=名稱,路徑,是否排除catch(有設定為啟用)
* UnzipPath=7zip路徑
* WslName=要備份的WSL (Windows Subsystem for Linux) 名稱

----

## USB-Mobile_APP_Shortcut

供快速開啟隨身碟內程式使用。
因不同電腦的硬碟硬碟數量、隨身碟數量不同，每次插上隨身碟後分配的磁碟代號可能不同，造成沒辦法設立捷徑快速開啟隨身碟內的程式。

此腳本需設定 DetectionTarget ，可以是隨身碟內的檔案或資料夾。
腳本會偵測存在此路徑的磁碟代號，並以此代號開啟預先設定好放在隨身碟路徑內的程式。

----

## Set_Static_IP

使用腳本快速設定靜態IP，可搭配 Runas 使用。

----

## CapsLockToCtrl

重新映射鍵盤，腳本包含復原回預設狀態功能。

* CapsLock 改為 【Ctrl】
* Ctrl 改為【Esc】
* Esc 改為【Capslock

----

## Continuous_Open_App

有時需要開啟復數的相同程式或檔案，故使用此腳本輔助。
特殊功能是已經開啟的程式不會重複開啟。

參數形式 App[1]=7z.exe,C:\Program Files\7-Zip,0
執行檔或檔案名稱,路徑,是否開啟後要先暫停腳本(1為啟用暫停)