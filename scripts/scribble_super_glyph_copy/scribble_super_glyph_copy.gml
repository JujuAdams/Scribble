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
    __scribble_super_glyph_copy_common(_target_font_data, _source_font_data);
    
    var _target_glyphs_map       = _target_font_data.__glyphs_map;
    var _target_glyph_data_grid  = _target_font_data.__glyph_data_grid;
    var _source_glyphs_map       = _source_font_data.__glyphs_map;
    var _source_glyphs_data_grid = _source_font_data.__glyph_data_grid;
    
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
            __scribble_glyph_duplicate(_source_glyphs_map, _source_glyphs_data_grid, _target_glyphs_map, _target_glyph_data_grid, _unicode, _overwrite);
            ++_unicode;
        }
        
        ++_i;
    }
    
    ds_grid_set_region(_target_glyph_data_grid, 0, SCRIBBLE_GLYPH.FONT_HEIGHT, ds_grid_width(_target_glyph_data_grid), SCRIBBLE_GLYPH.FONT_HEIGHT,
                       max(_target_font_data.__height, _source_font_data.__height));
}

function __scribble_super_glyph_copy_common(_target_font_data, _source_font_data)
{
    if (_source_font_data.__msdf == undefined)
    {
        __scribble_error("Cannot determine if the source font is an MSDF font. Please add glyphs to it");
    }
    else if (_target_font_data.__msdf == undefined)
    {
        //Target font hasn't had anything added to it yet
    }
    else if (_target_font_data.__msdf || _source_font_data.__msdf)
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
}

function __scribble_prepare_super_work_array(_input_array)
{
    var _output_array = [];
    
    var _i = 0;
    repeat(array_length(_input_array))
    {
        var _glyph_to_copy = _input_array[_i];
        
        if (is_string(_glyph_to_copy))
        {
            var _j = 1;
            repeat(string_length(_glyph_to_copy))
            {
                //TODO - Make this more efficient by grouping contiguous glyphs together
                var _unicode = ord(string_char_at(_glyph_to_copy, _j));
                array_push(_output_array, [_unicode, _unicode]);
                ++_j;
            }
            
            _glyph_to_copy = undefined;
        }
        
        if (is_numeric(_glyph_to_copy))
        {
            _glyph_to_copy = [_glyph_to_copy, _glyph_to_copy];
        }
        
        if (is_array(_glyph_to_copy))
        {
            array_push(_output_array, _glyph_to_copy);
        }
        
        ++_i;
    }
    
    return _output_array;
}

function __scribble_glyph_duplicate(_source_map, _source_grid, _target_map, _target_grid, _glyph, _overwrite)
{
    var _source_x = _source_map[? _glyph];
    if (_source_x == undefined)
    {
        __scribble_trace("Warning! Glyph ", _glyph, " (", chr(_glyph), ") not found in source font");
        return;
    }
    
    var _target_x = _target_map[? _glyph];
    if (_target_x == undefined)
    {
        //Create a new column in the grid to store this glyph's data
        var _target_x = ds_grid_width(_target_grid);
        _target_map[? _glyph] = _target_x;
        ds_grid_resize(_target_grid, _target_x+1, SCRIBBLE_GLYPH.__SIZE);
    }
    else
    {
        if (!_overwrite)
        {
            //Glyph already exists in target, skip it
            return;
        }
        
        //Copy data from source directly into the existing slot in the font's glyph table
    }
    
    //Do the actual copying
    ds_grid_set_grid_region(_target_grid, _source_grid, _source_x, 0, _source_x, SCRIBBLE_GLYPH.__SIZE, _target_x, 0);
}