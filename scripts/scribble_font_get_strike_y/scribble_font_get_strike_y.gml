// Feather disable all

/// Returns the y-position of the strike-through for a font, relative to the top of a line.
/// 
/// @param fontName

function scribble_font_get_strike_y(_font)
{
    __ScribbleGetFontData(_font).__strikeY;
}
