// Feather disable all

/// Forces Scribble to re-set all shader uniforms the next time text is drawn. You should call this
/// function if Scribble is exhibiting strange behaviour after another process takes control of the
/// application e.g. after showing an ad on Android.

function scribble_flush_shader_uniforms()
{
    static _scribbleState = __ScribbleSystem().__state;
    with(_scribbleState)
    {
        __shaderAnimDesync          = true;
        __shaderAnimDesyncToDefault = true;
    }
}
