// Feather disable all
/// @param scale  pulse scale offset. A value of 0 will cause no visible scaling changes for a glyph, a value of 1 will cause a glyph to double in size
/// @param speed  pulse speed. Larger values cause glyph scales to pulse faster

function scribble_anim_pulse(_scale, _speed)
{
    static _array = __scribble_initialize().__anim_properties;
    
    if ((_scale != _array[__SCRIBBLE_ANIM.__PULSE_SCALE])
    ||  (_speed != _array[__SCRIBBLE_ANIM.__PULSE_SPEED]))
    {
        _array[@ __SCRIBBLE_ANIM.__PULSE_SCALE] = _scale;
        _array[@ __SCRIBBLE_ANIM.__PULSE_SPEED] = _speed;
        
        static _scribble_state = __scribble_initialize().__state;
        with(_scribble_state)
        {
            __shader_anim_desync            = (not __shader_anim_disabled); //Only re-set uniforms when the animations aren't disabled
            __shader_anim_desync_to_default = false;
        }
    }
}
