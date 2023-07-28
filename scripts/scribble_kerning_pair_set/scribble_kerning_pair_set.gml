// Feather disable all
/// Adjusts the separation offset between two characters
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param firstChar          First character in the pair, as a string
/// @param secondChar         Second character in the pair, as a string
/// @param value              The value to set
/// @param [relative=false]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value

function scribble_kerning_pair_set(_font, _first_char, _second_char, _value, _relative = false)
{
    var  _first_unicode = is_real( _first_char)?  _first_char : ord( _first_char);
    var _second_unicode = is_real(_second_char)? _second_char : ord(_second_char);
    
    var _font_data = __scribble_get_font_data(_font);
    var _kerning_map = _font_data.__kerning_map;
    
    var _lookup = ((_second_unicode & 0xFFFF) << 16) | (_first_unicode & 0xFFFF);
    var _new_value = _relative? ((_kerning_map[? _lookup] ?? 0) + _value) : _value;
    _kerning_map[? _lookup] = _new_value;
    
    return _new_value;
}
