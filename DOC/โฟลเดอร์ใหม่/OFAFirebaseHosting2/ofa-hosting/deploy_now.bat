@echo off
title Deploy ONE FOR ALL to Firebase
cd /d "%~dp0"

:: Add npm global to PATH
set PATH=%APPDATA%\npm;%PATH%

echo === ONE FOR ALL - Firebase Deploy ===
echo.

firebase --version
if errorlevel 1 (
  echo Firebase CLI not found. Installing now...
  call npm install -g firebase-tools
)

echo.
echo Deploying to Firebase Hosting...
echo.
firebase deploy --only hosting

echo.
if errorlevel 1 (
  echo [FAILED] Deploy failed! Please run "firebase login" first.
) else (
  echo [SUCCESS] Deployed to https://oneforall-office.web.app
)
echo.
pause
