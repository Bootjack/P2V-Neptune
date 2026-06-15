# Source / working art files (NOT shipped)

Everything under `Source/` is working material for building the mod — it is **not** part of the deployed mod and is never exposed to DCS. The DCS junction points only at `../P2V-7S/`, so keep heavy/working files here to keep the shipped mod lean.

```
Source/
└── Blender/
    ├── P2V-7S_exterior.blend   exterior model working file
    ├── reference/              3-views, photos, scale drawings
    └── textures/               source PSD/PNG, bakes (export flattened to the mod)
```

## Where exported assets go (into the shipped mod)

| Asset                | Export target                          | Notes |
|----------------------|----------------------------------------|-------|
| Exterior model       | `../P2V-7S/Shapes/P2V-7S.edm`          | Filename must be `P2V-7S.edm` (matches `Shape`/`shape_table_data`). |
| Cockpit model        | `../P2V-7S/Cockpit/Shapes/`            | Mounted in `entry.lua`. |
| Exterior textures    | `../P2V-7S/Textures/`                  | Mounted in `entry.lua`. |
| Cockpit textures     | `../P2V-7S/Cockpit/Textures/`          | Mounted in `entry.lua`. |

The mod is a live junction, so overwriting `P2V-7S/Shapes/P2V-7S.edm` updates DCS immediately — just restart DCS (or reload the mission) to see changes; no `deploy.ps1` re-run needed.
