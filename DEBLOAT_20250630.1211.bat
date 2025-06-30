@echo off
title Ultimate Windows 11 Cleaner v3.11 Military Edition
color 0A
cls
echo ====================================================
echo          Ultimate Windows 11 Cleaner v3.11
echo                Military Edition - 2025
echo ====================================================
echo.


echo.
echo [1/8] Removing Microsoft Edge

taskkill /F /IM msedge.exe >nul 2>&1
taskkill /F /IM msedgeupdate.exe >nul 2>&1
set "EdgeFound="
for /d %%i in ("%ProgramFiles(x86)%\Microsoft\Edge\Application\*") do (
    set "EdgeVersion=%%~nxi"
    set "EdgeFound=1"
)
if defined EdgeFound (
    "%ProgramFiles(x86)%\Microsoft\Edge\Application\%EdgeVersion%\Installer\setup.exe" --uninstall --system-level --verbose-logging --force-uninstall >nul 2>&1
)
rd /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate" >nul 2>&1
rd /s /q "%ProgramFiles(x86)%\Microsoft\EdgeWebView" >nul 2>&1
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
echo.
echo [2/8] Disabling Copilot, Widgets, Chat, WebExperience, OneDrive, Bing

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Widgets" /v AllowWidgets /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Chat" /v ChatIcon /t REG_DWORD /d 3 /f >nul 2>&1

:: Disable Bing in Start Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1
echo.
echo [3/8] Removing UWP bloatware

for %%A in (
    *BingNews* *BingWeather* *BingFinance* *BingSports* *BingFoodAndDrink*
    *ZuneMusic* *ZuneVideo* *Microsoft.Music.Preview*
    *OfficeHub* *GetOffice*
    *MicrosoftTeams* *SkypeApp*
    *MicrosoftWindowsFeedbackHub* *GetHelp*
    *People* *Solitaire* *Microsoft.3DBuilder* *MixedReality* *Paint3D*
) do (
    powershell -Command "Get-AppxPackage -AllUsers %%A | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
)
echo.
echo [4/8] Removing telemetry

:: Microsoft telemetry services
sc stop DiagTrack >nul 2>&1
sc delete DiagTrack >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc delete dmwappushservice >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

:: Driver telemetry
sc stop AMD External Events Utility >nul 2>&1
sc delete AMD External Events Utility >nul 2>&1
sc stop NvTelemetryContainer >nul 2>&1
sc delete NvTelemetryContainer >nul 2>&1
sc stop IntelTelemetry >nul 2>&1
sc delete IntelTelemetry >nul 2>&1

:: Application Experience
sc stop AeLookupSvc >nul 2>&1
sc delete AeLookupSvc >nul 2>&1
sc stop PcaSvc >nul 2>&1
sc delete PcaSvc >nul 2>&1

:: Windows Error Reporting
sc stop WerSvc >nul 2>&1
sc delete WerSvc >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1

:: CEIP / Compatibility tasks
schtasks /Delete /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /F >nul 2>&1
schtasks /Delete /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /F >nul 2>&1
schtasks /Delete /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /F >nul 2>&1
schtasks /Delete /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /F >nul 2>&1

:: utcsvc
sc stop utcsvc >nul 2>&1
sc delete utcsvc >nul 2>&1

:: Windows Spotlight / ads
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f >nul 2>&1
echo.
echo [5/8] Applying ETW hardening

wevtutil sl Microsoft-Windows-Diagnosis-PLA/Operational /e:false >nul 2>&1
wevtutil sl Microsoft-Windows-TaskScheduler/Operational /e:false >nul 2>&1
wevtutil sl Microsoft-Windows-DiskDiagnosticDataCollector/Operational /e:false >nul 2>&1
echo.
echo [6/8] Applying gaming optimizations and fixing brightness

reg add "HKCU\Control Panel\Desktop" /v AutoRotation /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DisableAdaptiveBrightness /t REG_DWORD /d 1 /f >nul 2>&1
echo [XBOX] Optional Xbox removal and disabling GameDVR
:AskXbox
set /p confirmXbox=Do you want to remove Xbox platform and disable GameDVR (Y/N)? 
if /I "%confirmXbox%"=="Y" (
    powershell -Command "Get-AppxPackage -AllUsers *Xbox* | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
    powershell -Command "Get-AppxPackage -AllUsers *GamingApp* | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
    powershell -Command "Get-AppxPackage -AllUsers *XboxGamingOverlay* | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
    powershell -Command "Get-AppxPackage -AllUsers *XboxSpeechToTextOverlay* | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
    powershell -Command "Get-AppxPackage -AllUsers *Xbox.TCUI* | ForEach-Object {Try {Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop} Catch {}}"
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
) else if /I "%confirmXbox%"=="N" (
    echo Skipping Xbox removal...
) else (
    echo Invalid input. Please type Y or N.
    goto AskXbox
)
echo ------------------ CLEANUP COMPLETE ------------------
echo Ultimate Windows 11 Cleanup Completed Successfully!
echo -----------------------------------------------------
pause >nul