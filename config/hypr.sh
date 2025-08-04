
#!/usr/bin/env bash
# Minimal Hyprland + Kitty setup
# Modern Wayland desktop with beautiful terminal

set -e

yay -S --needed --noconfirm \
    hyprland \
    kitty \
    ttf-jetbrains-mono \
    xdg-desktop-portal-hyprland
