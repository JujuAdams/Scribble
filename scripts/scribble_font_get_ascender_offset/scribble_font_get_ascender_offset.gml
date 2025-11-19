// Feather disable all

/// Returns a font's ascender offset, that is, the distance from the top of a line to the top of
/// the tallest glyph.
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string

function scribble_font_get_ascender_offset(_font)
{
    return __scribble_get_font_data(_font).__ascender_offset;
}
