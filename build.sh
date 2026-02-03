#!/bin/bash
# Build script for Clickable-FC3Eagle OVGME distribution
# Creates a zip file with the tech mod:
#   - Clickable-FC3Eagle (SavedGames/Mods/tech variant)

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="${1:-$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' "$SCRIPT_DIR/entry.lua" | head -1)}"
BUILD_DIR="$SCRIPT_DIR/build"
DIST_DIR="$SCRIPT_DIR/dist"
ZIP_NAME="Clickable-FC3Eagle-${VERSION}.zip"

echo "=== Building Clickable-FC3Eagle version $VERSION ==="

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"

# ============================================
# 1. Clickable-FC3Eagle (SavedGames/Mods/tech variant)
# ============================================
echo "Building Clickable-FC3Eagle (SavedGames/tech variant)..."

TECH_ROOT="$BUILD_DIR/Clickable-FC3Eagle/Mods/tech/Clickable-FC3Eagle"
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
# Create ZIP
# ============================================
echo "Creating zip file..."

cd "$BUILD_DIR"
rm -f "$DIST_DIR/$ZIP_NAME"
zip -r "$DIST_DIR/$ZIP_NAME" Clickable-FC3Eagle

echo ""
echo "=== Build complete ==="
echo "Output: $DIST_DIR/$ZIP_NAME"
echo ""
echo "Contents:"
unzip -l "$DIST_DIR/$ZIP_NAME" | head -30
echo "..."

# Cleanup build directory (optional - comment out to keep)
# rm -rf "$BUILD_DIR"
