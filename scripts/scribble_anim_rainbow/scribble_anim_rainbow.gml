/// @param weight  Rainbow blend weight. 0 does not show any rainbow effect at all, and 1 will blend a glyph's colour fully with the rainbow colour
/// @param speed   Rainbow speed. Larger values cause characters to change colour more rapidly

function scribble_anim_rainbow(_weight, _speed)
{
    static _scribble_state = __scribble_get_state();
    static _array = _scribble_state.__anim_property_array;
    
    if ((_weight != _array[__SCRIBBLE_ANIM.__RAINBOW_WEIGHT])
    ||  (_speed  != _array[__SCRIBBLE_ANIM.__RAINBOW_SPEED ]))
    {
        _array[@ __SCRIBBLE_ANIM.__RAINBOW_WEIGHT] = _weight;
        _array[@ __SCRIBBLE_ANIM.__RAINBOW_SPEED ] = _speed;
        
        _scribble_state.__shader_anim_desync            = true;
        _scribble_state.__shader_anim_desync_to_default = false;
    }
}