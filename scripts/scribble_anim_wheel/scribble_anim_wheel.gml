// Feather disable all

/// @param size       Wheel amplitude, in pixels
/// @param frequency  Wheel frequency. Larger values create more "humps" over a certain number of characters
/// @param speed      Wheel speed. Larger numbers cause characters to move up and down more rapidly

function scribble_anim_wheel(_size, _frequency, _speed)
{
    static _array = __ScribbleSystem().__animPropertiesArray;
    
    if ((_size     != _array[__SCRIBBLE_ANIM_WHEEL_SIZE ])
    || (_frequency != _array[__SCRIBBLE_ANIM_WHEEL_FREQ ])
    || (_speed     != _array[__SCRIBBLE_ANIM_WHEEL_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM_WHEEL_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM_WHEEL_FREQ ] = _frequency;
        _array[@ __SCRIBBLE_ANIM_WHEEL_SPEED] = _speed;
        
        static _scribbleState = __ScribbleSystem().__state;
        with(_scribbleState)
        {
            __shaderAnimDesync          = (not __shaderAnimDisabled); //Only re-set uniforms when the animations aren't disabled
            __shaderAnimDesyncToDefault = false;
        }
    }
}
