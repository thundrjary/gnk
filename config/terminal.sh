#!/usr/bin/env bash
# Simple kmscon installation with JetBrains Mono
# Non-interactive, no auto-login

set -e

echo "Installing kmscon with JetBrains Mono..."

# Check if yay (AUR helper) is installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper first..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd - > /dev/null
    rm -rf /tmp/yay
fi

# Install packages (kmscon is in AUR)
yay -S --needed --noconfirm kmscon ttf-jetbrains-mono

# Create kmscon config
sudo mkdir -p /etc/kmscon
sudo tee /etc/kmscon/kmscon.conf > /dev/null << 'EOF'
font-engine=pango
font-name=JetBrains Mono
font-size=24
palette=custom

# Modern dark color scheme based on your palette
# Dark variants (0-7)
palette-black=24,24,24
palette-red=250,77,86
palette-green=66,190,101
palette-yellow=200,182,112
palette-blue=80,128,255
palette-magenta=166,101,208
palette-cyan=80,176,224
palette-white=181,189,197

# Light variants (8-15)
palette-dark-grey=82,82,82
palette-light-red=255,114,121
palette-light-green=122,192,152
palette-light-yellow=248,230,160
palette-light-blue=120,169,255
palette-light-magenta=163,160,216
palette-light-cyan=154,198,224
palette-light-grey=224,224,224

# Background and foreground
palette-background=8,12,16
palette-foreground=224,224,224
EOF

# Enable kmsconvt on tty1 (correct service name)
if systemctl is-enabled getty@tty1.service &>/dev/null; then
    sudo systemctl disable getty@tty1.service
    echo "✓ Disabled getty@tty1.service"
fi

sudo systemctl enable kmsconvt@tty1.service
echo "✓ Enabled kmsconvt@tty1.service"

# Set clean login message
echo "Hello!" | sudo tee /etc/issue > /dev/null
echo "✓ Set clean login message"

echo ""
echo "✓ kmscon installed with JetBrains Mono 20pt"
echo "✓ Modern dark color scheme applied"
echo "✓ No auto-login configured"
echo "Reboot to use modern console on tty1!"
