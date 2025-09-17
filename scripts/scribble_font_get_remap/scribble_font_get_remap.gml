// Feather disable all

/// Returns the remapping for a font. If no remapping is set up then this function will return
/// the original font.
/// 
/// @param originalFont

function scribble_font_get_remap(_original_font)
{
    return __ScribbleGetFontData(_original_font).__remap ?? _original_font;
}