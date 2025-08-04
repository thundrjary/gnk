#!/usr/bin/env bash
# Makes login message just say "Hello!" with nicer font

set -e

# Backup original files (only if backups don't exist)
[[ ! -f /etc/issue.bak ]] && sudo cp /etc/issue /etc/issue.bak 2>/dev/null || true
[[ ! -f /etc/vconsole.conf.bak ]] && sudo cp /etc/vconsole.conf /etc/vconsole.conf.bak 2>/dev/null || true

# Set simple login message
echo "Hello, Mayla!" | sudo tee /etc/issue > /dev/null

# Set large console font (Terminus 13x32 - much bigger)
echo "FONT=ter-132n" | sudo tee /etc/vconsole.conf > /dev/null

# Apply font change immediately
sudo systemctl restart systemd-vconsole-setup 2>/dev/null || true

echo "Login message set to 'Hello!'"
echo "Console font changed to Terminus 13x32 (large)"
