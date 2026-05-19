@echo off
cd /d "C:\Users\ASUS\Desktop\ONEFORALL\DOC\โฟลเดอร์ใหม่\OFAFirebaseHosting2\ofa-hosting"

echo Removing old .git folder...
rmdir /s /q .git 2>nul

echo Setting git config...
git config --global user.email "ummpluk@gmail.com"
git config --global user.name "Pluk"

echo Initializing git repo...
git init -b main

echo Adding files...
git add .

echo Committing...
git commit -m "initial commit"

echo.
echo ========================================
echo Done! Now run git push:
echo   git remote add origin https://github.com/ummpluk/ofa-office-app.git
echo   git push -u origin main
echo ========================================
pause
