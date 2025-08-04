#!/bin/bash
set -euo pipefail

yay -S --noconfirm --needed \
    libinput \
    xf86-input-wacom \
    libwacom \
    iio-sensor-proxy \

modprobe elan_i2c || echo "isssue running modprobe elan_ii2c"
