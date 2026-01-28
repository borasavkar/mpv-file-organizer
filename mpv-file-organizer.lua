--[[
    MPV File Organizer by Bora Savkar
    
    Description:
    This script organizes your media files (Video or Audio) by reading the 
    "Album" metadata tag. It creates a subfolder with the album name 
    inside your specified root directory and copies the file there.Automatically organizes the currently playing media file into a subfolder 
    based on its metadata (Default: Album Name).
    
    Logic: Classic iTunes-style organization (Tag -> Folder).3

    GitHub: https://github.com/borasavkar/mpv-file-organizer
]]--

local mp = require 'mp'
local msg = require 'mp.msg'

-- ####################################################################
-- USER SETTINGS (Please Edit This Section)
-- ####################################################################

-- The ROOT DIRECTORY where files will be archived.
-- Example: "D:\\Archive\\Music" or "E:\\Videos"
-- WARNING: Use double backslashes (\\) for Windows paths. Do not add a trailing slash.
local ARCHIVE_ROOT = "C:\\Media"

-- Trigger Key Binding (Default: Ctrl+c)
local KEY_BINDING = "ctrl+c"

-- ####################################################################
-- Script Logic (Do not edit below this line)
-- ####################################################################

-- Sanitizes filenames by removing characters forbidden in Windows
local function sanitize_name(name)
    if not name then return "Unknown_Album" end
    -- Forbidden chars: \ / : * ? " < > |
    name = name:gsub("[\\/:*?\"<>|]", "-")
    -- Remove leading/trailing whitespace
    name = name:gsub("^%s*(.-)%s*$", "%1")
    return name
end

local function archive_file()
    -- Retrieve necessary properties
    local current_path = mp.get_property("path")
    local filename = mp.get_property("filename")
    local album_tag = mp.get_property("metadata/by-key/album")
    
    -- Stop if no file is playing
    if not current_path then
        mp.osd_message("No media playing!", 2)
        return
    end

    -- Warning if 'Album' tag is missing
    if not album_tag or album_tag == "" then
        mp.osd_message("ERROR: No 'Album' metadata tag found!", 4)
        msg.warn("Metadata tag missing. Archive operation cancelled.")
        return
    end

    -- Sanitize the album name
    local safe_album = sanitize_name(album_tag)
    
    -- Construct target paths
    local target_folder = ARCHIVE_ROOT .. "\\" .. safe_album
    local target_file_path = target_folder .. "\\" .. filename

    -- Notify user
    mp.osd_message("Archiving: " .. safe_album, 999)

    -- Prepare the command (Create Folder & Copy & Open Explorer)
    -- Quotes (" ") are critical for paths containing spaces.
    local cmd = string.format(
        'cmd /c mkdir "%s" & copy "%s" "%s" & explorer /select,"%s"',
        target_folder,
        current_path,
        target_folder,
        target_file_path
    )
    
    msg.info("Executing Command: " .. cmd)
    
    -- Execute
    os.execute(cmd)

    -- Update OSD when done
    mp.osd_message("✔ Copied to: " .. safe_album, 3)
end

-- Bind the key
mp.add_key_binding(KEY_BINDING, "archive-media", archive_file)

print("MPV Album Archiver loaded. Target: " .. ARCHIVE_ROOT)
print("Usage: Ensure file has 'Album' tag and press " .. KEY_BINDING)