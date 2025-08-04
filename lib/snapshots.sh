#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

create_snapshot() {
    # Install snapper if needed
    install_if_missing snapper

    # Configure if needed
    if [[ ! -f /etc/snapper/configs/root ]]; then
        sudo snapper -c root create-config /
    fi

    # Create snapshot
    local desc="pre-gnk-$(date -u +%Y%m%dT%H%M%SZ)"
    local snap_id=$(sudo snapper -c root create --print-number --description "$desc")
    echo "Created snapshot $snap_id"
}
