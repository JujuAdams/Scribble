function scribble_super_glyph_delete(_target)
{
    var _font_data = global.__scribble_font_data[? _target];
    if (_font_data == undefined) __scribble_error("Font \"", _font_data, "\" not found");
    
    var _glyphs_map = _font_data.__glyphs_map;
    
    //Copy arguments into an array
    var _glyphs_array = array_create(argument_count - 1);
    var _i = 0;
    repeat(argument_count - 1)
    {
        _glyphs_array[@ _i] = argument[_i+1];
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
            ds_map_delete(_glyphs_map, _unicode);
            ++_unicode;
        }
        
        ++_i;
    }
}