// Feather disable all
/// @param targetFontName
/// @param sourceFontName
/// @param overwrite

function scribble_super_glyph_copy_all(_target, _source, _overwrite)
{
    var _target_font_data = __scribble_get_font_data(_target);
    var _source_font_data = __scribble_get_font_data(_source);
    
    //Verify that the two fonts can be used together
    __scribble_super_glyph_copy_common(_target_font_data, _source_font_data);
    
    var _source_glyphs_map       = _source_font_data.__glyphs_map;
    var _source_glyphs_data_grid = _source_font_data.__glyph_data_grid;
    var _target_glyphs_map       = _target_font_data.__glyphs_map;
    var _target_glyph_data_grid  = _target_font_data.__glyph_data_grid;
    
    var _keys_array = ds_map_keys_to_array(_source_glyphs_map);
    var _i = 0;
    repeat(array_length(_keys_array))
    {
        __scribble_glyph_duplicate(_source_glyphs_map, _source_glyphs_data_grid, _target_glyphs_map, _target_glyph_data_grid, _keys_array[_i], _overwrite);
        ++_i;
    }
    
    _target_font_data.__height = max(_target_font_data.__height, _source_font_data.__height)
    ds_grid_set_region(_target_glyph_data_grid, 0, SCRIBBLE_GLYPH.FONT_HEIGHT, ds_grid_width(_target_glyph_data_grid), SCRIBBLE_GLYPH.FONT_HEIGHT, _target_font_data.__height);
}
