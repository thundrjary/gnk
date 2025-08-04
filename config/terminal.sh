#!/usr/bin/env bash
# Makes login message just say "Hello!" with nicer font

set -e

# Check available fonts first
echo "Checking available large fonts..."
large_fonts=()
for font in ter-132n ter-132b ter-124n ter-124b sun12x22 iso01-12x22; do
    if [[ -f "/usr/share/kbd/consolefonts/${font}.psfu.gz" ]] || [[ -f "/usr/share/kbd/consolefonts/${font}.psf.gz" ]]; then
        large_fonts+=("$font")
    fi
done

if [[ ${#large_fonts[@]} -eq 0 ]]; then
    echo "ERROR: No large fonts found. Install terminus-font package:"
    echo "sudo pacman -S terminus-font"
    exit 1
fi

echo "Found large fonts: ${large_fonts[*]}"
selected_font="${large_fonts[0]}"

# Backup original files (only if backups don't exist)
[[ ! -f /etc/issue.bak ]] && sudo cp /etc/issue /etc/issue.bak 2>/dev/null || true
[[ ! -f /etc/vconsole.conf.bak ]] && sudo cp /etc/vconsole.conf /etc/vconsole.conf.bak 2>/dev/null || true

# Set simple login message
echo "Hello!" | sudo tee /etc/issue > /dev/null

# Set large console font permanently
echo "FONT=$selected_font" | sudo tee /etc/vconsole.conf > /dev/null

# Apply font change immediately using setfont
echo "Applying font $selected_font..."
sudo setfont "$selected_font"

echo "✓ Login message set to 'Hello!'"
echo "✓ Console font changed to $selected_font"
echo "✓ Font applied immediately and will persist after reboot"
