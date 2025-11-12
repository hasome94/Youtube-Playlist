import os
import sys
from pathlib import Path

try:
    import yt_dlp
except ImportError:
    print("Error: yt-dlp is not installed.")
    print("Please install it using: pip install yt-dlp")
    sys.exit(1)


def download_playlist(playlist_url, download_path):
    """Download a YouTube playlist at best quality."""
    
    # Ensure download path exists
    Path(download_path).mkdir(parents=True, exist_ok=True)
    
    # Configure yt-dlp options for best quality
    # Using 'best' format which downloads already-merged formats (no ffmpeg required)
    ydl_opts = {
        'format': 'best',  # Best quality
        'outtmpl': os.path.join(download_path, '%(title)s.%(ext)s'),
        'noplaylist': False,  # Download entire playlist
        'progress_hooks': [progress_hook],
    }
    
    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            print(f"\nStarting download to: {download_path}")
            print(f"Playlist URL: {playlist_url}\n")
            ydl.download([playlist_url])
            print("\nDownload completed successfully!")
    except Exception as e:
        print(f"\nError occurred: {str(e)}")
        sys.exit(1)


def progress_hook(d):
    """Display download progress."""
    if d['status'] == 'downloading':
        if 'total_bytes' in d:
            total = d['total_bytes']
            downloaded = d.get('downloaded_bytes', 0)
            percent = (downloaded / total) * 100 if total > 0 else 0
            print(f"\rDownloading: {percent:.1f}% ({downloaded}/{total} bytes)", end='', flush=True)
        elif '_percent_str' in d:
            print(f"\r{d['_percent_str']}", end='', flush=True)
    elif d['status'] == 'finished':
        print(f"\nFinished: {d['filename']}")


def main():
    """Main function to get user input and start download."""
    print("=" * 60)
    print("YouTube Playlist Downloader")
    print("=" * 60)
    
    # Get playlist URL
    playlist_url = input("\nEnter YouTube Playlist URL: ").strip()
    if not playlist_url:
        print("Error: URL cannot be empty.")
        sys.exit(1)
    
    # Get download path
    download_path = input("Enter download path (press Enter for current directory): ").strip()
    if not download_path:
        download_path = os.path.join(os.getcwd(), "downloads")
    
    # Convert to absolute path
    download_path = os.path.abspath(download_path)
    
    print(f"\nDownload path: {download_path}")
    
    # Confirm before starting
    confirm = input("\nStart download? (y/n): ").strip().lower()
    if confirm != 'y':
        print("Download cancelled.")
        sys.exit(0)
    
    # Start download
    download_playlist(playlist_url, download_path)


if __name__ == "__main__":
    main()

