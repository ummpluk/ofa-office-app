@echo off
title Firebase Deploy
cd /d "%~dp0"
(
echo === DEPLOY ===
echo Time: %date% %time%
"%APPDATA%\npm\firebase.cmd" deploy --only hosting 2>&1
echo Exit: %errorlevel%
) > deploy_result.txt 2>&1
type deploy_result.txt
pause
