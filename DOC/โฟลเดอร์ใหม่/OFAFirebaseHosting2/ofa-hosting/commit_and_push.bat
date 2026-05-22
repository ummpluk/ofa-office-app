@echo off
chcp 65001 >nul
cd /d "C:\Users\ASUS\Desktop\ONEFORALL"

echo Removing index lock if exists...
if exist ".git\index.lock" del /f ".git\index.lock"

echo Adding all changes...
git add -A

echo Committing...
git commit -m "fix: complete app with all 10 accounting modules"

echo Pushing...
git push origin main

echo.
echo Done! Check: https://github.com/ummpluk/ofa-office-app/actions
pause
