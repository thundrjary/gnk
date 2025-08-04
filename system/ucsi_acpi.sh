#!/usr/bin/env bash

set -euo pipefail

if [[ -d "/boot/loader/entries" ]]; then # systemd-boot
elif [[ -f "/etc/default/grub" ]]; then # grub
elif [[ -d "/etc/cmdline.d" ]]; then # UKI
elif [[ -f "/etc/kernel/cmdline" ]]; then # UKI Alt
else
        echo ""
        echo " None of systemd-boot, GRUB, or UKI detected.  Please manually add these kernel parameters:"
        echo "   - splash (to see the graphical splash screen)"
        echo "   - quiet (for silent boot)"
        echo ""
fi
