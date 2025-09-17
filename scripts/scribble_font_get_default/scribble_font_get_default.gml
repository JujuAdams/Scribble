// Feather disable all
/// Returns the default font that Scribble is using for text elements

function scribble_font_get_default()
{
    static _scribbleState = __ScribbleSystem().__state;
    return _scribbleState.__default_font;
}
