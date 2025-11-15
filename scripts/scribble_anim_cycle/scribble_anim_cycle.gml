// Feather disable all

/// @param speed      Cycle speed. Larger numbers cause characters to change color more rapidly
/// @param frequency  Cycle frequency. Larger values create more color changes over a certain number of characters

function scribble_anim_cycle(_speed, _frequency)
{
    static _array = __ScribbleSystem().__animPropertiesArray;
    
    if ((_speed     != _array[__SCRIBBLE_ANIM_CYCLE_SPEED    ])
    ||  (_frequency != _array[__SCRIBBLE_ANIM_CYCLE_FREQUENCY]))
    {
        _array[@ __SCRIBBLE_ANIM_CYCLE_SPEED    ] = clamp(_speed, 0, 1);
        _array[@ __SCRIBBLE_ANIM_CYCLE_FREQUENCY] = clamp(_frequency, 0, 1);
        
        static _scribbleState = __ScribbleSystem().__state;
        with(_scribbleState)
        {
            __shaderAnimDesync          = (not __shaderAnimDisabled); //Only re-set uniforms when the animations aren't disabled
            __shaderAnimDesyncToDefault = false;
        }
    }
}
