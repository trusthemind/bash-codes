#!/bin/bash

function system_analysis {
    echo "------------------------------------------------"
    echo "              System Analysis Report            "
    echo "------------------------------------------------"

    echo -e "\nDisk Usage:\n"
    df -h --output=source,fstype,size,used,avail,pcent,target | grep -E '^/dev/' 
    echo "------------------------------------------------"

    echo -e "\nMemory Usage:\n"
    free -h | awk 'NR==1{printf "%-20s %-10s %-10s %-10s\n", $1, $2, $3, $4} NR==2{printf "%-20s %-10s %-10s %-10s\n", $1, $2, $3, $4}'
    echo "------------------------------------------------"

    echo -e "\nLoad (last 1, 5, and 15 minutes):\n"
    uptime | awk -F'load average:' '{ print $2 }' | sed 's/^\s*//;s/\s*$//'
    echo "------------------------------------------------"

    echo -e "\nProcesses by Memory Usage:\n"
    ps aux --sort=-%mem | awk 'NR==1{print $0} NR>1 && NR<=11{printf "%-10s %-5s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $11, $12}' 
    echo "------------------------------------------------"

    echo -e "\nProcesses by CPU Usage:\n"
    ps aux --sort=-%cpu | awk 'NR==1{print $0} NR>1 && NR<=11{printf "%-10s %-5s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $11, $12}' 
    echo "------------------------------------------------"
}

function cache_cleanup {
    echo "Starting cache optimization and cleanup..."
    
    echo "Cleaning APT cache..."
    sudo apt-get clean
    sudo apt-get autoremove -y
    echo "------------------------------------------------"

    if [ -d ~/.cache/thumbnails ]; then
        echo "Cleaning thumbnail cache..."
        rm -rf ~/.cache/thumbnails/*
        echo "Thumbnail cache cleared."
    fi
    echo "------------------------------------------------"

    echo "Cleaning old logs..."
    sudo find /var/log -type f -mtime +30 -exec rm {} \;
    echo "Old logs cleared."

    echo "Cleaning old systemd journal logs..."
    sudo journalctl --vacuum-time=7d
    echo "------------------------------------------------"

    echo "Cleaning old Docker images..."
    sudo docker system prune -a --force
    echo "Old Docker images cleared."
    echo "------------------------------------------------"

    echo "Freeing up cached memory..."
    sync; sudo sysctl -w vm.drop_caches=3
    echo "------------------------------------------------"
}

function update_system {
    echo "------------------------------------------------"
    echo "Updating system package list..."
    sudo apt-get update -y
    echo "System package list updated successfully."
    echo "------------------------------------------------"
}

function upgrade_system {
    echo "------------------------------------------------"
    echo "Upgrading system packages..."
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    echo "System packages upgraded successfully."
    echo "------------------------------------------------"
}

function update_drivers {
    echo "------------------------------------------------"
    echo "Updating drivers..."
    sudo ubuntu-drivers autoinstall
    echo "Drivers updated successfully."
    echo "------------------------------------------------"
}

function main_menu {
    while true; do
        echo "Please select an option:"
        echo "1) System Analysis"
        echo "2) Cache Cleanup"
        echo "3) Update System (Refresh package list)"
        echo "4) Upgrade System (Install latest package updates)"
        echo "5) Update Drivers"
        echo "6) Upgrade Both System and Drivers"
        echo "7) Exit"
        read -p "Enter your choice (1-7): " choice

        case $choice in
            1)
                system_analysis
                ;;
            2)
                cache_cleanup
                ;;
            3)
                update_system
                ;;
            4)
                upgrade_system
                ;;
            5)
                update_drivers
                ;;
            6)
                upgrade_system
                update_drivers
                ;;
            7)
                clear
                echo "Exiting script."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please try again."
                ;;
        esac
        echo "------------------------------------------------"
        echo "Returning to the main menu..."
    done
}

main_menu
