# P2V-7S Neptune DCS Mod — Implementation Plan

## Context

The goal is to build a full-fidelity DCS World aircraft mod for the Lockheed P2V-7S (SP-2H) Neptune, a Cold War-era maritime patrol / ASW aircraft. The mod will use the A-4E-C community mod as a structural reference and template. The goal is learning the full DCS modding stack, not shipping fast. The aircraft features twin R-3350 radial engines plus twin J34 jet pods, a multi-station crew (pilot, copilot, sensor operators), and ASW mission systems (MAD, sonobuoys, Jezebel/Julie). Multi-crew is not available to community modders, so crew stations will be AI-automated with pilot-accessible controls.

The 3D model will follow a hybrid approach: a rough blockout with correct proportions and instrument panel faces, detailed enough to place gauges and switches, refined over time.

## Project Identity

- Mod folder name: P2V-7S (DCS mod directory)
- Aircraft ID: P2V-7S (used in declare_plugin, make_flyable, database)
- EFM DLL name: Neptune (binary name in entry.lua)
- Display name: P2V-7S Neptune

## Gameplan

### Phase 0: Project Scaffold & DCS Recognition

Goal: DCS sees the mod in the module list. Nothing loads, nothing flies — just proof that the plumbing works.

Files to create:

```
P2V-7S/
├── entry.lua                          # declare_plugin,
mount paths, make_flyable, plugin_done
├── P2V-7S.lua                         # Aircraft
definition (minimal: empty pylons, basic mass/inertia)
├── Views.lua                          # Pilot eye
position, basic snap views
├── comm.lua                           # Stub — empty
radio menu
├── Entry/
│   └── Suspension.lua                 # Landing gear
geometry (tricycle gear positions, damping)
├── Cockpit/
│   ├── Scripts/
│   │   ├── devices.lua                # Device ID enum
(start with ~8 devices)
│   │   ├── device_init.lua            # MainPanel +
minimal device creators
│   │   ├── mainpanel_init.lua         # shape_name, basic
gauge stubs
│   │   ├── command_defs.lua           # Minimal command
set
│   │   ├── EFM_Data_Bus.lua           # Stub — parameter
handles, no DLL require yet
│   │   └── utils.lua                  # Utility functions
(can copy from A-4E-C)
│   └── Shapes/                        # Empty initially
(blockout model goes here later)
├── Shapes/                            # External model
placeholder
├── Textures/                          # Placeholder
textures
├── Input/
│   ├── name.lua                       # Input profile
name
│   ├── keyboard/
│   │   └── default.lua                # Minimal
keybindings
│   └── joystick/
│       └── default.lua                # Minimal joystick
bindings
├── Liveries/
│   └── P2V-7S/
│       └── default/
│           └── description.lua        # Default livery
stub
├── Sounds/                            # Empty initially
├── Weapons/
│   └── P2V7S_Weapons.lua             # Empty — no weapons
yet
├── UnitPayloads/
│   └── P2V-7S.lua                     # Empty payload
table
└── Options/
    ├── optionsData.lua                # Minimal options
    └── optionsDb.lua                  # Option defaults
```

Key reference files from A-4E-C:

- A-4E-C/entry.lua — structure to replicate
- A-4E-C/Cockpit/Scripts/devices.lua — counter pattern
- A-4E-C/Cockpit/Scripts/device_init.lua — creator pattern
- A-4E-C/Views.lua — view settings structure
- A-4E-C/Entry/Suspension.lua — gear physics format

Milestone test:

- Install mod in DCS World/Mods/aircraft/P2V-7S/
- DCS shows "P2V-7S Neptune" in the module manager
- Aircraft appears in Mission Editor (even if it crashes on spawn — that's Phase 1's problem)

---

### Phase 1: Ramp Presence

Goal: Aircraft spawns on a ramp without crashing DCS. Placeholder geometry visible. Pilot can sit in cockpit and look around.

Depends on:

- Blender blockout model exported as .edm (cockpit + external)
- Minimal EFM DLL that returns zero forces (aircraft sits under gravity)

Work:

1. Blockout 3D model — rough cockpit shell with:
  - Instrument panel face (flat, correct proportions)
  - Throttle quadrant area
  - Overhead panel area
  - Windscreen/canopy frame
  - Pilot seat position
  - Export as Cockpit_P2V7S.edm via Blender EDM exporter
2. External model — basic fuselage shape, wings, empennage, gear (can be very rough)
3. Minimal EFM DLL — Neptune.dll:
  - Implement all required ed_fm_* exports with stub/zero returns
  - Return non-zero fuel from ed_fm_get_internal_fuel()
  - Set draw args for gear-down position
  - Build with CMake + MSVC, output to bin/Neptune.dll
  - No flight physics yet — just don't crash
4. Wire up entry.lua — point to real model paths, reference Neptune binary
5. Fix mainpanel_init.lua — reference Cockpit_P2V7S shape, define a few basic gauges tied to model animation args

Milestone test:

- Cold start on Batumi ramp
- Aircraft visible in external view
- F1 cockpit view shows interior
- Head tracking / mouse look works
- No DCS crash or error log spam

