// Feather disable all
/// @param target
/// @param source
/// @param overwrite
/// @param glyphs
/// @param [glyphs]...

function scribble_super_glyph_copy(_target, _source, _overwrite)
{
    var _target_font_data = __scribble_get_font_data(_target);
    var _source_font_data = __scribble_get_font_data(_source);
    
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
