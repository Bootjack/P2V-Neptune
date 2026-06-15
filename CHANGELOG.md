# Changelog

All notable changes to the P2V-7S Neptune mod are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project aims to follow [Semantic Versioning](https://semver.org/). Until a `1.0.0` release, minor versions track development phases and the API/behavior may change freely.

## [Unreleased]

### Added
- `README.md` and `CHANGELOG.md`.
- Landing-gear ground-contact geometry (`nose_gear_pos` / `main_gear_pos`, amortizer strokes, wheel diameters) so the aircraft rests on its wheels instead of the bounding box.

### Fixed
- LOD display distance: the single LOD was named for a 50 m range, so the model vanished when zoomed out; extended so it renders at normal viewing distances.
- Gear resting height: `gear_pos.y` must be the wheel **ground-contact point** (bottom of the tire), not the axle/hub — the off-by-a-wheel-radius error was sinking the aircraft.

## [0.1.0] - 2026-06-14 — Phase 1: first spawn

First build that spawns, renders, and flies (as AI, on a rough placeholder flight model).

### Added
- Blockout exterior `.edm` model (untextured), with collision shells and a bounding/user box.
- `SFM_Data` block (placeholder aerodynamics + engine tables) — **required** for the SFM/AI flight model; its absence was the Phase 1 spawn crash.
- Damage/collision model wired 1:1 to the exterior collision shells (`GEAR_FRONT`, `GEAR_L`, `GEAR_R`, `MAIN`).
- `WorldID` on the unit type; P2V performance parameters (mass, dimensions, speeds, thrust placeholders).
- Art-source workflow under `Source/` (Blender working files kept out of the shipped mod).

### Fixed
- Spawn crash (`ACCESS_VIOLATION` in the flight-model init FSM) caused by the missing `SFM_Data` block.
- "Corrupt damage model" crash: collision-shell object names must match DCS's cell vocabulary and be a 1:1 set with the `Damage` table (no extra keys, no unmatched shells).
- Empty (541-byte) `.edm` exports: meshes were dropped because they had no EDM material assigned.
- Required EDM scene structure: `Export` root → `LOD_0_*` (meshes) + `Collision` (shells), with `Bounding_Box` / `User_Box` as Empty Cubes typed via the exporter's `Obj.Type` (not a custom property).

### Notes
- No cockpit, textures, weapons, or sound yet. `sounderName` intentionally disabled until sound files exist.
- Default task is `Reconnaissance` (the aircraft is weaponless for now).
- The placeholder `SFM_Data` will be replaced by the External Flight Model (`Neptune.dll`) in Phase 4.

## [0.0.1] - 2026-06-13 — Phase 0: scaffold

### Added
- Full DCS aircraft mod scaffold (~22 files): `entry.lua`, aircraft definition, views, comm, suspension, cockpit script stubs (devices, command defs, mainpanel, device_init, EFM data bus), input bindings, and livery/options/weapons/payload stubs.
- `deploy.ps1` / `undeploy.ps1` for junction-based deployment to DCS Saved Games.

### Fixed
- Deploy: switched from a symlink (needs admin) to a directory junction; documented the PowerShell execution-policy workaround.
- Startup crashes from an empty `Sounds/` mount and a missing `Tasks` field in the aircraft definition.

[Unreleased]: https://github.com/Bootjack/P2V-Neptune/compare/main...HEAD
[0.1.0]: https://github.com/Bootjack/P2V-Neptune/commits/main
[0.0.1]: https://github.com/Bootjack/P2V-Neptune/commits/main
