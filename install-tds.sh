#!/bin/bash
# Technitium DNS Server installer & systemd service setup

set -e

# Variables
TDS_URL="https://technitium.com/dns/Technitium.DNS.Server-Linux-x64.tar.gz"
INSTALL_DIR="/opt/technitium-dns"
SERVICE_FILE="/etc/systemd/system/technitium-dns.service"

echo "=== Installing Technitium DNS Server ==="

# Create install directory
sudo mkdir -p "$INSTALL_DIR"

# Download latest version
echo "Downloading Technitium DNS Server..."
wget -O /tmp/tds.tar.gz "$TDS_URL"

# Extract
echo "Extracting files..."
sudo tar -xvzf /tmp/tds.tar.gz -C "$INSTALL_DIR" --strip-components=1

# Clean up
rm /tmp/tds.tar.gz

# Create systemd service
echo "Creating systemd service..."
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Technitium DNS Server
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/dnsserver
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable technitium-dns
sudo systemctl start technitium-dns

echo "Installation complete! Web UI available at http://<server-ip>:5380/"
