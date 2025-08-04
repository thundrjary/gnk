#!/usr/bin/env bash
# Cleanup script to undo kmscon installation and configurations
# Restores system to original state

set -e

echo "Cleaning up kmscon installation and configurations..."

# Remove auto-login configurations
if [[ -d /etc/systemd/system/kmsconvt@tty1.service.d ]]; then
    sudo rm -rf /etc/systemd/system/kmsconvt@tty1.service.d
    echo "✓ Removed auto-login configuration"
fi

# Disable kmsconvt service
if systemctl is-enabled kmsconvt@tty1.service &>/dev/null; then
    sudo systemctl disable kmsconvt@tty1.service
    echo "✓ Disabled kmsconvt@tty1.service"
fi

# Re-enable standard getty service
if ! systemctl is-enabled getty@tty1.service &>/dev/null; then
    sudo systemctl enable getty@tty1.service
    echo "✓ Re-enabled getty@tty1.service"
fi

# Remove kmscon configuration
if [[ -d /etc/kmscon ]]; then
    sudo rm -rf /etc/kmscon
    echo "✓ Removed kmscon configuration directory"
fi

# Restore original login message
if [[ -f /etc/issue.bak ]]; then
    sudo cp /etc/issue.bak /etc/issue
    sudo rm /etc/issue.bak
    echo "✓ Restored original login message from backup"
else
    # Restore default Arch login message
    sudo tee /etc/issue > /dev/null << 'EOF'
Arch Linux \r (\l)

EOF
    echo "✓ Restored default Arch login message"
fi

# Restore original vconsole.conf if backup exists
if [[ -f /etc/vconsole.conf.bak ]]; then
    sudo cp /etc/vconsole.conf.bak /etc/vconsole.conf
    sudo rm /etc/vconsole.conf.bak
    echo "✓ Restored original vconsole.conf"
fi

# Reset console font to default
sudo setfont 2>/dev/null || true
echo "✓ Reset console font to default"

# Reload systemd to pick up changes
sudo systemctl daemon-reload
echo "✓ Reloaded systemd configuration"

# Optional: Remove kmscon package
read -p "Remove kmscon package? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v yay &> /dev/null; then
        yay -R kmscon --noconfirm 2>/dev/null || echo "kmscon package not found or already removed"
    else
        echo "yay not found, cannot remove kmscon package"
    fi
    echo "✓ Attempted to remove kmscon package"
fi

echo ""
echo "✓ Cleanup completed!"
echo "✓ Standard getty@tty1 service restored"
echo "✓ Auto-login configurations removed"
echo "✓ Original login behavior restored"
echo ""
echo "Reboot to return to standard console on tty1"
