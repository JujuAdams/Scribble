/// @param speed       Cycle speed. Larger numbers cause characters to change colour more rapidly
/// @param frequency   Cycle frequency

function scribble_anim_cycle(_speed, _frequency)
{
    static _array = __scribble_get_anim_properties();
    
    if ((_speed     != _array[__SCRIBBLE_ANIM.__CYCLE_SPEED    ])
    ||  (_frequency != _array[__SCRIBBLE_ANIM.__CYCLE_FREQUENCY]))
    {
        _array[@ __SCRIBBLE_ANIM.__CYCLE_SPEED    ] = _speed;
        _array[@ __SCRIBBLE_ANIM.__CYCLE_FREQUENCY] = _frequency;
        
        static _scribble_state = __scribble_get_state();
        with(_scribble_state)
        {
            __shader_anim_desync            = true;
            __shader_anim_desync_to_default = false;
        }
    }
}