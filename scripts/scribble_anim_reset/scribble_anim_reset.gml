// Feather disable all
/// Resets animation effects to their default values

function scribble_anim_reset()
{
    static _scribble_state = __scribble_system().__state;
    with(_scribble_state)
    {
        if (!__shader_anim_default)
        {
            static _array = __scribble_system().__anim_properties;
            _array[@ __SCRIBBLE_ANIM_WAVE_SIZE     ] = SCRIBBLE_DEFAULT_WAVE_SIZE;
            _array[@ __SCRIBBLE_ANIM_WAVE_FREQ     ] = SCRIBBLE_DEFAULT_WAVE_FREQUENCY;
            _array[@ __SCRIBBLE_ANIM_WAVE_SPEED    ] = SCRIBBLE_DEFAULT_WAVE_SPEED;
            _array[@ __SCRIBBLE_ANIM_SHAKE_SIZE    ] = SCRIBBLE_DEFAULT_SHAKE_SIZE;
            _array[@ __SCRIBBLE_ANIM_SHAKE_SPEED   ] = SCRIBBLE_DEFAULT_SHAKE_SPEED;
            _array[@ __SCRIBBLE_ANIM_WOBBLE_ANGLE  ] = SCRIBBLE_DEFAULT_WOBBLE_ANGLE;
            _array[@ __SCRIBBLE_ANIM_WOBBLE_FREQ   ] = SCRIBBLE_DEFAULT_WOBBLE_FREQ;
            _array[@ __SCRIBBLE_ANIM_PULSE_SCALE   ] = SCRIBBLE_DEFAULT_PULSE_SCALE;
            _array[@ __SCRIBBLE_ANIM_PULSE_SPEED   ] = SCRIBBLE_DEFAULT_PULSE_SPEED;
            _array[@ __SCRIBBLE_ANIM_WHEEL_SIZE    ] = SCRIBBLE_DEFAULT_WHEEL_SIZE;
            _array[@ __SCRIBBLE_ANIM_WHEEL_FREQ    ] = SCRIBBLE_DEFAULT_WHEEL_FREQUENCY;
            _array[@ __SCRIBBLE_ANIM_WHEEL_SPEED   ] = SCRIBBLE_DEFAULT_WHEEL_SPEED;
            _array[@ __SCRIBBLE_ANIM_JITTER_MINIMUM] = SCRIBBLE_DEFAULT_JITTER_MIN_SCALE;
            _array[@ __SCRIBBLE_ANIM_JITTER_MAXIMUM] = SCRIBBLE_DEFAULT_JITTER_MAX_SCALE;
            _array[@ __SCRIBBLE_ANIM_JITTER_SPEED  ] = SCRIBBLE_DEFAULT_JITTER_SPEED;
            _array[@ __SCRIBBLE_ANIM_SLANT_GRADIENT] = SCRIBBLE_SLANT_GRADIENT;
        }
        
        if (!__shader_anim_desync)
        {
            __shader_anim_desync            = (not __shader_anim_disabled); //Only re-set uniforms when the animations aren't disabled
            __shader_anim_desync_to_default = true;
        }
    }
}
