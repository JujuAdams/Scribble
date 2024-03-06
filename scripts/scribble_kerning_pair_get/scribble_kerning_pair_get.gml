// Feather disable all
/// Returns the separation offset between two characters
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param firstChar          First character in the pair, as a string
/// @param secondChar         Second character in the pair, as a string

function scribble_kerning_pair_get(_font, _first_char, _second_char)
{
    var _font_data = __scribble_get_font_data(_font);
    
    var  _first_unicode = is_real( _first_char)?  _first_char : ord( _first_char);
    var _second_unicode = is_real(_second_char)? _second_char : ord(_second_char);
    
    var _kerning_map = _font_data.__kerning_map;
    
    return (_kerning_map[? ((_second_unicode & 0xFFFF) << 16) | (_first_unicode & 0xFFFF)] ?? 0);
}
