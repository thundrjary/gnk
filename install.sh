#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR=~/.local/share/gnk
cd "$INSTALL_DIR"

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

# CREATE SNAPSHOT
show_subtext "Setting up snapshots [1/4" yellow
source $INSTALL_DIR/system/snapshots.sh

DESC="pre-change-$(date -u +%Y%m%dT%H%M%SZ)"

# .. Ensure snapper exists and is configured
if ! command -v snapper &>/dev/null; then
    echo "Error: snapper not found" >&2
    exit 1
fi

if [[ ! -f /etc/snapper/configs/root ]]; then
    echo "Error: snapper config for 'root' not found" >&2
    exit 1
fi

# .. Create snapshot and validate
SNAP_ID=$(sudo snapper -c root create --print-number --description "$DESC") || {
    echo "Error: snapshot creation failed" >&2
    exit 1
}

# .. Confirm snapshot is listed
if ! sudo snapper -c root list | awk '{print $1}' | grep -qx "$SNAP_ID"; then
    echo "Error: snapshot $SNAP_ID not found after creation" >&2
    exit 1
fi

echo "Snapshot $SNAP_ID ($DESC) created successfully"

# INSTALL PREREQUISITES
source $INSTALL_DIR/preflight/aur.sh

# SYSTEM CONFIGURATION
show_subtext "Setting up system configuration [2/4" yellow
source $INSTALL_DIR/system/core.sh
source $INSTALL_DIR/system/ucsi_acpi.sh
source $INSTALL_DIR/system/detect-keyboard-layout.sh
source $INSTALL_DIR/system/input.sh
source $INSTALL_DIR/system/touchscreen.sh

# USER CONFIGURATION
show_subtext "Setting up user configuration [3/4]" yellow
#source $INSTALL_DIR/user/terminal.sh
source $INSTALL_DIR/user/login.sh
source $INSTALL_DIR/user/shell.sh
source $INSTALL_DIR/user/hypr.sh
source $INSTALL_DIR/user/utilities.sh

# UPDATES
show_subtext "Updating system packages [4/4]" yellow
sudo pacman -Syu --noconfirm

# REBOOT
show_subtext "Finished. Rebooting now ..." yellow
sleep 2
sudo reboot
