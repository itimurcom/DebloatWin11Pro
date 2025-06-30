@echo off
title Ultimate Windows 11 Cleaner v3.250630.1241 Military Edition
color 0A
cls
echo ====================================================
echo          Ultimate Windows 11 Cleaner v3.250630.1241
echo                Military Edition - 2025
echo ====================================================

:: [1/6] Removing Microsoft Edge
echo [1/6] Removing Microsoft Edge
taskkill /F /IM msedge.exe >nul 2>&1
taskkill /F /IM msedgeupdate.exe >nul 2>&1
set "EdgeFound="
for %%i in ("C:\Program Files (x86)\Microsoft\Edge\Application\*") do (
    set "EdgeVersion=%%~nxi"
    set "EdgeFound=1"
)
if defined EdgeFound (
    "C:\Program Files (x86)\Microsoft\Edge\Application\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall >nul 2>&1
)
rd /s /q "C:\Program Files (x86)\Microsoft\EdgeUpdate" >nul 2>&1
rd /s /q "C:\Program Files (x86)\Microsoft\EdgeWebView" >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /f >nul 2>&1
sc stop edgeupdate >nul 2>&1
sc stop edgeupdatem >nul 2>&1
sc delete edgeupdate >nul 2>&1
sc delete edgeupdatem >nul 2>&1
schtasks /Delete /TN "Microsoft\EdgeUpdate\Edge Update Task Machine Core" /F >nul 2>&1
schtasks /Delete /TN "Microsoft\EdgeUpdate\Edge Update Task Machine UA" /F >nul 2>&1
takeown /F "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /A /R /D Y >nul 2>&1
icacls "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /grant Administrators:F /T >nul 2>&1
rd /s /q "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate\DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdgeUpdate" /v DoNotUpdateToEdgeWithChromium /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1

:: [2/6] Disabling Copilot, Widgets, Chat, WebExperience, OneDrive, Bing
echo [2/6] Disabling Copilot, Widgets, Chat, WebExperience, OneDrive, Bing
powershell -Command "Try { Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0 -Force } Catch {}"
powershell -Command "Try { Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'CortanaConsent' -Value 0 -Force } Catch {}"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Widgets" /v AllowWidgets /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Chat" /v ChatIcon /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1

:: [3/6] Removing UWP bloatware
echo [3/6] Removing UWP bloatware
for %%A in (*BingNews* *BingWeather* *BingFinance* *BingSports* *BingFoodAndDrink* *ZuneMusic* *ZuneVideo* *Microsoft.Music.Preview* *OfficeHub* *GetOffice* *MicrosoftTeams* *SkypeApp* *MicrosoftWindowsFeedbackHub* *GetHelp* *People* *Solitaire* *Microsoft.3DBuilder* *MixedReality* *Paint3D*) do (
    powershell -Command "Get-AppxPackage -AllUsers %%A | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
)

:: [4/6] Removing telemetry
echo [4/6] Removing telemetry
sc stop DiagTrack >nul 2>&1
sc delete DiagTrack >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc delete dmwappushservice >nul 2>&1

:: [5/6] Applying ETW hardening
echo [5/6] Applying ETW hardening
wevtutil sl Microsoft-Windows-Diagnosis-PLA/Operational /e:false >nul 2>&1
wevtutil sl Microsoft-Windows-TaskScheduler/Operational /e:false >nul 2>&1

:: [6/6] Applying gaming optimizations and fixing brightness
echo [6/6] Applying gaming optimizations and fixing brightness
reg add "HKCU\Control Panel\Desktop" /v AutoRotation /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DisableAdaptiveBrightness /t REG_DWORD /d 1 /f >nul 2>&1

:: [XBOX] Optional Xbox removal
echo [XBOX] Optional Xbox removal and disabling GameDVR (Y/N):
set /p confirmXbox=
if /I "%confirmXbox%"=="Y" (
    powershell -Command "Get-AppxPackage -AllUsers *Xbox* | Remove-AppxPackage"
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    echo -> Xbox and GameDVR removed
) else (
    echo -> Skipped Xbox removal
)

echo --------------------------------------------
echo        Ultimate Windows 11 Cleanup Done
echo --------------------------------------------
pause
