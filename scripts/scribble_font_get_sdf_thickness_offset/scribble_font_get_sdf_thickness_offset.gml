/// Returns a font's SDF spread
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string

function scribble_font_get_sdf_thickness_offset(_font)
{
    return __scribble_get_font_data(_font).__get_sdf_thickness_offset();
}