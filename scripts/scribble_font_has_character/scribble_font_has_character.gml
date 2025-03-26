// Feather disable all
/// Tests to see if a font has the given character
/// 
/// Returns: Boolean, indicating whether the given character is found in the font
/// @param {String} fontName   The target font, as a string
/// @param {String} character  Character to test for, as a string
/// @returns {Bool}

function scribble_font_has_character(_font_name, _character)
{
    return ds_map_exists(__scribble_get_font_data(_font_name).__glyphs_map, ord(_character));
}
