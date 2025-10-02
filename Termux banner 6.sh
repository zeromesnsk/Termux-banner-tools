#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m'

# Banner paths
BANNER_DIR="$HOME/termux-banner-tool"
BANNER_FILE="$HOME/.termux/banner.txt"
FONT_FILE="$HOME/.termux/font.ttf"

# Functions
print_status() { echo -e "${CYAN}[*]${NC} $1"; }
print_error() { echo -e "${RED}[!]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }

# Show menu
show_menu() {
    clear
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║             TERMUX BANNER TOOL              ║"
    echo "║        Customize Your Termux Look           ║"
    echo "╠══════════════════════════════════════════════╣"
    echo -e "${NC}"
    echo -e "${CYAN}[1]${NC} Install Requirements"
    echo -e "${CYAN}[2]${NC} Create Custom Banner"
    echo -e "${CYAN}[3]${NC} Preview Banner"
    echo -e "${CYAN}[4]${NC} Install Banner"
    echo -e "${CYAN}[5]${NC} Remove Banner"
    echo -e "${CYAN}[6]${NC} Exit"
    echo -e "${PURPLE}"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Install requirements
install_tool() {
    print_status "Installing required packages..."
    pkg install -y python git ruby figlet toilet neofetch cmatrix
    gem install lolcat
    mkdir -p ~/.termux
    print_success "Installation completed!"
    read -p "Press Enter to continue..."
}

# Create banner (Slant + Box + Hacker Email + Future Sysinfo)
create_banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗"
    echo "║              CREATE CUSTOM BANNER            ║"
    echo -e "╚══════════════════════════════════════════════╝${NC}"

    echo -n "Enter your banner text (Default = HACKER): "
    read banner_text
    banner_text=${banner_text:-HACKER}

    echo -n "Enter your Hacker Email (shown left/right): "
    read hacker_email
    hacker_email=${hacker_email:-hacker@example.com}

    # Generate banner text (style = slant)
    banner_ascii=$(figlet -f slant "$banner_text")

    # System info in FUTURE font
    sysinfo=$(neofetch --stdout | head -n 6 | toilet -f future)

    # Box layout
    {
        echo "┌───────────────────────────────────────────────┐"
        printf "│ %-45s │\n" "$hacker_email"
        echo "├───────────────────────────────────────────────┤"
        echo "$banner_ascii"
        echo "├───────────────────────────────────────────────┤"
        echo "$sysinfo"
        echo "└───────────────────────────────────────────────┘"
    } > "$BANNER_FILE"

    clear
    echo -e "${CYAN}Your Banner Preview:${NC}"
    cat "$BANNER_FILE" | lolcat

    print_success "Banner saved at $BANNER_FILE"
    read -p "Press Enter to continue..."
}

# Preview banner
preview_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found! Create one first."
    else
        clear
        cat "$BANNER_FILE" | lolcat
    fi
    read -p "Press Enter to continue..."
}

# Install banner
install_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found! Create one first."
        read -p "Press Enter to continue..."
        return
    fi
    if ! grep -q "cat ~/.termux/banner.txt" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Custom Termux Banner" >> ~/.bashrc
        echo "clear" >> ~/.bashrc
        echo "cat ~/.termux/banner.txt | lolcat" >> ~/.bashrc
        echo "echo ''" >> ~/.bashrc
    fi
    print_success "Banner installed! Restart Termux to see it."
    read -p "Press Enter to continue..."
}

# Remove banner
remove_banner() {
    if [ -f "$BANNER_FILE" ]; then
        rm "$BANNER_FILE"
        print_success "Banner removed!"
    else
        print_error "No banner found!"
    fi
    sed -i '/# Custom Termux Banner/d' ~/.bashrc
    sed -i '/cat ~\/.termux\/banner.txt/d' ~/.bashrc
    sed -i '/lolcat/d' ~/.bashrc
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_menu
    read -p "Select an option [1-6]: " choice
    case $choice in
        1) install_tool ;;
        2) create_banner ;;
        3) preview_banner ;;
        4) install_banner ;;
        5) remove_banner ;;
        6) echo -e "${GREEN}Thanks for using Termux Banner Tool!${NC}"; exit 0 ;;
        *) print_error "Invalid option!" ;;
    esac
done