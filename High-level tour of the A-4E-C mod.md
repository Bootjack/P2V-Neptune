Here's your high-level tour of how the A-4E-C mod works,
  organized as a roadmap for building your own aircraft.

  ---
  1. Entry Point — How DCS Discovers Your Mod

  A-4E-C/entry.lua is the single most important file. It's
  the handshake with DCS:

  - declare_plugin() — registers the mod's name, version,
  binaries (your EFM DLL), skins, missions, input profiles,
   and options
  - mount_vfs_*() calls — mount your custom assets into
  DCS's virtual filesystem:
    - mount_vfs_model_path() — 3D models (.edm files)
    - mount_vfs_texture_path() — textures
    - mount_vfs_sound_path() — sound definitions
    - mount_vfs_liveries_path() — livery directories
  - make_flyable() — the critical call that registers the
  aircraft as player-flyable, linking cockpit scripts,
  flight model data, and comms
  - dofile() calls load the aircraft definition, weapons,
  and payloads
  - plugin_done() — finalizes registration

  Everything flows from this file. For a P-2 Neptune, you'd
   create P-2V/entry.lua with the same structure, changing
  names and paths.

  ---
  2. Aircraft Definition — A-4E-C/A-4E-C.lua

  This ~95KB file defines the aircraft itself for DCS's
  database:

  - Built-in weapons via declare_weapon() (e.g., the Colt
  MK12 20mm guns)
  - Pylon configurations — what can be loaded on each
  hardpoint, with CLSIDs linking to DCS's weapon database
  - Physical properties passed to make_flyable(): center of
   mass, moments of inertia
  - Suspension/gear geometry (defined in
  Entry/Suspension.lua) — wheel positions, damping,
  friction

  For the Neptune, this is where you'd define its turrets,
  bomb bay, pylon stations, and physical characteristics.

  ---
  3. External Flight Model (EFM) — The C++ Core

  A-4E-C/ExternalFM/ contains 50+ C++ source files compiled
   into Scooter.dll. This is the flight dynamics engine.

  Key modules:

  ┌───────────────────┬─────────────────────────────────┐
  │       File        │             Purpose             │
  ├───────────────────┼─────────────────────────────────┤
  │ Scooter.h/cpp     │ Main EFM implementation —       │
  │                   │ exports the DCS FM API          │
  ├───────────────────┼─────────────────────────────────┤
  │ FlightModel.h/cpp │ Aerodynamic force/moment        │
  │                   │ calculations                    │
  ├───────────────────┼─────────────────────────────────┤
  │ Airframe.h/cpp    │ Structural model, control       │
  │                   │ surfaces                        │
  ├───────────────────┼─────────────────────────────────┤
  │ Engine2.h/cpp     │ Engine simulation (J65          │
  │                   │ turbojet)                       │
  ├───────────────────┼─────────────────────────────────┤
  │ FuelSystem2.h/cpp │ Fuel tank management, transfer  │
  │                   │ logic                           │
  ├───────────────────┼─────────────────────────────────┤
  │ Radar.h/cpp       │ AN/APG-53A radar simulation     │
  ├───────────────────┼─────────────────────────────────┤
  │ Avionics.h/cpp    │ Avionics integration            │
  └───────────────────┴─────────────────────────────────┘

  DCS interface: The ED_FM_API.h header defines the C API
  that DCS calls — functions for forces, moments,
  atmosphere, damage, etc. Your DLL must export these.

  Build system: The root CMakeLists.txt builds the DLL and
  links against CockpitBase.lib (a proprietary DCS library)
   and Lua. It also has a code generation step that
  converts Lua device/command IDs into C++ headers, keeping
   the two sides synchronized.

  For the Neptune, you'd need to model twin R-3350 radials
  + J34 jet pods, which is a significantly different engine
   model. The aerodynamics would also differ substantially
  (twin-engine, larger airframe).

  ---
  4. Cockpit Systems — The Lua Layer

  Cockpit/Scripts/ is where avionics and systems logic
  lives, entirely in Lua.

  Architecture:

  1. devices.lua — assigns a numeric ID to every cockpit
  device (~50 devices: ILS, engine, electrical, radar,
  weapons, etc.)
  2. device_init.lua — maps each device ID to a Lua script
  controller
  3. command_defs.lua — defines all cockpit commands
  (switches, buttons, knobs) starting at ID 10000
  4. mainpanel_init.lua (57KB) — defines every cockpit
  gauge, linking animation arguments in the 3D model to
  parameter values
  5. EFM_Data_Bus.lua — the bridge between Lua cockpit code
   and C++ flight model

  System scripts (Cockpit/Scripts/Systems/):

  ~30 Lua files, one per system: engine.lua,
  electric_system.lua, radar.lua, gear.lua, flaps.lua,
  rwr.lua, countermeasures.lua, afcs2.lua (autopilot),
  shrike.lua (AGM-45 guidance), etc.

  Data flow:

  Player Input → command_defs → device controller (Lua) →
  EFM_Data_Bus → C++ flight model
  C++ flight model → parameter handles → mainpanel_init
  gauges → cockpit 3D model animations

  ---
  5. 3D Models

  Models are .edm files (DCS's proprietary format, exported
   from 3ds Max with ED's plugin). They aren't in this repo
   (see .gitignore / get_binaries.py), but are referenced
  by name:

  - External model: mounted from Shapes/ directory
  - Cockpit model: shape_name = "Cockpit_A-4E" in
  mainpanel_init.lua, mounted from Cockpit/Shapes/
  - Animation arguments: numbered 0–999, driven by Lua
  parameters — these animate gear, flaps, needles,
  switches, etc.

  ---
  6. Sounds — Sounds/sdef/

  ~60 .sdef files (DCS sound definition format) organized
  under Sounds/sdef/Aircrafts/A-4E-C/. These define engine
  sounds, airflow, gear, missile seekers, RWR tones, etc.
  They reference .ogg audio files and are mounted via
  mount_vfs_sound_path().

  ---
  7. Liveries — Liveries/A-4E-C/

  Each livery is a folder with a description.lua that maps
  material names in the 3D model to texture files:

  livery = {
      {"Top", DIFFUSE, "my_texture_top", true},
      {"Bottom", ROUGHNESS_METALLIC, "my_roughmet", true},
  }

  DCS auto-discovers livery folders. Countries are listed
  to control which factions can use each skin.

  ---
  8. Input Bindings — Input/

  Organized by device type (joystick/, keyboard/, mouse/),
  each with a default.lua. These reference commands from
  command_defs.lua and organize them into categories. They
  extend DCS's common binding profile via
  external_profile().

  ---
  9. Weapons & Loadouts — Weapons/ and UnitPayloads/

  - Weapons/A4E_Weapons.lua (102KB) — defines every weapon
  via declare_weapon() and declare_loadout(), including
  drag coefficients, weights, shape references, and DCS
  weapon type attributes
  - UnitPayloads/A-4E-C.lua — defines preset loadout
  combinations for the mission editor

  ---
  10. Options & Config

  - Options/ — mod-specific settings UI (trim speeds,
  cockpit shake, radar mode, brake assist, etc.) with a
  .dlg dialog definition and Lua data files
  - Config/config.lua — ejection seat trajectory animation

  ---
  Summary: What You'd Need for a P-2V Neptune

  ┌────────────────┬────────┬─────────────────────────┐
  │   Component    │ Effort │          Notes          │
  ├────────────────┼────────┼─────────────────────────┤
  │ entry.lua      │ Low    │ Boilerplate, change     │
  │                │        │ names/paths             │
  ├────────────────┼────────┼─────────────────────────┤
  │ Aircraft       │        │ Define pylons, bomb     │
  │ definition     │ Medium │ bay, turrets, physical  │
  │                │        │ properties              │
  ├────────────────┼────────┼─────────────────────────┤
  │ External       │        │ Twin recip + jet pods,  │
  │ Flight Model   │ Very   │ larger airframe,        │
  │ (C++)          │ High   │ completely different    │
  │                │        │ aero                    │
  ├────────────────┼────────┼─────────────────────────┤
  │ Cockpit        │        │ Different instruments,  │
  │ systems (Lua)  │ High   │ multi-crew stations,    │
  │                │        │ different avionics      │
  ├────────────────┼────────┼─────────────────────────┤
  │ 3D models      │ Very   │ Full modeling,          │
  │ (external +    │ High   │ texturing, rigging with │
  │ cockpit)       │        │  animation args         │
  ├────────────────┼────────┼─────────────────────────┤
  │ Sounds         │ Medium │ Engine recordings,      │
  │                │        │ systems sounds          │
  ├────────────────┼────────┼─────────────────────────┤
  │ Liveries       │ Low    │ Template once model is  │
  │                │        │ done                    │
  ├────────────────┼────────┼─────────────────────────┤
  │ Input bindings │ Low    │ Map commands to         │
  │                │        │ controls                │
  ├────────────────┼────────┼─────────────────────────┤
  │ Weapons        │ Medium │ Torpedoes, depth        │
  │                │        │ charges, bombs, rockets │
  └────────────────┴────────┴─────────────────────────┘

  The A-4E-C is an excellent template. The architecture is
  clean and well-separated. You can largely copy the
  structure, rename everything, and start replacing systems
   one at a time.
