#!/usr/bin/env bash
# Makes login message just say "Hello!" with nicer font
set -e

echo "Setting up fbterm with JetBrains Mono..."

# Install from AUR (fbterm not in main repos)
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper first..."
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
fi

# Install fbterm and font
yay -S --needed fbterm ttf-jetbrains-mono

# Configure fbterm
cat > ~/.fbtermrc << 'EOF'
# fbterm configuration
font-names=JetBrains Mono
font-size=16
color-foreground=7
color-background=0
EOF

# Add user to video group (required for fbterm)
sudo usermod -a -G video $(whoami)

# Create startup script
cat > ~/.bash_profile << 'EOF'
# Start fbterm on tty1
if [[ $TTY == /dev/tty1 ]] && ! pgrep -x fbterm > /dev/null; then
    fbterm
fi
EOF

echo "Hello!" | sudo tee /etc/issue > /dev/null

echo "✓ fbterm configured with JetBrains Mono"
echo "✓ Added user to video group"
echo "✓ Clean login message set"
echo ""
echo "Logout and login to tty1 to use fbterm!"
echo "Note: fbterm is less maintained than kmscon."
