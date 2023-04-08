/// @param size       Wheel amplitude, in pixels
/// @param frequency  Wheel frequency. Larger values create more "humps" over a certain number of characters
/// @param speed      Wheel speed. Larger numbers cause characters to move up and down more rapidly

function scribble_anim_wheel(_size, _frequency, _speed)
{
    static _scribble_state = __scribble_get_state();
    static _array = _scribble_state.__anim_property_array;
    
    if ((_size     != _array[__SCRIBBLE_ANIM.__WHEEL_SIZE ])
    || (_frequency != _array[__SCRIBBLE_ANIM.__WHEEL_FREQ ])
    || (_speed     != _array[__SCRIBBLE_ANIM.__WHEEL_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__WHEEL_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM.__WHEEL_FREQ ] = _frequency;
        _array[@ __SCRIBBLE_ANIM.__WHEEL_SPEED] = _speed;
        
        _scribble_state.__shader_anim_desync            = true;
        _scribble_state.__shader_anim_desync_to_default = false;
    }
}