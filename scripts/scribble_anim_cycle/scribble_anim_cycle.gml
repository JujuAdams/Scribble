/// @param speed
/// @param saturation
/// @param value

function scribble_anim_cycle(_speed, _saturation, _value)
{
    if ((_speed      != global.__scribble_anim_properties[__SCRIBBLE_ANIM.CYCLE_SPEED     ])
    ||  (_saturation != global.__scribble_anim_properties[__SCRIBBLE_ANIM.CYCLE_SATURATION])
    ||  (_value      != global.__scribble_anim_properties[__SCRIBBLE_ANIM.CYCLE_VALUE     ]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.CYCLE_SPEED     ] = _speed;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.CYCLE_SATURATION] = _saturation;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.CYCLE_VALUE     ] = _value;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}