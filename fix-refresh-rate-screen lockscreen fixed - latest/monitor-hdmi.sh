#!/bin/bash

# Set proper environment for GUI access
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"
export HOME="/Users/anilabha"

# Ensure we're in the user's session
export USER="anilabha"
export LOGNAME="anilabha"

REFRESH_SCRIPT="$(dirname "$0")/fix_display.sh"

echo "Script Started with PID: $$"
echo "Display monitor started at $(date)"

# Test if displayplacer is accessible
if ! command -v displayplacer &> /dev/null; then
    echo "ERROR: displayplacer command not found in PATH"
    exit 1
fi

PREV_STATE="unknown"

echo "Monitoring for HDMI and Screen Lock..."

while true; do
    # 1. Very fast HDMI check using displayplacer (0.03 seconds instead of 1s system_profiler)
    HDMI_CONNECTED=false
    if [[ $(displayplacer list 2>/dev/null | grep -c "Type:") -ge 2 ]]; then
        HDMI_CONNECTED=true
    fi
    
    # 2. Check if the screen is locked
    SCREEN_LOCKED=false
    if ioreg -n Root -d1 2>/dev/null | grep -q '"IOConsoleLocked" = Yes'; then
        SCREEN_LOCKED=true
    fi
    
    # 3. Decide what state we should be in
    if $HDMI_CONNECTED; then
        if $SCREEN_LOCKED; then
            TARGET_STATE="locked"
        else
            TARGET_STATE="unlocked"
        fi
    else
        TARGET_STATE="disconnected"
    fi
    
    # 4. If the state changed, immediately run the script
    if [[ "$TARGET_STATE" != "$PREV_STATE" ]]; then
        if [[ "$TARGET_STATE" == "locked" ]]; then
            echo "$(date): Screen LOCKED with HDMI connected. Moving to second display immediately!"
            bash "$REFRESH_SCRIPT" "locked" &
            
        elif [[ "$TARGET_STATE" == "unlocked" ]]; then
            echo "$(date): Screen UNLOCKED with HDMI connected. Reverting to primary internal!"
            bash "$REFRESH_SCRIPT" &
        fi
        
        PREV_STATE="$TARGET_STATE"
    fi
    
    # Sleep half a second so it responds instantly
    sleep 0.5
done
