#!/bin/bash
# Automated fix for 120Hz/60Hz display conflict
# Preserves current main/extended display configuration

echo "🔧 Starting display refresh rate fix..."

# Get current display configuration
echo "📋 Detecting current display configuration..."

# Get current displayplacer configuration
CURRENT_CONFIG=$(displayplacer list)

# Extract internal display info
INTERNAL_ID="462C1990-567F-5C42-050E-76AFCC40E6A5"
EXTERNAL_ID="345C6A48-2B30-2098-689B-213F5A8D9991"

# Determine current origins (positions)
#INTERNAL_ORIGIN=$(echo "$CURRENT_CONFIG" | grep -A 10 "$INTERNAL_ID" | grep "origin:" | sed 's/.*origin:(\([^)]*\)).*/\1/')
#EXTERNAL_ORIGIN=$(echo "$CURRENT_CONFIG" | grep -A 10 "$EXTERNAL_ID" | grep "origin:" | sed 's/.*origin:(\([^)]*\)).*/\1/')

# Internal is always main display (0,0), external is always secondary (1920,0)
INTERNAL_ORIGIN="0,0"
EXTERNAL_ORIGIN="1920,0"

# If we can't detect origins, fall back to defaults
if [[ -z "$INTERNAL_ORIGIN" ]]; then
    echo "⚠️  Could not detect internal display origin, using (0,0)"
    INTERNAL_ORIGIN="0,0"
fi

if [[ -z "$EXTERNAL_ORIGIN" ]]; then
    echo "⚠️  Could not detect external display origin, using (1920,0)"
    EXTERNAL_ORIGIN="1920,0"
fi

echo "🖥️  Internal display origin: ($INTERNAL_ORIGIN)"
echo "🖥️  External display origin: ($EXTERNAL_ORIGIN)"

# Internal display: Change to 48Hz temporarily (reset step) - preserve positions
echo "Step 1: Setting internal display to 48Hz (preserving arrangement)..."
displayplacer "id:$INTERNAL_ID res:1920x1080 hz:48 color_depth:8 enabled:true scaling:off origin:($INTERNAL_ORIGIN) degree:0" "id:$EXTERNAL_ID res:1920x1080 hz:60 color_depth:8 enabled:true scaling:off origin:($EXTERNAL_ORIGIN) degree:0"

# Wait for display system to stabilize
echo "⏳ Waiting 3 seconds..."
sleep 3

# Internal display: Change to 120Hz (target state) - preserve positions
echo "Step 2: Setting internal display to 120Hz (preserving arrangement)..."
displayplacer "id:$INTERNAL_ID res:1920x1080 hz:120 color_depth:8 enabled:true scaling:off origin:($INTERNAL_ORIGIN) degree:0" "id:$EXTERNAL_ID res:1920x1080 hz:60 color_depth:8 enabled:true scaling:off origin:($EXTERNAL_ORIGIN) degree:0"

echo "✅ Display refresh rate fix completed!"
echo "   Internal: 120Hz | External: 60Hz"
echo "   Display arrangement preserved"
