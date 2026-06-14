# P2V-7S Neptune — Development Log

## 2026-06-13 ~20:00 — Phase 0: Project Scaffold

### Codebase tour & planning
- Explored the A-4E-C community mod as a structural reference for building a DCS aircraft mod
- Key architecture: `entry.lua` → `declare_plugin` / `make_flyable` / `plugin_done`; cockpit devices in Lua; flight model in C++ DLL
- Decided on P2V-7S (SP-2H) variant: twin R-3350 radials + twin J34 jet pods, full ASW suite
- Multi-crew is not available to community modders — ASW crew stations will be AI-automated
- Decided to go EFM from day one (skip SFM), stub out flight model, focus on systems depth
- 3D model approach: hybrid blockout — rough proportions, real panel faces, refined over time
- Official Blender EDM exporter available from Eagle Dynamics on GitHub

### Scaffold created
- Created full project structure at `D:\Projects\Coding\community-p2v-7s\P2V-7S\`
- 22 files: entry.lua, aircraft definition, views, comm, suspension, cockpit scripts (devices, commands, mainpanel, device_init, EFM data bus), input bindings, livery/options/weapons stubs
- `devices.lua` defines 30 device IDs upfront (electrical through ASW systems) so IDs stay stable
- `command_defs.lua` reserves ranges: standard DCS commands + custom 10000+ and device 3000+
- Deploy strategy: symlink/junction from DCS Saved Games to project directory

## 2026-06-14 ~00:00 — First DCS load attempt

### Crash #1: Sound path mount
- DCS crashed immediately after mounting empty `Sounds/` directory
- Fix: commented out `mount_vfs_sound_path` in entry.lua
- Also noted `mount_vfs_sound_path()` is marked OBSOLETE by DCS — other mods (A-4E-C, AJS37) still use it with just a warning

### Crash #2: Missing `Tasks` field
- Real error found in dcs.log: `ALERT Dispatcher: Error running db_scan: attempt to get length of field 'Tasks' (a nil value)`
- `P2V-7S.lua` aircraft definition was missing `Tasks` and `DefaultTask` — DCS's `db_mods.lua` requires these
- Fix: added `Tasks = { aircraft_task(AntishipStrike), aircraft_task(GroundAttack), aircraft_task(Reconnaissance) }` and `DefaultTask`

### Crash #3: Stale symlink
- Git Bash `ln -s` created a copy, not a live symlink — edits weren't reflected at the DCS mod path
- Fix: use Windows directory junction instead (`mklink /J` via cmd.exe, or PowerShell `deploy.ps1`)
- Key lesson: always use `mklink /J` (junction) or PowerShell `New-Item -ItemType SymbolicLink` on Windows — Git Bash symlinks don't work for Windows apps
- Verify junction is live: `type "D:\Saved Games\DCS.openbeta\Mods\aircraft\P2V-7S\P2V-7S.lua" | findstr Tasks`

## 2026-06-14 ~01:00 — Phase 0 complete: mod loads in DCS

### Fixed the deploy link
- The mod dir in `Mods\aircraft\` was a stale copy from `deploy.sh` (Git Bash) — its contents weren't updating/being found. `deploy.ps1` had never run successfully.
- Two issues stopped `deploy.ps1`: (1) it used `-ItemType SymbolicLink` (needs admin) — switched to `-ItemType Junction` (no elevation, same-volume; matches CLAUDE.md); (2) PS execution policy blocked the unsigned script ("not digitally signed"). Run via `powershell -ExecutionPolicy Bypass -File deploy.ps1`; persistent fix is `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

### Phase 0 end state reached (as designed)
- With a live junction, P2V-7S shows in the modules bar, is selectable in the mission editor, and a mission with it loads.
- As expected for a model-less scaffold: the client slot is dropped and nothing renders, because `Shapes/` has no `P2V-7S.edm` (`Shape = "P2V-7S"` is unresolvable). The full Lua plugin pipeline is now proven end to end.
- Phase 1 starts with a blockout `.edm` so the slot survives and the aircraft renders.
