/// @param angle      Maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right
/// @param frequency  Wobble frequency. Larger values cause glyphs to oscillate faster

function scribble_anim_wobble(_angle, _frequency)
{
    var _array = __scribble_get_anim_properties();
    
    if ((_angle     != _array[__SCRIBBLE_ANIM.__WOBBLE_ANGLE])
    ||  (_frequency != _array[__SCRIBBLE_ANIM.__WOBBLE_FREQ ]))
    {
        _array[@ __SCRIBBLE_ANIM.__WOBBLE_ANGLE] = _angle;
        _array[@ __SCRIBBLE_ANIM.__WOBBLE_FREQ ] = _frequency;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}