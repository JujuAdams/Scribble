/// Emulation of draw_text(), but using Scribble for rendering
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// It is common practice in GameMaker to draw typewriter text like so:
///     draw_text(x, y, string_copy(typewriter_text, 1, count));
/// 
/// Instead, when using draw_text_scribble(), please write your code like so:
///     draw_text_scribble(x, y, typewriter_text, count);
/// 
/// This will take full advantage of Scribble's power (and is less to type!)
/// 
/// @param x            The x coordinate of the drawn string
/// @param y            The y coordinate of the drawn string
/// @param string       The string to draw
/// @param [charCount]  The number of characters from the string to draw. If not specified, all characters will be drawn

function draw_text_scribble(_x, _y, _string, _reveal = undefined)
{
    var _font = draw_get_font();
    _font = !font_exists(_font)? global.__scribble_default_font : font_get_name(_font);
    
    var _element = scribble(_string)
    .align(draw_get_halign(), draw_get_valign())
    .starting_format(_font, c_white)
    .blend(draw_get_color(), draw_get_alpha());
    if (_reveal != undefined) _element.reveal(_reveal);
    _element.draw(_x, _y);
    return _element;
}