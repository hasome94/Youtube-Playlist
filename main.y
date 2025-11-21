import os
import threading
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.scrollview import ScrollView
from kivy.uix.spinner import Spinner
from kivy.core.window import Window
from kivy.garden.filebrowser import FileBrowser
from pathlib import Path

try:
    import yt_dlp
except ImportError:
    yt_dlp = None

Window.size = (360, 640)

class YouTubePlaylistDownloader(App):
    def build(self):
        self.download_thread = None
        
        main_layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Title
        title = Label(
            text='YouTube Playlist Downloader',
            size_hint_y=0.1,
            font_size='18sp',
            bold=True
        )
        main_layout.add_widget(title)
        
        # Scroll view for content
        scroll_view = ScrollView(size_hint=(1, 0.85))
        content_layout = GridLayout(
            cols=1,
            spacing=10,
            size_hint_y=None,
            padding=5
        )
        content_layout.bind(minimum_height=content_layout.setter('height'))
        
        # URL Input
        url_label = Label(text='Playlist URL:', size_hint_y=None, height=40)
        content_layout.add_widget(url_label)
        
        self.url_input = TextInput(
            multiline=False,
            hint_text='Paste YouTube playlist URL here',
            size_hint_y=None,
            height=40
        )
        content_layout.add_widget(self.url_input)
        
        # Download Path Label
        path_label = Label(text='Download Location:', size_hint_y=None, height=40)
        content_layout.add_widget(path_label)
        
        self.path_display = Label(
            text='Storage/Downloads',
            size_hint_y=None,
            height=40,
            markup=True
        )
        content_layout.add_widget(self.path_display)
        
        # Quality Spinner
        quality_label = Label(text='Quality:', size_hint_y=None, height=40)
        content_layout.add_widget(quality_label)
        
        self.quality_spinner = Spinner(
            text='Best',
            values=('Best', 'High', 'Medium', 'Low'),
            size_hint_y=None,
            height=40
        )
        content_layout.add_widget(self.quality_spinner)
        
        # Status Display
        self.status_label = Label(
            text='Ready',
            size_hint_y=None,
            height=100,
            markup=True
        )
        content_layout.add_widget(self.status_label)
        
        scroll_view.add_widget(content_layout)
        main_layout.add_widget(scroll_view)
        
        # Button Layout
        button_layout = BoxLayout(size_hint_y=0.15, spacing=5)
        
        download_btn = Button(
            text='Download',
            size_hint_x=0.7,
            background_color=(0.2, 0.6, 0.2, 1)
        )
        download_btn.bind(on_press=self.start_download)
        button_layout.add_widget(download_btn)
        
        clear_btn = Button(
            text='Clear',
            size_hint_x=0.3,
            background_color=(0.6, 0.2, 0.2, 1)
        )
        clear_btn.bind(on_press=self.clear_fields)
        button_layout.add_widget(clear_btn)
        
        main_layout.add_widget(button_layout)
        
        return main_layout
    
    def start_download(self, instance):
        if not yt_dlp:
            self.status_label.text = '[color=ff0000]Error: yt-dlp not available[/color]'
            return
        
        url = self.url_input.text.strip()
        if not url:
            self.status_label.text = '[color=ff0000]Error: URL cannot be empty[/color]'
            return
        
        if 'youtube.com' not in url and 'youtu.be' not in url:
            self.status_label.text = '[color=ff0000]Error: Invalid YouTube URL[/color]'
            return
        
        # Create downloads directory
        download_path = os.path.join('/storage/emulated/0/Downloads', 'YT_Playlists')
        Path(download_path).mkdir(parents=True, exist_ok=True)
        
        self.status_label.text = '[color=ffff00]Starting download...[/color]'
        self.download_thread = threading.Thread(
            target=self.download_playlist,
            args=(url, download_path)
        )
        self.download_thread.daemon = True
        self.download_thread.start()
    
    def download_playlist(self, url, path):
        try:
            format_map = {
                'Best': 'best',
                'High': 'best[height>=720]',
                'Medium': 'best[height>=480]',
                'Low': 'best[height>=360]'
            }
            
            ydl_opts = {
                'format': format_map.get(self.quality_spinner.text, 'best'),
                'outtmpl': os.path.join(path, '%(title)s.%(ext)s'),
                'noplaylist': False,
                'progress_hooks': [self.progress_hook],
                'quiet': False,
                'no_warnings': False,
            }
            
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])
            
            self.status_label.text = f'[color=00ff00]Download completed!\n\nSaved to:\n{path}[/color]'
        except Exception as e:
            self.status_label.text = f'[color=ff0000]Error: {str(e)[:100]}[/color]'
    
    def progress_hook(self, d):
        if d['status'] == 'downloading':
            percent = d.get('_percent_str', 'Downloading...')
            speed = d.get('_speed_str', '')
            eta = d.get('_eta_str', '')
            self.status_label.text = f'[color=ffffff]{percent}\nSpeed: {speed}\nETA: {eta}[/color]'
        elif d['status'] == 'finished':
            self.status_label.text = f'[color=00ff00]Finished: {d.get("filename", "Video")}[/color]'
    
    def clear_fields(self, instance):
        self.url_input.text = ''
        self.status_label.text = 'Ready'

if __name__ == '__main__':
    YouTubePlaylistDownloader().run()