---
Phase 2: Clickable Cockpit Framework

Goal: Switches click, knobs turn, lights illuminate. No systems logic yet — just input → animation.

Devices to implement (stubs with click response):

1. ELECTRIC_SYSTEM — master battery switch, generator switches
2. ENGINE — throttle quadrant (4 levers: 2 recip throttle, 2 jet throttle), mixture, prop RPM
3. CANOPY — entry hatch
4. GEAR — gear handle
5. FLAPS — flap lever
6. EXT_LIGHTS — nav lights, landing lights, taxi light
7. INT_LIGHTS — instrument panel lights, flood lights
8. FUEL_SYSTEM — fuel selector, crossfeed, tank switches

Work:

1. command_defs.lua — define commands for every cockpit control
2. clickable_defs.lua — define clickable zones on the 3D model
3. System scripts — one .lua per device, following the A-4E-C pattern:
  - GetSelf(), make_default_activity(), listen_command()
  - SetCommand() toggles state
  - update() drives animation args
4. mainpanel_init.lua — expand gauge definitions for each animated element
5. Input bindings — keyboard/joystick mappings for all commands

Key A-4E-C reference:

- Cockpit/Scripts/Systems/canopy.lua — simplest device pattern
- Cockpit/Scripts/Systems/ext_lights.lua — switch → state → animation
- Cockpit/Scripts/clickable_defs.lua — clickable zone format

Milestone test:

- Click battery switch → switch animates
- Move throttle with mouse → lever moves
- Gear handle clicks up/down
- All switches have keybindings

---

### Phase 3: Core Systems — Power, Engines, Fuel

Goal: Systems have real logic. Electrical bus powers instruments. Engines start and run. Fuel depletes.

Work:

1. Electrical system — DC bus, battery, 2 engine-driven generators, essential/non-essential buses. Switches control power flow. Instruments require power to display.
2. Engine system (R-3350s) — startup sequence: battery → starter → ignition → idle. Throttle controls RPM. EGT, oil pressure, manifold pressure gauges respond. Engine instruments: tachometer, manifold pressure, cylinder head temp, oil temp/pressure, fuel flow.
3. Engine system (J34 jets) — simpler: start switch → spool → idle → throttle. EGT, RPM gauges.
4. Fuel system — internal tanks (bomb bay, wing), fuel selectors, crossfeed, quantity gauges. Fuel flow to engines. Transfer logic between tanks.
5. EFM_Data_Bus.lua — now connects to real parameter handles. Wire up engine params, fuel, electrical state.
6. EFM DLL update — implement basic engine model:
  - R-3350: throttle → RPM → thrust (lookup table initially)
  - J34: throttle → RPM → thrust
  - Fuel consumption
  - Still no aerodynamics — just thrust and fuel burn on the ramp

Key A-4E-C reference:

- Cockpit/Scripts/Systems/electric_system.lua + electric_system_api.lua
- Cockpit/Scripts/Systems/engine.lua
- ExternalFM/FM/Engine2.h/cpp
- ExternalFM/FM/FuelSystem2.h/cpp

Milestone test:

- Cold & dark start: no instruments lit
- Battery on → essential bus powered → some instruments alive
- Engine start sequence: starter whine → ignition → idle RPM
- Throttle up → RPM increases, fuel flow increases
- Fuel quantity decreases over time
- Engine shutdown sequence works

---

### Phase 4: Flight

Goal: Aircraft taxies, takes off, flies, and lands. Basic but believable aerodynamics.

Work:

1. EFM aerodynamic model — implement in C++:
  - Lift as function of AoA and airspeed
  - Drag (parasitic + induced)
  - Pitch/roll/yaw moments from control surfaces
  - Ground effect
  - Basic stall behavior
  - Prop torque / P-factor (asymmetric thrust)
  - Use NACA data for the P2V's wing (NACA 23000 series)
2. Flight controls — elevator, ailerons, rudder:
  - Stick and pedal inputs → control surface deflection
  - Trim system (elevator, rudder, aileron trim tabs)
3. Landing gear physics — weight on wheels, braking, nosewheel steering, taxi behavior
4. Flap system — flap deployment affects lift/drag curves
5. Basic instruments for flight — altimeter, airspeed indicator, attitude indicator, heading indicator, VSI, turn coordinator
6. Views.lua refinement — correct external chase cam position for the larger airframe

Key A-4E-C reference:

- ExternalFM/FM/FlightModel.h/cpp — aerodynamic calculation structure
- ExternalFM/FM/Airframe.h/cpp — control surface management
- Cockpit/Scripts/Systems/flaps.lua, trim.lua
- Basic EFM Template (external reference) for starting point

Milestone test:

- Taxi under own power with nosewheel steering
- Takeoff roll → rotation → climb
- Level flight, turns, climbs, descents
- Approach and landing (even if rough)
- Asymmetric thrust noticeable with one engine out
- Stall behavior (nose drop, not instant spin)

---

### Phase 5: Navigation & Radios

Goal: Navigate by instruments. Communicate with ATC/AI. SRS integration.

Work:

