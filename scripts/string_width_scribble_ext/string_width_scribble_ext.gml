/// Emulation of string_height(), but using Scribble for calculating the width
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// @param string  The string to draw
/// @param width   The maximum width in pixels of the string before a line break

function string_width_scribble_ext(_string, _width)
{
    static _scribble_state = __scribble_get_state();
    
    var _font = draw_get_font();
    _font = !font_exists(_font)? _scribble_state.__default_font : font_get_name(_font);
    
    return scribble(_string).font(_font).layout_wrap(_width).get_width();
}