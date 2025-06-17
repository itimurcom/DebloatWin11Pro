@echo off
setlocal EnableDelayedExpansion

echo ================================
echo Starting Ultimate Windows 11 Cleaner v2.0 Military Edition...
echo ================================

:: Microsoft Edge Removal
echo Removing Microsoft Edge...
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

:: SystemApps Edge wipe
echo Removing SystemApps Edge...
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

:: System bloatware removal
echo Removing system bloatware...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Widgets" /v AllowWidgets /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Chat" /v ChatIcon /t REG_DWORD /d 3 /f >nul 2>&1

powershell -Command "Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *MicrosoftWindowsFeedbackHub* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *ZuneVideo* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *OneDrive* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *OfficeHub* | Remove-AppxPackage"

:: Telemetry removal
echo Disabling Microsoft telemetry...
sc stop DiagTrack >nul 2>&1
sc delete DiagTrack >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc delete dmwappushservice >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableInventory /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisablePCA /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1

:: Telemetry tasks
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1

:: Vendor telemetry removal
echo Disabling AMD telemetry...
sc stop AMDRyzenMasterDriverV20 >nul 2>&1
sc delete AMDRyzenMasterDriverV20 >nul 2>&1
sc stop AMDRSServ >nul 2>&1
sc delete AMDRSServ >nul 2>&1
sc stop "AMD External Events Utility" >nul 2>&1
sc config "AMD External Events Utility" start= disabled >nul 2>&1

echo Disabling NVIDIA telemetry...
sc stop NvTelemetryContainer >nul 2>&1
sc delete NvTelemetryContainer >nul 2>&1

echo Disabling Intel telemetry...
sc stop icssvc >nul 2>&1
sc delete icssvc >nul 2>&1

:: ETW hardening
echo Applying ETW hardening...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowDeviceNameInTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f >nul 2>&1

:: Gaming optimization
echo Applying gaming optimizations...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
powercfg /setactive SCHEME_MIN >nul 2>&1
bcdedit /set useplatformclock false >nul 2>&1

:: Brightness fix
echo Fixing brightness issues...
powercfg -setacvalueindex SCHEME_MIN SUB_VIDEO ADAPTBRIGHTNESS 0 >nul 2>&1
powercfg -setdcvalueindex SCHEME_MIN SUB_VIDEO ADAPTBRIGHTNESS 0 >nul 2>&1
powercfg /setactive SCHEME_MIN >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\VideoSettings" /v EnableCABC /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v DisableCABC /t REG_DWORD /d 1 /f >nul 2>&1

echo ================================
echo Ultimate Windows 11 Cleanup Completed Successfully!
echo ================================
pause
