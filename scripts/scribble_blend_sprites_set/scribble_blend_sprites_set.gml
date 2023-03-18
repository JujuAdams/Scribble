/// @param state  Whether to colour blend sprites when drawing text

function scribble_blend_sprites_set(_state)
{
    static _scribble_state = __scribble_get_state();
    
    _state = real(_state);
    
    with(_scribble_state)
    {
        if (_state != __blend_sprites)
        {
            __blend_sprites = _state;
            
            __render_flag_value  = ((__render_flag_value & (~(0x02))) | (_state << 1));
            __render_flag_desync = true;
        }
    }
}