// Feather disable all

/// Sets a font's ascender offset, that is, the distance from the top of a line to the top of the
/// tallest glyph.
/// 
/// N.B. This function will **not** adjust the line height or glyphs positions. Please use
///      `scribble_glyph_set()` to do that.
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param value     Value to set

function scribble_font_set_ascender_offset(_font, _value)
{
    __scribble_get_font_data(_font).__ascender_offset = _value;
}
