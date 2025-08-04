#!/usr/bin/env bash
# Simple kmscon installation with JetBrains Mono
# No cleanup, just install and configure

set -e

echo "Installing kmscon with JetBrains Mono..."

# Check if yay (AUR helper) is installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper first..."
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd - > /dev/null
fi

# Install packages (kmscon is in AUR)
yay -S --needed kmscon ttf-jetbrains-mono

# Create kmscon config
sudo mkdir -p /etc/kmscon
sudo tee /etc/kmscon/kmscon.conf > /dev/null << 'EOF'
font-engine=pango
font-name=JetBrains Mono
font-size=16
palette=custom
palette-background=40,40,40
palette-foreground=235,219,178
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

# Optional auto-login
read -p "Enable auto-login? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    USERNAME=$(whoami)
    sudo mkdir -p /etc/systemd/system/kmsconvt@tty1.service.d/
    sudo tee /etc/systemd/system/kmsconvt@tty1.service.d/autologin.conf > /dev/null << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/kmscon --vt=%i --seats=seat0 --no-switchvt --login -- /bin/login -f $USERNAME
EOF
    echo "✓ Auto-login enabled for $USERNAME"
fi

echo ""
echo "✓ kmscon installed with JetBrains Mono 16pt"
echo "✓ Dark color scheme applied"
echo "Reboot to use modern console on tty1!"
