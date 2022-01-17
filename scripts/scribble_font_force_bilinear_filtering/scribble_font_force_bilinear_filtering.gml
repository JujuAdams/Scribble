/// @param font
/// @param state

function scribble_font_force_bilinear_filtering(_font, _state)
{
    if (!ds_map_exists(global.__scribble_font_data, _font))
    {
        __scribble_error("Font \"", _font, "\" not found");
        exit;
    }
    
    var _font_data = global.__scribble_font_data[? _font];
    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    ds_grid_set_region(_grid, 0, SCRIBBLE_GLYPH.BILINEAR, ds_map_size(_map) - 1, SCRIBBLE_GLYPH.BILINEAR, _state);
}