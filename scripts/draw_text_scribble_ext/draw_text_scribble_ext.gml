/// Emulation of draw_text_ext(), but using Scribble for rendering
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// It is common practice in GameMaker to draw typewriter text like so:
///     draw_text_ext(x, y, -1, max_width, string_copy(typewriter_text, 1, count));
/// 
/// Instead, when using draw_text_scribble_ext(), please write your code like so:
///     draw_text_scribble_ext(x, y, max_width, typewriter_text, count);
/// 
/// This will take full advantage of Scribble's power (and is less to type!)
/// 
/// @param x            The x coordinate of the drawn string
/// @param y            The y coordinate of the drawn string
/// @param string       The string to draw
/// @param width        The maximum width in pixels of the string before a line break
/// @param [charCount]  The number of characters from the string to draw. If not specified, all characters will be drawn

function draw_text_scribble_ext(_x, _y, _string, _width, _reveal = undefined)
{
    var _element = scribble(_string)
    .align(draw_get_halign(), draw_get_valign())
    .starting_format(draw_get_font(), c_white)
    .blend(draw_get_color(), draw_get_alpha())
    .wrap(_width);
    if (_reveal != undefined) _element.reveal(_reveal);
    _element.draw(_x, _y);
    return _element;
}