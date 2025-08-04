#!/usr/bin/env bash
# Set up kmscon with JetBrains Mono - no X11 needed
# First cleans up all previous terminal modifications

set -e

echo "Cleaning up previous terminal modifications..."

# Restore original files if backups exist
if [[ -f /etc/issue.bak ]]; then
    sudo cp /etc/issue.bak /etc/issue
    sudo rm /etc/issue.bak
    echo "✓ Restored original /etc/issue"
fi

if [[ -f /etc/vconsole.conf.bak ]]; then
    sudo cp /etc/vconsole.conf.bak /etc/vconsole.conf
    sudo rm /etc/vconsole.conf.bak
    echo "✓ Restored original /etc/vconsole.conf"
fi

# Remove auto-login setup
if [[ -d /etc/systemd/system/getty@tty1.service.d ]]; then
    sudo rm -rf /etc/systemd/system/getty@tty1.service.d
    echo "✓ Removed auto-login configuration"
fi

# Clean up alacritty configs
rm -rf ~/.config/alacritty ~/.config/i3 ~/.xinitrc 2>/dev/null || true
echo "✓ Removed Alacritty/X11 configurations"

# Clean up fbterm
rm -rf ~/.fbtermrc 2>/dev/null || true
sudo pacman -R fbterm --noconfirm 2>/dev/null || true
echo "✓ Removed fbterm"

# Reset bash_profile (remove auto-startx and fbterm lines)
if [[ -f ~/.bash_profile ]]; then
    # Create backup
    cp ~/.bash_profile ~/.bash_profile.bak
    # Remove lines containing startx or fbterm
    sed -i '/startx/d; /fbterm/d; /XDG_VTNR/d; /DISPLAY/d' ~/.bash_profile
    # Remove empty lines at end
    sed -i -e :a -e '/^\s*$/N;ba' -e 's/\n*$//' ~/.bash_profile
    echo "✓ Cleaned ~/.bash_profile"
fi

# Reset any font changes
sudo setfont 2>/dev/null || true

# Re-enable standard getty if it was disabled
sudo systemctl enable getty@tty1.service 2>/dev/null || true

echo "✓ Previous configurations cleaned up"
echo ""
echo "Setting up kmscon with JetBrains Mono..."

# Install kmscon and JetBrains Mono font
sudo pacman -S --needed kmscon ttf-jetbrains-mono

# Create kmscon config directory
sudo mkdir -p /etc/kmscon

# Configure kmscon with JetBrains Mono
sudo tee /etc/kmscon/kmscon.conf > /dev/null << 'EOF'
# kmscon configuration
font-engine=pango
font-name=JetBrains Mono
font-size=16
palette=custom

# Custom color scheme (dark theme)
palette-black=30,30,30
palette-red=204,36,29
palette-green=152,151,26
palette-yellow=215,153,33
palette-blue=69,133,136
palette-magenta=177,98,134
palette-cyan=104,157,106
palette-light-grey=168,153,132
palette-dark-grey=146,131,116
palette-light-red=251,73,52
palette-light-green=184,187,38
palette-light-yellow=250,189,47
palette-light-blue=131,165,152
palette-light-magenta=211,134,155
palette-light-cyan=142,192,124
palette-white=235,219,178

# Background and foreground
palette-background=40,40,40
palette-foreground=235,219,178
EOF

# Replace getty with kmscon on tty1
sudo systemctl disable getty@tty1.service
sudo systemctl enable kmscon@tty1.service

# Clean login message (kmscon will use this)
echo "Hello!" | sudo tee /etc/issue > /dev/null

# Optional: Set up auto-login with kmscon
read -p "Enable auto-login? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    USERNAME=$(whoami)
    sudo mkdir -p /etc/systemd/system/kmscon@tty1.service.d/
    sudo tee /etc/systemd/system/kmscon@tty1.service.d/autologin.conf > /dev/null << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/kmscon --vt=%i --seats=seat0 --no-switchvt --login -- /bin/login -f $USERNAME
EOF
    echo "✓ Auto-login enabled for $USERNAME"
fi

echo "✓ kmscon installed with JetBrains Mono"
echo "✓ TrueType font rendering enabled"
echo "✓ Modern color scheme applied"
echo "✓ Clean login message set"
echo ""
echo "Reboot to use kmscon on tty1!"
echo "Regular TTYs (tty2-6) will still be available."
