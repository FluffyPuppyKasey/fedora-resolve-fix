#!/bin/bash

# Create a folder to store Resolve's libraries, just in case.
mkdir -p "${pwd}/ResolveLibBackup"

# Install the packages Resolve needs
sudo dnf install libxcrypt-compat apr apr-util mesa-libGLU

xdg-open https://www.blackmagicdesign.com/products/davinciresolve

# Wait for the Davinci Resolve installer to download, and extract the ZIP once it's finished.
download_dir="$HOME/Downloads"
while true; do
    # Check for incomplete download files
    part_files=$(ls "$download_dir"/*.part "$download_dir"/*.crdownload 2>/dev/null | wc -l)
    if [ "$part_files" -eq 0 ]; then
        echo "Download completed! Preparing to run the installer"
        if ls "$download_dir"/*.zip >/dev/null 2>&1; then
            break
        fi
    fi
    sleep 1
done

unzip "$download_dir"/DaVinci_Resolve_*.zip -d "$download_dir"
find "$download_dir" -name DaVinci_Resolve_*.run -exec chmod +x \{\} \;
"$download_dir"/DaVinci_Resolve_*.run

# Move Resolve's libraries to the backup folder we made earlier.
sudo mv /opt/resolve/libs/libgmodule* "${pwd}/ResolveLibBackup/"
sudo mv /opt/resolve/libs/libgio* "${pwd}/ResolveLibBackup/"

echo "Cleaning up!"
rm "$download_dir"/DaVinci_Resolve_*

echo "Install completed. Resolve may show a black screen on the first start, just close it and it should start up!"
