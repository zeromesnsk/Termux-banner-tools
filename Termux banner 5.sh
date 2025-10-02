#!/bin/bash
# Enhanced Termux Banner Tool
# Features: centered text, figlet/toilet banners, boxed output, neofetch info, lolcat preview

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

BANNER_DIR="$HOME/termux-banner-tool"
BANNER_FILE="$HOME/.termux/banner.txt"
FONT_FILE="$HOME/.termux/font.ttf"

mkdir -p "$BANNER_DIR"
mkdir -p "$HOME/.termux"

# Helpers
print_status() { echo -e "${GREEN}[*]${NC} $1"; }
print_error() { echo -e "${RED}[!]${NC} $1"; }
print_success() { echo -e "${GREEN}[+]${NC} $1"; }

# Center text to terminal width
center_text() {
    local width
    width=$(tput cols 2>/dev/null || echo 80)
    while IFS= read -r line; do
        line=${line%%$'\r'}
        len=${#line}
        if [ "$len" -ge "$width" ]; then
            echo "$line"
        else
            pad=$(( (width - len) / 2 ))
            printf "%*s%s\n" "$pad" "" "$line"
        fi
    done
}

# Draw box around text
boxed_output() {
    local content="$1"
    IFS=$'\n' read -r -d '' -a lines <<<"$content"$'\0'
    max=0
    for l in "${lines[@]}"; do
        (( ${#l} > max )) && max=${#l}
    done
    border="$(printf '%*s' $((max + 4)) '' | tr ' ' '-')"
    echo "+$border+"
    for l in "${lines[@]}"; do
        printf "|  %-*s  |\n" "$max" "$l"
    done
    echo "+$border+"
}

# Menu
show_menu() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${GREEN}   ENHANCED TERMUX BANNER TOOL${NC}"
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${GREEN}[1]${NC} Install dependencies"
    echo -e "${GREEN}[2]${NC} Create/Update Banner"
    echo -e "${GREEN}[3]${NC} Preview Banner"
    echo -e "${GREEN}[4]${NC} Install Banner (auto show at start)"
    echo -e "${GREEN}[5]${NC} Remove Banner"
    echo -e "${GREEN}[6]${NC} Change Font"
    echo -e "${GREEN}[7]${NC} Show Current Banner"
    echo -e "${GREEN}[8]${NC} Exit"
}

install_deps() {
    print_status "Updating packages..."
    pkg update -y && pkg upgrade -y
    print_status "Installing required packages..."
    pkg install -y python git ruby figlet toilet neofetch coreutils
    gem install lolcat || true
    print_success "Dependencies installed."
    read -p "Press enter to continue..."
}

create_banner() {
    print_status "Enter banner text (Ctrl+D to finish if multiline):"
    banner_text=$(</dev/stdin)
    [ -z "$banner_text" ] && { print_error "No text entered!"; return; }

    echo "Choose generator:"
    echo "1) figlet"
    echo "2) toilet"
    echo "3) plain"
    read -p "Choice [1-3]: " gen

    case $gen in
        1)
            read -p "Figlet font (default=standard): " ff
            ff=${ff:-standard}
            raw=$(echo "$banner_text" | figlet -f "$ff")
            ;;
        2)
            read -p "Toilet filter (metal, gay, full...): " tf
            tf=${tf:-metal}
            raw=$(echo "$banner_text" | toilet -f future --filter "$tf" 2>/dev/null || echo "$banner_text")
            ;;
        *) raw="$banner_text" ;;
    esac

    centered=$(printf "%s\n" "$raw" | center_text)
    sysinfo=$(neofetch --stdout --config off | sed -n '1,10p')
    ts="Generated: $(date '+%Y-%m-%d %H:%M:%S')"

    content="$centered\n\n$sysinfo\n$ts"
    boxed=$(boxed_output "$content")

    printf "%s\n" "$boxed" > "$BANNER_FILE"

    print_success "Banner created at $BANNER_FILE"
    echo "Previewing..."
    cat "$BANNER_FILE" | lolcat
    read -p "Press enter to continue..."
}

preview_banner() {
    [ ! -f "$BANNER_FILE" ] && { print_error "No banner found!"; read; return; }
    clear
    cat "$BANNER_FILE" | lolcat
    read -p "Press enter to continue..."
}

install_banner() {
    [ ! -f "$BANNER_FILE" ] && { print_error "No banner found!"; read; return; }
    if ! grep -q "cat ~/.termux/banner.txt" ~/.bashrc 2>/dev/null; then
        echo "clear" >> ~/.bashrc
        echo "cat ~/.termux/banner.txt | lolcat" >> ~/.bashrc
        echo "echo ''" >> ~/.bashrc
    fi
    print_success "Banner installed. Restart Termux to see it."
    read -p "Press enter to continue..."
}

remove_banner() {
    [ -f "$BANNER_FILE" ] && { rm -f "$BANNER_FILE"; print_success "Banner file removed."; } || print_error "No banner file."
    sed -i '/cat ~\/.termux\/banner.txt/d' ~/.bashrc 2>/dev/null || true
    sed -i '/lolcat/d' ~/.bashrc 2>/dev/null || true
    read -p "Press enter to continue..."
}

change_font() {
    echo "Available: Ubuntu, Cousine, Go, Source Code Pro"
    read -p "Enter font name: " fn
    [ -z "$fn" ] && return
    url="https://github.com/termux/termux-styling/raw/master/fonts/${fn}.ttf"
    print_status "Downloading font..."
    curl -L -o "$FONT_FILE" "$url"
    [ -f "$FONT_FILE" ] && print_success "Font saved to $FONT_FILE. Restart Termux to apply." || print_error "Download failed."
    read -p "Press enter to continue..."
}

show_current_banner() {
    [ -f "$BANNER_FILE" ] && cat "$BANNER_FILE" || print_error "No banner found!"
    read -p "Press enter to continue..."
}

# Main loop
while true; do
    show_menu
    read -p "Select option [1-8]: " choice
    case $choice in
        1) install_deps ;;
        2) create_banner ;;
        3) preview_banner ;;
        4) install_banner ;;
        5) remove_banner ;;
        6) change_font ;;
        7) show_current_banner ;;
        8) exit 0 ;;
        *) print_error "Invalid option!" ;;
    esac
done