#!/bin/bash

# 1. Update and install xrdp
sudo apt update && sudo apt install xrdp -y

# 2. Stop services to apply changes
sudo systemctl stop xrdp
sudo systemctl stop xrdp-sesman

# 3. Configure xrdp.ini to use Hyper-V vsock and correct security layer
sudo sed -i 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/use_vsock=false/use_vsock=false/g' /etc/xrdp/xrdp.ini # Required for certain handshakes
sudo sed -i 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini

# 4. Add xrdp to the ssl-cert group to avoid permission issues
sudo adduser xrdp ssl-cert

# 5. Start services
sudo systemctl enable --now xrdp
sudo systemctl restart xrdp

echo "Ubuntu configuration complete. Please SHUT DOWN the VM now."
