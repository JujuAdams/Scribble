// Feather disable all
/// @param minScale  Jitter minimum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
/// @param maxScale  Jitter maximum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
/// @param speed     Jitter speed. Larger values cause glyph scales to fluctuate faster

function scribble_anim_jitter(_min_scale, _max_scale, _speed)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_min_scale != _array[__SCRIBBLE_ANIM.__JITTER_MINIMUM])
    ||  (_max_scale != _array[__SCRIBBLE_ANIM.__JITTER_MAXIMUM])
    ||  (_speed     != _array[__SCRIBBLE_ANIM.__JITTER_SPEED  ]))
    {
        _array[@ __SCRIBBLE_ANIM.__JITTER_MINIMUM] = _min_scale;
        _array[@ __SCRIBBLE_ANIM.__JITTER_MAXIMUM] = _max_scale;
        _array[@ __SCRIBBLE_ANIM.__JITTER_SPEED  ] = _speed;
        
        static _scribble_state = __scribble_get_state();
        with(_scribble_state)
        {
            __shader_anim_desync            = true;
            __shader_anim_desync_to_default = false;
        }
    }
}
