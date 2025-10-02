#!/bin/bash

# Colors for beautiful output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
MAGENTA='\033[1;35m'
ORANGE='\033[1;33m'
NC='\033[0m'

# Functions for status messages
print_status() {
    echo -e "${CYAN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_banner() {
    clear
    echo -e "${PURPLE}"
    echo "████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗"
    echo "╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝"
    echo "   ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ "
    echo "   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ "
    echo "   ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗"
    echo "   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${CYAN}"
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│                TERMUX BANNER TOOL                  │"
    echo "│           Customize Your Termux Look               │"
    echo "└─────────────────────────────────────────────────────┘"
    echo -e "${NC}"
}

# Check if running on Termux
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    print_error "This script must be run in Termux!"
    exit 1
fi

# Update packages
print_banner
print_status "Updating packages..."
pkg update -y && pkg upgrade -y

# Install dependencies
print_status "Installing required packages..."
pkg install -y python git ruby figlet toilet neofetch cmatrix

# Install lolcat for rainbow colors
print_status "Installing lolcat for colorful output..."
gem install lolcat

# Create custom banner directory
BANNER_DIR="$HOME/termux-banner-tool"
if [ -d "$BANNER_DIR" ]; then
    print_status "Removing existing directory..."
    rm -rf "$BANNER_DIR"
fi

print_status "Creating custom banner tool..."
mkdir -p "$BANNER_DIR"
cd "$BANNER_DIR"

# Create the main script
cat > banner-tool << 'EOF'
#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
MAGENTA='\033[1;35m'
ORANGE='\033[1;33m'
NC='\033[0m'

# Paths
BANNER_DIR="$HOME/termux-banner-tool"
BANNER_FILE="$HOME/.termux/banner.txt"
FONT_FILE="$HOME/.termux/font.ttf"

# Show main menu
show_menu() {
    clear
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║             TERMUX BANNER TOOL              ║"
    echo "║          Customize Your Terminal            ║"
    echo "╠══════════════════════════════════════════════╣"
    echo -e "${NC}"
    echo -e "${CYAN}[1]${NC} Install Requirements"
    echo -e "${CYAN}[2]${NC} Create Custom Banner"
    echo -e "${CYAN}[3]${NC} Preview Banner"
    echo -e "${CYAN}[4]${NC} Install Banner"
    echo -e "${CYAN}[5]${NC} Remove Banner"
    echo -e "${CYAN}[6]${NC} Change Font"
    echo -e "${CYAN}[7]${NC} Show Current Banner"
    echo -e "${CYAN}[8]${NC} Special Effects"
    echo -e "${CYAN}[9]${NC} Exit"
    echo -e "${PURPLE}"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Install tool function
install_tool() {
    print_status "Installing required packages..."
    pkg install -y python git ruby figlet toilet neofetch cmatrix
    gem install lolcat
    
    mkdir -p ~/.termux
    print_success "Installation completed!"
    echo "Press enter to continue..."
    read
}

# Create custom banner
create_banner() {
    print_status "Creating custom banner..."
    echo -n "Enter your banner text: "
    read banner_text

    if [ -z "$banner_text" ]; then
        print_error "No text entered!"
        return
    fi
    
    echo "Select banner style:"
    echo "1) Standard"
    echo "2) Big"
    echo "3) Mini"
    echo "4) Block"
    echo "5) Slant"
    echo "6) Script"
    echo "7) Digital"
    read -p "Enter choice [1-7]: " style_choice
    
    case $style_choice in
        1) style="standard" ;;
        2) style="big" ;;
        3) style="mini" ;;
        4) style="block" ;;
        5) style="slant" ;;
        6) style="script" ;;
        7) style="digital" ;;
        *) style="standard" ;;
    esac

    # Generate banner with better formatting
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║               YOUR BANNER                   ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Create the banner file
    echo -e "${BLUE}" > "$BANNER_FILE"
    echo "┌─────────────────────────────────────────────────────┐" >> "$BANNER_FILE"
    echo "│                   WELCOME TO                       │" >> "$BANNER_FILE"
    echo "└─────────────────────────────────────────────────────┘" >> "$BANNER_FILE"
    echo -e "${NC}" >> "$BANNER_FILE"
    
    figlet -f $style "$banner_text" >> "$BANNER_FILE"
    echo "" >> "$BANNER_FILE"
    
    # Add system information
    echo -e "${GREEN}" >> "$BANNER_FILE"
    echo "┌─────────────────────────────────────────────────────┐" >> "$BANNER_FILE"
    echo "│                 SYSTEM INFO                        │" >> "$BANNER_FILE"
    echo "└─────────────────────────────────────────────────────┘" >> "$BANNER_FILE"
    echo -e "${YELLOW}" >> "$BANNER_FILE"
    neofetch --stdout | head -n 10 >> "$BANNER_FILE"
    
    print_success "Banner created at: $BANNER_FILE"
    echo "Press enter to continue..."
    read
}

