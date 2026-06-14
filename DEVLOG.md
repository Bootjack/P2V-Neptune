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
- Set up art workflow: working files (`.blend`, reference, texture source) live in `Source/` (never shipped); exterior model exports to `P2V-7S/Shapes/P2V-7S.edm`. See `Source/README.md`.

## 2026-06-14 ~05:00 — Phase 1: first model crashes on spawn (collision/damage)

### Crash #4: Corrupt damage model → ACCESS_VIOLATION
- First exterior `.edm` exported into `Shapes/`. DCS loaded the model fine, then crashed on spawn (`C0000005 ACCESS_VIOLATION`).
- dcs.log root cause:
  - `WORLDGENERAL: Unit [P2V-7S]: No property record for cell "Collision_Gear_Nose"` (also `_Main_Left`, `_Main_Right`)
  - `APP: Unit [P2V-7S]: Corrupt damage model.` → dump written
- Two-sided cause: (1) the model's collision-shell objects used invented names (`Collision_Gear_*`); DCS only accepts names from its fixed cell vocabulary in `DCS\Scripts\Aircrafts\_Common\Damage.lua`. (2) `P2V-7S.lua` had `Damage = {}`, so even a correct name had no property record.
- Key lesson: a collision shell's **object name** maps via `damage_cells` to a numbered cell, which must have a matching entry in the aircraft's `Damage` table. Name ↔ cell ↔ property record must all agree, or the damage model is "corrupt" and spawning crashes.

### Fix applied
- `P2V-7S.lua`: replaced `Damage = {}` with `verbose_to_dmg_properties{...}` (the A-4E-C pattern) covering gear cells `GEAR_FRONT` (8), `GEAR_L` (15), `GEAR_R` (16), plus stub hull cells `NOSE_CENTER`/`MAIN`/`TAIL` for later.
- Blender TODO: rename the three collision shells to `GEAR_FRONT` / `GEAR_L` / `GEAR_R` and re-export. Likely next: add a fuselage collision shell named `MAIN` for a stable ground/collision hull.
- Reference: gear names recognized by DCS — nose `FRONT_GEAR_BOX`/`GEAR_FRONT`/`STOIKA_F`; left `LEFT_GEAR_BOX`/`GEAR_L`/`STOIKA_L`; right `RIGHT_GEAR_BOX`/`GEAR_R`/`STOIKA_R`.

## 2026-06-14 — Phase 1: FIRST SUCCESSFUL SPAWN (the crash #6 saga)

### The bug
- After fixing the damage model, the P2V kept crashing at spawn: `C0000005 ACCESS_VIOLATION at …167` in `Common::FSM::onSymbol_ → enterToState_ → sendOutputSymbol_`, fired the instant `MissionSpawn:spawnPlanes` ran. The faulting address was `00:00000000` — a textbook **null-pointer deref**.
- **Root cause: `P2V-7S.lua` had no `SFM_Data` block.** With `AFMenabled = false`, both the SFM and the AI flight model are built from `SFM_Data` (aerodynamics polar + engine table) at spawn. With it absent, the flight-model FSM dereferenced null on instantiation. Added a placeholder `SFM_Data` (classic format: `aerodynamics.table_data` M/Cx0/Cya/B/B4/Omxmax/Aldop/Cymax + `engine` with thrust `table_data`) → **it spawned, rendered, and the AI flew toward its waypoint.**

### Why it took so long (and the lessons)
- The crash address was **byte-identical across every change** — empty model, render-only model, render+collision, a *known-good A-4E-C model swapped in*, A-4E-C flight params, `make_flyable` on/off, AI-only vs flyable, ground vs airborne, Caucasus vs Mariana, single unit, A-4E-C mod disabled. Nothing moved it.
- Lesson — **a frozen crash address = many causes funnel through one shared init path.** `Common::FSM` is a generic engine primitive; dozens of unrelated misconfigs all crash at the same `enterToState_` when the unit's state machines come online at spawn. Reading the address tells you *where*, never *why*; only isolation by elimination does.
- Lesson — **a model that *renders* is not a model that *spawns*.** The `.edm` showed fine in the ME loadout preview (pure graphics path) the whole time; the crash was in unit instantiation, which the preview never exercises. Don't trust "it renders" as "the model is fine."
- The decisive move: **swapping a known-good A-4E-C `.edm` AND its flight params in behind our own definition** — both still crashed → conclusively exonerated the model AND the param values → pointed at the one block neither provided: `SFM_Data` (the A-4E-C has one even though it's EFM).
- Tooling: verified `.edm` contents with `pdftotext`/`grep` of node-type strings (`model::RenderNode`, `ShellNode`, `LodNode`), but learned binary fields (bounding box, `SFM_Data` is Lua not model) aren't greppable — string-grep checks node *types*, not everything.

### Bugs fixed along the way (crash #5 and model-export issues)
- **Crash #5** — the `Damage` table and collision shells must be an *exact 1:1 set*: extra `Damage` keys with no matching shell throw `No cell for property records … → Corrupt damage model`. Trimmed `Damage` to exactly the shells present.
- **Empty `.edm` (541 bytes)** — meshes were silently dropped on export because they had **no EDM material**. Assigning EDM materials made `RenderNode` geometry appear (37 KB).
- **`Bounding_Box`/`User_Box`** — must be **Empty Cubes** in a **scene collection** (Outliner/View-Layer, checkbox enabled — *not* an object/group collection), with `Obj.Type` set via the EDM N-panel dropdown (not a `TYPE=` custom property). Required scene structure: `Export` root → `LOD_0_50` (meshes) + `Collision` (shells) + the two boxes.

### Current state
- P2V-7S spawns as AI, renders, and flies (rough placeholder SFM). `P2V-7S.lua` rolled back from the A-4 diagnostic clone to real P2V values; debugging changes reverted; `SFM_Data` placeholder + `WorldID` kept. `sounderName` still disabled (no sound files yet — crash #1). Textures show DCS "missing" placeholders (model is untextured — expected).
- Next: real cockpit `.edm` + clickable framework (Phase 2), and eventually the EFM (`Neptune.dll`) to replace the placeholder `SFM_Data`.
