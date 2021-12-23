/// @param size   Shake amplitude, in pixels
/// @param speed  Shake speed. Larger values cause characters to move around more rapidly

function scribble_anim_shake(_size, _speed)
{
    if ((_size  != global.__scribble_anim_properties[__SCRIBBLE_ANIM.SHAKE_SIZE ])
    ||  (_speed != global.__scribble_anim_properties[__SCRIBBLE_ANIM.SHAKE_SPEED]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.SHAKE_SIZE ] = _size;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.SHAKE_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}