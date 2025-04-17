// Feather disable all

/// Forces Scribble to re-set all shader uniforms the next time text is drawn. You should call this
/// function if Scribble is exhibiting strange behaviour after another process takes control of the
/// application e.g. after showing an ad on Android.

function scribble_flush_shader_uniforms()
{
    static _scribble_state = __scribble_initialize().__state;
    with(_scribble_state)
    {
        __shader_anim_desync            = true;
        __shader_anim_desync_to_default = true;
    }
}
