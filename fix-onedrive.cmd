@echo off
echo === Resetting user folders to default local paths (%USERPROFILE%) ===

:: Reset common folders in registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Desktop" /t REG_EXPAND_SZ /d "%USERPROFILE%\Desktop" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal" /t REG_EXPAND_SZ /d "%USERPROFILE%\Documents" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Pictures" /t REG_EXPAND_SZ /d "%USERPROFILE%\Pictures" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Music" /t REG_EXPAND_SZ /d "%USERPROFILE%\Music" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "My Video" /t REG_EXPAND_SZ /d "%USERPROFILE%\Videos" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}" /t REG_EXPAND_SZ /d "%USERPROFILE%\Downloads" /f

:: Add/Reset Screenshots folder path in registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" /t REG_EXPAND_SZ /d "%USERPROFILE%\Pictures\Screenshots" /f

:: Create Screenshots folder if missing
set "SSPATH=%USERPROFILE%\Pictures\Screenshots"
if not exist "%SSPATH%" (
    echo Creating Screenshots folder...
    mkdir "%SSPATH%"
)

:: Restart Explorer to apply changes
echo Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo ✅ Done. System folders and Screenshots path have been reset.
pause
