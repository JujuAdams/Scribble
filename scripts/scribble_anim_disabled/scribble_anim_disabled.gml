// Feather disable all

/// @param state

function scribble_anim_disabled(_state)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    with(_scribbleState)
    {
        if (__shaderAnimDisabled != _state)
        {
            __shaderAnimDisabled = _state;
            __shaderAnimDesync = true;
        }
    }
}