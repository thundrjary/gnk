
#!/usr/bin/env bash
# Minimal Hyprland + Kitty setup
# Modern Wayland desktop with beautiful terminal

set -e

echo "Setting up minimal Hyprland + Kitty environment..."

# Install packages
yay -S --needed --noconfirm \
    hyprland \
    kitty \
    ttf-jetbrains-mono \
    waybar \
    wofi \
    xdg-desktop-portal-hyprland

echo "✓ Installed Hyprland and dependencies"

# Create Hyprland config directory
mkdir -p ~/.config/hypr

# Create minimal Hyprland config
cat > ~/.config/hypr/hyprland.conf << 'EOF'
# Hyprland configuration

# Monitor setup
monitor=,preferred,auto,1

# Input configuration
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
    sensitivity = 0
}

# General settings
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(5579f0ee) rgba(a665d0ee) 45deg
    col.inactive_border = rgba(393939aa)
    layout = dwindle
    allow_tearing = false
}

# Decoration
decoration {
    rounding = 8
    blur {
        enabled = true
        size = 8
        passes = 1
    }
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Layout
dwindle {
    pseudotile = true
    preserve_split = true
}

# Window rules
windowrulev2 = float,class:^(wofi)$

# Keybindings
$mainMod = SUPER

# Basic bindings
bind = $mainMod, RETURN, exec, kitty
bind = $mainMod, Q, killactive
bind = $mainMod, M, exit
bind = $mainMod, V, togglefloating
bind = $mainMod, D, exec, wofi --show drun
bind = $mainMod, P, pseudo
bind = $mainMod, J, togglesplit

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Mouse bindings
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Auto-start
exec-once = waybar
exec-once = kitty
EOF

echo "✓ Created Hyprland configuration"

# Create Kitty config directory
mkdir -p ~/.config/kitty

# Create Kitty config with your color scheme
cat > ~/.config/kitty/kitty.conf << 'EOF'
# Kitty configuration

# Font
font_family JetBrains Mono
font_size 16.0
bold_font auto
italic_font auto
bold_italic_font auto

# Cursor
cursor_shape block
cursor_blink_interval 0

# Scrollback
scrollback_lines 10000

# Mouse
copy_on_select yes
strip_trailing_spaces smart

# Window
window_padding_width 8
confirm_os_window_close 0

# Modern color scheme (based on your palette)
background #080c10
foreground #b5bdc5

# Black
color0 #181818
color8 #525252

# Red  
color1 #fa4d56
color9 #ff7279

# Green
color2 #42be65
color10 #7ac098

# Yellow
color3 #c8b670
color11 #f8e6a0

# Blue
color4 #5080ff
color12 #78a9ff

# Magenta
color5 #a665d0
color13 #a3a0d8

# Cyan
color6 #50b0e0
color14 #9ac6e0

# White
color7 #b5bdc5
color15 #e0e0e0

# Tab bar
tab_bar_style powerline
tab_powerline_style round
EOF

echo "✓ Created Kitty configuration"

# Create minimal waybar config
mkdir -p ~/.config/waybar

cat > ~/.config/waybar/config << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery"],
    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "1": "1",
            "2": "2", 
            "3": "3",
            "4": "4",
            "5": "5",
            "urgent": "",
            "focused": "",
            "default": ""
        }
    },
    "clock": {
        "format": "{:%H:%M}",
        "format-alt": "{:%Y-%m-%d}"
    },
    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""]
    },
    "network": {
        "format-wifi": "{essid} ",
        "format-ethernet": "Connected ",
        "format-disconnected": "Disconnected ⚠"
    },
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-muted": "🔇",
        "format-icons": {
            "default": ["🔈", "🔉", "🔊"]
        }
    }
}
EOF

cat > ~/.config/waybar/style.css << 'EOF'
* {
    font-family: JetBrains Mono;
    font-size: 13px;
}

window#waybar {
    background-color: rgba(8, 12, 16, 0.9);
    border-bottom: 2px solid rgba(85, 121, 240, 0.9);
    color: #b5bdc5;
}

#workspaces button {
    padding: 0 8px;
    background-color: transparent;
    color: #b5bdc5;
    border: none;
    border-radius: 0;
}

#workspaces button:hover {
    background: rgba(85, 121, 240, 0.2);
}

#workspaces button.active {
    background-color: rgba(85, 121, 240, 0.6);
}

#clock, #battery, #network, #pulseaudio {
    padding: 0 10px;
    color: #b5bdc5;
}

#battery.critical {
    color: #fa4d56;
}
EOF

echo "✓ Created Waybar configuration"

# Set up auto-start script
cat > ~/.profile << 'EOF'
# Auto-start Hyprland on tty1
if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
    exec Hyprland
fi
EOF

echo ""
echo "✓ Minimal Hyprland + Kitty setup complete!"
echo ""
echo "Key bindings:"
echo "  Super + Enter    = Open Kitty terminal"
echo "  Super + D        = Application launcher (wofi)"
echo "  Super + Q        = Close window"
echo "  Super + M        = Exit Hyprland"
echo "  Super + 1-9      = Switch workspaces"
echo "  Super + V        = Toggle floating"
echo "  Super + Arrow    = Move focus"
echo ""
echo "To start Hyprland:"
echo "  1. Reboot or logout"
echo "  2. Login on tty1 (Ctrl+Alt+F1)"
echo "  3. Hyprland will start automatically"
echo ""
echo "Or start manually: Hyprland"
