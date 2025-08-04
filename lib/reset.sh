#!/bin/bash

perform_reset() {
    echo "Performing system reset to first snapshot..."

    local first_snap=$(sudo snapper -c root list | awk 'NR>3 && $1 != "0" {print $1; exit}')

    if [[ -n "$first_snap" ]]; then
        echo "Rolling back to snapshot $first_snap"
        sudo snapper -c root rollback "$first_snap"

        # Create post-reboot script
        cat > /tmp/restore-gnk.sh << 'EOF'
#!/bin/bash
# Auto-restore GNK after reset
sleep 10  # Wait for system to settle

# Clone fresh repo
git clone https://github.com/thundrjary/gnk.git ~/.local/share/gnk

# Ensure scripts are executable
find ~/.local/share/gnk -type f -name '*.sh' -exec chmoc +x {} +

# Run installation
bash ~/.local/share/gnk/install.sh

# Clean up
rm /tmp/restore-gnk.sh
crontab -r 2>/dev/null || true
EOF
        chmod +x /tmp/restore-gnk.sh

        # Schedule to run after reboot
        echo "@reboot /tmp/restore-gnk.sh" | crontab -

        echo "System will reboot and auto-reinstall GNK..."
        sleep 3
        sudo reboot
    else
        echo "Error: No suitable snapshot found"
        exit 1
    fi
}
