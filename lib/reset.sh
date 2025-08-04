#!/bin/bash

perform_reset() {
    echo "Performing system reset to first snapshot..."

    local first_snap=$(sudo snapper -c root list | awk 'NR>3 && $1 != "0" {print $1; exit}')

    if [[ -n "$first_snap" ]]; then
        echo "Rolling back to snapshot $first_snap"
        sudo snapper -c root rollback "$first_snap"
        echo "System will reboot to complete rollback..."
        sleep 3
        sudo reboot
    else
        echo "Error: No suitable snapshot found"
        exit 1
    fi
}
