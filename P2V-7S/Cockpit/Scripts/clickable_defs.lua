cursor_mode = {
    CUMODE_CLICKABLE             = 0,
    CUMODE_CLICKABLE_AND_CAMERA  = 1,
    CUMODE_CAMERA                = 2,
}

clickable_mode_initial_status = cursor_mode.CUMODE_CLICKABLE
use_pointer_name  = true
anim_speed_default = 16

-- Two-position toggle switch (rocker/flipper).
-- arg cycles between 0 (aft/down/off) and 1 (fwd/up/on).
-- value sent to SetCommand: +1 when toggling on, -1 when toggling off.
function default_2_position_tumb(hint_, device_, command_, arg_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default
    return {
        class           = {class_type.TUMB, class_type.TUMB},
        hint            = hint_,
        device          = device_,
        action          = {command_, command_},
        arg             = {arg_, arg_},
        arg_value       = {1, -1},
        arg_lim         = {{0, 1}, {0, 1}},
        updatable       = true,
        use_OBB         = true,
        animated        = {true, true},
        animation_speed = {animation_speed_, animation_speed_},
        sound           = sound_ and {{sound_, sound_}} or nil,
    }
end
