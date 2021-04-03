/// Tests to see if a font has the given character
/// 
/// Returns: Boolean, indicating whether the given character is found in the font
/// @param fontName   The target font, as a string
/// @param character  Character to test for, as a string

function scribble_font_has_character(_font_name, _character)
{
    var _character_code = ord(_character);
    
    var _font_data         = __scribble_get_font_data(_font_name);
    var _font_glyphs_array = _font_data.glyphs_array;
    
    if (_font_glyphs_array == undefined)
    {
        return ds_map_exists(_font_data.glyphs_map, _character_code);
    }
    else
    {
        return ((_character_code >= _font_data.glyph_min) && (_character_code <= _font_data.glyph_max));
    }
}