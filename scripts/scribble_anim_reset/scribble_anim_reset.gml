// Feather disable all
/// Resets animation effects to their default values

function scribble_anim_reset()
{
    static _scribble_state = __scribble_get_state();
    with(_scribble_state)
    {
        if (!__shader_anim_default)
        {
            static _array = __scribble_get_anim_properties();
            _array[@ __SCRIBBLE_ANIM.__WAVE_SIZE       ] = SCRIBBLE_DEFAULT_WAVE_SIZE;
            _array[@ __SCRIBBLE_ANIM.__WAVE_FREQ       ] = SCRIBBLE_DEFAULT_WAVE_FREQUENCY;
            _array[@ __SCRIBBLE_ANIM.__WAVE_SPEED      ] = SCRIBBLE_DEFAULT_WAVE_SPEED;
            _array[@ __SCRIBBLE_ANIM.__SHAKE_SIZE      ] = SCRIBBLE_DEFAULT_SHAKE_SIZE;
            _array[@ __SCRIBBLE_ANIM.__SHAKE_SPEED     ] = SCRIBBLE_DEFAULT_SHAKE_SPEED;
            _array[@ __SCRIBBLE_ANIM.__RAINBOW_WEIGHT  ] = SCRIBBLE_DEFAULT_RAINBOW_WEIGHT;
            _array[@ __SCRIBBLE_ANIM.__RAINBOW_SPEED   ] = SCRIBBLE_DEFAULT_RAINBOW_SPEED;
            _array[@ __SCRIBBLE_ANIM.__WOBBLE_ANGLE    ] = SCRIBBLE_DEFAULT_WOBBLE_ANGLE;
            _array[@ __SCRIBBLE_ANIM.__WOBBLE_FREQ     ] = SCRIBBLE_DEFAULT_WOBBLE_FREQ;
            _array[@ __SCRIBBLE_ANIM.__PULSE_SCALE     ] = SCRIBBLE_DEFAULT_PULSE_SCALE;
            _array[@ __SCRIBBLE_ANIM.__PULSE_SPEED     ] = SCRIBBLE_DEFAULT_PULSE_SPEED;
            _array[@ __SCRIBBLE_ANIM.__WHEEL_SIZE      ] = SCRIBBLE_DEFAULT_WHEEL_SIZE;
            _array[@ __SCRIBBLE_ANIM.__WHEEL_FREQ      ] = SCRIBBLE_DEFAULT_WHEEL_FREQUENCY;
            _array[@ __SCRIBBLE_ANIM.__WHEEL_SPEED     ] = SCRIBBLE_DEFAULT_WHEEL_SPEED;
            _array[@ __SCRIBBLE_ANIM.__CYCLE_SPEED     ] = SCRIBBLE_DEFAULT_CYCLE_SPEED;
            _array[@ __SCRIBBLE_ANIM.__CYCLE_SATURATION] = SCRIBBLE_DEFAULT_CYCLE_SATURATION;
            _array[@ __SCRIBBLE_ANIM.__CYCLE_VALUE     ] = SCRIBBLE_DEFAULT_CYCLE_VALUE;
            _array[@ __SCRIBBLE_ANIM.__JITTER_MINIMUM  ] = SCRIBBLE_DEFAULT_JITTER_MIN_SCALE;
            _array[@ __SCRIBBLE_ANIM.__JITTER_MAXIMUM  ] = SCRIBBLE_DEFAULT_JITTER_MAX_SCALE;
            _array[@ __SCRIBBLE_ANIM.__JITTER_SPEED    ] = SCRIBBLE_DEFAULT_JITTER_SPEED;
            _array[@ __SCRIBBLE_ANIM.__SLANT_GRADIENT  ] = SCRIBBLE_SLANT_GRADIENT;
            
            __blink_on_duration  = SCRIBBLE_DEFAULT_BLINK_ON_DURATION;
            __blink_off_duration = SCRIBBLE_DEFAULT_BLINK_OFF_DURATION;
            __blink_time_offset  = SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET;
        }
        
        if (!__shader_anim_desync)
        {
            __shader_anim_desync            = true;
            __shader_anim_desync_to_default = true;
        }
    }
}
