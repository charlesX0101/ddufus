# ddufus: User Manual

A lightweight, TTY-based tool for safely flashing .img and .iso files to USB drives and SD cards on Linux.

This manual walks you through the full usage of the script, from download to successful flashing.

## 1. Download the Script

Place the `ddufus.sh` script into a working directory. For example:

~/Downloads/ddufus/ddufus.sh

## 2. Make the Script Executable

Open a terminal, navigate to the directory, and run:

chmod +x ddufus.sh

## 3. Run the Script

Execute the script with:

./ddufus.sh

If you're not in the same directory, provide the full path:

bash ~/Downloads/ddufus/ddufus.sh

## 4. Main Menu Overview

Once launched, the tool shows a simple TTY interface:

1) Select Source Image 
2) Select Target Device 
3) Flash 
q) Quit

## 5. Select Source Image

Select option 1. This opens a clean TTY file browser.

- Use the numbered prompt to navigate into directories or select image files.
- Directories are shown first, files second.
- Dotfiles are hidden to reduce clutter.
- Only .img, .iso, and .xz files are supported.

If you select a .xz file:
- The script will attempt to decompress it in-place.
- The resulting .img or .iso file will become the selected source.

Use `b` to go up one directory 
Use `q` to cancel and return to the main menu

## 6. Select Target Device

Select option 2. This shows a list of connected block devices.

Example output:

sda   512G   Samsung SSD 
sdb   16G    SanDisk USB 

To select the target device, type only the device name (not the full path). For example:

sdb

The script checks `/dev/sdb` and confirms it is a valid block device.

**Be careful to select the correct device. This script uses dd and will overwrite the entire target.**

## 7. Flash the Image

Select option 3.

If both the source and target are valid, the script runs:

sudo dd if=/path/to/image.img of=/dev/sdX bs=4M status=progress conv=fsync

This may take several minutes. You will see progress output in the terminal.

Once complete, it performs a sync and informs you when it is safe to remove the device.

## 8. Quit

Select `q` from the main menu to exit the script.

## Notes

- This script does not require installation.
- It assumes basic familiarity with Linux terminal use.
- It is designed to be portable and simple, and to avoid accidentally wiping system drives.


