function clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function move_toward(current, target, step)
    if current < target then
        return math.min(current + step, target)
    elseif current > target then
        return math.max(current - step, target)
    end
    return current
end

POUNDS_TO_KG  = 0.453592
GALLON_TO_KG  = 3.0856   -- avgas
KTS_TO_MPS    = 0.514444
FT_TO_M       = 0.3048
NM_TO_M       = 1852.0
