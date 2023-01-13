/// @param size   Shake amplitude, in pixels
/// @param speed  Shake speed. Larger values cause characters to move around more rapidly

function scribble_anim_shake(_size, _speed)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_size  != _array[__SCRIBBLE_ANIM.__SHAKE_SIZE ])
    ||  (_speed != _array[__SCRIBBLE_ANIM.__SHAKE_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__SHAKE_SIZE ] = _size;
        _array[@ __SCRIBBLE_ANIM.__SHAKE_SPEED] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}