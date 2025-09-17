// Feather disable all
/// Tests to see if a font has the given character
/// 
/// Returns: Boolean, indicating whether the given character is found in the font
/// @param fontName   The target font, as a string
/// @param character  Character to test for, as a string

function scribble_font_has_character(_fontName, _character)
{
    return ds_map_exists(__ScribbleGetFontData(_fontName).__glyphsMap, ord(_character));
}
