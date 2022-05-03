/// Resets animation effects to their default values

function scribble_anim_reset()
{
    if (!global.__scribble_anim_shader_default || !global.__scribble_anim_shader_msdf_default)
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WAVE_SIZE       ] = SCRIBBLE_DEFAULT_WAVE_SIZE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WAVE_FREQ       ] = SCRIBBLE_DEFAULT_WAVE_FREQUENCY;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WAVE_SPEED      ] = SCRIBBLE_DEFAULT_WAVE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__SHAKE_SIZE      ] = SCRIBBLE_DEFAULT_SHAKE_SIZE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__SHAKE_SPEED     ] = SCRIBBLE_DEFAULT_SHAKE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__RAINBOW_WEIGHT  ] = SCRIBBLE_DEFAULT_RAINBOW_WEIGHT;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__RAINBOW_SPEED   ] = SCRIBBLE_DEFAULT_RAINBOW_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WOBBLE_ANGLE    ] = SCRIBBLE_DEFAULT_WOBBLE_ANGLE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WOBBLE_FREQ     ] = SCRIBBLE_DEFAULT_WOBBLE_FREQ;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__PULSE_SCALE     ] = SCRIBBLE_DEFAULT_PULSE_SCALE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__PULSE_SPEED     ] = SCRIBBLE_DEFAULT_PULSE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WHEEL_SIZE      ] = SCRIBBLE_DEFAULT_WHEEL_SIZE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WHEEL_FREQ      ] = SCRIBBLE_DEFAULT_WHEEL_FREQUENCY;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WHEEL_SPEED     ] = SCRIBBLE_DEFAULT_WHEEL_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__CYCLE_SPEED     ] = SCRIBBLE_DEFAULT_CYCLE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__CYCLE_SATURATION] = SCRIBBLE_DEFAULT_CYCLE_SATURATION;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__CYCLE_VALUE     ] = SCRIBBLE_DEFAULT_CYCLE_VALUE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__JITTER_MINIMUM  ] = SCRIBBLE_DEFAULT_JITTER_MIN_SCALE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__JITTER_MAXIMUM  ] = SCRIBBLE_DEFAULT_JITTER_MAX_SCALE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__JITTER_SPEED    ] = SCRIBBLE_DEFAULT_JITTER_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__SLANT_GRADIENT  ] = SCRIBBLE_SLANT_GRADIENT;
        
        global.__scribble_anim_blink_on_duration  = SCRIBBLE_DEFAULT_BLINK_ON_DURATION;
        global.__scribble_anim_blink_off_duration = SCRIBBLE_DEFAULT_BLINK_OFF_DURATION;
        global.__scribble_anim_blink_time_offset  = SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET;
    }
    
    if (!global.__scribble_anim_shader_default)
    {
        global.__scribble_anim_shader_desync            = true;
        global.__scribble_anim_shader_desync_to_default = true;
    }
    
    if (!global.__scribble_anim_shader_msdf_default)
    {
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = true;
    }
}