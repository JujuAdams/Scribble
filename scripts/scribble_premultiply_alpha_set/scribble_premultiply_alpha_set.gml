/// @param state  Whether to premultiply alpha when drawing text

function scribble_premultiply_alpha_set(_state)
{
    static _scribble_state = __scribble_get_state();
    
    _state = real(_state);
    
    with(_scribble_state)
    {
        if (_state != __premultiply_alpha)
        {
            __premultiply_alpha = _state;
            
            __render_flag_value  = ((__render_flag_value & (~(0x01))) | _state);
            __render_flag_desync = true;
        }
    }
}