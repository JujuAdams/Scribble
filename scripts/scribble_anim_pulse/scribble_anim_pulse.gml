/// @param scale  pulse scale offset. A value of 0 will cause no visible scaling changes for a glyph, a value of 1 will cause a glyph to double in size
/// @param speed  pulse speed. Larger values cause glyph scales to pulse faster

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