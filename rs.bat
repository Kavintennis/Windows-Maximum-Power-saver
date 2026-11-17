@echo off
setlocal EnableExtensions
title Restore Windows 10 Power Settings

:: Requires Administrator privileges.
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo Please right-click this file and choose "Run as administrator".
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   RESTORE WINDOWS 10 POWER SETTINGS
echo ==========================================
echo.
echo This restores the standard Balanced power plan
echo and resets the power settings changed by the
echo Maximum Power Saving batch file.
echo.
choice /c YN /n /m "Continue? [Y/N] "
if errorlevel 2 exit /b 0

:: Restore standard Balanced plan.
powercfg /setactive SCHEME_BALANCED

:: Restore processor settings to Balanced defaults.
:: Windows Balanced defaults: minimum 5%%, maximum 100%%,
:: boost mode enabled/efficient (default value 2).
powercfg /setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PERFBOOSTMODE 2
powercfg /setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR PERFBOOSTMODE 2

:: Restore active cooling policy (where supported).
powercfg /setacvalueindex SCHEME_BALANCED SUB_PROCESSOR SYSCOOLPOL 1
powercfg /setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR SYSCOOLPOL 1

:: Restore common Balanced display, sleep, hibernate and disk timeouts.
powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 5
powercfg /change standby-timeout-ac 30
powercfg /change standby-timeout-dc 15
powercfg /change disk-timeout-ac 20
powercfg /change disk-timeout-dc 10
powercfg /setacvalueindex SCHEME_BALANCED SUB_SLEEP HIBERNATEIDLE 0
powercfg /setdcvalueindex SCHEME_BALANCED SUB_SLEEP HIBERNATEIDLE 0

:: Restore wireless adapter to medium power saving (Balanced default).
powercfg /setacvalueindex SCHEME_BALANCED 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 2
powercfg /setdcvalueindex SCHEME_BALANCED 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 2

:: Restore USB selective suspend to enabled (Balanced default).
powercfg /setacvalueindex SCHEME_BALANCED 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
powercfg /setdcvalueindex SCHEME_BALANCED 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1

:: Restore PCIe link-state power management to moderate savings.
powercfg /setacvalueindex SCHEME_BALANCED SUB_PCIEXPRESS ASPM 1
powercfg /setdcvalueindex SCHEME_BALANCED SUB_PCIEXPRESS ASPM 2

:: Ensure Balanced remains active.
powercfg /setactive SCHEME_BALANCED

echo.
echo ==========================================
echo Balanced power plan activated.
echo ==========================================
echo.
echo Note: Windows does not expose a universal command to recover
echo every original OEM-specific timeout or custom power-plan value.
echo This script restores common Balanced defaults, not necessarily
echo your exact previous ASUS/MyASUS configuration.
echo.
pause
endlocal
