
#!/bin/bash
# Minimal Hyprland + Kitty setup
# Modern Wayland desktop with beautiful terminal

set -euo pipefail

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
