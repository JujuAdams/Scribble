/// @param targetFontName
/// @param sourceFontName
/// @param overwrite

function scribble_super_glyph_copy_all(_target, _source, _overwrite)
{
    var _target_font_data = global.__scribble_font_data[? _target];
    var _source_font_data = global.__scribble_font_data[? _source];
    
    if (_target_font_data == undefined)
    {
        __scribble_error("Font \"", _target, "\" not found");
    }
    
    if (_source_font_data == undefined)
    {
        __scribble_error("Font \"", _source, "\" not found");
    }
    
    //Verify that the two fonts can be used together
    var _y_offset = __scribble_super_glyph_copy_common(_target_font_data, _source_font_data);
    
    var _target_glyphs_map = _target_font_data.__glyphs_map;
    var _source_glyphs_map = _source_font_data.__glyphs_map;
    
    var _keys_array = ds_map_keys_to_array(_source_glyphs_map);
    var _i = 0;
    repeat(array_length(_keys_array))
    {
        var _key = _keys_array[_i];
        
        if (_overwrite || !ds_map_exists(_target_glyphs_map, _key))
        {
            _target_glyphs_map[? _key] = __scribble_glyph_duplicate(_source_glyphs_map[? _key], _y_offset);
        }
        
        ++_i;
    }
}