/// Returns a font's scale
/// 
/// @param fontName  The target font, as a string

function scribble_font_get_scale(_font)
{
    return __scribble_get_font_data(_font).__scale;
}