/// @param target
/// @param source
/// @param overwrite
/// @param glyphs
/// @param [glyphs]...

function scribble_font_collage_glyph_copy(_target, _source, _overwrite)
{
    var _target_font_data = global.__scribble_font_data[? _target];
    var _source_font_data = global.__scribble_font_data[? _source];
    
    var _target_glyphs_map = _target_font_data.glyphs_map;
    var _source_glyphs_map = _source_font_data.glyphs_map;
    
    var _glyphs_array = array_create(argument_count - 3);
    var _i = 3;
    repeat(argument_count - 3)
    {
        _glyphs_array[@ _i] = argument[_i];
        ++_i;
    }
    
    var _work_array = __scribble_prepare_collage_work_array(_glyphs_array);
    
    var _i = 0;
    repeat(_work_array)
    {
        var _glyph_range_array = _work_array[_i];
        
        var _ord = _glyph_range_array[0];
        repeat(1 + _glyph_range_array[1] - _ord)
        {
            var _source_glyph_data = _source_glyphs_map[? _ord];
            if (_source_glyph_data == undefined)
            {
                __scribble_trace("Warning! Glyph ", _ord, " (", chr(_ord), ") not found in source font");
            }
            else if (_overwrite || !ds_map_exists(_target_glyphs_map, _ord))
            {
                _target_glyphs_map[? _ord] = __scribble_glyph_duplicate(_source_glyph_data);
            }
            
            ++_ord;
        }
        
        ++_i;
    }
}