#!/bin/bash

# Script to install Flameshot via Flatpak
# This script installs Flatpak (if not already installed), Flameshot, and configures permissions

set -e

echo "=== Flameshot Installation Script ==="
echo ""

# Check if Flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak is not installed. Installing Flatpak..."

    # Detect the distribution and install Flatpak accordingly
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                sudo apt update
                sudo apt install -y flatpak
                ;;
            arch|manjaro)
                sudo pacman -S --noconfirm flatpak
                ;;
            fedora)
                sudo dnf install -y flatpak
                ;;
            *)
                echo "Unsupported distribution: $ID"
                echo "Please install Flatpak manually and run this script again."
                exit 1
                ;;
        esac
    else
        echo "Cannot detect distribution. Please install Flatpak manually."
        exit 1
    fi

    # Add Flathub repository
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Flatpak installed successfully!"
else
    echo "Flatpak is already installed."
    # Ensure Flathub is added
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo ""

# Install Flameshot
echo "Installing Flameshot via Flatpak..."
flatpak install -y flathub org.flameshot.Flameshot

echo ""

# Set screenshot permission
echo "Setting screenshot permission for Flameshot..."
flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes

echo ""

# Check display server (Wayland vs X11)
echo "Checking display server..."
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "Detected Wayland session."
    echo "Note: Flameshot may have issues with Wayland. If you encounter problems,"
    echo "consider switching to X11 or using the native system screenshot tool."
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    echo "Detected X11 session."
else
    echo "Could not detect session type. Current: $XDG_SESSION_TYPE"
fi

echo ""

# Test Flameshot
echo "Testing Flameshot installation..."
echo "Running: flatpak run --command=flameshot org.flameshot.Flameshot gui"
echo ""
echo "Note: You may see some Qt warnings. These are usually harmless."
echo "The screenshot tool should open. Take a screenshot to verify, then close it."
echo ""

flatpak run --command=flameshot org.flameshot.Flameshot gui

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Flameshot has been installed and tested."
echo ""
echo "To use Flameshot, you need to bind a keyboard shortcut:"
echo ""
echo "Command to bind: flatpak run --command=flameshot org.flameshot.Flameshot gui"
echo ""
echo "For GNOME:"
echo "  1. Open Settings > Keyboard > Keyboard Shortcuts"
echo "  2. Scroll down and click 'View and Customize Shortcuts' > 'Custom Shortcuts'"
echo "  3. Click '+' to add a new shortcut"
echo "  4. Name: 'Flameshot'"
echo "  5. Command: flatpak run --command=flameshot org.flameshot.Flameshot gui"
echo "  6. Click 'Set Shortcut' and press your preferred key (e.g., Print Screen)"
echo ""
echo "For KDE Plasma:"
echo "  1. Open System Settings > Shortcuts"
echo "  2. Click 'Add Application' or 'Add Command'"
echo "  3. Enter the command above"
echo "  4. Assign your preferred key combination"
echo ""
