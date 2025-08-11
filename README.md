# ddufus

ddufus is a lightweight TTY-style ISO and IMG flasher for Linux. It provides a clean terminal UI, safe device selection, and built-in xz decompression. It requires no GUI and no installer.

## Features

Simple interactive menu in pure Bash 
File browser filters out hidden dotfiles 
Directories are listed above files 
Automatically detects iso, img, and xz files 
Decompresses xz files in place 
Device selection uses lsblk for safety 
Uses dd with status=progress and conv=fsync 
Fully portable with no external dependencies beyond coreutils

## Usage

1. Clone or copy the script 
   git clone https://github.com/charlesX0101/ddufus 
   cd ddufus 
   chmod +x ddufus.sh

2. Run from terminal 
   ./ddufus.sh

3. Follow the prompts 
   Select Source Image - navigate to an iso, img, or xz file 
   Select Target Device - choose from available devices via lsblk 
   Flash - writes the image to the device using dd with progress

Note: Always double-check the target device. dd will overwrite it with no confirmation.

## File Support

Supports .img and .iso directly 
Supports .xz with automatic decompression using unxz 
Unsupported file types such as .zip or .7z will trigger a warning and be ignored

## Philosophy

ddufus is written for users who prefer terminal-based tools and want full control over how images are selected and written. It is simple, portable, and transparent. It assumes you have basic familiarity with device names and the risks of using dd.

## License

MIT License

