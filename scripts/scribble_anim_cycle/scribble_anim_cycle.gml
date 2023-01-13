/// @param speed       Cycle speed. Larger numbers cause characters to change colour more rapidly
/// @param saturation  Cycle colour saturation, from 0 to 255. Colour cycles using the HSV model to create colours
/// @param value       Cycle colour value, from 0 to 255. Colour cycles using the HSV model to create colours

function scribble_anim_cycle(_speed, _saturation, _value)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_speed      != _array[__SCRIBBLE_ANIM.__CYCLE_SPEED     ])
    ||  (_saturation != _array[__SCRIBBLE_ANIM.__CYCLE_SATURATION])
    ||  (_value      != _array[__SCRIBBLE_ANIM.__CYCLE_VALUE     ]))
    {
        _array[@ __SCRIBBLE_ANIM.__CYCLE_SPEED     ] = _speed;
        _array[@ __SCRIBBLE_ANIM.__CYCLE_SATURATION] = _saturation;
        _array[@ __SCRIBBLE_ANIM.__CYCLE_VALUE     ] = _value;
        
        static _scribble_state = __scribble_get_state();
        with(_scribble_state)
        {
            __standard_anim_desync            = true;
            __standard_anim_desync_to_default = false;
            __msdf_anim_desync                = true;
            __msdf_anim_desync_to_default     = false;
        }
    }
}