#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

install_if_missing linux-firmware
install_if_missing intel-ucode
install_if_missing intel-media-driver
install_if_missing mesa
