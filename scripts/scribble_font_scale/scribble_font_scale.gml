/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param scale     Scaling factor to apply

function scribble_font_scale(_font, _scale)
{
    var _font_data = __scribble_get_font_data(_font);
    
    var _grid = _font_data.__glyph_data_grid;
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.X_OFFSET, ds_grid_width(_grid)-1, SCRIBBLE_GLYPH.FONT_SCALE, _scale);
    
    _font_data.__scale *= _scale;
    _font_data.__calculate_font_height();
}