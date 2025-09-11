#!/bin/bash

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

# Check if running on Termux
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    print_error "This script must be run in Termux!"
    exit 1
fi

# Update packages
print_status "Updating packages..."
pkg update -y && pkg upgrade -y

# Install dependencies
print_status "Installing dependencies..."
pkg install -y python git ruby figlet toilet neofetch

# Install lolcat for color output
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
NC='\033[0m'

# Banner directory
BANNER_DIR="$HOME/termux-banner-tool"
BANNER_FILE="$HOME/.termux/banner.txt"
FONT_FILE="$HOME/.termux/font.ttf"

# Function to display main menu
show_menu() {
    clear
    echo -e "${CYAN}"
    echo "=========================================="
    echo "          TERMUX BANNER TOOL"
    echo "=========================================="
    echo -e "${NC}"
    echo -e "${GREEN}[1]${NC} Install Banner Tool"
    echo -e "${GREEN}[2]${NC} Create Custom Banner"
    echo -e "${GREEN}[3]${NC} Preview Banner"
    echo -e "${GREEN}[4]${NC} Install Banner"
    echo -e "${GREEN}[5]${NC} Remove Banner"
    echo -e "${GREEN}[6]${NC} Change Font"
    echo -e "${GREEN}[7]${NC} Show Current Banner"
    echo -e "${GREEN}[8]${NC} Exit"
    echo -e "${CYAN}"
    echo "=========================================="
    echo -e "${NC}"
}

# Function to install the tool
install_tool() {
    print_status "Installing required packages..."
    pkg install -y python git ruby figlet toilet neofetch
    gem install lolcat
    
    # Create .termux directory if it doesn't exist
    mkdir -p ~/.termux
    
    print_success "Installation completed!"
    echo "Press enter to continue..."
    read
}

# Function to create custom banner
create_banner() {
    print_status "Creating custom banner..."
    echo "Enter your banner text: "
    read banner_text
    
    if [ -z "$banner_text" ]; then
        print_error "No text entered!"
        return
    fi
    
    echo "Select banner style:"
    echo "1) Regular"
    echo "2) Big"
    echo "3) Mini"
    echo "4) Mono9"
    echo "5) Smmono9"
    echo "6) Smmono12"
    read -p "Enter choice [1-6]: " style_choice
    
    case $style_choice in
        1) style="standard" ;;
        2) style="big" ;;
        3) style="mini" ;;
        4) style="mono9" ;;
        5) style="smmono9" ;;
        6) style="smmono12" ;;
        *) style="standard" ;;
    esac
    
    # Generate banner
    figlet -f $style "$banner_text" > "$BANNER_FILE"
    
    # Add some color
    echo -e "${CYAN}" >> "$BANNER_FILE"
    neofetch --ascii_distro arch | head -n 10 >> "$BANNER_FILE"
    echo -e "${NC}" >> "$BANNER_FILE"
    
    print_success "Banner created at $BANNER_FILE"
    echo "Press enter to continue..."
    read
}

# Function to preview banner
preview_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found! Create one first."
        echo "Press enter to continue..."
        read
        return
    fi
    
    clear
    echo -e "${CYAN}"
    cat "$BANNER_FILE" | lolcat
    echo -e "${NC}"
    echo "Press enter to continue..."
    read
}

# Function to install banner
install_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found! Create one first."
        echo "Press enter to continue..."
        read
        return
    fi
    
    # Add banner to bashrc
    if ! grep -q "cat ~/.termux/banner.txt" ~/.bashrc; then
        echo "clear" >> ~/.bashrc
        echo "cat ~/.termux/banner.txt | lolcat" >> ~/.bashrc
        echo "echo ''" >> ~/.bashrc
    fi
    
    print_success "Banner installed! It will appear each time you start Termux."
    echo "Press enter to continue..."
    read
}

# Function to remove banner
remove_banner() {
    if [ -f "$BANNER_FILE" ]; then
        rm "$BANNER_FILE"
        print_success "Banner removed!"
    else
        print_error "No banner found!"
    fi
    
    # Remove from bashrc
    sed -i '/cat ~\/.termux\/banner.txt/d' ~/.bashrc
    sed -i '/lolcat/d' ~/.bashrc
    
    echo "Press enter to continue..."
    read
}

# Function to change font
change_font() {
    echo "Available fonts:"
    echo "1) Ubuntu"
    echo "2) Cousine"
    echo "3) Go"
    echo "4) Source Code Pro"
    echo "5) Cancel"
    read -p "Enter choice [1-5]: " font_choice
    
    case $font_choice in
        1) font="ubuntu" ;;
        2) font="cousine" ;;
        3) font="go" ;;
        4) font="source_code_pro" ;;
        5) return ;;
        *) font="ubuntu" ;;
    esac
    
    # Download font
    print_status "Downloading font..."
    curl -L -o "$FONT_FILE" "https://github.com/termux/termux-styling/raw/master/fonts/${font}.ttf"
    
    print_success "Font installed! Restart Termux to see changes."
    echo "Press enter to continue..."
    read
}

# Function to show current banner
show_current_banner() {
    if [ ! -f "$BANNER_FILE" ]; then
        print_error "No banner found!"
    else
        echo -e "${CYAN}"
        cat "$BANNER_FILE"
        echo -e "${NC}"
    fi
    
    echo "Press enter to continue..."
    read
}

# Main loop
while true; do
    show_menu
    read -p "Select an option [1-8]: " choice
    case $choice in
        1) install_tool ;;
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
EOF

# Make the script executable
chmod +x banner-tool

# Add to PATH
echo 'export PATH=$PATH:~/termux-banner-tool' >> ~/.bashrc

print_success "Termux Banner Tool installed successfully!"
print_status "To use the tool, run: banner-tool"
print_status "Or restart your Termux session"

# Run the tool
echo -e "${YELLOW}"
read -p "Do you want to run the banner tool now? [y/N]: " run_now
if [[ $run_now == "y" || $run_now == "Y" ]]; then
    ./banner-tool
fi