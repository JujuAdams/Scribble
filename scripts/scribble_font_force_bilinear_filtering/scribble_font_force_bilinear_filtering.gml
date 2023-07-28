// Feather disable all
/// @param font
/// @param state

function scribble_font_force_bilinear_filtering(_font, _state)
{
    var _font_data = __scribble_get_font_data(_font);
    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    ds_grid_set_region(_grid, 0, SCRIBBLE_GLYPH.BILINEAR, ds_map_size(_map) - 1, SCRIBBLE_GLYPH.BILINEAR, _state);
}
