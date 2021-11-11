/// @param weight
/// @param speed

function scribble_anim_rainbow(_weight, _speed)
{
    if ((_weight != global.__scribble_anim_properties[__SCRIBBLE_ANIM.RAINBOW_WEIGHT])
    ||  (_speed  != global.__scribble_anim_properties[__SCRIBBLE_ANIM.RAINBOW_SPEED ]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.RAINBOW_WEIGHT] = _weight;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.RAINBOW_SPEED ] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}