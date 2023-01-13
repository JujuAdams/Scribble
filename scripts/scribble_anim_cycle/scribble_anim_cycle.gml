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
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}