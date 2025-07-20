# Modify the fix_display.sh file with correct display id parameters: Use GPT help by getting output from the following command: 
    system_profiler SPDisplaysDataType

# Copy the fix-refresh-rate-screen/monitor-hdmi.sh path and modify in plist file in line 9

# Copy this plist file inside: 
    ~/Library/LaunchAgents/

# Execute the following commands to provide permissions
    chmod +x /Users/anilabha/Desktop/VSCode_Workspace/fix-refresh-rate-screen
    chmod 644 ~/Library/LaunchAgents/com.anilabha.monitorhdmi.plist

# To load (Run in background): 
    launchctl load ~/Library/LaunchAgents/com.anilabha.monitorhdmi.plist

# To unload (Stop Background): 
    launchctl unload ~/Library/LaunchAgents/com.anilabha.monitorhdmi.plist

# To check status: 
    launchctl list | grep com.anilabha.monitorhdmi 

# Internal display will automatically switch from 120 to 48 and 48 to 120 after user logs in. In lock screen with HDMI, the user will not be able to see the password box, either make display 2 as primary or provide password in headless mode


# Also to change timezone run the following commands

sudo rm /etc/localtime
sudo ln -s /var/db/timezone/zoneinfo/Asia/Kolkata /etc/localtime

