#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR=~/gnk

catch_errors() {
  echo -e "\n\e[31mInstallation failed!\e[0m"
  echo "You can retry by running: bash ~/.local/share/gnk/install.sh"
}

trap catch_errors ERR

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

# Install preqrequisites
source $INSTALL_DIR/preflight/aur.sh

# System Configuration
show_subtext "Setting up system configuration [1/3" yellow
source $INSTALL_DIR/system/core.sh
source $INSTALL_DIR/system/ucsi_acpi.sh
source $INSTALL_DIR/system/detect-keyboard-layout.sh
source $INSTALL_DIR/system/input.sh
source $INSTALL_DIR/system/touchscreen.sh

# User Configuration
show_subtext "Setting up user configuration [2/3]" yellow
#source $INSTALL_DIR/user/terminal.sh
source $INSTALL_DIR/user/login.sh
source $INSTALL_DIR/user/shell.sh
source $INSTALL_DIR/user/hypr.sh
source $INSTALL_DIR/user/utilities.sh

# Updates
show_subtext "Updating system packages [3/3]" yellow
sudo pacman -Syu --noconfirm

# Reboot
show_subtext "Finished. Rebooting now ..." yellow
sleep 2
reboot