# Preview banner
preview_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found! Create one first."
        echo "Press enter to continue..."
        read
        return
    fi

    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║               BANNER PREVIEW                ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    cat "$BANNER_FILE" | lolcat
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║             PREVIEW COMPLETE                ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Press enter to continue..."
    read
}

# Install banner
install_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found! Create one first."
        echo "Press enter to continue..."
        read
        return
    fi

    # Add to bashrc
    if ! grep -q "cat ~/.termux/banner.txt" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Custom Termux Banner" >> ~/.bashrc
        echo "clear" >> ~/.bashrc
        echo "cat ~/.termux/banner.txt | lolcat" >> ~/.bashrc
        echo "echo ''" >> ~/.bashrc
    fi
    
    print_success "Banner installed! It will appear when you start Termux."
    echo "Press enter to continue..."
    read
}

# Remove banner
remove_banner() {
    if [ -f "$BANNER_FILE" ]; then
        rm "$BANNER_FILE"
        print_success "Banner removed!"
    else
        print_error "No banner found!"
    fi

    # Remove from bashrc
    sed -i '/# Custom Termux Banner/d' ~/.bashrc
    sed -i '/cat ~\/.termux\/banner.txt/d' ~/.bashrc
    sed -i '/lolcat/d' ~/.bashrc
    
    echo "Press enter to continue..."
    read
}

# Change font
change_font() {
    echo "Available fonts:"
    echo "1) Ubuntu (Default)"
    echo "2) Cousine"
    echo "3) Go Mono"
    echo "4) Source Code Pro"
    echo "5) Fira Code"
    echo "6) Cancel"
    read -p "Enter choice [1-6]: " font_choice

    case $font_choice in
        1) font="ubuntu" ;;
        2) font="cousine" ;;
        3) font="go" ;;
        4) font="source_code_pro" ;;
        5) font="firacode" ;;
        6) return ;;
        *) font="ubuntu" ;;
    esac
    
    print_status "Downloading font..."
    curl -L -o "$FONT_FILE" "https://github.com/termux/termux-styling/raw/master/fonts/${font}.ttf" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_success "Font installed! Restart Termux to see changes."
    else
        print_error "Failed to download font!"
    fi
    
    echo "Press enter to continue..."
    read
}

# Show current banner
show_current_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found!"
    else
        echo -e "${CYAN}"
        echo "╔══════════════════════════════════════════════╗"
        echo "║             CURRENT BANNER                  ║"
        echo "╚══════════════════════════════════════════════╝"
        echo -e "${NC}"
        cat "$BANNER_FILE"
    fi
    
    echo "Press enter to continue..."
    read
}

# Special effects
special_effects() {
    clear
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║               SPECIAL EFFECTS               ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${CYAN}[1]${NC} Matrix Effect"
    echo -e "${CYAN}[2]${NC} Colorful Neofetch"
    echo -e "${CYAN}[3]${NC} Animated Text"
    echo -e "${CYAN}[4]${NC} Back to Main Menu"
    
    read -p "Enter choice [1-4]: " effect_choice
    
    case $effect_choice in
        1)
            print_status "Starting matrix effect..."
            cmatrix
            ;;
        2)
            print_status "Showing colorful system info..."
            neofetch | lolcat
            echo "Press enter to continue..."
            read
            ;;
        3)
            echo -n "Enter text to animate: "
            read animate_text
            if [ ! -z "$animate_text" ]; then
                for i in {1..3}; do
                    clear
                    echo -e "${CYAN}"
                    figlet -f slant "$animate_text" | lolcat
                    sleep 0.5
                    clear
                    echo -e "${GREEN}"
                    figlet -f block "$animate_text" | lolcat
                    sleep 0.5
                done
            fi
            ;;
        4)
            return
            ;;
        *)
            print_error "Invalid option!"
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Select an option [1-9]: " choice
    case $choice in
        1) install_tool ;;
        2) create_banner ;;
        3) preview_banner ;;
        4) install_banner ;;
        5) remove_banner ;;
        6) change_font ;;
        7) show_current_banner ;;
        8) special_effects ;;
        9) 
            echo -e "${GREEN}Thanks for using Termux Banner Tool!${NC}"
            exit 0 
            ;;
        *) 
            print_error "Invalid option! Please try again."
            sleep 2
            ;;
    esac
done
EOF

# Make script executable
chmod +x banner-tool

# Add to PATH
echo 'export PATH=$PATH:~/termux-banner-tool' >> ~/.bashrc

print_success "Termux Banner Tool installed successfully!"
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗"
echo -e "║                  USAGE GUIDE                  ║"
echo -e "╚══════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}• Run the tool:${NC} banner-tool"
echo -e "${GREEN}• Or restart Termux and run 'banner-tool'${NC}"
echo ""

# Ask to run now
echo -e "${YELLOW}"
read -p "Do you want to run the banner tool now? [y/N]: " run_now
if [[ $run_now == "y" || $run_now == "Y" ]]; then
    ./banner-tool
else
    echo -e "${CYAN}You can run the tool later by typing 'banner-tool'${NC}"
fi