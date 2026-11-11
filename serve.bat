@echo off
setlocal

:: Find local IP using PowerShell (filter for 192.168.x.x or 10.x.x.x)
for /f "delims=" %%i in ('powershell -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like '192.168.*' -or $_.IPAddress -like '10.*'} | Select-Object -First 1).IPAddress"') do (
    set IP=%%i
)

if not defined IP (
    for /f "delims=" %%i in ('powershell -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' -and $_.IPAddress -notlike '0.0.*'} | Select-Object -First 1).IPAddress"') do (
        set IP=%%i
    )
)

if not defined IP (
    set IP=127.0.0.1
)

echo ========================================
echo Static server running at:
echo   http://%IP%:8080
echo   http://localhost:8080
echo ========================================
echo Press Ctrl+C to stop
echo ========================================

python -m http.server 8080
