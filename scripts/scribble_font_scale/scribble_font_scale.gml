// Feather disable all
/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param scale     Scaling factor to apply

function scribble_font_scale(_font, _scale)
{
    var _font_data = __ScribbleGetFontData(_font);
    
    var _grid = _font_data.__glyphDataGrid;
    ds_grid_multiply_region(_grid, 0, __SCRIBBLE_GLYPH_PROPR_X_OFFSET, ds_grid_width(_grid)-1, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE, _scale);
    
    _font_data.__scale      *= _scale;
    _font_data.__height     *= _scale;
    _font_data.__underlineY *= _scale;
    _font_data.__strikeY    *= _scale;
}
