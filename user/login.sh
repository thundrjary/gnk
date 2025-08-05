#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

install_if_missing greetd
install_if_missing foot
install_if_missing cage

sudo cp config/greetd/config.toml /etc/greetd/config.toml

sudo systemctl enable greetd
