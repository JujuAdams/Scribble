// Feather disable all

/// Sets the y-position of the underline for a font, relative to the top of a line.
/// 
/// @param fontName
/// @param value

function scribble_font_set_underline_y(_font, _value)
{
    __ScribbleGetFontData(_font).__underlineY = _value;
}
