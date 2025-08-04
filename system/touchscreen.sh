#!/bin/bash
source ../lib/common.sh

install_if_missing wvkbd
install_if_missing hyprgrass
install_if_missing touchegg

sudo systemctl enable touchegg
