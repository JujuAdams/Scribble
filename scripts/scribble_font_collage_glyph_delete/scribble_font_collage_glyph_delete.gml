function scribble_font_collage_glyph_delete(_target)
{
    var _font_data = global.__scribble_font_data[? _target];
    var _glyphs_map = _font_data.glyphs_map;
    
    //Copy arguments into an array
    var _glyphs_array = array_create(argument_count - 1);
    var _i = 1;
    repeat(argument_count - 1)
    {
        _glyphs_array[@ _i] = argument[_i];
        ++_i;
    }
    
    //Pass the argument array into our preparation function
    //This turns the argument array in a series of ranges to operate on
    var _work_array = __scribble_prepare_collage_work_array(_glyphs_array);
    
    var _i = 0;
    repeat(_work_array)
    {
        var _glyph_range_array = _work_array[_i];
        
        var _ord = _glyph_range_array[0];
        repeat(1 + _glyph_range_array[1] - _ord)
        {
            ds_map_delete(_glyphs_map, _ord);
            ++_ord;
        }
        
        ++_i;
    }
}