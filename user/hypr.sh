
#!/usr/bin/env bash
# Minimal Hyprland + Kitty setup
# Modern Wayland desktop with beautiful terminal

set -euo pipefail

SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/hyprland.service"
BIN_PATH="/usr/bin/Hyprland"

yay -S --needed --noconfirm \
    hyprland \
    kitty \
    ttf-jetbrains-mono nnotofonts ttf-font-awesome \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    hyprshot hyprpicker hyprlock hypridle hyprland-qtutils \
    mako \
    polkit \
    wlroots \
    slurp satty \
    pipewire wireplumber \
    wl-clipboard
