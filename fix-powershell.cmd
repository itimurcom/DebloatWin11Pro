@echo off
setlocal EnableDelayedExpansion

echo ================================
echo  Fix PowerShell for Windows 11
echo ================================

:: 1. Check admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [ERROR] Run this script as Administrator.
    pause
    exit /b
)

:: 2. Check if powershell.exe exists in expected path
set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%PS_EXE%" (
    echo [INFO] PowerShell executable exists: "%PS_EXE%"
) else (
    echo [INFO] PowerShell executable missing. Trying to restore it...
    :: 3. Try restoring via DISM (if package still present)
    dism /online /Cleanup-Image /RestoreHealth
    if exist "%PS_EXE%" (
        echo [OK] PowerShell restored.
    ) else (
        echo [WARNING] DISM did not recover powershell.exe
        echo Trying to install optional feature 'MicrosoftWindowsPowerShellV2Root'...
        dism /online /add-capability /capabilityname:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0
    )
)

:: 4. Fix PATH variable if missing PowerShell
echo [INFO] Checking if PowerShell is in PATH...
echo %PATH% | find /i "WindowsPowerShell" >nul
if %errorLevel% NEQ 0 (
    echo [FIX] Adding PowerShell to PATH...
    setx PATH "%PATH%;%SystemRoot%\System32\WindowsPowerShell\v1.0"
) else (
    echo [OK] PowerShell already in PATH.
)

:: 5. Final check
echo.
echo [CHECK] Trying to launch PowerShell...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "Write-Host 'PowerShell is working'" 2>nul

if %errorLevel% NEQ 0 (
    echo [ERROR] PowerShell could not be restored automatically.
    echo Try reinstalling it via Microsoft Store or reinstall optional features manually.
) else (
    echo [SUCCESS] PowerShell is restored and operational.
)

pause
