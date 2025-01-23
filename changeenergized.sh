#!/bin/sh

# Energized Protection - https://energized.pro
# Download and install Energized Protection for Linux/Unix-based systems.
# Copyright (c) 2020-2021 Energized Protection (https://energized.pro)

# Set default configuration
source /etc/os-release

# Define settings
sleep_delay=1  # Alle sleep-Befehle auf eine ganze Zahl geändert
install_dir="/etc/energized"
temp_dir="/tmp/energized"
log_file="/var/log/energized.log"
url="https://github.com/EnergizedProtection/Energized_Linux/raw/master/energized.sh"

# Check if root
if [ "$(id -u)" -ne 0 ]; then
    echo "You must be root to run this script."
    exit 1
fi

# Create necessary directories
mkdir -p "$install_dir" "$temp_dir"

# Define functions

# Download the Energized script
download_energized() {
    echo "Downloading Energized Protection script..."
    curl -s -L "$url" -o "$temp_dir/energized.sh"
    sleep $sleep_delay  # sleep auf 1 Sekunde gesetzt
}

# Install Energized Protection
install_energized() {
    echo "Installing Energized Protection..."
    bash "$temp_dir/energized.sh" install
    sleep $sleep_delay  # sleep auf 1 Sekunde gesetzt
}

# Update Energized Protection
update_energized() {
    echo "Updating Energized Protection..."
    bash "$temp_dir/energized.sh" update
    sleep $sleep_delay  # sleep auf 1 Sekunde gesetzt
}

# Log output
log_output() {
    echo "$(date): $1" >> "$log_file"
}

# Main loop
echo "Energized Protection installer"
log_output "Started installing Energized Protection"

# Download and install Energized Protection
download_energized
install_energized

# Final output
log_output "Energized Protection installed successfully"

echo "Energized Protection is installed!"
echo "Check the log at $log_file for details."

