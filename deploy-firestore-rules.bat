@echo off
REM MedTrack Firestore Rules Setup Script (Windows)
REM This script helps you deploy Firestore rules to your Firebase project

echo ================================
echo MedTrack Firestore Rules Setup
echo ================================
echo.

REM Check if Firebase CLI is installed
firebase --version >nul 2>&1
if errorlevel 1 (
    echo Firebase CLI is not installed.
    echo Installing Firebase CLI...
    npm install -g firebase-tools
)

echo Firebase CLI is installed
echo.

REM Check if user is logged in
firebase projects:list >nul 2>&1
if errorlevel 1 (
    echo You need to log in to Firebase.
    call firebase login
)

echo.
echo Available Firebase Projects:
call firebase projects:list

echo.
set /p PROJECT_ID="Enter your Firebase Project ID (from the list above): "

if "%PROJECT_ID%"=="" (
    echo No project ID provided. Exiting.
    pause
    exit /b 1
)

echo.
echo Deploying Firestore rules to project: %PROJECT_ID%
echo.

REM Check if firestore.rules exists
if exist "firestore.rules" (
    call firebase deploy --only firestore:rules --project=%PROJECT_ID%
    if errorlevel 0 (
        echo.
        echo Firestore rules deployed successfully!
        echo.
        echo Next steps:
        echo 1. Restart your Flutter app (full restart, not hot reload^)
        echo 2. Try logging in again
        echo 3. You should no longer see permission denied errors
    ) else (
        echo.
        echo Failed to deploy rules. Check the error above.
    )
) else (
    echo firestore.rules file not found in current directory.
    echo Make sure you run this script from the project root.
)

pause
