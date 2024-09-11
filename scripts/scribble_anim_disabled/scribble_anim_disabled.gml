// Feather disable all

/// @param state

function scribble_anim_disabled(_state)
{
    static _scribble_state = __scribble_initialize().__state;
    
    with(_scribble_state)
    {
        if (__shader_anim_disabled != _state)
        {
            __shader_anim_disabled = _state;
            __shader_anim_desync = true;
        }
    }
}