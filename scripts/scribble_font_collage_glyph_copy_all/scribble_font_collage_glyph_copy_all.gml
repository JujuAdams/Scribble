/// @param targetFontName
/// @param sourceFontName
/// @param overwrite

function scribble_font_collage_glyph_copy_all(_target, _source, _overwrite)
{
    var _target_font_data = global.__scribble_font_data[? _target];
    var _source_font_data = global.__scribble_font_data[? _source];
    
    var _target_glyphs_map = _target_font_data.glyphs_map;
    var _source_glyphs_map = _source_font_data.glyphs_map;
    
    var _keys_array = ds_map_keys_to_array(_source_glyphs_map);
    var _i = 0;
    repeat(array_length(_keys_array))
    {
        var _key = _keys_array[_i];
        
        if (_overwrite || !ds_map_exists(_target_glyphs_map, _key))
        {
            _target_glyphs_map[? _key] = _source_glyphs_map[? _key];
        }
        
        ++_i;
    }
}