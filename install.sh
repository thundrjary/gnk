#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR=~/.local/share/gnk/

catch_errors() {
  echo -e "\n\e[31mInstallation failed!\e[0m"
  echo "You can retry by running: bash ~/.local/share/gnk/install.sh"
}

trap catch_errors ERR

show_subtext() {
  echo "$1" | tte --frame-rate ${3:-640} ${2:-wipe}
  echo
}

# Install preqrequisites
# ...

# Configuration
show_subtext "Setting up system configuration [1/2]"
source $INSTALL_DIR/system/ucsi_acpi.sh

# Updates
show_subtext "Updating system packages [2/2]"
sudo updatedb
sudo pacman -Syu --noconfirm

# Reboot
show_subtext "Finished. Rebooting now ..."
sleep 2
reboot
