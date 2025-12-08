#!/bin/bash

# MedTrack Firestore Rules Setup Script
# This script helps you deploy Firestore rules to your Firebase project

echo "================================"
echo "MedTrack Firestore Rules Setup"
echo "================================"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo "Installing Firebase CLI..."
    npm install -g firebase-tools
fi

echo "✅ Firebase CLI is installed"
echo ""

# Check if user is logged in to Firebase
firebase projects:list > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "📋 You need to log in to Firebase."
    firebase login
fi

echo ""
echo "🔍 Available Firebase Projects:"
firebase projects:list

echo ""
echo "Enter your Firebase Project ID (from the list above):"
read PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo "❌ No project ID provided. Exiting."
    exit 1
fi

echo ""
echo "⏳ Deploying Firestore rules to project: $PROJECT_ID"
echo ""

# Use the firestore.rules file from project root
if [ -f "firestore.rules" ]; then
    firebase deploy --only firestore:rules --project=$PROJECT_ID
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Firestore rules deployed successfully!"
        echo ""
        echo "📝 Next steps:"
        echo "1. Restart your Flutter app (full restart, not hot reload)"
        echo "2. Try logging in again"
        echo "3. You should no longer see permission denied errors"
    else
        echo ""
        echo "❌ Failed to deploy rules. Check the error above."
    fi
else
    echo "❌ firestore.rules file not found in current directory."
    echo "Make sure you run this script from the project root."
fi
