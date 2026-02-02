# FC3Eagle Clickable Installation

A partially clickable cockpit mod for the F-15C in DCS World.

## Requirements

- DCS World
- F-15C (either standalone module or FC3 package)
- OVGME (recommended) - [Download here](https://github.com/mguegan/overn/releases)

## Installation with OVGME (Recommended)

The `OVGME/` folder contains three mod packages:

| Mod Folder | Target | Description |
|------------|--------|-------------|
| `FC3Eagle-Clickable-SavedGames` | Saved Games\DCS | Main mod - **always required** |
| `FC3Eagle-Clickable-F15C-FC3` | DCS Install | F-15C cockpit overlay for **FC3 owners** |
| `FC3Eagle-Clickable-F15C-Standalone` | DCS Install | F-15C cockpit overlay for **Standalone F-15C owners** |

### Setup Steps

1. **Configure OVGME** with two mod roots:
   - One pointing to your `Saved Games\DCS\` folder
   - One pointing to your DCS installation folder (e.g., `C:\Program Files\Eagle Dynamics\DCS World\`)

2. **Copy mod folders** to appropriate OVGME mod directories:
   - Copy `FC3Eagle-Clickable-SavedGames` to your Saved Games OVGME mods folder
   - Copy `FC3Eagle-Clickable-F15C-FC3` OR `FC3Eagle-Clickable-F15C-Standalone` to your DCS Install OVGME mods folder

3. **Enable mods** in OVGME:
   - Enable `FC3Eagle-Clickable-SavedGames` (always required)
   - Enable the appropriate F-15C overlay for your version

4. **Launch DCS** and enjoy clickable cockpit controls!

## Manual Installation (Alternative)

1. Copy contents of `FC3Eagle-Clickable-SavedGames/` to your `Saved Games\DCS\` folder
2. Copy contents of the appropriate F-15C overlay to your DCS installation folder

## Usage

- **LAlt+C** - Toggle clickable mode
- Manage mod options in DCS Settings

## Uninstallation

If using OVGME, simply disable the mods. For manual installation, remove the installed files or verify/repair DCS.
