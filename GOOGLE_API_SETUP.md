# Google API Setup Guide

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click "Select a project" → "New Project"
3. Enter project name (e.g., "YouTube Upload Automation")
4. Click "Create"

## Step 2: Enable YouTube Data API

1. In your project, go to "APIs & Services" → "Library"
2. Search for "YouTube Data API v3"
3. Click on it and click "Enable"

## Step 3: Create OAuth 2.0 Credentials

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. If prompted, configure the OAuth consent screen:
   - User Type: External
   - App name: YouTube Upload Automation
   - User support email: your email
   - Developer contact: your email
   - Click "Save and Continue"
   - Scopes: Skip (click "Save and Continue")
   - Test users: Add your email
   - Click "Save and Continue"

4. Back to Create OAuth client ID:
   - Application type: **Desktop app**
   - Name: YouTube Uploader
   - Click "Create"

## Step 4: Download Credentials

1. You'll see a dialog with your Client ID and Client Secret
2. Click "Download JSON"
3. Rename the downloaded file to `client_secrets.json`
4. Move it to your project directory:
   ```bash
   mv ~/Downloads/client_secret_*.json ~/Documents/personalAutomation/youtubeUpload/client_secrets.json
   ```

## Step 5: First-Time Authorization

The first time you run the script, it will:
1. Open your browser
2. Ask you to sign in to Google
3. Show permissions requested (YouTube upload access)
4. Click "Allow"
5. Create a `token.pickle` file for future use

**Important:** Keep `client_secrets.json` and `token.pickle` private. Never commit them to Git.

## API Quota

- YouTube Data API has a default quota of 10,000 units per day
- A single video upload costs 1,600 units
- This allows ~6 uploads per day for free
- You can request quota increases if needed

## Troubleshooting

**"Access blocked: This app's request is invalid"**
- Make sure you added yourself as a test user in the OAuth consent screen

**"The user has not granted the app access"**
- Run the script again and make sure to click "Allow" in the browser

**"Invalid client secrets"**
- Make sure `client_secrets.json` is in the correct directory
- Check that the file is valid JSON (open it in a text editor)
