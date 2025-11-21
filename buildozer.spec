[app]
title = YouTube Playlist Downloader
package.name = ytplaylistdownloader
package.domain = com.yourdomain

source.dir = .
source.include_exts = py,png,jpg,kv,atlas

version = 1.0.0

requirements = python3,kivy,yt-dlp,urllib3,certifi

orientation = portrait

fullscreen = 0

android.permissions = INTERNET,READ_EXTERNAL_STORAGE,WRITE_EXTERNAL_STORAGE

android.api = 31
android.minapi = 21
android.ndk = 25b
android.accept_sdk_license = True

android.logcat_filters = *:S python:D

p4a.source_dir = 
p4a.bootstrap = sdl2

arch = arm64-v8a

[buildozer]
log_level = 2
warn_on_root = 1
