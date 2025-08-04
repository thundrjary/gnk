#!/bin/bash

ping -c 1 -W 2 8.8.8.8 &>/dev/null || { echo "No internet connection. Fix network and retry."; exit 1; }

sudo pacman -Sy --noconfirm --needed git

# handle repo idempotently
if [[ -d ~/.local/share/gnk ]]; then
        # directory exists; update if it's a git repo
        cd ~/.local/share/gnk && git pull --quiet >/dev/null 2>&1
else
        git clone https://github.com/thundrjary/gnk.git ~/.local/share/gnk >/dev/null
fi

find ~/.local/share/gnk -type f -name '*.sh' -exec chmod +x {} +

# run install script
source ~/.local/share/gnk/install.sh --reset
