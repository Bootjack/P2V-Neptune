ViewSettings = {
    Cockpit = {
        -- CockpitLocalPoint places the entire cockpit EDM so its world origin lands at
        -- this position in airframe coords (X fwd+, Y up+, Z right+). The pilot's head
        -- must be at the EDM world origin; EyePoint is a fine-tune offset from there.
        [1] = {  -- Pilot (left seat)
            CameraViewAngleLimits  = {20.0, 140.0},
            CockpitLocalPoint      = {0.625, 1.165, -0.575},
            CameraAngleRestriction = {false, 90.0, 0.4},
            CameraAngleLimits      = {200.0, -90.0, 90.0},
            EyePoint               = {0.0, 0.0, 0.0},
            ShoulderSize           = 0.25,
            Allow360rotation       = false,
            limits_6DOF            = {
                x    = {-0.10, 0.40},
                y    = {-0.30, 0.15},
                z    = {-0.25, 0.25},
                roll = 90.0,
            },
        },
        [2] = {  -- Copilot (right seat, ~1.1 m right of pilot)
            CameraViewAngleLimits  = {20.0, 140.0},
            CockpitLocalPoint      = {0.625, 1.165, 0.575},
            CameraAngleRestriction = {false, 90.0, 0.4},
            CameraAngleLimits      = {200.0, -90.0, 90.0},
            EyePoint               = {0.0, 0.0, 0.0},
            ShoulderSize           = 0.25,
            Allow360rotation       = false,
            limits_6DOF            = {
                x    = {-0.10, 0.40},
                y    = {-0.30, 0.15},
                z    = {-0.25, 0.25},
                roll = 90.0,
            },
        },
    },

    Chase = {
        LocalPoint      = {-18.0, 6.0, -8.0},
        AnglesDefault   = {-60.0, -30.0},
    },

    Arcade = {
        LocalPoint      = {-40.0, 10.0, 0.0},
        AnglesDefault   = {0.0, -8.0},
    },
}

SnapViews = {
    [1] = {
        [1] = { -- default forward
            viewAngle = 75.0,
            hAngle    = 0.0,
            vAngle    = -8.0,
            x_trans   = 0.0,
            y_trans   = 0.0,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
        [2] = { -- instrument panel
            viewAngle = 50.0,
            hAngle    = 0.0,
            vAngle    = -35.0,
            x_trans   = 0.1,
            y_trans   = -0.05,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
        [3] = { -- left window
            viewAngle = 85.0,
            hAngle    = 80.0,
            vAngle    = -10.0,
            x_trans   = 0.0,
            y_trans   = 0.0,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
        [4] = { -- right window
            viewAngle = 85.0,
            hAngle    = -80.0,
            vAngle    = -10.0,
            x_trans   = 0.0,
            y_trans   = 0.0,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
        [5] = { -- overhead panel
            viewAngle = 70.0,
            hAngle    = 0.0,
            vAngle    = 50.0,
            x_trans   = 0.0,
            y_trans   = 0.0,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
        [6] = { -- throttle quadrant
            viewAngle = 50.0,
            hAngle    = -45.0,
            vAngle    = -30.0,
            x_trans   = 0.0,
            y_trans   = 0.0,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
    },
    [2] = {
        [1] = { -- copilot default forward
            viewAngle = 75.0,
            hAngle    = 0.0,
            vAngle    = -8.0,
            x_trans   = 0.0,
            y_trans   = 0.0,
            z_trans   = 0.0,
            rollAngle = 0.0,
        },
    },
}
