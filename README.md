# P2V-7S Neptune — DCS World Community Mod

An in-development, full-fidelity [DCS World](https://www.digitalcombatsimulator.com/) aircraft mod for the
**Lockheed P2V-7S (SP-2H) Neptune** — a Cold War maritime patrol and anti-submarine warfare aircraft with
twin Wright R-3350 radials, twin Westinghouse J34 turbojet pods, and a full ASW sensor suite (MAD, sonobuoys,
Jezebel/Julie).

This is a **learning project** — depth over speed. The goal is to learn the entire DCS modding stack
(Lua aircraft definitions, EDM 3D models, clickable cockpits, and a C++ External Flight Model) by building one
aircraft properly, using the [A-4E-C community mod](https://github.com/heclak/community-a4e-c) as a structural
reference.

> ⚠️ **Status: early development (Phase 1).** The aircraft spawns, renders, and flies as AI on a placeholder
> flight model. There is no cockpit, no textures, no weapons, and no sound yet. Not flyable by players in any
> meaningful sense. See the [roadmap](#roadmap) and [`DEVLOG.md`](DEVLOG.md).

## What works today

- Loads in DCS and appears in the module manager and Mission Editor.
- Spawns as an AI aircraft, renders a rough blockout exterior model, and flies (rough placeholder SFM).
- Sits on its landing gear, takes off, navigates to waypoints.
- Damage/collision model wired to the exterior collision shells.

## Requirements

- **To run:** DCS World OpenBeta (developed against **2.9.27**).
- **To develop the model:** [Blender](https://www.blender.org/) with Eagle Dynamics' official EDM exporter plugin.
- **To develop the EFM (later):** a C++ toolchain (CMake + MSVC) — not required yet.

## Installation / deployment

The mod is deployed by creating a Windows **directory junction** from your DCS Saved Games folder to this
repo's `P2V-7S/` directory, so edits are live without copying.

```powershell
# from the repo root, in PowerShell:
powershell -ExecutionPolicy Bypass -File .\deploy.ps1
```

Then restart DCS. To remove it, run `undeploy.ps1` the same way.

Notes:
- `deploy.ps1` uses a junction (no Administrator needed). The target path
  (`D:\Saved Games\DCS.openbeta\Mods\aircraft`) is set near the top of the script — edit it if your DCS Saved
  Games folder is elsewhere.
- If PowerShell blocks the script ("not digitally signed"), the `-ExecutionPolicy Bypass` invocation above
  handles it; for a persistent fix run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

## Repository structure

| Path | Purpose |
|------|---------|
| `P2V-7S/` | The DCS mod itself — **the only thing deployed to DCS** (Lua definitions, `Shapes/*.edm`, input, liveries). |
| `Source/` | Art/working files — Blender `.blend`, reference drawings, texture source. **Not shipped.** See `Source/README.md`. |
| `deploy.ps1` / `undeploy.ps1` | Create/remove the DCS junction. |
| `DEVLOG.md` | Running development log — decisions, bugs, fixes, and lessons. |
| `Implementation Plan.md` | Phase-by-phase build plan. |
| `CLAUDE.md` | Project conventions and key paths (also used by the Claude Code assistant). |
| `CHANGELOG.md` | Versioned change history. |

The exterior model exports from `Source/Blender/` to `P2V-7S/Shapes/P2V-7S.edm`.

## Roadmap

- **Phase 0 — Scaffold:** mod recognized by DCS. ✅
- **Phase 1 — Ramp presence:** blockout model spawns, renders, and flies (placeholder SFM). ✅ *(current)*
- **Phase 2 — Clickable cockpit framework:** cockpit model + switches/knobs animate.
- **Phase 3 — Core systems:** electrical, engines (R-3350 + J34), fuel.
- **Phase 4 — Flight:** EFM aerodynamics (`Neptune.dll`) replacing the placeholder SFM.
- **Phase 5 — Navigation & radios.**
- **Phase 6 — ASW mission systems:** MAD, sonobuoys, Jezebel/Julie, searchlight.
- **Phase 7 — Sound, liveries, weapons, polish.**

See [`Implementation Plan.md`](Implementation%20Plan.md) for detail.

## License

To be determined. This is an **unofficial, fan-made** project and is **not affiliated with or endorsed by**
Eagle Dynamics or Lockheed Martin. "DCS World" is a trademark of Eagle Dynamics.
