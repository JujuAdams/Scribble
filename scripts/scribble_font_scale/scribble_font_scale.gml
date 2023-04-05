/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param scale     Scaling factor to apply

function scribble_font_scale(_font, _scale)
{
    var _font_data = __scribble_get_font_data(_font);
    _font_data.__scale *= _scale;
    _font_data.__calculate_font_height();
}