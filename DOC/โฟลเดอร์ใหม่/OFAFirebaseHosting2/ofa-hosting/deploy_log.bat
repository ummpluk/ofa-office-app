@echo off
title Deploy ONE FOR ALL - Logging
cd /d "%~dp0"

set PATH=%APPDATA%\npm;C:\Program Files\nodejs;%PATH%

echo === Deploy Log === > deploy_output.txt
echo Date: %date% %time% >> deploy_output.txt
echo. >> deploy_output.txt

echo Checking firebase... >> deploy_output.txt
where firebase >> deploy_output.txt 2>&1
firebase --version >> deploy_output.txt 2>&1

echo. >> deploy_output.txt
echo Deploying... >> deploy_output.txt
firebase deploy --only hosting >> deploy_output.txt 2>&1

echo. >> deploy_output.txt
echo Exit code: %errorlevel% >> deploy_output.txt

echo Done! Check deploy_output.txt for results.
type deploy_output.txt
pause
