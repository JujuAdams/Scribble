/// @param weight  Rainbow blend weight. 0 does not show any rainbow effect at all, and 1 will blend a glyph's colour fully with the rainbow colour
/// @param speed   Rainbow speed. Larger values cause characters to change colour more rapidly

function scribble_anim_rainbow(_weight, _speed)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_weight != _array[__SCRIBBLE_ANIM.__RAINBOW_WEIGHT])
    ||  (_speed  != _array[__SCRIBBLE_ANIM.__RAINBOW_SPEED ]))
    {
        _array[@ __SCRIBBLE_ANIM.__RAINBOW_WEIGHT] = _weight;
        _array[@ __SCRIBBLE_ANIM.__RAINBOW_SPEED ] = _speed;
        
        static _scribble_state = __scribble_get_state();
        with(_scribble_state)
        {
            __standard_anim_desync            = true;
            __standard_anim_desync_to_default = false;
            __msdf_anim_desync                = true;
            __msdf_anim_desync_to_default     = false;
        }
    }
}