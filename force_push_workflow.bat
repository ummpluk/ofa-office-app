@echo off
cd /d "C:\Users\ASUS\Desktop\ONEFORALL"

git add -f .github/workflows/deploy.yml
git commit -m "fix: use FIREBASE_TOKEN for deploy"
git push

echo.
echo Done! Check: https://github.com/ummpluk/ofa-office-app/actions
pause
