#!/bin/bash
# Technitium DNS Server updater script

set -e

TDS_URL="https://technitium.com/dns/Technitium.DNS.Server-Linux-x64.tar.gz"
INSTALL_DIR="/opt/technitium-dns"
BACKUP_DIR="/opt/technitium-dns-backup-$(date +%F_%H%M%S)"

echo "=== Updating Technitium DNS Server ==="

# Stop service
echo "Stopping Technitium DNS Server..."
sudo systemctl stop technitium-dns

# Backup current install
echo "Backing up current installation to $BACKUP_DIR..."
sudo cp -r "$INSTALL_DIR" "$BACKUP_DIR"

# Download latest version
echo "Downloading latest version..."
wget -O /tmp/tds.tar.gz "$TDS_URL"

# Extract new version
echo "Extracting new version..."
sudo tar -xvzf /tmp/tds.tar.gz -C "$INSTALL_DIR" --strip-components=1

# Clean up
rm /tmp/tds.tar.gz

# Start service
echo "Starting Technitium DNS Server..."
sudo systemctl start technitium-dns

echo "Update complete! Old version backed up at $BACKUP_DIR"
