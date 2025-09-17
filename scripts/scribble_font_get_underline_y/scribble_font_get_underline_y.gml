// Feather disable all

/// Returns the y-position of the underline for a font, relative to the top of a line.
/// 
/// @param fontName

function scribble_font_get_underline_y(_font)
{
    __ScribbleGetFontData(_font).__underlineY;
}
