function scribble_premultiply_alpha_get()
{
    static _scribble_state = __scribble_get_state();
    return _scribble_state.__premultiply_alpha;
}