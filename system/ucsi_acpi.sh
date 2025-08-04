#!/bin/bash
# Suppresses ucpi_acpi error which is polluting initial login prompt
set -euo pipefail

BOOT_ENTRY_DIR="/boot/loader/entries"
REQUIRED_OPTS=("quiet" "loglevel=3" "systemd.show_status=no")

heal_options_line() {
    local line="$1"
    for opt in "${REQUIRED_OPTS[@]}"; do
        if ! grep -q -w "$opt" <<< "$line"; then
            line="$line $opt"
        fi
    done
    echo "$line"
}

if [[ -d "$BOOT_ENTRY_DIR" ]]; then
    for entry in "$BOOT_ENTRY_DIR"/*.conf; do
        [[ -f "$entry" ]] || continue
        [[ "$entry" == *fallback* ]] && {
            echo "Skipped: $(basename "$entry") (fallback)"
            continue
        }

        current_opts=$(grep '^options ' "$entry" || true)
        if [[ -z "$current_opts" ]]; then
            echo "ERROR: No 'options' line in $entry" >&2
            continue
        fi

        healed_opts=$(heal_options_line "$current_opts")

        if [[ "$current_opts" != "$healed_opts" ]]; then
            echo "Patching: $(basename "$entry")"
            sudo sed -i "s|^$current_opts\$|$healed_opts|" "$entry"
        else
            echo "OK: $(basename "$entry") already patched"
        fi
    done
fi
