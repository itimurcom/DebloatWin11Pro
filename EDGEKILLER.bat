@echo off
setlocal EnableDelayedExpansion

echo ================================
echo Starting Edge Killer 3.0...
echo ================================

:: Kill running Edge processes
taskkill /F /IM msedge.exe >nul 2>&1
taskkill /F /IM msedgewebview2.exe >nul 2>&1
taskkill /F /IM msedgeupdate.exe >nul 2>&1

:: Stop and delete Edge Update services
sc stop edgeupdate >nul 2>&1
sc stop edgeupdatem >nul 2>&1
sc delete edgeupdate >nul 2>&1
sc delete edgeupdatem >nul 2>&1

:: Delete Edge scheduled tasks
schtasks /Delete /TN "Microsoft\EdgeUpdate\Edge Update Task Machine Core" /F >nul 2>&1
schtasks /Delete /TN "Microsoft\EdgeUpdate\Edge Update Task Machine UA" /F >nul 2>&1

:: Remove Edge SystemApps stub
takeown /F "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /A /R /D Y >nul 2>&1
icacls "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /grant Administrators:F /T >nul 2>&1
rd /s /q "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" >nul 2>&1

:: Remove EdgeCore
rd /s /q "C:\Program Files (x86)\Microsoft\EdgeCore" >nul 2>&1

:: Remove Edge main app (if any left)
rd /s /q "C:\Program Files (x86)\Microsoft\Edge" >nul 2>&1

:: Remove WebView2 Runtime (careful: only if you're not using Xbox/GameBar!)
rd /s /q "C:\Program Files (x86)\Microsoft\EdgeWebView" >nul 2>&1

:: Clean registry Edge update keys
reg delete "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdgeUpdate" /f >nul 2>&1

:: Block Edge self-healing reinstalls
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate\DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v UpdateDefault /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdgeUpdate" /v DoNotUpdateToEdgeWithChromium /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Feature Update Stack offering Edge reinstall
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator" /v AllowEdgeInstall /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Edge MSI-based reinstalls
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BlockExternalExtensions /t REG_DWORD /d 1 /f >nul 2>&1

echo ================================
echo Edge Killer 3.0 Completed Successfully!
echo ================================
pause
