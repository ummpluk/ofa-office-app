@echo off
cd /d "C:\Users\ASUS\Desktop\ONEFORALL\DOC\โฟลเดอร์ใหม่\OFAFirebaseHosting2\ofa-hosting"

echo Force adding .github folder...
git add .github -f
git status

git commit -m "add github actions workflow"
git push

echo.
echo Done! Check: https://github.com/ummpluk/ofa-office-app/actions
pause
