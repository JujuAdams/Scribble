// Feather disable all
/// @param fontName
/// @param [hex=false]

function scribble_font_get_glyph_ranges(_name, _hex = false)
{
    var _fontData = __ScribbleGetFontData(_name);
    
    var _keysArray = ds_map_keys_to_array(_fontData.__glyphsMap);
    array_sort(_keysArray, true);
    
    var _outArray = [];
    
    var _min = _keysArray[0];
    var _max = _keysArray[0];
    
    var _i = 1;
    repeat(array_length(_keysArray)-1)
    {
        var _key = _keysArray[_i];
        
        if (_key > _max+1)
        {
            if (_hex)
            {
                array_push(_outArray, [string(ptr(_min)), string(ptr(_max))]);
            }
            else
            {
                array_push(_outArray, [_min, _max]);
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
    
    array_push(_outArray, [string(ptr(_min)), string(ptr(_max))]);
    
    return _outArray;
}
