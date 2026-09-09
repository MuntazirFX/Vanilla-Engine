# Vanilla-Engine-Citrus

A vanilla Half-Life iOS engine project. The CSMoE game/mod layer is not included.

## What is kept
- The existing Xash3D-compatible engine code and native iOS/mobile support.
- The existing rendering, input/touch and audio engine work.
- The classic Xash3D C++ main menu (with CSMoE mod menus removed).

## What is removed
- CSMoE game DLL/client DLL source
- Zombie/TDM/DM/CSO gameplay code
- CSMoE custom weapons and CS bot code
- CSMoE custom VGUI and Lua menu layer
- CSMoE custom-game/mod selector

## Vanilla game source
The build downloads the vanilla-compatible `FWGS/hlsdk-portable` source during CI and links it statically into the iOS executable. Its master branch is the Half-Life SDK intended for GoldSource/Xash3D compatibility; its mod implementations live on separate branches.

## iOS
The iOS executable launches with `-game valve` and expects the legally obtained Steam Half-Life `valve` directory in the app Documents folder. The proprietary Steam game assets are not included in this repository.

## License
See the licenses included with the engine and the upstream Half-Life SDK used by the build.
