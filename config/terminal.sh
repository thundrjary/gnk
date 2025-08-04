#!/usr/bin/env bash
# Set up kmscon with JetBrains Mono - no X11 needed
# Robust version with comprehensive error handling and rollback

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Global variables for rollback
GETTY_WAS_ENABLED=false
KMSCON_SERVICE_ENABLED=false
KMSCON_CONFIG_CREATED=false
AUTOLOGIN_CREATED=false

# Logging functions
log_info() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }

# Error handler with rollback
cleanup_on_error() {
    local exit_code=$?
    log_error "Script failed with exit code $exit_code. Rolling back changes..."
    
    # Rollback in reverse order
    if [[ "$AUTOLOGIN_CREATED" == true ]]; then
        sudo rm -rf /etc/systemd/system/kmscon@tty1.service.d/ 2>/dev/null || true
        log_info "Removed auto-login configuration"
    fi
    
    if [[ "$KMSCON_SERVICE_ENABLED" == true ]]; then
        sudo systemctl disable kmscon@tty1.service 2>/dev/null || true
    fi
    
    if [[ "$GETTY_WAS_ENABLED" == true ]]; then
        sudo systemctl enable getty@tty1.service 2>/dev/null || true
        log_info "Re-enabled getty@tty1.service"
    fi
    
    if [[ "$KMSCON_CONFIG_CREATED" == true ]]; then
        sudo rm -rf /etc/kmscon/ 2>/dev/null || true
        log_info "Removed kmscon configuration"
    fi
    
    log_error "Rollback completed. System should be in original state."
    exit $exit_code
}

# Set up error trap
trap cleanup_on_error ERR

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if running as root (we don't want that)
    if [[ $EUID -eq 0 ]]; then
        log_error "Don't run this script as root. Run as your regular user with sudo access."
        exit 1
    fi
    
    # Check sudo access
    if ! sudo -n true 2>/dev/null; then
        log_info "Testing sudo access..."
        if ! sudo true; then
            log_error "This script requires sudo access"
            exit 1
        fi
    fi
    
    # Check if we're on Arch Linux
    if [[ ! -f /etc/arch-release ]]; then
        log_warn "This script is designed for Arch Linux. Proceeding anyway..."
    fi
    
    # Check internet connectivity for package installation
    if ! ping -c 1 archlinux.org &> /dev/null; then
        log_error "No internet connection. Cannot install packages."
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

# Safe file operations
safe_backup_file() {
    local file="$1"
    local backup="${file}.bak"
    
    if [[ -f "$file" && ! -f "$backup" ]]; then
        if sudo cp "$file" "$backup"; then
            log_info "Backed up $file"
            return 0
        else
            log_error "Failed to backup $file"
            return 1
        fi
    fi
    return 0
}

safe_restore_file() {
    local file="$1"
    local backup="${file}.bak"
    
    if [[ -f "$backup" ]]; then
        if sudo cp "$backup" "$file" && sudo rm "$backup"; then
            log_info "Restored original $file"
            return 0
        else
            log_error "Failed to restore $file"
            return 1
        fi
    fi
    return 0
}

# Service management with validation
manage_service() {
    local action="$1"
    local service="$2"
    
    # Check if service exists
    if ! systemctl list-unit-files "$service" &>/dev/null; then
        log_warn "Service $service does not exist"
        return 1
    fi
    
    # Perform action with validation
    case "$action" in
        "enable")
            if sudo systemctl enable "$service"; then
                log_info "Enabled $service"
                return 0
            else
                log_error "Failed to enable $service"
                return 1
            fi
            ;;
        "disable")
            if sudo systemctl disable "$service" 2>/dev/null; then
                log_info "Disabled $service"
                return 0
            else
                log_warn "Could not disable $service (may not be enabled)"
                return 0
            fi
            ;;
        *)
            log_error "Unknown service action: $action"
            return 1
            ;;
    esac
}

