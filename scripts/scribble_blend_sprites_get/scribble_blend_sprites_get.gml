function scribble_blend_sprites_get()
{
    static _scribble_state = __scribble_get_state();
    return _scribble_state.__blend_sprites;
}