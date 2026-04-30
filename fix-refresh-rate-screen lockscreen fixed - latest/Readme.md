# Fix Refresh Rate and Automatic Display Switch

This tool automatically fixes the 120Hz/60Hz refresh rate conflict on macOS when connecting an external HDMI monitor. Additionally, it intelligently detects when your screen is locked (or when restarting your Mac) and automatically moves the Login Window to your external HDMI monitor, reverting back to the internal MacBook screen as primary once you log in.

## Prerequisites
You must have `displayplacer` installed.
```bash
brew install jakehilborn/jakehilborn/displayplacer
```

## Setup Instructions

### 1. Configure Monitor IDs
Modify the `fix_display.sh` file with your correct display ID parameters. You can find your specific monitor IDs by running:
```bash
displayplacer list
```
Update the `INTERNAL_ID` and `EXTERNAL_ID` variables inside `fix_display.sh`.

### 2. Deploy to Shared Folder (Required for Login Window)
Because of macOS security restrictions at the lock screen, the scripts must be placed in a shared folder so the Login Window can access them. Run these commands in your terminal from inside this project directory:

```bash
# Create a shared public directory for the scripts
sudo mkdir -p /Users/Shared/fix-refresh-rate-screen

# Copy the scripts to the shared directory
sudo cp monitor-hdmi.sh /Users/Shared/fix-refresh-rate-screen/
sudo cp fix_display.sh /Users/Shared/fix-refresh-rate-screen/

# Make them executable
sudo chmod 755 /Users/Shared/fix-refresh-rate-screen/monitor-hdmi.sh
sudo chmod 755 /Users/Shared/fix-refresh-rate-screen/fix_display.sh
```

### 3. Install System LaunchAgent
To make the script run immediately at the Apple logo (before login), copy the `.plist` file to the System LaunchAgents folder and set strict root permissions:

```bash
# Copy the LaunchAgent plist to the System folder
sudo cp com.anilabha..monitorhdmi.plist /Library/LaunchAgents/com.anilabha.monitorhdmi.plist

# Set strict system permissions (required by macOS)
sudo chown root:wheel /Library/LaunchAgents/com.anilabha.monitorhdmi.plist
sudo chmod 644 /Library/LaunchAgents/com.anilabha.monitorhdmi.plist
```

### 4. Apply Changes
**Restart your Mac.** 
macOS will automatically read the new configuration on boot and start monitoring the displays directly at the Login Window.

---

## Troubleshooting & Management

**To check if the agent is running:**
```bash
launchctl list | grep com.anilabha.monitorhdmi 
```

**To read the logs:**
```bash
cat /tmp/monitor-hdmi.log
cat /tmp/monitor-hdmi-err.log
```

**To cleanly uninstall the agent:**
```bash
sudo rm /Library/LaunchAgents/com.anilabha.monitorhdmi.plist
sudo rm -rf /Users/Shared/fix-refresh-rate-screen
# Then restart your Mac
```

---

# Extras

**To change timezone run the following commands:**
```bash
sudo rm /etc/localtime
sudo ln -s /var/db/timezone/zoneinfo/Asia/Kolkata /etc/localtime
```
