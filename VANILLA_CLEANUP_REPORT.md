# Vanilla cleanup report

This archive was produced from the supplied `Vanilla-Engine-citrus.zip`.

## Preserved
The existing `engine/`, `common/`, `public/`, `SourceSDK/`, rendering/mobile support and other engine-side code were preserved.

## Removed from the game/UI layer
- `dlls/` CSMoE game layer
- `cl_dll/` CSMoE client layer
- `game_shared/` CSMoE shared game layer
- `vgui2_support/` CSMoE VGUI support layer
- `luash/` and menu Lua glue
- CSMoE ImGui menu layer
- CSMoE custom-game menu
- CSMoE player-introduction dialog
- CSMoE resource/tutorial image

## Build change
The repository now fetches `FWGS/hlsdk-portable` during CI and uses its vanilla Half-Life game/client sources instead of the removed CSMoE game layer.

## Important
The supplied ZIP did not contain the actual CSMoE `dlls/wpn_shared` sources or several referenced gamemode sources; many were referenced by CMake but absent from the ZIP. Therefore the clean build is based on a fresh vanilla HLSDK source at build time rather than trying to repair hundreds of missing CSMoE files.

The Steam `valve` game assets are intentionally not included; use your legally obtained Half-Life files.
