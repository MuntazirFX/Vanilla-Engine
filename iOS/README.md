# Vanilla Half-Life iOS build

The iOS build is produced directly by CMake as a native arm64 application bundle.

- Deployment target: iOS 15.0+
- Game directory: `Documents/valve`
- Default launch argument: `-game valve`
- Game assets are not included in this source tree.
- ImGui, Lua scripting, VGUI2, CS/CSO gameplay and custom-game selection are disabled/removed from the vanilla build.
