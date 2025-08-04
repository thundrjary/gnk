#!/bin/bash
set -euo pipefail
source ../lib/common.sh

install_if_missing libinput
install_if_missing xf86-input-wacom
install_if_missing libwacom
install_if_missing iio-sensor-proxy

modprobe elan_i2c || echo "isssue running modprobe elan_ii2c"
