// Feather disable all

/// Sets a font's ascender, that is, the distance from the top of the tallest glyph to the baseline
/// for the font.
/// 
/// N.B. This function will **not** adjust the line height or glyphs positions. Please use
///      `scribble_glyph_set()` to do that.
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param value     Value to set

function scribble_font_set_ascender(_font, _value)
{
    __scribble_get_font_data(_font).__ascender = _value;
}
