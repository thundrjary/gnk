#!/bin/bash
set -euo pipefail

# Verify btrfs in use
if ! findmnt -n -o FSTYPE / | grep -q btrfs; then
    echo "Error: Root is not on Btrfs. Snapper requires Btrfs." >&2
    exit 1
fi

# Install snapper if not present
if ! command -v snapper &>/dev/null; then
    yay -S --noconfirm --needed snapper
fi

# Create config only if it doesn't exist
if [[ ! -f /etc/snapper/configs/root ]]; then
    sudo snapper -c root create-config /
fi

# Ensure /.snapshots directory exists and is configured
if [[ ! -d /.snapshots ]]; then
    sudo mkdir /.snapshots
fi

# Set correct ownership and permissions
sudo chown :wheel /.snapshots
sudo chmod 750 /.snapshots
