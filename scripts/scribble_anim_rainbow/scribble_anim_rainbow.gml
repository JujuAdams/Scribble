// Feather disable all
/// @param weight  Rainbow blend weight. 0 does not show any rainbow effect at all, and 1 will blend a glyph's colour fully with the rainbow colour
/// @param speed   Rainbow speed. Larger values cause characters to change colour more rapidly

function scribble_anim_rainbow(_weight, _speed)
{
    static _array = __scribble_initialize().__anim_properties;
    
    if ((_weight != _array[__SCRIBBLE_ANIM.__RAINBOW_WEIGHT])
    ||  (_speed  != _array[__SCRIBBLE_ANIM.__RAINBOW_SPEED ]))
    {
        _array[@ __SCRIBBLE_ANIM.__RAINBOW_WEIGHT] = _weight;
        _array[@ __SCRIBBLE_ANIM.__RAINBOW_SPEED ] = _speed;
        
        static _scribble_state = __scribble_initialize().__state;
        with(_scribble_state)
        {
            __shader_anim_desync            = (not __shader_anim_disabled); //Only re-set uniforms when the animations aren't disabled
            __shader_anim_desync_to_default = false;
        }
    }
}
