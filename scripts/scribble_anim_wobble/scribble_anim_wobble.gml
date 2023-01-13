/// @param angle      Maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right
/// @param frequency  Wobble frequency. Larger values cause glyphs to oscillate faster

function scribble_anim_wobble(_angle, _frequency)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_angle     != _array[__SCRIBBLE_ANIM.__WOBBLE_ANGLE])
    ||  (_frequency != _array[__SCRIBBLE_ANIM.__WOBBLE_FREQ ]))
    {
        _array[@ __SCRIBBLE_ANIM.__WOBBLE_ANGLE] = _angle;
        _array[@ __SCRIBBLE_ANIM.__WOBBLE_FREQ ] = _frequency;
        
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