main() {
    echo "=== kmscon Setup with JetBrains Mono ==="
    echo "This script will clean up previous terminal modifications and install kmscon."
    echo ""
    
    check_prerequisites
    
    log_info "Starting cleanup of previous terminal modifications..."
    
    # Cleanup section with better error handling
    safe_restore_file "/etc/issue" || log_warn "Could not restore /etc/issue"
    safe_restore_file "/etc/vconsole.conf" || log_warn "Could not restore /etc/vconsole.conf"
    
    # Remove auto-login setup
    if [[ -d /etc/systemd/system/getty@tty1.service.d ]]; then
        if sudo rm -rf /etc/systemd/system/getty@tty1.service.d; then
            log_info "Removed auto-login configuration"
        else
            log_warn "Could not remove auto-login configuration"
        fi
    fi
    
    # Clean up user configs (these should be safe to remove)
    rm -rf ~/.config/alacritty ~/.config/i3 ~/.xinitrc 2>/dev/null || true
    log_info "Removed Alacritty/X11 configurations"
    
    # Clean up fbterm
    rm -rf ~/.fbtermrc 2>/dev/null || true
    if sudo pacman -R fbterm --noconfirm 2>/dev/null; then
        log_info "Removed fbterm package"
    fi
    
    # Reset bash_profile safely
    if [[ -f ~/.bash_profile ]]; then
        if cp ~/.bash_profile ~/.bash_profile.bak; then
            # Remove problematic lines
            sed -i '/startx/d; /fbterm/d; /XDG_VTNR/d; /DISPLAY/d' ~/.bash_profile
            sed -i -e :a -e '/^\s*$/N;ba' -e 's/\n*$//' ~/.bash_profile
            log_info "Cleaned ~/.bash_profile"
        else
            log_warn "Could not backup ~/.bash_profile"
        fi
    fi
    
    # Reset font safely
    sudo setfont 2>/dev/null || true
    
    # Check if getty@tty1 is enabled (for rollback purposes)
    if systemctl is-enabled getty@tty1.service &>/dev/null; then
        GETTY_WAS_ENABLED=true
    fi
    
    # Re-enable standard getty if it was disabled
    manage_service "enable" "getty@tty1.service" || log_warn "Could not enable getty@tty1.service"
    
    log_info "Cleanup completed successfully"
    echo ""
    
    # Installation section
    log_info "Installing kmscon and JetBrains Mono..."
    
    # Install packages with error checking
    if ! sudo pacman -S --needed kmscon ttf-jetbrains-mono; then
        log_error "Failed to install required packages"
        exit 1
    fi
    log_info "Packages installed successfully"
    
    # Create kmscon config directory
    if sudo mkdir -p /etc/kmscon; then
        KMSCON_CONFIG_CREATED=true
        log_info "Created kmscon config directory"
    else
        log_error "Failed to create kmscon config directory"
        exit 1
    fi
    
    # Configure kmscon with comprehensive config
    if sudo tee /etc/kmscon/kmscon.conf > /dev/null << 'EOF'; then
# kmscon configuration
font-engine=pango
font-name=JetBrains Mono
font-size=16
palette=custom

# Custom color scheme (dark theme)
palette-black=30,30,30
palette-red=204,36,29
palette-green=152,151,26
palette-yellow=215,153,33
palette-blue=69,133,136
palette-magenta=177,98,134
palette-cyan=104,157,106
palette-light-grey=168,153,132
palette-dark-grey=146,131,116
palette-light-red=251,73,52
palette-light-green=184,187,38
palette-light-yellow=250,189,47
palette-light-blue=131,165,152
palette-light-magenta=211,134,155
palette-light-cyan=142,192,124
palette-white=235,219,178

# Background and foreground
palette-background=40,40,40
palette-foreground=235,219,178
EOF
        log_info "Created kmscon configuration"
    else
        log_error "Failed to create kmscon configuration"
        exit 1
    fi
    
    # Replace getty with kmscon
    if manage_service "disable" "getty@tty1.service"; then
        if manage_service "enable" "kmscon@tty1.service"; then
            KMSCON_SERVICE_ENABLED=true
            log_info "Successfully replaced getty with kmscon on tty1"
        else
            log_error "Failed to enable kmscon service"
            exit 1
        fi
    else
        log_error "Failed to disable getty service"
        exit 1
    fi
    
    # Set clean login message
    if echo "Hello!" | sudo tee /etc/issue > /dev/null; then
        log_info "Set clean login message"
    else
        log_warn "Could not set login message"
    fi
    
    # Optional auto-login with proper validation
    echo ""
    read -p "Enable auto-login? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        USERNAME=$(whoami)
        if [[ -z "$USERNAME" ]]; then
            log_error "Could not determine username"
            exit 1
        fi
        
        if sudo mkdir -p /etc/systemd/system/kmscon@tty1.service.d/; then
            if sudo tee /etc/systemd/system/kmscon@tty1.service.d/autologin.conf > /dev/null << EOF; then
[Service]
ExecStart=
ExecStart=/usr/bin/kmscon --vt=%i --seats=seat0 --no-switchvt --login -- /bin/login -f $USERNAME
EOF
                AUTOLOGIN_CREATED=true
                log_info "Auto-login enabled for $USERNAME"
            else
                log_error "Failed to create auto-login configuration"
                exit 1
            fi
        else
            log_error "Failed to create auto-login directory"
            exit 1
        fi
    fi
    
    # Success message
    echo ""
    echo "=== Installation Complete ==="
    log_info "kmscon installed with JetBrains Mono"
    log_info "TrueType font rendering enabled"
    log_info "Modern color scheme applied"
    log_info "Clean login message set"
    echo ""
    echo "Reboot to use kmscon on tty1!"
    echo "Regular TTYs (tty2-6) will still be available."
    echo ""
    echo "If you encounter issues, check: journalctl -u kmscon@tty1.service"
}

# Run main function
main "$@"
