// Feather disable all

/// Returns the remapping for a font. If no remapping is set up then this function will return
/// the original font.
/// 
/// @param originalFont

function scribble_font_get_remap(_originalFont)
{
    return __ScribbleGetFontData(_originalFont).__remap ?? _originalFont;
}