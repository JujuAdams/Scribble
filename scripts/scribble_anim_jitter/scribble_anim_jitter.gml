/// @param scale  Jitter scale. A value of 0 will cause no visible scaling changes for a glyph
/// @param speed  Jitter speed. Larger values cause glyph scales to fluctuate faster

function scribble_anim_jitter(_scale, _speed)
{
    static _scribble_state = __scribble_get_state();
    static _array = _scribble_state.__anim_property_array;
    
    if ((_scale != _array[__SCRIBBLE_ANIM.__JITTER_SCALE])
    ||  (_speed != _array[__SCRIBBLE_ANIM.__JITTER_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__JITTER_SCALE] = _scale;
        _array[@ __SCRIBBLE_ANIM.__JITTER_SPEED] = _speed;
        
        _scribble_state.__shader_anim_desync            = true;
        _scribble_state.__shader_anim_desync_to_default = false;
    }
}