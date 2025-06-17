@echo off
echo === Installing Chocolatey ===

:: Step 1: Check if running as Administrator
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
  echo [ERROR] This script must be run as Administrator.
  pause
  exit /b
)

:: Step 2: Define PowerShell path explicitly
set "PS_PATH=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS_PATH%" (
  echo [ERROR] PowerShell not found at %PS_PATH%
  echo Please install or restore Windows PowerShell.
  pause
  exit /b
)

:: Step 3: Install Chocolatey via PowerShell
echo Downloading and executing Chocolatey installer...
"%PS_PATH%" -NoProfile -ExecutionPolicy Bypass -Command ^
  "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

:: Step 4: Verify installation
IF EXIST "%ProgramData%\chocolatey\bin\choco.exe" (
  echo [OK] Chocolatey was installed successfully.
) ELSE (
  echo [FAIL] Chocolatey installation failed.
)

echo === Done ===
pause
