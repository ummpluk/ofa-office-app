@echo off
cd /d "C:\Users\ASUS\Desktop\ONEFORALL\DOC\โฟลเดอร์ใหม่\OFAFirebaseHosting2\ofa-hosting"

echo Removing unused bat files...
del /f git_setup.bat 2>nul
del /f push_workflow.bat 2>nul
del /f fix_and_push.bat 2>nul
del /f deploy.bat 2>nul
del /f deploy_log.bat 2>nul
del /f deploy_now.bat 2>nul
del /f deploy_result.txt 2>nul
del /f cleanup.bat 2>nul

echo Removing old .github folder inside ofa-hosting...
rmdir /s /q .github 2>nul

echo.
echo Done! Only push.bat and deploy_check.bat remain.
pause
