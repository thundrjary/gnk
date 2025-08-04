#!/bin/bash

USER=$(whoami)

install_if_missing() { 
        pacman -Qi "$1" &>/dev/null || yay -S --noconfirm --needed "$1"; 
}

copy_if_different() { 
        cmp -s "$1" "$2" 2>/dev/null || sudo cp "$1" "$2"; 
}

enable_if_disabled() { 
        systemctl is-enabled "$1" &>/dev/null || sudo systemctl enable "$1"; 
}

# install.sh and all subscripts:
source lib/common.sh
