/// @param size       Wave amplitude, in pixels
/// @param frequency  Wave frequency. Larger values create more "humps" over a certain number of characters
/// @param speed      Wave speed. Larger numbers cause characters to move up and down more rapidly

function scribble_anim_wave(_size, _frequency, _speed)
{
    if ((_size      != global.__scribble_anim_properties[__SCRIBBLE_ANIM.__WAVE_SIZE ])
    ||  (_frequency != global.__scribble_anim_properties[__SCRIBBLE_ANIM.__WAVE_FREQ ])
    ||  (_speed     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.__WAVE_SPEED]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WAVE_SIZE ] = _size;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WAVE_FREQ ] = _frequency;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__WAVE_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}