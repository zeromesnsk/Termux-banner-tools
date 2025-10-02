#!/bin/bash
# Termux Banner Tool (Linux Style)
# Author: Zerome Hacker 😎

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# Banner Header
banner() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║             LINUX STYLE BANNER TOOL            ║"
    echo "║                 for TERMUX USERS               ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Menu
menu() {
    echo -e "${GREEN}[1]${NC} Create Custom Banner"
    echo -e "${GREEN}[2]${NC} Show System Info"
    echo -e "${GREEN}[3]${NC} Install Hacker Style Font"
    echo -e "${GREEN}[4]${NC} Matrix Effect"
    echo -e "${GREEN}[5]${NC} Exit"
    echo ""
}

# Create banner
create_banner() {
    echo -n "Enter your banner text: "
    read text
    echo -e "${YELLOW}Choose style:${NC}"
    echo "1) Standard"
    echo "2) Slant"
    echo "3) Block"
    echo "4) Big"
    read -p "Choice [1-4]: " style
    case $style in
        1) figlet -f standard "$text" | lolcat ;;
        2) figlet -f slant "$text" | lolcat ;;
        3) figlet -f block "$text" | lolcat ;;
        4) figlet -f big "$text" | lolcat ;;
        *) figlet "$text" | lolcat ;;
    esac
    echo ""
    echo -e "${GREEN}[✓] Banner generated successfully!${NC}"
    echo "Press enter to continue..."
    read
}

# Show system info
sys_info() {
    echo -e "${MAGENTA}SYSTEM INFO${NC}"
    neofetch | lolcat
    echo "Press enter to continue..."
    read
}

# Install font
install_font() {
    echo -e "${YELLOW}Downloading hacker font...${NC}"
    mkdir -p ~/.termux
    curl -L -o ~/.termux/font.ttf "https://github.com/termux/termux-styling/raw/master/fonts/firacode.ttf"
    echo -e "${GREEN}[✓] Font installed! Restart Termux to see changes.${NC}"
    read
}

# Matrix effect
matrix_effect() {
    cmatrix
}

# Main
while true; do
    banner
    menu
    read -p "Select an option [1-5]: " choice
    case $choice in
        1) create_banner ;;
        2) sys_info ;;
        3) install_font ;;
        4) matrix_effect ;;
        5) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}[!] Invalid option!${NC}"; sleep 1 ;;
    esac
done