function scribble_font_collage_glyph_delete(_target)
{
    var _target_font_data = global.__scribble_font_data[? _target];
    
    var _glyphs_array = array_create(argument_count - 1);
    var _i = 1;
    repeat(argument_count - 1)
    {
        _glyphs_array[@ _i] = argument[_i];
        ++_i;
    }
    
    var _work_array = __scribble_prepare_collage_work_array(_glyphs_array);
    
    var _i = 0;
    repeat(_work_array)
    {
        var _glyph_range_array = _work_array[_i];
        
        var _j = _glyph_range_array[0];
        repeat(1 + _glyph_range_array[1] - _j)
        {
            
            
            
            
            
            ++_j;
        }
        
        ++_i;
    }
}