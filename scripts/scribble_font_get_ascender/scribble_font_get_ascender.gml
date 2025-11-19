// Feather disable all

/// Returns a font's ascender, that is, the distance from the top of the tallest glyph to the
/// baseline for the font.
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string

function scribble_font_get_ascender(_font)
{
    return __scribble_get_font_data(_font).__ascender;
}
