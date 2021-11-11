/// @param angle
/// @param frequency

function scribble_anim_wobble(_angle, _frequency)
{
    if ((_angle     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WOBBLE_ANGLE])
    ||  (_frequency != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WOBBLE_FREQ ]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WOBBLE_ANGLE] = _angle;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WOBBLE_FREQ ] = _frequency;
        
        global.__scribble_anim_shader_desync      = true;
        global.__scribble_anim_shader_msdf_desync = true;
    }
}