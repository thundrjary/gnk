#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

install_if_missing tlp
install_if_missing tlp-rdw
install_if_missing acpi_call
install_if_missing brightnessctl

sudo systemctl enable tlp
