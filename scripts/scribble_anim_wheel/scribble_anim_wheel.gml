/// @param size
/// @param frequency
/// @param speed

function scribble_anim_wheel(_size, _frequency, _speed)
{
    if ((_size     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WHEEL_SIZE ])
    || (_frequency != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WHEEL_FREQ ])
    || (_speed     != global.__scribble_anim_properties[__SCRIBBLE_ANIM.WHEEL_SPEED]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_SIZE ] = _size;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_FREQ ] = _frequency;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.WHEEL_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync      = true;
        global.__scribble_anim_shader_msdf_desync = true;
    }
}