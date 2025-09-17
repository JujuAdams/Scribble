// Feather disable all
/// Emulation of string_width(), but using Scribble for calculating the width
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// @param string    The string to draw

function string_width_scribble(_string)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    var _font = draw_get_font();
    _font = !font_exists(_font)? _scribbleState.__defaultFont : font_get_name(_font);
    
    return scribble(_string, "__draw_text_scribble__").font(_font).get_width();
}
