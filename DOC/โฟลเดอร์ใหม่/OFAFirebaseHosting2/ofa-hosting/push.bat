@echo off
cd /d "C:\Users\ASUS\Desktop\ONEFORALL\DOC\โฟลเดอร์ใหม่\OFAFirebaseHosting2\ofa-hosting"

git add .
git commit -m "update"
git push

echo.
echo Push complete! Check GitHub Actions:
echo https://github.com/ummpluk/ofa-office-app/actions
pause
