/// Resets animation effects to their default values

function scribble_anim_reset()
{
    if (!global.__scribble_anim_shader_default || !global.__scribble_anim_shader_msdf_default)
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WAVE_SIZE       ] = SCRIBBLE_DEFAULT_WAVE_SIZE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WAVE_FREQ       ] = SCRIBBLE_DEFAULT_WAVE_FREQUENCY;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WAVE_SPEED      ] = SCRIBBLE_DEFAULT_WAVE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.SHAKE_SIZE      ] = SCRIBBLE_DEFAULT_SHAKE_SIZE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.SHAKE_SPEED     ] = SCRIBBLE_DEFAULT_SHAKE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.RAINBOW_WEIGHT  ] = SCRIBBLE_DEFAULT_RAINBOW_WEIGHT;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.RAINBOW_SPEED   ] = SCRIBBLE_DEFAULT_RAINBOW_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WOBBLE_ANGLE    ] = SCRIBBLE_DEFAULT_WOBBLE_ANGLE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WOBBLE_FREQ     ] = SCRIBBLE_DEFAULT_WOBBLE_FREQ;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.PULSE_SCALE     ] = SCRIBBLE_DEFAULT_PULSE_SCALE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.PULSE_SPEED     ] = SCRIBBLE_DEFAULT_PULSE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_SIZE      ] = SCRIBBLE_DEFAULT_WHEEL_SIZE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_FREQ      ] = SCRIBBLE_DEFAULT_WHEEL_FREQUENCY;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_SPEED     ] = SCRIBBLE_DEFAULT_WHEEL_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.CYCLE_SPEED     ] = SCRIBBLE_DEFAULT_CYCLE_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.CYCLE_SATURATION] = SCRIBBLE_DEFAULT_CYCLE_SATURATION;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.CYCLE_VALUE     ] = SCRIBBLE_DEFAULT_CYCLE_VALUE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.JITTER_MINIMUM  ] = SCRIBBLE_DEFAULT_JITTER_MIN_SCALE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.JITTER_MAXIMUM  ] = SCRIBBLE_DEFAULT_JITTER_MAX_SCALE;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.JITTER_SPEED    ] = SCRIBBLE_DEFAULT_JITTER_SPEED;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.SLANT_GRADIENT  ] = SCRIBBLE_SLANT_GRADIENT;
        
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