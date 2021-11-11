/// @param minScale
/// @param maxScale
/// @param speed

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