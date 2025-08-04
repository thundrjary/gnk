#!/bin/bash
set -euo pipefail

yay -S --noconfirm --needed \
    linux-firmware \
    intel-ucode \
    intel-media-driver \
    mesa
