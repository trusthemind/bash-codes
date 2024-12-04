#!/bin/bash

# Function to activate Windows
activate_windows() {
    local key="$1"

    # Check if a key was provided
    if [[ -z "$key" ]]; then
        echo "Please provide a valid Windows product key."
        exit 1
    fi

    # Set the product key
    echo "Setting the product key..."
    slmgr.vbs /ipk "$key"
    
    # Activate Windows
    echo "Activating Windows..."
    slmgr.vbs /ato

    # Confirm activation status
    echo "Checking activation status..."
    slmgr.vbs /dli
}

# Replace YOUR_WINDOWS_KEY_HERE with your actual key or pass it as an argument
activate_windows "W269N-WFGWX-YVC9B-4J6C9-T83GX"
