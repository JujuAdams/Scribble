/// @param scale
/// @param speed

function scribble_anim_pulse(_scale, _speed)
{
    if ((_scale != global.__scribble_anim_properties[__SCRIBBLE_ANIM.PULSE_SCALE])
    ||  (_speed != global.__scribble_anim_properties[__SCRIBBLE_ANIM.PULSE_SPEED]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.PULSE_SCALE] = _scale;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.PULSE_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}