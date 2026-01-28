# MPV File Organizer 📂

**MPV File Organizer** is a lightweight Lua script for MPV Player that brings order to your media library. It instantly moves the currently playing file into a specific folder structure based on its metadata tags.

Currently optimized for **Album-based** organization (like the classic iTunes logic), making it perfect for both music archives and video series.

## 🎯 What Does It Do?

It organizes your scattered media files with a single keystroke:
1.  Reads the **"Album"** metadata tag from the currently playing file.
2.  Creates a **subfolder** with that album name inside your defined root directory.
3.  **Copies** the file into that folder.
4.  Opens Windows Explorer and selects the copied file for you.

## 🚀 Features

* 🎵 **Universal:** Works with both Music (MP3, FLAC) and Video (MKV, MP4).
* 🛡️ **Error-Proof:** Automatically sanitizes filenames by replacing forbidden Windows characters (e.g., `AC/DC` -> `AC-DC`).
* 📂 **Auto-Folder:** Creates the folder if it doesn't exist, or adds to it if it does.
* ⚡ **Instant Access:** Opens the destination folder immediately after copying.

## 🛠️ Installation

1.  Download `mpv-album-archiver.lua`.
2.  Place it into your MPV `scripts` folder:
    * **Standard:** `%APPDATA%\mpv\scripts\`
    * **Portable:** `portable_config\scripts\`

## ⚙️ Configuration

By default, the script archives to `E:\Band`. To change this, open the `.lua` file with any text editor and modify the following line:

```lua
-- The root folder where files will be archived.
-- Note: Use double backslashes (\\) for Windows paths.
local ARCHIVE_ROOT = "D:\\MyArchive\\Videos"