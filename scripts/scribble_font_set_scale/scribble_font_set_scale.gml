/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName          The target font, as a string
/// @param scale             Scaling factor to apply
/// @param [relative=false]  Whether to apply the scaling factor multiplicatively

function scribble_font_set_scale(_font, _scale, _relative = false)
{
    var _font_data = __scribble_get_font_data(_font);
    
    if (not _relative) _scale /= _font_data.__scale;
    
    var _grid = _font_data.__glyph_data_grid;
    ds_grid_multiply_region(_grid, 0, __SCRIBBLE_GLYPH.__X_OFFSET, ds_grid_width(_grid)-1, __SCRIBBLE_GLYPH.__LEFT_OFFSET, _scale);
    
    _font_data.__scale *= _scale;
    _font_data.__calculate_font_height();
}