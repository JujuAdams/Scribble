/// @param target
/// @param source
/// @param glyphs
/// @param [glyphs]...

function scribble_font_collage_glyph_copy(_target, _source)
{
    var _target_font_data = global.__scribble_font_data[? _target];
    var _source_font_data = global.__scribble_font_data[? _source];
    
    var _glyphs_array = array_create(argument_count - 2);
    var _i = 2;
    repeat(argument_count - 2)
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