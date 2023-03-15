/// Adjusts the separation offset between multiples characters
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param firstString        First characters in the pair, as a string
/// @param secondString       Second characters in the pair, as a string
/// @param value              The value to set
/// @param [relative=false]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value

function scribble_kerning_pair_set(_font, _first_string, _second_string, _value, _relative = false)
{
	var _new_values = [];
	
	for(var _i = 1; _i <= string_length(_first_string); _i ++) {
	
		var _first_char = string_char_at(_first_string, _i);
		
		for(var _j = 1; _j <= string_length(_second_string); _j++) {
			
			var _second_char = string_char_at(_second_string, _j);
			
			var  _first_unicode = is_real( _first_char)?  _first_char : ord( _first_char);
		    var _second_unicode = is_real(_second_char)? _second_char : ord(_second_char);
    
		    var _font_data = __scribble_get_font_data(_font);
		    var _kerning_map = _font_data.__kerning_map;
    
		    var _lookup = ((_second_unicode & 0xFFFF) << 16) | (_first_unicode & 0xFFFF);
			var _new_value = _relative? ((_kerning_map[? _lookup] ?? 0) + _value) : _value;
		    array_push(_new_values, _new_value) 
		    _kerning_map[? _lookup] = _new_value;
		
		}

	}

    return _new_values;
}
