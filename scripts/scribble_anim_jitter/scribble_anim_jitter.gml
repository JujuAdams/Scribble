// Feather disable all

/// @param minScale  Jitter minimum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
/// @param maxScale  Jitter maximum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
/// @param speed     Jitter speed. Larger values cause glyph scales to fluctuate faster

function scribble_anim_jitter(_minScale, _maxScale, _speed)
{
    static _array = __ScribbleSystem().__animPropertiesArray;
    
    if ((_minScale != _array[__SCRIBBLE_ANIM_JITTER_MINIMUM])
    ||  (_maxScale != _array[__SCRIBBLE_ANIM_JITTER_MAXIMUM])
    ||  (_speed    != _array[__SCRIBBLE_ANIM_JITTER_SPEED  ]))
    {
        _array[@ __SCRIBBLE_ANIM_JITTER_MINIMUM] = _minScale;
        _array[@ __SCRIBBLE_ANIM_JITTER_MAXIMUM] = _maxScale;
        _array[@ __SCRIBBLE_ANIM_JITTER_SPEED  ] = _speed;
        
        static _scribbleState = __ScribbleSystem().__state;
        with(_scribbleState)
        {
            __shaderAnimDesync          = (not __shaderAnimDisabled); //Only re-set uniforms when the animations aren't disabled
            __shaderAnimDesyncToDefault = false;
        }
    }
}
