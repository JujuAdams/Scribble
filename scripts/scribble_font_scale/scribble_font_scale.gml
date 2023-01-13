/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param scale     Scaling factor to apply

function scribble_font_scale(_font, _scale)
{
    var _font_data = __scribble_get_font_data_map(_font);
    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    
    _font_data.__scale *= _scale;
    
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.X_OFFSET, ds_grid_width(_grid)-1, SCRIBBLE_GLYPH.FONT_SCALE, _scale);
    
    _font_data.__calculate_font_height();
}