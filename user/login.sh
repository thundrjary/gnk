#!/bin/bash
set -euo pipefail
source ../lib/common.sh

install_if_missing greetd
install_if_missing greetd-wlgreet

sudo cp config/greetd/config.toml /etc/greetd/config.toml
sudo cp config/greetd/wlgreet.toml /etc/greetd/wlgreet.toml
sudo systemctl enable greetd
