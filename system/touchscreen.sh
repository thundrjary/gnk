#!/bin/bash

yay -S --noconfirm --needed \
    wvkbd \
    hyprgrass \
    touchegg

sudo systemctl enable touchegg
