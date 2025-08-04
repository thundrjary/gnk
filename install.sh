#!/bin/bash
set -euo pipefail

# Import lib/common.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

# INSTALL OPTIONS
# .. revert to base install and reinstall
if [[ "${1:-}" == "--reset" ]]; then
    source "$SCRIPT_DIR/lib/reset.sh"
    perform_reset
    exit 0
fi

trap 'echo -e "\n\e[31mInstallation failed!\e[0m"; echo "Retry: bash install.sh"' ERR

# STEPS
# .. create snapshot
show_subtext "Setting up snapshots [1/4" yellow
source $INSTALL_DIR/system/snapshots.sh

# .. install prerequisites
source $INSTALL_DIR/preflight/aur.sh

# .. system configuration
show_subtext "Setting up system configuration [2/4" yellow
source $INSTALL_DIR/system/core.sh
source $INSTALL_DIR/system/ucsi_acpi.sh
source $INSTALL_DIR/system/detect-keyboard-layout.sh
source $INSTALL_DIR/system/input.sh
source $INSTALL_DIR/system/power.sh

# .. user configuration
show_subtext "Setting up user configuration [3/4]" yellow
source $INSTALL_DIR/user/login.sh
source $INSTALL_DIR/user/shell.sh
source $INSTALL_DIR/user/hypr.sh
source $INSTALL_DIR/user/utilities.sh

# .. updates
show_subtext "Updating system packages [4/4]" yellow
sudo pacman -Syu --noconfirm

# REBOOT
show_subtext "Finished. Rebooting now ..." yellow
sleep 2
sudo reboot
