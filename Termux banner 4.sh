# Create custom banner
create_banner() {
    print_status "Creating custom banner..."
    
    # Get banner text
    echo -n "Enter your banner text: "
    read banner_text

    if [ -z "$banner_text" ]; then
        print_error "No text entered!"
        return
    fi
    
    # Get hacker email text
    echo -n "Enter left hacker text (e.g., From: anonymous@darknet): "
    read left_text
    echo -n "Enter right hacker text (e.g., Encrypted: YES): "
    read right_text
    
    # ASCII art input
    echo "Enter your custom ASCII art (press Ctrl+D when finished):"
    ascii_art=$(cat)
    
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
        *) style="slant" ;; # Default to slant as requested
    esac

    # Generate banner with box design
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║               YOUR BANNER                   ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Create the banner file with box design
    echo -e "${BLUE}" > "$BANNER_FILE"
    
    # Top border
    echo "┌─────────────────────────────────────────────────────┐" >> "$BANNER_FILE"
    
    # Header with centered text
    echo "│                   TERMUX SYSTEM                    │" >> "$BANNER_FILE"
    echo "│                  SECURE ACCESS                     │" >> "$BANNER_FILE"
    echo "├─────────────────────────────────────────────────────┤" >> "$BANNER_FILE"
    
    # Hacker info in two columns
    if [ ! -z "$left_text" ] || [ ! -z "$right_text" ]; then
        printf "│ %-25s %25s │\n" "$left_text" "$right_text" >> "$BANNER_FILE"
        echo "├─────────────────────────────────────────────────────┤" >> "$BANNER_FILE"
    fi
    
    # Main banner text
    figlet -f $style "$banner_text" >> "$BANNER_FILE"
    echo "" >> "$BANNER_FILE"
    
    # Custom ASCII art section
    if [ ! -z "$ascii_art" ]; then
        echo "├─────────────────────────────────────────────────────┤" >> "$BANNER_FILE"
        echo "│                 CUSTOM ASCII ART                   │" >> "$BANNER_FILE"
        echo "├─────────────────────────────────────────────────────┤" >> "$BANNER_FILE"
        echo "$ascii_art" >> "$BANNER_FILE"
    fi
    
    # System information
    echo "├─────────────────────────────────────────────────────┤" >> "$BANNER_FILE"
    echo "│                 SYSTEM INFORMATION                  │" >> "$BANNER_FILE"
    echo "├─────────────────────────────────────────────────────┤" >> "$BANNER_FILE"
    echo -e "${GREEN}" >> "$BANNER_FILE"
    neofetch --stdout | head -n 8 >> "$BANNER_FILE"
    
    # Bottom border
    echo -e "${BLUE}" >> "$BANNER_FILE"
    echo "└─────────────────────────────────────────────────────┘" >> "$BANNER_FILE"
    echo -e "${NC}" >> "$BANNER_FILE"
    
    print_success "Hacker-style banner created at: $BANNER_FILE"
    echo "Press enter to continue..."
    read
}