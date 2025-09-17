// Feather disable all

/// @param state

function scribble_anim_disabled(_state)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    with(_scribbleState)
    {
        if (__shader_anim_disabled != _state)
        {
            __shader_anim_disabled = _state;
            __shader_anim_desync = true;
        }
    }
}