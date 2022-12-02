/// Returns the default font that Scribble is using for text elements

function scribble_font_get_default()
{
    __scribble_system();
    return global.__scribble_default_font;
}