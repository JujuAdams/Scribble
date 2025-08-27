// Feather disable all

/// Returns the y-position of the strike-through for a font, relative to the top of a line.
/// 
/// @param fontName

function scribble_font_get_strike_y(_font)
{
    __scribble_get_font_data(_font).__strikeY;
}
