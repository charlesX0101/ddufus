#!/bin/bash

# ddufus.sh: TTY ISO/img flasher with safe device selection and decompression

SOURCE_IMAGE=""
TARGET_DEVICE=""

# Function to browse for image source file
browse_source() {
    local current_dir="$HOME"
    while true; do
        clear
        echo "==== Browse for Source Image ===="
        echo "Current Directory: $current_dir"
        echo

        mapfile -t all_entries < <(ls -1A "$current_dir" | grep -v '^\.')

        dirs=()
        files=()
        for entry in "${all_entries[@]}"; do
            if [[ -d "$current_dir/$entry" ]]; then
                dirs+=("$entry")
            else
                files+=("$entry")
            fi
        done

        IFS=$'\n' sorted_dirs=($(sort <<<"${dirs[*]}"))
        IFS=$'\n' sorted_files=($(sort <<<"${files[*]}"))
        unset IFS

        entries=("${sorted_dirs[@]}" "${sorted_files[@]}")

        for i in "${!entries[@]}"; do
            if [[ -d "$current_dir/${entries[$i]}" ]]; then
                echo "$((i+1))) [DIR] ${entries[$i]}"
            else
                echo "$((i+1))) ${entries[$i]}"
            fi
        done

        echo
        echo "b) Go up one directory"
        echo "q) Cancel"
        echo
        read -rp "Choose an entry: " choice

        if [[ "$choice" == "b" ]]; then
            current_dir=$(dirname "$current_dir")
        elif [[ "$choice" == "q" ]]; then
            return
        elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#entries[@]} )); then
            selected="${entries[$((choice-1))]}"
            selected_path="$current_dir/$selected"
            if [[ -d "$selected_path" ]]; then
                current_dir="$selected_path"
            else
                ext="${selected_path##*.}"
                case "$ext" in
                    img|iso) SOURCE_IMAGE="$selected_path"; return ;;
                    xz)
                        echo "Decompressing $selected_path..."
                        unxz -k "$selected_path" || { echo "Failed to decompress."; sleep 2; return; }
                        SOURCE_IMAGE="${selected_path%.xz}"
                        return
                        ;;
                    *) echo "Unsupported file type."; sleep 2 ;;
                esac
            fi
        else
            echo "Invalid choice."
            sleep 1
        fi
    done
}

# Function to select target device
select_target_device() {
    clear
    echo "==== Select Target Device ===="
    lsblk -d -o NAME,SIZE,MODEL
    echo
    read -rp "Enter target device (e.g., sdb): " device
    if [[ -b "/dev/$device" ]]; then
        TARGET_DEVICE="/dev/$device"
    else
        echo "Invalid device."
        sleep 2
    fi
}

# Flash image
flash_image() {
    if [[ -z "$SOURCE_IMAGE" || -z "$TARGET_DEVICE" ]]; then
        echo "Source or Target not selected."
        sleep 2
        return
    fi
    echo "Flashing $SOURCE_IMAGE to $TARGET_DEVICE..."
    sudo dd if="$SOURCE_IMAGE" of="$TARGET_DEVICE" bs=4M status=progress conv=fsync
    sync
    echo "Done. You can now safely remove the device."
    read -n 1 -s -r -p "Press any key to continue..."
}

# Main menu
main_menu() {
    while true; do
        clear
        echo "==== ddufus: USB/SD Flasher for Linux ===="
        echo
        echo "1) Select Source Image"
        echo "2) Select Target Device"
        echo "3) Flash"
        echo "q) Quit"
        echo
        [[ -n "$SOURCE_IMAGE" ]] && echo "Source: $SOURCE_IMAGE"
        [[ -n "$TARGET_DEVICE" ]] && echo "Target: $TARGET_DEVICE"
        echo
        read -rp "Choose an option: " opt
        case "$opt" in
            1) browse_source ;;
            2) select_target_device ;;
            3) flash_image ;;
            q) exit 0 ;;
            *) echo "Invalid option."; sleep 1 ;;
        esac
    done
}

main_menu
