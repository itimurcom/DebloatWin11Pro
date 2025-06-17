@echo off
echo === Removing Chocolatey ===

:: Check if running as Administrator
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
  echo This script must be run as Administrator.
  pause
  exit /b
)

:: Step 1: Stop Chocolatey-related processes (optional)
echo Checking for Chocolatey-related processes...
tasklist | find /I "choco" >nul
if %errorlevel%==0 (
    echo Found Chocolatey processes. Attempting to kill...
    taskkill /F /IM choco.exe >nul 2>&1
)

:: Step 2: Use PowerShell to delete Chocolatey folder and PATH entries
set "PS_PATH=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS_PATH%" (
    echo PowerShell not found. Cannot proceed.
    pause
    exit /b
)

:: PowerShell commands: remove folder, clean PATH, delete registry key
"%PS_PATH%" -NoProfile -ExecutionPolicy Bypass -Command ^
  "$chocoDir = 'C:\ProgramData\chocolatey';" ^
  "if (Test-Path $chocoDir) { Remove-Item -Path $chocoDir -Recurse -Force; Write-Host 'Chocolatey folder removed.' } else { Write-Host 'Chocolatey folder not found.' };" ^
  "$envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine');" ^
  "$newPath = ($envPath -split ';' | Where-Object { $_ -notlike '*chocolatey*' }) -join ';';" ^
  "[Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine'); Write-Host 'PATH variable cleaned.';" ^
  "if (Test-Path 'HKLM:\SOFTWARE\Chocolatey') { Remove-Item -Path 'HKLM:\SOFTWARE\Chocolatey' -Recurse -Force; Write-Host 'Registry key removed.' }"

echo === Chocolatey has been removed. ===
echo It is recommended to restart your computer.
pause
