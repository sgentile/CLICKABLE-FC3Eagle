# ClickableF15CMod Project Overview

## Project Purpose
This is a DCS World mod for the F-15C aircraft that adds fully clickable cockpit controls and animations. Originally forked from RedK0d's CLICKABLE-FC3 project and now focused exclusively on the F-15C Standalone module.

## Project Structure & File Descriptions

### Root Level Files
- **README.md** - Main documentation with features, installation, and list of clickable controls
- **CHANGELOG.md** - Development history and version notes
- **INSTALL.md** - Installation instructions
- **entry.lua** - Main entry point for the mod
- **claude.md** - Development context (this file)

### Cockpit/Scripts/ - Core Mod Files
Main implementation directory for the F-15C clickable system:

- **clickabledata.lua** - Defines all clickable UI elements and their mappings. Maps 3D cockpit elements (PNT_* names) to buttons, axes, and rotaries with hints and device commands. This is the primary file for adding new clickable controls.

- **clickable_defs.lua** - Contains function templates for creating clickable element definitions:
  - `default_button()` - Creates button controls (on/off)
  - `default_movable_axis()` - Creates axis controls (continuous movement)
  - `default_2_position_tumb()` - Creates 2-position toggle switches
  - `default_3_position_tumb()` - Creates 3-position cyclic controls
  - Animation speed and cursor mode settings

- **command_defs.lua** - Lists all DCS World command IDs (Keys.*) that the mod uses. Maps human-readable command names to their numeric IDs in DCS. Reference for all available aircraft commands.

- **devices.lua** - Enumerates device constants used in the clickable system (e.g., devices.CLICKABLE, devices.LIGHT_CONTROL_SYSTEM)

- **device_init.lua** - Initializes device settings and parameters

- **devices.lua** - Device type definitions and enum values

- **mainpanel_init.lua** - Main panel initialization and gauge setup

- **supported.lua** - Aircraft support definitions

- **utils.lua** - Utility functions for the mod

- **dump.lua** - Debug/logging utilities

### Cockpit/Scripts/SYSTEMS/ - Animation & Control Systems
Handles runtime animation logic and state management:

- **clickable.lua** - Main update loop that handles:
  - Clickable mode toggling (LAlt+C)
  - Control state updates
  - Animation timers
  - Countermeasure system logic
  - Radar and targeting state management
  - Command dispatching

- **PNT_update.lua** - Updates parameter references for animated elements:
  - Gets references to all clickable element animations (PNT_* references)
  - Syncs animation states with DCS aircraft state
  - ~30+ animated elements tracked here

- **functions.lua** - Utility functions for file operations (read, write, copy, move, etc.)

### Build Output (build/)
Build artifacts created by build.sh:

- **ClickableF15CMod/** - SavedGames/Mods/tech installation variant
- **ClickableF15CMod-Aircraft/** - Aircraft mod for F-15C Standalone

### Options/ - Configuration Files
User settings and options management:

- **options.dlg** - Options dialog UI definition
- **optionsData.lua** - Options data structure
- **optionsDb.lua** - Options database/persistence

### Shapes/ & Skins/
3D model assets for the F-15C cockpit

## Key Concepts

### Clickable Elements
Elements are defined in **clickabledata.lua** using format:
```lua
elements["ELEMENT_ID"] = function_type("Display Name", device, command)
```

The ELEMENT_ID must match a 3D connector name in the cockpit model (e.g., PNT_EJECT, PNT_AIRBRAKE).

### Animation System
- Animations use DCS draw argument numbers (integer indices)
- Each animation has an arg_number in mainpanel_init.lua (e.g., arg_number = 428 for taxi light)
- PNT_update.lua gets references and syncs them with cockpit state
- Animation speed is controllable via `animation_speed` parameter

### Device Commands
- Commands defined in **command_defs.lua** as device_commands.CLIC_*
- Both DCS native commands (Keys.*) and custom mod commands supported
- Commands are dispatched when clickable elements are clicked

## Development Workflow

### To Add a New Clickable Control:
1. Add element definition to **clickabledata.lua**
2. Create corresponding command in **command_defs.lua** (if custom)
3. Add handler logic in **clickable.lua** if state management needed
4. Get reference in **PNT_update.lua** if animation required
5. Test with clickable mode toggled on (LAlt+C)

### To Add a New Animation:
1. Find the 3D model connector name (PNT_* or similar)
2. Create gauge/parameter in **mainpanel_init.lua** with arg_number
3. Get reference in **PNT_update.lua**
4. Update state in appropriate SYSTEMS lua file (clickable.lua, light_control.lua, etc.)

## Current Features
- 28+ clickable cockpit controls
- Animated landing/taxi lights
- Navigation lights with intensity/flash control
- Anti-collision lights management
- Cockpit illumination system
- Countermeasures management (Chaff/Flares)
- Full lighting management system
- Autopilot controls (CAS, Altitude Hold, Attitude Hold)
- Flight surface controls (Flaps, Airbrake, Trim)
- Engine controls
- Weapon and targeting systems
