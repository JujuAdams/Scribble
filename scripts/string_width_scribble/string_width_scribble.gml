// Feather disable all
/// Emulation of string_width(), but using Scribble for calculating the width
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// @param string    The string to draw

function string_width_scribble(_string)
{
    static _scribble_state = __scribble_get_state();
    
    var _font = draw_get_font();
    _font = !font_exists(_font)? _scribble_state.__default_font : font_get_name(_font);
    
    return scribble(_string).starting_format(_font, c_white).get_width();
}
