// Feather disable all

function scribble_anim_get_disabled()
{
    static _scribbleState = __ScribbleSystem().__state;
    
    return _scribbleState.__shader_anim_disabled;
}