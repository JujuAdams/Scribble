// Feather disable all

/// Sets the tick size with `1` representing a full tick. Setting this value lower will cause
/// text elements and typing to animate slower. `0` represents no animation at all. You may not
/// use a negative value for the tick size.
/// 
/// You may optionally set the tick size to `undefined` to allow Scribble to automatically
/// adjust all animation speeds relative to the framerate. This is calculated as follows:
/// 
///     `tickSize = clamp(delta_time / 16667, 1/5, 5);`
/// 
/// @param value

function scribble_set_tick_size(_value)
{
    static _system = __ScribbleSystem();
    with(_system)
    {
        if (is_numeric(_value))
        {
            __userTickSize = max(0, _value);
        }
        else
        {
            __userTickSize = undefined;
        }
    }
}