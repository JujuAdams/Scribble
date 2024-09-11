// Feather disable all
/// @param size       Wheel amplitude, in pixels
/// @param frequency  Wheel frequency. Larger values create more "humps" over a certain number of characters
/// @param speed      Wheel speed. Larger numbers cause characters to move up and down more rapidly

function scribble_anim_wheel(_size, _frequency, _speed)
{
    static _array = __scribble_initialize().__anim_properties;
    
    if ((_size     != _array[__SCRIBBLE_ANIM.__WHEEL_SIZE ])
    || (_frequency != _array[__SCRIBBLE_ANIM.__WHEEL_FREQ ])
    || (_speed     != _array[__SCRIBBLE_ANIM.__WHEEL_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__WHEEL_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM.__WHEEL_FREQ ] = _frequency;
        _array[@ __SCRIBBLE_ANIM.__WHEEL_SPEED] = _speed;
        
        static _scribble_state = __scribble_initialize().__state;
        with(_scribble_state)
        {
            __shader_anim_desync            = (not __shader_anim_disabled); //Only re-set uniforms when the animations aren't disabled
            __shader_anim_desync_to_default = false;
        }
    }
}
