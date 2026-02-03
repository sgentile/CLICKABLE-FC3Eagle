#!/bin/bash
# Build script for ClickableF15CMod OVGME distribution
# Creates a zip file with 2 folders:
#   - ClickableF15CMod (SavedGames/Mods/tech variant)
#   - ClickableF15CMod-Aircraft (aircraft mod for F-15C Standalone)

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="${1:-$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$SCRIPT_DIR/entry.lua" | head -1)}"
BUILD_DIR="$SCRIPT_DIR/build"
DIST_DIR="$SCRIPT_DIR/dist"
ZIP_NAME="ClickableF15CMod-${VERSION}.zip"

echo "=== Building ClickableF15CMod version $VERSION ==="

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"

# ============================================
# 1. ClickableF15CMod (SavedGames/Mods/tech variant)
# ============================================
echo "Building ClickableF15CMod (SavedGames/tech variant)..."

TECH_ROOT="$BUILD_DIR/ClickableF15CMod/Mods/tech/ClickableF15CMod"
mkdir -p "$TECH_ROOT"

# Copy entry.lua
cp "$SCRIPT_DIR/entry.lua" "$TECH_ROOT/"

# Copy Cockpit/Scripts
mkdir -p "$TECH_ROOT/Cockpit/Scripts"
cp -r "$SCRIPT_DIR/Cockpit/Scripts/"* "$TECH_ROOT/Cockpit/Scripts/"

# Copy Options
mkdir -p "$TECH_ROOT/Options"
cp -r "$SCRIPT_DIR/Options/"* "$TECH_ROOT/Options/"

# Copy Skins
mkdir -p "$TECH_ROOT/Skins"
cp -r "$SCRIPT_DIR/Skins/"* "$TECH_ROOT/Skins/"

# Copy Shapes
mkdir -p "$TECH_ROOT/Shapes"
cp -r "$SCRIPT_DIR/Shapes/"* "$TECH_ROOT/Shapes/"

# ============================================
# 2. ClickableF15CMod-Aircraft (aircraft mod variant)
# ============================================
echo "Building ClickableF15CMod-Aircraft..."

STANDALONE_ROOT="$BUILD_DIR/ClickableF15CMod-Aircraft/Mods/aircraft/F-15C/Cockpit"
mkdir -p "$STANDALONE_ROOT"

# Copy from src/aircraft sources
if [ -d "$SCRIPT_DIR/src/aircraft/F-15C-Standalone/Cockpit" ]; then
    cp -r "$SCRIPT_DIR/src/aircraft/F-15C-Standalone/Cockpit/"* "$STANDALONE_ROOT/"
else
    echo "ERROR: F15C-Standalone source not found at src/aircraft/F-15C-Standalone/Cockpit"
    exit 1
fi

# ============================================
# Create ZIP
# ============================================
echo "Creating zip file..."

cd "$BUILD_DIR"
rm -f "$DIST_DIR/$ZIP_NAME"
zip -r "$DIST_DIR/$ZIP_NAME" ClickableF15CMod ClickableF15CMod-Aircraft

echo ""
echo "=== Build complete ==="
echo "Output: $DIST_DIR/$ZIP_NAME"
echo ""
echo "Contents:"
unzip -l "$DIST_DIR/$ZIP_NAME" | head -30
echo "..."

# Cleanup build directory (optional - comment out to keep)
# rm -rf "$BUILD_DIR"
