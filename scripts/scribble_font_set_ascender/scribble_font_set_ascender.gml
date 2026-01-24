// Feather disable all

/// Sets a font's ascender, that is, the distance from the top of the tallest glyph to the baseline
/// for the font.
/// 
/// N.B. This function will **not** adjust the line height, underline, strike-througb or glyphs
///      positions. Please use `scribble_glyph_set()` to do that.
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param value     Value to setg

function scribble_font_set_ascender(_font, _value)
{
    __ScribbleGetFontData(_font).__ascender = _value;
}