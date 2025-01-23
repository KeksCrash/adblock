#!/bin/bash

# Directory where adblock lists will be stored
BLOCKLIST_DIR="/sd/adblock/lists"
LOG_FILE="/sd/adblock/adblock_update.log"
REPO_DIR="/sd/adblock"

# List of URLs of adblock sources
declare -A blocklists=(
    ["https://github.com/AdAway/adaway.github.io"]="adaway_blocklist.txt"
    ["https://adguard.com"]="adguard_blocklist.txt"
    ["https://github.com/Perflyst/PiHoleBlocklist"]="android_tracking_blocklist.txt"
    ["https://github.com/privacy-protection-tools/anti-A"]="anti_ad_blocklist.txt"
    ["https://github.com/anudeepND/blacklist"]="anudeep_blocklist.txt"
    ["https://github.com/hoshsadiq/adblock-nocoin-list"]="bitcoin_blocklist.txt"
    ["https://disconnect.me"]="disconnect_blocklist.txt"
    ["https://energized.pro"]="energized_blocklist.txt"
    ["https://github.com/abyssin/pihole-blocklist"]="gaming_blocklist.txt"
    ["https://easylist.to"]="easylist_blocklist.txt"
)

# Function to download blocklists
download_blocklist() {
    local url=$1
    local filename=$2
    local output_file="$BLOCKLIST_DIR/$filename"

    echo "[INFO] Downloading blocklist from $url..." | tee -a "$LOG_FILE"
    
    # Download the file using curl
    curl -s -o "$output_file" "$url"

    if [[ $? -eq 0 ]]; then
        echo "[INFO] Successfully downloaded: $filename" | tee -a "$LOG_FILE"
    else
        echo "[ERROR] Failed to download: $filename" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Function to update the local repository (if needed, e.g., for pushing to GitHub or any server)
update_local_repo() {
    echo "[INFO] Updating local repository..." | tee -a "$LOG_FILE"
    
    cd "$REPO_DIR" || { echo "[ERROR] Repository directory not found!"; exit 1; }

    git add .
    git commit -m "Update blocklists"
    git push origin

    if [[ $? -eq 0 ]]; then
        echo "[INFO] Successfully updated repository." | tee -a "$LOG_FILE"
    else
        echo "[ERROR] Failed to update repository." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Main Script

echo "[INFO] Starting Adblock list update process..." | tee -a "$LOG_FILE"

# Create blocklist directory if not exists
mkdir -p "$BLOCKLIST_DIR"

# Loop over the blocklist URLs and download each
for url in "${!blocklists[@]}"; do
    filename="${blocklists[$url]}"
    download_blocklist "$url" "$filename"
done

# Update the local repository if necessary (Optional)
update_local_repo

echo "[INFO] All blocklists are up-to-date!" | tee -a "$LOG_FILE"

