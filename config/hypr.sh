
#!/usr/bin/env bash
# Minimal Hyprland + Kitty setup
# Modern Wayland desktop with beautiful terminal

set -euo pipefail

SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/hyprland.service"
BIN_PATH="/usr/bin/Hyprland"

yay -S --needed --noconfirm \
    hyprland \
    ghostty \
    ttf-jetbrains-mono \
    xdg-desktop-portal-hyprland

# Ensure service directory exists
mkdir -p "$SERVICE_DIR"

# Create or overwrite the service file only if content differs
read -r -d '' SERVICE_CONTENT <<EOF
[Unit]
Description=Hyprland Wayland Session
After=graphical-session.target

[Service]
ExecStart=$BIN_PATH
Restart=always
Environment=PATH=%h/.local/bin:/usr/local/bin:/usr/bin
Environment=XDG_SESSION_TYPE=wayland

[Install]
WantedBy=default.target
EOF

# Write only if different
if [[ ! -f "$SERVICE_FILE" || "$(cat "$SERVICE_FILE")" != "$SERVICE_CONTENT" ]]; then
    echo "$SERVICE_CONTENT" > "$SERVICE_FILE"
fi

# Enable the service if not already enabled
if ! systemctl --user is-enabled --quiet hyprland.service; then
    systemctl --user daemon-reload
    systemctl --user enable hyprland.service
fi
