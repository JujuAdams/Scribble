/// @param target
/// @param source
/// @param overwrite
/// @param glyphs
/// @param [glyphs]...

function scribble_super_glyph_copy(_target, _source, _overwrite)
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
    
    //Copy arguments into an array
    var _glyphs_array = array_create(argument_count - 3);
    var _i = 0;
    repeat(argument_count - 3)
    {
        _glyphs_array[@ _i] = argument[_i+3];
        ++_i;
    }
    
    //Pass the argument array into our preparation function
    //This turns the argument array in a series of ranges to operate on
    var _work_array = __scribble_prepare_super_work_array(_glyphs_array);
    
    var _i = 0;
    repeat(array_length(_work_array))
    {
        var _glyph_range_array = _work_array[_i];
        
        var _unicode = _glyph_range_array[0];
        repeat(1 + _glyph_range_array[1] - _unicode)
        {
            var _source_glyph_data = _source_glyphs_map[? _unicode];
            if (_source_glyph_data == undefined)
            {
                __scribble_trace("Warning! Glyph ", _unicode, " (", chr(_unicode), ") not found in source font");
            }
            else if (_overwrite || !ds_map_exists(_target_glyphs_map, _unicode))
            {
                _target_glyphs_map[? _unicode] = __scribble_glyph_duplicate(_source_glyph_data, _y_offset);
            }
            
            ++_unicode;
        }
        
        ++_i;
    }
}

function __scribble_super_glyph_copy_common(_target_font_data, _source_font_data)
{
    if (_target_font_data.__msdf || _source_font_data.__msdf)
    {
        if (_target_font_data.__msdf == false)
        {
            __scribble_error("Cannot mix standard/sprite fonts with MSDF fonts (target is not an MSDF font)");
        }
        
        if (_source_font_data.__msdf == false)
        {
            __scribble_error("Cannot mix standard/sprite fonts with MSDF fonts (source is not an MSDF font)");
        }
        
        if (_source_font_data.__msdf_pxrange == undefined)
        {
            __scribble_error("Source font's MSDF pxrange must be defined before copying glyphs");
        }
        
        if ((_target_font_data.__msdf_pxrange != undefined) && (_target_font_data.__msdf_pxrange != _source_font_data.__msdf_pxrange))
        {
            __scribble_error("MSDF font pxrange must match (target = ", _target_font_data.__msdf_pxrange, " vs. source = ", _source_font_data.__msdf_pxrange, ")");
        }
    }
    
    _target_font_data.__msdf = _source_font_data.__msdf;
    _target_font_data.__msdf_pxrange = _source_font_data.__msdf_pxrange;
    
    //Now calculate the y offset required to centre one font to the other
    if (_target_font_data.__height > _source_font_data.__height)
    {
        return (_target_font_data.__height - _source_font_data.__height) div 2;
    }
    
    if (_target_font_data.__height < _source_font_data.__height)
    {
        var _glyphs_map = _target_font_data.__glyphs_map;
        if (ds_map_size(_glyphs_map) > 0)
        {
            var _y_offset = (_source_font_data.__height - _target_font_data.__height) div 2;
            
            var _glyphs_array = ds_map_values_to_array(_glyphs_map);
            var _i = 0;
            repeat(array_length(_glyphs_array))
            {
                _glyphs_array[_i][@ SCRIBBLE_GLYPH.Y_OFFSET] += _y_offset;
                ++_i;
            }
        }
        
        _target_font_data.__height = _source_font_data.__height;
    }
    
    return 0;
}