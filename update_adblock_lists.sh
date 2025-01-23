#!/bin/bash 

# Verzeichnisse
BLOCKLIST_DIR="/sd/adblock/lists"
TEMP_DIR="/tmp/adb_"
LOG_FILE="/sd/adblock/adblock_update.log"

# Liste von Blocklisten-URLs und den jeweiligen Ziel-Dateinamen im /tmp/adb_ Verzeichnis
declare -A blocklists=(
    ["https://github.com/AdAway/adaway.github.io"]="adb_list.adaway.gz"
    ["https://adguard.com"]="adb_list.adguard.gz"
    ["https://github.com/Perflyst/PiHoleBlocklist"]="adb_list.firetv_tracking.gz"
    ["https://github.com/privacy-protection-tools/anti-A"]="adb_list.anti_ad.gz"
    ["https://github.com/anudeepND/blacklist"]="adb_list.anudeep.gz"
    ["https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts"]="adb_list.bitcoin.gz"  # Korrigierte URL
    ["https://disconnect.me"]="adb_list.disconnect.gz"
    ["https://energized.pro"]="adb_list.energized.gz"
    ["https://github.com/abyssin/pihole-blocklist"]="adb_list.smarttv_tracking.gz"
    ["https://easylist.to"]="adb_list.reg_de.gz"
    ["https://github.com/Perflyst/PiHoleBlocklist"]="adb_list.reg_de.gz"
    ["https://github.com/Perflyst/PiHoleBlocklist"]="adb_list.smarttv_tracking.gz"
    ["https://github.com/Dawsey21"]="adb_list.spam404.gz"
    ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"]="adb_list.stevenblack.gz"
    ["https://oisd.nl"]="adb_list.oisd_nl.gz"
    ["https://pgl.yoyo.org"]="adb_list.yoyo.gz"
    ["https://raw.githubusercontent.com/utcapitole/blacklist/master/blacklist-general"]="adb_list.utcapitole.gz"
    ["https://raw.githubusercontent.com/utcapitole/blacklist/master/blacklist-porn"]="adb_list.utcapitole_porn.gz"
)

# Funktion zum Herunterladen und Speichern der Blocklisten
download_blocklist() {
    local url=$1
    local filename=$2
    local output_file="$BLOCKLIST_DIR/$filename"

    echo "[INFO] Downloading blocklist from $url..." | tee -a "$LOG_FILE"
    
    # Blockliste herunterladen und in das Zielverzeichnis speichern
    curl -s -o "$output_file" "$url"

    if [[ $? -eq 0 ]]; then
        echo "[INFO] Successfully downloaded: $filename" | tee -a "$LOG_FILE"
    else
        echo "[ERROR] Failed to download: $filename" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Funktion zum Ersetzen der Blocklisten im /tmp/adb_ Verzeichnis
replace_blocklist() {
    local filename=$1
    local local_file="$BLOCKLIST_DIR/$filename"
    local temp_file="$TEMP_DIR/$filename"

    # Sicherstellen, dass die Datei existiert
    if [[ -f "$local_file" ]]; then
        # Ersetze die Datei im /tmp/adb_ Verzeichnis
        cp "$local_file" "$temp_file"
        echo "[INFO] Replaced: $filename" | tee -a "$LOG_FILE"
    else
        echo "[ERROR] File does not exist: $local_file" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Hauptskript

echo "[INFO] Starting Adblock list update process..." | tee -a "$LOG_FILE"

# Erstelle Blocklisten-Verzeichnis, falls es nicht existiert
mkdir -p "$BLOCKLIST_DIR"
mkdir -p "$TEMP_DIR"

# Durchlaufe alle URLs und lade die Blocklisten herunter
for url in "${!blocklists[@]}"; do
    filename="${blocklists[$url]}"
    download_blocklist "$url" "$filename"
done

# Ersetze die Blocklisten im /tmp/adb_ Verzeichnis
for filename in "${blocklists[@]}"; do
    replace_blocklist "$filename"
done

echo "[INFO] All blocklists are up-to-date!" | tee -a "$LOG_FILE"

