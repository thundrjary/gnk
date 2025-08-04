#!/bin/bash

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
