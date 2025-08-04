#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

install_if_missing libinput
install_if_missing xf86-input-wacom
install_if_missing libwacom
install_if_missing iio-sensor-proxy

# touchscren gestures
install_if_missing wvkbd
install_if_missing hyprgrass
install_if_missing touchegg


modprobe elan_i2c || echo "isssue running modprobe elan_ii2c"
