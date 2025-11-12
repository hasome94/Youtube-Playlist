# YouTube Playlist Downloader

A simple Python application to download YouTube playlists at the best available quality.

## Features

- Download entire YouTube playlists
- Downloads videos at the best available resolution
- Interactive command-line interface
- Progress tracking for each video
- Automatic directory creation
- No ffmpeg required (uses already-merged formats)

## Requirements

- Python 3.6 or higher
- yt-dlp library

## Installation

1. Clone or download this repository

2. Install the required dependencies:
```bash
pip install -r requirements.txt
```

Or install yt-dlp directly:
```bash
pip install yt-dlp
```

## Usage

1. Run the application:
```bash
python playlist_downloader.py
```

2. When prompted, enter:
   - **YouTube Playlist URL**: The full URL of the YouTube playlist you want to download
   - **Download path**: The folder where you want to save the videos (press Enter to use the default `downloads` folder in the current directory)

3. Confirm the download by typing `y` when prompted

4. Wait for the download to complete. The app will show progress for each video in the playlist.

## Example

```
============================================================
YouTube Playlist Downloader
============================================================

Enter YouTube Playlist URL: https://www.youtube.com/playlist?list=PLxxxxx
Enter download path (press Enter for current directory): C:\Videos\MyPlaylist

Download path: C:\Videos\MyPlaylist

Start download? (y/n): y

Starting download to: C:\Videos\MyPlaylist
Playlist URL: https://www.youtube.com/playlist?list=PLxxxxx

[Download progress will be shown here]
```

## Notes

- Videos are saved with their original titles as filenames
- The download path will be created automatically if it doesn't exist
- The app downloads videos at the best quality available that doesn't require merging (no ffmpeg needed)
- Make sure you have sufficient disk space for the videos

## Troubleshooting

**Error: yt-dlp is not installed**
- Solution: Run `pip install yt-dlp` to install the required library

**Error: URL cannot be empty**
- Solution: Make sure you provide a valid YouTube playlist URL

**Download fails or is slow**
- Check your internet connection
- Verify the playlist URL is correct and accessible
- Some videos may be unavailable or restricted

## License

This project is open source and available for personal use.

