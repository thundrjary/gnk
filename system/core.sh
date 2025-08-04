#!/bin/bash
set -euo pipefail

yay -S --noconfirm \
    linux-firmware \
    intel-ucode \
    intel-media-driver \
    mesa
