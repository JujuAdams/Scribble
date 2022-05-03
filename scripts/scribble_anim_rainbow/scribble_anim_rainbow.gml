/// @param weight  Rainbow blend weight. 0 does not show any rainbow effect at all, and 1 will blend a glyph's colour fully with the rainbow colour
/// @param speed   Rainbow speed. Larger values cause characters to change colour more rapidly

function scribble_anim_rainbow(_weight, _speed)
{
    if ((_weight != global.__scribble_anim_properties[__SCRIBBLE_ANIM.__RAINBOW_WEIGHT])
    ||  (_speed  != global.__scribble_anim_properties[__SCRIBBLE_ANIM.__RAINBOW_SPEED ]))
    {
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__RAINBOW_WEIGHT] = _weight;
        global.__scribble_anim_properties[@ __SCRIBBLE_ANIM.__RAINBOW_SPEED ] = _speed;
        
        global.__scribble_anim_shader_desync                 = true;
        global.__scribble_anim_shader_desync_to_default      = false;
        global.__scribble_anim_shader_msdf_desync            = true;
        global.__scribble_anim_shader_msdf_desync_to_default = false;
    }
}