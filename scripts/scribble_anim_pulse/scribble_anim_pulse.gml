/// @param scale  pulse scale offset. A value of 0 will cause no visible scaling changes for a glyph, a value of 1 will cause a glyph to double in size
/// @param speed  pulse speed. Larger values cause glyph scales to pulse faster

function scribble_anim_pulse(_scale, _speed)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_scale != _array[__SCRIBBLE_ANIM.__PULSE_SCALE])
    ||  (_speed != _array[__SCRIBBLE_ANIM.__PULSE_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__PULSE_SCALE] = _scale;
        _array[@ __SCRIBBLE_ANIM.__PULSE_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}