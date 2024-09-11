// Feather disable all
/// Returns the default font that Scribble is using for text elements

function scribble_font_get_default()
{
    static _scribble_state = __scribble_initialize().__state;
    return _scribble_state.__default_font;
}
