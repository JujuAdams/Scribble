// Feather disable all
/// @param size   Shake amplitude, in pixels
/// @param speed  Shake speed. Larger values cause characters to move around more rapidly

function scribble_anim_shake(_size, _speed)
{
    static _array = __ScribbleSystem().__animPropertiesArray;
    
    if ((_size  != _array[__SCRIBBLE_ANIM_SHAKE_SIZE ])
    ||  (_speed != _array[__SCRIBBLE_ANIM_SHAKE_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM_SHAKE_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM_SHAKE_SPEED] = _speed;
        
        static _scribbleState = __ScribbleSystem().__state;
        with(_scribbleState)
        {
            __shaderAnimDesync          = (not __shaderAnimDisabled); //Only re-set uniforms when the animations aren't disabled
            __shaderAnimDesyncToDefault = false;
        }
    }
}
