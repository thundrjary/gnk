#!/bin/bash

USER=$(whoami)
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_FILE="$INSTALL_DIR/.state"

show_subtext() {
  # $1 = text, $2 = color (optional), $3 = style (ignored)
  color="${2:-cyan}"
  case "$color" in
    red)     code=31 ;;
    green)   code=32 ;;
    yellow)  code=33 ;;
    blue)    code=34 ;;
    magenta) code=35 ;;
    cyan)    code=36 ;;
    white)   code=37 ;;
    *)       code=0  ;; # default
  esac
  echo -e "\e[1;${code}m$1\e[0m"
  echo
}

install_if_missing() { 
        pacman -Qi "$1" &>/dev/null || yay -S --noconfirm --needed "$1"; 
}

copy_if_different() { 
        cmp -s "$1" "$2" 2>/dev/null || sudo cp "$1" "$2"; 
}

enable_if_disabled() { 
        systemctl is-enabled "$1" &>/dev/null || sudo systemctl enable "$1"; 
}

catch_errors() {
  echo -e "\n\e[31mInstallation failed!\e[0m"
  echo "You can retry by running: bash ~/.local/share/gnk/install.sh"
}
