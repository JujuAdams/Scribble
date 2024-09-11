// Feather disable all
/// @param speed       Cycle speed. Larger numbers cause characters to change colour more rapidly
/// @param saturation  Cycle colour saturation, from 0 to 255. Colour cycles using the HSV model to create colours
/// @param value       Cycle colour value, from 0 to 255. Colour cycles using the HSV model to create colours

function scribble_anim_cycle(_speed, _saturation, _value)
{
    static _array = __scribble_initialize().__anim_properties;
    
    if ((_speed      != _array[__SCRIBBLE_ANIM.__CYCLE_SPEED     ])
    ||  (_saturation != _array[__SCRIBBLE_ANIM.__CYCLE_SATURATION])
    ||  (_value      != _array[__SCRIBBLE_ANIM.__CYCLE_VALUE     ]))
    {
        _array[@ __SCRIBBLE_ANIM.__CYCLE_SPEED     ] = _speed;
        _array[@ __SCRIBBLE_ANIM.__CYCLE_SATURATION] = _saturation;
        _array[@ __SCRIBBLE_ANIM.__CYCLE_VALUE     ] = _value;
        
        static _scribble_state = __scribble_initialize().__state;
        with(_scribble_state)
        {
            __shader_anim_desync            = (not __shader_anim_disabled); //Only re-set uniforms when the animations aren't disabled
            __shader_anim_desync_to_default = false;
        }
    }
}