1. Radio system — ARC-27 UHF radio (or period-appropriate set):
  - Frequency selection via cockpit controls
  - comm.lua radio menus for AI comms
  - VOIP_Radios/Installations/P2V-7S.lua for SRS
2. Navigation — ADF receiver, TACAN (if P2V-7S had it, otherwise omni/ADF):
  - Bearing indicator on instrument panel
  - Frequency/channel selection
3. ILS — approach capability if historically accurate

Key A-4E-C reference:

- Cockpit/Scripts/Systems/radio_controls.lua — ARC-51 implementation
- VOIP_Radios/Installations/A-4E-C.lua — SRS hookup
- Cockpit/Scripts/Nav/ — navigation system scripts
- comm.lua — radio menu structure

Milestone test:

- Tune radio frequency → hear ATIS
- ADF needle points to NDB
- SRS shows correct frequency in multiplayer
- AI wingman responds to radio commands

---

### Phase 6: ASW Mission Systems

Goal: The unique Neptune systems that make this mod
special.

Work:

1. MAD (Magnetic Anomaly Detector) — custom cockpit device:
  - MAD boom extend/retract (animation)
  - Detection logic: query DCS for submarine units within range
  - Cockpit indicator: trace/needle deflection on approach
  - Auto-mark capability (smoke marker drop on detection)
  - Operator panel with sensitivity controls
2. Sonobuoy system — custom device:
  - Sonobuoy launcher tubes (deployable stores)
  - Pattern deployment controls (cockpit panel)
  - Deployment via mission scripting bridge (Lua triggers)
  - Buoy status panel (active/expired/detecting)
3. Jezebel/Julie listening station — custom cockpit device:
  - Frequency analyzer display (custom indicator, like the radar display)
  - Signal processing: passive (Jezebel) vs active (Julie) modes
  - Contact classification interface
  - AI operator automation: "crew" processes signals, presents bearings
  - LOFARgram-style display (custom 2D rendering)
4. Searchlight — belly-mounted searchlight for night ASW:
  - Extend/retract, on/off, slew controls
5. Mission scripting integration — Lua scripts that:
  - Spawn submarine targets with configurable behavior
  - Simulate sonobuoy acoustic detection zones
  - Feed detection data back to cockpit devices via EFM data bus

Key A-4E-C reference:

- Cockpit/Scripts/RADAR/ — custom sensor display (indicator pattern)
- ExternalFM/FM/Radar.h/cpp — C++ sensor simulation
- Cockpit/Scripts/Systems/shrike.lua — weapon-sensor integration pattern

Milestone test:

- MAD boom extends, needle deflects when near submarine unit
- Sonobuoys deploy from aircraft
- Jezebel display shows bearing lines to acoustic contacts
- AI crew calls out contacts
- Complete ASW search pattern: deploy buoys → prosecute contact → MAD confirm → mark

---

### Phase 7: Sound & Polish

Goal: Immersive audio, liveries, weapons, documentation.

Work:

1. Sound design — .sdef files for:
  - R-3350 engine sounds (start, idle, cruise, shutdown)
  - J34 jet pod sounds
  - Airflow, gear, flaps
  - Cockpit switches and systems
  - MAD audio tones
  - Sonobuoy deployment sounds
2. Liveries — VP squadron paint schemes (VP-1 through VP-56, foreign operators)
3. Weapons — depth charges, torpedoes (Mk 43/44), bombs, rockets, mines
4. Options menu — trim speeds, control sensitivity, system automation toggles
5. Kneeboard — checklists, performance charts, ASW procedures

---

Initial Project Setup Steps (what to do first)

These are the concrete first steps to execute when we exit planning:

1. Create the project directory structure under a new repo (not inside the A-4E-C repo)
2. Write entry.lua — adapted from A-4E-C's, with P2V-7S names/paths
3. Write the minimal Lua scaffold — devices.lua, device_init.lua, command_defs.lua, mainpanel_init.lua (all stubs)
4. Write P2V-7S.lua — aircraft definition with correct mass, dimensions, empty pylons
5. Write Views.lua — pilot eye position for the P2V cockpit
6. Write stub files — comm.lua, Suspension.lua, weapons, payloads
7. Set up the EFM build — CMakeLists.txt, minimal C++ stubs, build Neptune.dll
8. Write Input/ bindings — minimal keyboard/joystick defaults

After this scaffold is complete, DCS should recognize the mod. Then the blockout model and iterative system development begins.

---

Key Architectural Decisions

1. Lua device IDs — define all planned devices upfront in devices.lua (even unimplemented ones), so IDs stay stable as systems are added
2. Command ID ranges — reserve ranges in command_defs.lua for each system (e.g., 10000-10099 flight controls, 10100-10199 electrical, 10200-10299 engines, 10300-10399 ASW systems)
3. EFM data bus — define all planned parameter handles upfront with stub values, so cockpit scripts don't break as the C++ FM is built out
4. Code generation — adopt the A-4E-C's Lua→C++ header generation pattern from day one to keep device/command IDs synchronized
5. Separate repo — this is a new project, not a fork of A-4E-C
