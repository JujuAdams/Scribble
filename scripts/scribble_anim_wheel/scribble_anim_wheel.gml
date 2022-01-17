/// @param size       Wheel amplitude, in pixels
/// @param frequency  Wheel frequency. Larger values create more "humps" over a certain number of characters
/// @param speed      Wheel speed. Larger numbers cause characters to move up and down more rapidly

function scribble_anim_wheel(_size, _frequency, _speed)
{
    if ((_size     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WHEEL_SIZE ])
    || (_frequency != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WHEEL_FREQ ])
    || (_speed     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WHEEL_SPEED]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_SIZE ] = _size;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_FREQ ] = _frequency;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}