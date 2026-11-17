@echo off
setlocal EnableExtensions
title Maximum Power Saving - Windows 10

:: Requires Administrator privileges.
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo Please right-click this file and choose "Run as administrator".
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   MAXIMUM POWER SAVING - WINDOWS 10
echo ==========================================
echo.
echo This activates the built-in Power saver plan and applies
echo aggressive power-saving settings to AC and battery power.
echo CPU performance will be noticeably reduced.
echo.

choice /c YN /n /m "Continue? [Y/N] "
if errorlevel 2 exit /b 0

:: Activate Windows' built-in Power saver plan.
powercfg /setactive SCHEME_MAX

:: Processor: minimum 5%%, maximum 50%%, disable boost.
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 50
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 50
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 0

:: Cooling policy: passive where supported.
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 0

:: Turn off display after 5 minutes on AC / 2 minutes on battery.
powercfg /change monitor-timeout-ac 5
powercfg /change monitor-timeout-dc 2

:: Sleep after 15 minutes on AC / 5 minutes on battery.
powercfg /change standby-timeout-ac 15
powercfg /change standby-timeout-dc 5

:: Hibernate after 30 minutes on AC / 15 minutes on battery.
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 1800
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 900

:: Turn off hard disks after 5 minutes on AC / 2 minutes on battery.
powercfg /change disk-timeout-ac 5
powercfg /change disk-timeout-dc 2

:: Wireless adapter: maximum power saving (Windows setting GUID).
powercfg /setacvalueindex SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 3
powercfg /setdcvalueindex SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 3

:: USB selective suspend: enabled.
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1

:: PCI Express link-state power management: maximum savings.
powercfg /setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 2
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 2

:: Apply all settings.
powercfg /setactive SCHEME_CURRENT

echo.
echo ==========================================
echo Power-saving settings have been applied.
echo ==========================================
echo.
echo Notes:
echo - CPU maximum is limited to 50%%, including when plugged in.
echo - Wi-Fi, USB and PCIe power saving are enabled where supported.
echo - Some device drivers may ignore settings they do not support.
echo - ASUS/MyASUS thermal or performance modes may override some settings.
echo.
echo To restore the standard Balanced plan, run this file again only after
echo changing the final command to powercfg /setactive SCHEME_BALANCED,
echo or run: powercfg /setactive SCHEME_BALANCED
echo.
pause
endlocal
