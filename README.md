# YouTube Upload Automation

Automatically upload videos from your Mac to YouTube with playlist organization, triggered by AirDrop.

## Problem

Recording videos on iPhone for review (training sessions, technique analysis, etc.) creates a repetitive workflow:
- High-def videos fill up phone storage quickly
- Cloud storage costs money
- YouTube creator uploads are free and unlimited
- Manual uploading via YouTube Studio is tedious (5+ minutes per video)
- YouTube mobile app doesn't support playlist selection during upload

## Solution

An automation that:
1. Watches your Downloads folder for AirDropped videos
2. Moves videos to an upload queue
3. Opens Terminal with interactive prompts
4. Uploads to YouTube with your chosen title and playlist
5. Sets video as unlisted and "not for kids"
6. Deletes local file after successful upload

**Time per video:** 30 seconds (just entering metadata) vs 5 minutes of clicking

## Prerequisites

- macOS (uses Folder Actions and AppleScript)
- Python 3.7+
- Google account with YouTube channel
- Google Cloud Project with YouTube Data API enabled

## Installation

### 1. Clone the repository

```bash
cd ~/Documents
git clone https://github.com/sriramranga/youtube-upload-automation.git
cd youtube-upload-automation
```

### 2. Set up Python virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Set up Google API credentials

Follow the detailed guide: [Google API Setup](docs/GOOGLE_API_SETUP.md)

**Summary:**
1. Create Google Cloud Project
2. Enable YouTube Data API v3
3. Create OAuth 2.0 credentials (Desktop app)
4. Download `client_secrets.json` to this directory

### 4. First-time OAuth authorization

```bash
./venv/bin/python3 youtube_uploader.py
```

Browser will open for authorization. Sign in and allow access. This creates `token.pickle` for future use.

### 5. Make scripts executable

```bash
chmod +x handle_upload.sh
```

### 6. Install Folder Action

1. Open **Script Editor** (Applications → Utilities)
2. File → Open → Select `YouTubeAuto.scpt`
3. File → Export
   - File Format: **Script**
   - Where: `~/Library/Scripts/Folder Action Scripts/`
   - Name: `YouTubeAuto`

### 7. Attach Folder Action to Downloads

1. Open **Folder Actions Setup** (Spotlight search)
2. Check "Enable Folder Actions"
3. Click **+** button
4. Select your **Downloads** folder
5. Choose `YouTubeAuto.scpt`
6. Ensure checkbox next to Downloads is enabled

## Usage

1. AirDrop video from iPhone to Mac
2. Video lands in Downloads
3. After 5 seconds, file moves to `airdropVideos/` folder
4. Terminal opens automatically after another 5 seconds
5. Enter video title when prompted
6. Select playlist from your YouTube playlists (or skip)
7. Video uploads to YouTube (unlisted, not for kids)
8. File deleted after successful upload
9. Close Terminal window

## How It Works

### Architecture

```
AirDrop → Downloads/
          ↓ (5 sec delay)
     YouTubeAuto.scpt (Folder Action)
          ↓
     Move to airdropVideos/
          ↓ (5 sec delay)
     handle_upload.sh (creates lock file)
          ↓
     Terminal opens → youtube_uploader.py
          ↓
     Interactive prompts → Upload via YouTube API
          ↓
     Delete file → Remove lock
```

### Key Design Decisions

**Why delays?** AirDrop and file system operations need time to complete. The 5-second delays prevent race conditions.

**Why Terminal window?** Visibility. You see what's happening and can troubleshoot if needed. Background processes are hard to debug.

**Why manual title/playlist entry?** Forces intentional organization. Also prevents automation from making wrong assumptions about metadata.

**Why lock file?** Prevents multiple upload scripts from running simultaneously if Folder Action triggers multiple times.

## Files

- `youtube_uploader.py` - Main Python script using YouTube Data API
- `YouTubeAuto.scpt` - AppleScript Folder Action for Downloads
- `handle_upload.sh` - Shell wrapper with lock file management
- `requirements.txt` - Python dependencies
- `client_secrets.json` - Your OAuth credentials (not in repo)
- `token.pickle` - Your auth token (auto-generated, not in repo)
- `processed_videos.json` - Upload history (auto-generated, not in repo)

## Troubleshooting

### Video not moving from Downloads

**Check Folder Actions are enabled:**
```bash
open /System/Library/CoreServices/Applications/Folder\ Actions\ Setup.app
```
Verify Downloads folder is listed with YouTubeAuto.scpt attached.

### Terminal doesn't open

**Check for stuck processes:**
```bash
ps aux | grep youtube_uploader
```

Kill any stuck processes:
```bash
killall python3
```

### File disappears before upload

**Multiple processes competing.** Remove lock file:
```bash
rm ~/Documents/youtube-upload-automation/.upload_lock
```

### "File not found" error during upload

File was processed by another instance. Check:
```bash
cat processed_videos.json
```

Reset if needed:
```bash
echo "[]" > processed_videos.json
```

## API Quota

YouTube Data API v3 quota:
- **Default:** 10,000 units/day
- **Upload cost:** 1,600 units
- **Daily uploads:** ~6 videos

Need more? Request quota increase in Google Cloud Console.

## Security Notes

**Never commit these files:**
- `client_secrets.json` (OAuth credentials)
- `token.pickle` (auth token)
- `processed_videos.json` (upload history)

These are excluded via `.gitignore`.

## Contributing

Found a bug? Have a feature request? Open an issue or submit a PR.

## License

MIT License - see LICENSE file for details.

## Acknowledgments

Built as part of "Week 3 of building in public" - learning how to work with AI (Claude) to build automations and understanding what engineers deal with when requirements are vague.

**Key lesson learned:** Being specific about workflows upfront saves hours of debugging. "Make it like X" isn't a spec. "Here's exactly what should happen, step by step" is.
