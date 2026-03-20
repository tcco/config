#!/bin/bash

# System Information and Health Check Script
# Displays comprehensive system information for troubleshooting

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BOLD}${CYAN}$1${NC}"
    echo -e "${CYAN}$(printf '=%.0s' {1..50})${NC}"
}

print_section() {
    echo -e "\n${BOLD}${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '-%.0s' {1..30})${NC}"
}

check_status() {
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
}

# Main system info function
show_system_info() {
    clear
    print_header "macOS System Information & Health Check"
    
    # Basic System Info
    print_section "System Information"
    echo "macOS Version: $(sw_vers -productVersion) ($(sw_vers -buildVersion))"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Shell: $SHELL"
    echo "Architecture: $(uname -m)"
    echo "Uptime: $(uptime | awk -F'( |,|:)+' '{print $6,$7",",$8,"hours,",$9,"minutes"}')"
    
    # Hardware Info
    print_section "Hardware Information"
    echo "Model: $(system_profiler SPHardwareDataType | grep "Model Name" | awk -F': ' '{print $2}')"
    echo "Chip: $(system_profiler SPHardwareDataType | grep "Chip" | awk -F': ' '{print $2}' || echo "Intel")"
    echo "Memory: $(system_profiler SPHardwareDataType | grep "Memory" | awk -F': ' '{print $2}')"
    echo "Serial: $(system_profiler SPHardwareDataType | grep "Serial Number" | awk -F': ' '{print $2}')"
    
    # Storage Info
    print_section "Storage Information"
    df -h / | tail -1 | awk '{printf "Root Disk: %s used of %s (%s available) - %s full\n", $3, $2, $4, $5}'
    
    # Memory Usage
    print_section "Memory Usage"
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+):\s+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
    
    # CPU Info
    print_section "CPU Information"
    echo "CPU Cores: $(sysctl -n hw.ncpu)"
    echo "CPU Brand: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")"
    
    # Network Info
    print_section "Network Information"
    echo "Active Interfaces:"
    ifconfig | grep -E "^[a-z]" | awk '{print $1}' | while read interface; do
        status=$(ifconfig "$interface" | grep "status:" | awk '{print $2}')
        if [[ "$status" == "active" ]]; then
            ip=$(ifconfig "$interface" | grep "inet " | awk '{print $2}' | head -1)
            echo "  $interface: $ip ($status)"
        fi
    done
    
    echo "External IP: $(curl -s ifconfig.me || echo "Unable to determine")"
    
    # Development Environment
    print_section "Development Environment"
    
    printf "%-20s" "Xcode CLI Tools:"
    if xcode-select -p &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(xcode-select -p)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "Homebrew:"
    if command -v brew &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(brew --version | head -1)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "Git:"
    if command -v git &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(git --version)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "Node.js:"
    if command -v node &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(node --version)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "npm:"
    if command -v npm &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(npm --version)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "pnpm:"
    if command -v pnpm &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(pnpm --version)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "Python3:"
    if command -v python3 &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(python3 --version)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "VS Code:"
    if command -v code &>/dev/null; then
        echo -e "${GREEN}✓${NC} $(code --version | head -1)"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    printf "%-20s" "Cursor:"
    if command -v cursor &>/dev/null; then
        echo -e "${GREEN}✓${NC} Available"
    else
        echo -e "${RED}✗ Not installed${NC}"
    fi
    
    # SSH Keys
    print_section "SSH Keys"
    if [[ -d ~/.ssh ]]; then
        ls -la ~/.ssh/ | grep -E "\.(pub|key)$" | while read -r line; do
            key_file=$(echo "$line" | awk '{print $9}')
            echo "  $key_file"
        done
    else
        echo "No SSH directory found"
    fi
    
    # Git Configuration
    print_section "Git Configuration"
    if command -v git &>/dev/null; then
        echo "User Name: $(git config --global user.name || echo "Not set")"
        echo "User Email: $(git config --global user.email || echo "Not set")"
        echo "Default Branch: $(git config --global init.defaultBranch || echo "Not set")"
    fi
    
    # Dotfiles Status
    print_section "Dotfiles Status"
    if [[ -d ~/dotfiles ]]; then
        cd ~/dotfiles
        echo "Directory: ~/dotfiles"
        if [[ -d .git ]]; then
            echo "Git Branch: $(git branch --show-current 2>/dev/null || echo "Unknown")"
            echo "Remote URL: $(git remote get-url origin 2>/dev/null || echo "No remote")"
            echo "Last Commit: $(git log -1 --oneline 2>/dev/null || echo "No commits")"
            
            # Check for uncommitted changes
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                echo -e "${YELLOW}Status: Uncommitted changes${NC}"
            else
                echo -e "${GREEN}Status: Clean${NC}"
            fi
        else
            echo "Not a git repository"
        fi
    else
        echo -e "${RED}Dotfiles directory not found${NC}"
    fi
    
    # Running Processes (top resource consumers)
    print_section "Top Processes (CPU)"
    ps -eo pid,ppid,pcpu,pmem,comm --sort=-pcpu | head -6
    
    print_section "Top Processes (Memory)"
    ps -eo pid,ppid,pcpu,pmem,comm --sort=-pmem | head -6
    
    # Disk Space Alert
    print_section "Disk Space Alert"
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [[ $disk_usage -gt 80 ]]; then
        echo -e "${RED}⚠️  Warning: Root disk is ${disk_usage}% full${NC}"
    else
        echo -e "${GREEN}✓ Disk space OK (${disk_usage}% used)${NC}"
    fi
    
    # System Load
    print_section "System Load"
    uptime | awk -F'load averages:' '{print "Load Average:" $2}'
    
    echo -e "\n${BOLD}${GREEN}System information complete!${NC}"
}

# Function to show just the summary
show_summary() {
    echo -e "${BOLD}${CYAN}Quick System Summary${NC}"
    echo "====================="
    echo "macOS: $(sw_vers -productVersion)"
    echo "Model: $(system_profiler SPHardwareDataType | grep "Model Name" | awk -F': ' '{print $2}')"
    echo "Memory: $(system_profiler SPHardwareDataType | grep "Memory" | awk -F': ' '{print $2}')"
    echo "Disk: $(df -h / | tail -1 | awk '{print $5 " used of " $2}')"
    echo "IP: $(curl -s ifconfig.me || echo "Unable to determine")"
    
    # Check critical tools
    echo -e "\nCritical Tools:"
    tools=("git" "node" "npm" "pnpm" "code" "cursor" "brew")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &>/dev/null; then
            echo -e "  $tool: ${GREEN}✓${NC}"
        else
            echo -e "  $tool: ${RED}✗${NC}"
        fi
    done
}

# Check command line arguments
case "${1:-full}" in
    "summary"|"-s"|"--summary")
        show_summary
        ;;
    "full"|"-f"|"--full"|"")
        show_system_info
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [option]"
        echo "Options:"
        echo "  full, -f, --full     Show complete system information (default)"
        echo "  summary, -s, --summary   Show quick summary"
        echo "  help, -h, --help     Show this help message"
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac