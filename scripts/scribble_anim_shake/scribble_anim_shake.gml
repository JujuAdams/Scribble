/// @param size   Shake amplitude, in pixels
/// @param speed  Shake speed. Larger values cause characters to move around more rapidly

function scribble_anim_shake(_size, _speed)
{
    static _scribble_state = __scribble_get_state();
    static _array = _scribble_state.__anim_property_array;
    
    if ((_size  != _array[__SCRIBBLE_ANIM.__SHAKE_SIZE ])
    ||  (_speed != _array[__SCRIBBLE_ANIM.__SHAKE_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__SHAKE_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM.__SHAKE_SPEED] = _speed;
        
        _scribble_state.__shader_anim_desync            = true;
        _scribble_state.__shader_anim_desync_to_default = false;
    }
}