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
font-size=20
palette=custom

# Xcode Dark color scheme (16 standard ANSI colors)
palette-black=65,68,83
palette-red=255,129,112
palette-green=120,194,179
palette-yellow=217,201,124
palette-blue=78,176,204
palette-magenta=255,122,178
palette-cyan=178,129,235
palette-white=223,223,224
palette-dark-grey=127,140,152
palette-light-red=255,129,112
palette-light-green=172,242,228
palette-light-yellow=255,161,79
palette-light-blue=107,223,255
palette-light-magenta=255,122,178
palette-light-cyan=218,186,255
palette-light-grey=223,223,224

# Background and foreground
palette-background=41,42,48
palette-foreground=223,223,224
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
echo "✓ kmscon installed with JetBrains Mono 16pt"
echo "✓ Dark color scheme applied"
echo "✓ No auto-login configured"
echo "Reboot to use modern console on tty1!"
