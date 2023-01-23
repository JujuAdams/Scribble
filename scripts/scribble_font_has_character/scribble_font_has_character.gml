/// Tests to see if a font has all the characters from the given range
/// 
/// Returns: Boolean, indicating whether all characters in the specified range are found in the font
/// @param fontName    The target font, as a string
/// @param range       Range to check against

function scribble_font_has_character(_font_name, _range)
{
    var _array = __scribble_parse_glyph_range_root(_range, _font_name);
    
    var _i = 0;
    repeat(array_length(_array))
    {
        if (!ds_map_exists(__scribble_get_font_data(_font_name).__glyphs_map, _array[_i])) return false;
        ++_i;
    }
    
    return true;
}