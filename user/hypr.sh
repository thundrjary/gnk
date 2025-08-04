#!/bin/bash
# Minimal Hyprland + Kitty setup
# Modern Wayland desktop with beautiful terminal
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

install_if_missing hyprland
install_if_missing kitty
install_if_missing ttf-jetbrains-mono
install_if_missing nnotofonts
install_if_missing ttf-font-awesome
install_if_missing xdg-desktop-portal-hyprland
install_if_missing xdg-desktop-portal-gtk
install_if_missing hyprshot
install_if_missing hyprpicker
install_if_missing hyprlock
install_if_missing hypridle
install_if_missing hyprland-qtutils
install_if_missing mako
install_if_missing polkit
install_if_missing wlroots
install_if_missing slurp
install_if_missing satty
install_if_missing pipewire
install_if_missing wireplumber
install_if_missing wl-clipboard
