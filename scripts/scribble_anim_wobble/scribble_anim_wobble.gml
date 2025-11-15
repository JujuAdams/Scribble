// Feather disable all

/// @param angle      Maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right
/// @param frequency  Wobble frequency. Larger values cause glyphs to oscillate faster

function scribble_anim_wobble(_angle, _frequency)
{
    static _array = __ScribbleSystem().__animPropertiesArray;
    
    if ((_angle     != _array[__SCRIBBLE_ANIM_WOBBLE_ANGLE])
    ||  (_frequency != _array[__SCRIBBLE_ANIM_WOBBLE_FREQ ]))
    {
        _array[@ __SCRIBBLE_ANIM_WOBBLE_ANGLE] = _angle;
        _array[@ __SCRIBBLE_ANIM_WOBBLE_FREQ ] = _frequency;
        
        static _scribbleState = __ScribbleSystem().__state;
        with(_scribbleState)
        {
            __shaderAnimDesync          = (not __shaderAnimDisabled); //Only re-set uniforms when the animations aren't disabled
            __shaderAnimDesyncToDefault = false;
        }
    }
}
