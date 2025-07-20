#!/bin/bash

# Set proper environment for GUI access
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/anilabha"

# Ensure we're in the user's session
export USER="anilabha"
export LOGNAME="anilabha"

REFRESH_SCRIPT="/Users/anilabha/Desktop/VSCode_Workspace/fix-refresh-rate-screen/fix_display.sh"

echo "Script Started with PID: $$"
echo "Display monitor started at $(date)"
echo "PATH: $PATH"
echo "HOME: $HOME"

# Test if displayplacer is accessible
if ! command -v displayplacer &> /dev/null; then
    echo "ERROR: displayplacer command not found in PATH"
    exit 1
fi

# Simple way to count displays using Resolution lines
PREV_COUNT=$(system_profiler SPDisplaysDataType | grep -c "Resolution:")

# Flag to track if script has been executed
SCRIPT_EXECUTED=false

echo "Initial display count: $PREV_COUNT" 
echo "Monitoring for display changes..."

while true; do
    CURR_COUNT=$(system_profiler SPDisplaysDataType | grep -c "Resolution:")
        
    # Check if display count is 2
    if [[ $CURR_COUNT -eq 2 ]]; then
        if [[ $SCRIPT_EXECUTED == false ]]; then
            echo "$(date): 2 displays detected, running fix script..."
            echo "Current working directory: $(pwd)"
            
            # Add more debugging
            echo "About to execute: $REFRESH_SCRIPT"
            ls -la "$REFRESH_SCRIPT"
            
            sleep 3  # Wait for display to settle
            
            # Execute with full path and capture output
            if bash "$REFRESH_SCRIPT"; then
                echo "$(date): Script executed successfully"
            else
                echo "$(date): Script execution failed with exit code: $?"
            fi
            
            SCRIPT_EXECUTED=true
            echo "$(date): Script completed and marked as executed" 
        fi
    fi
    
    # Reset flag if displays are disconnected (count goes down)
    if [[ $CURR_COUNT -lt $PREV_COUNT ]]; then
        echo "$(date): Display disconnected! Resetting execution flag"
        SCRIPT_EXECUTED=false
    fi
    
    PREV_COUNT=$CURR_COUNT
    sleep 3
done
