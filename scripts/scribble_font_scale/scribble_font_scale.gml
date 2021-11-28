/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param xscale    x-scaling factor to apply
/// @param yscale    y-scaling factor to apply

function scribble_font_scale(_font, _xscale, _yscale)
{
    if (!ds_map_exists(global.__scribble_font_data, _font))
    {
        __scribble_error("Font \"", _font, "\" not found");
        exit;
    }
    
    var _font_data = global.__scribble_font_data[? _font];
    var _grid = _font_data.glyph_data_grid;
    var _map  = _font_data.glyphs_map;
    
    _font_data.xscale *= _xscale;
    _font_data.yscale *= _yscale;
    _font_data.scale_dist = point_distance(0, 0, _font_data.xscale, _font_data.yscale);
    
    var _last = ds_map_size(_map)-1;
    
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.X_OFFSET,    _last, SCRIBBLE_GLYPH.X_OFFSET,    _xscale);
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.Y_OFFSET,    _last, SCRIBBLE_GLYPH.Y_OFFSET,    _yscale);
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.WIDTH,       _last, SCRIBBLE_GLYPH.WIDTH,       _xscale);
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.HEIGHT,      _last, SCRIBBLE_GLYPH.HEIGHT,      _yscale);
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.FONT_HEIGHT, _last, SCRIBBLE_GLYPH.FONT_HEIGHT, _yscale);
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.SEPARATION,  _last, SCRIBBLE_GLYPH.SEPARATION,  _xscale);
    ds_grid_multiply_region(_grid, 0, SCRIBBLE_GLYPH.FONT_SCALE,  _last, SCRIBBLE_GLYPH.FONT_SCALE,  _font_data.scale_dist);
    
    _font_data.calculate_font_height();
}