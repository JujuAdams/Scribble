// Feather disable all
/// @param angle      Maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right
/// @param frequency  Wobble frequency. Larger values cause glyphs to oscillate faster

function scribble_anim_wobble(_angle, _frequency)
{
    static _array = __scribble_initialize().__anim_properties;
    
    if ((_angle     != _array[__SCRIBBLE_ANIM.__WOBBLE_ANGLE])
    ||  (_frequency != _array[__SCRIBBLE_ANIM.__WOBBLE_FREQ ]))
    {
        _array[@ __SCRIBBLE_ANIM.__WOBBLE_ANGLE] = _angle;
        _array[@ __SCRIBBLE_ANIM.__WOBBLE_FREQ ] = _frequency;
        
        static _scribble_state = __scribble_initialize().__state;
        with(_scribble_state)
        {
            __shader_anim_desync            = (not __shader_anim_disabled); //Only re-set uniforms when the animations aren't disabled
            __shader_anim_desync_to_default = false;
        }
    }
}
