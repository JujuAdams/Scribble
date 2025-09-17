// Feather disable all

/// Sets the y-position of the strike-through for a font, relative to the top of a line.
/// 
/// @param fontName
/// @param value

function scribble_font_set_strike_y(_font, _value)
{
    __ScribbleGetFontData(_font).__strikeY = _value;
}
