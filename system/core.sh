#!/bin/bash
set -euo pipefail
source ../lib/common.sh

install_if_missing linux-firmware
install_if_missing intel-ucode
install_if_missing intel-media-driver
install_if_missing mesa
