/// @param minScale  Jitter minimum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
/// @param maxScale  Jitter maximum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
/// @param speed     Jitter speed. Larger values cause glyph scales to fluctuate faster

function scribble_anim_jitter(_min_scale, _max_scale, _speed)
{
    if ((_min_scale != global.__scribble_anim_properties[__SCRIBBLE_ANIM.JITTER_MINIMUM])
    ||  (_max_scale != global.__scribble_anim_properties[__SCRIBBLE_ANIM.JITTER_MAXIMUM])
    ||  (_speed     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.JITTER_SPEED  ]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.JITTER_MINIMUM] = _min_scale;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.JITTER_MAXIMUM] = _max_scale;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.JITTER_SPEED  ] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}