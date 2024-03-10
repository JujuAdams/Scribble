// Feather disable all
/// @param size   Shake amplitude, in pixels
/// @param speed  Shake speed. Larger values cause characters to move around more rapidly

function scribble_anim_shake(_size, _speed)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_size  != _array[__SCRIBBLE_ANIM.__SHAKE_SIZE ])
    ||  (_speed != _array[__SCRIBBLE_ANIM.__SHAKE_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__SHAKE_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM.__SHAKE_SPEED] = _speed;
        
        static _scribble_state = __scribble_get_state();
        with(_scribble_state)
        {
            __shader_anim_desync            = true;
            __shader_anim_desync_to_default = false;
        }
    }
}
