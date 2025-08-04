#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

install_if_missing bat
install_if_missing btop
install_if_missing eza
install_if_missing fd
install_if_missing fzf
install_if_missing man
install_if_missing ripgrep
install_if_missing tzupdate
install_if_missing zoxide
