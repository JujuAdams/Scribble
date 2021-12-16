/// @param fontName
/// @param [hex=false]

function scribble_font_get_glyph_ranges(_name, _hex = false)
{
    var _font_data = global.__scribble_font_data[? _name];
    if (_font_data == undefined)
    {
        __scribble_error("Font \"", _name, "\" not found");
        return [];
    }
    
    var _keys_array = ds_map_keys_to_array(_font_data.__glyphs_map);
    array_sort(_keys_array, lb_sort_ascending);
    
    var _out_array = [];
    
    var _min = _keys_array[0];
    var _max = _keys_array[0];
    
    var _i = 1;
    repeat(array_length(_keys_array)-1)
    {
        var _key = _keys_array[_i];
        
        if (_key > _max+1)
        {
            if (_hex)
            {
                array_push(_out_array, [string(ptr(_min)), string(ptr(_max))]);
            }
            else
            {
                array_push(_out_array, [_min, _max]);
            }
            
            var _min = _key;
            var _max = _key;
        }
        else
        {
            _max = _key;
        }
        
        ++_i;
    }
    
    array_push(_out_array, [string(ptr(_min)), string(ptr(_max))]);
    
    return _out_array;
}