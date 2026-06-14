# P2V-7S Neptune — DCS World Community Mod

## Project overview
Full-fidelity DCS World aircraft mod for the Lockheed P2V-7S (SP-2H) Neptune. Learning project — depth over speed.

## Key paths
- **Mod content:** `P2V-7S/` (all DCS mod files — the only thing the junction exposes to DCS)
- **Art/working source:** `Source/` (Blender `.blend`, reference, texture source — NOT shipped). Exterior model exports to `P2V-7S/Shapes/P2V-7S.edm`. See `Source/README.md`.
- **DCS install:** `E:\Program Files\DCS World OpenBeta`
- **DCS saved games:** `D:\Saved Games\DCS.openbeta`
- **Deploy target:** `D:\Saved Games\DCS.openbeta\Mods\aircraft\P2V-7S` (junction to `P2V-7S/`)
- **A-4E-C reference:** `C:\Users\Jason\Projects\Coding\community-a4e-c\A-4E-C`
- **DCS log:** `D:\Saved Games\DCS.openbeta\Logs\dcs.log`

## Deployment
Run `deploy.ps1` as Administrator to create a Windows directory junction. Then restart DCS to test. No copy/build step needed until the EFM DLL is added.

## Architecture reference
The A-4E-C community mod is the structural template. Key DCS mod patterns:
- `entry.lua`: `declare_plugin()` → `mount_vfs_*()` → `make_flyable()` → `dofile()` definitions → `make_view_settings()` → `plugin_done()`
- Cockpit devices: `devices.lua` (IDs) → `device_init.lua` (creators) → `Systems/*.lua` (implementations)
- EFM: C++ DLL (`Neptune.dll`) exporting `ed_fm_*` functions (Phase 1+)

## Development log
Progress, decisions, and bugs are tracked in `DEVLOG.md`.
