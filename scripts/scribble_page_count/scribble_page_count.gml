/// Returns: Total number of pages for the text element
/// @param string/textElement  Text element to target. This element must have been created previously by scribble_draw()

var _scribble_array = argument0;

if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != SCRIBBLE.__SIZE)
|| (_scribble_array[SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
|| _scribble_array[SCRIBBLE.FREED])
{
    var _string = string(_scribble_array);
    
    //Check the cache
    var _cache_string = _string + ":" + string(global.scribble_state_line_min_height) + ":" + string(global.scribble_state_max_width) + ":" + string(global.scribble_state_max_height);
    if (ds_map_exists(global.__scribble_global_cache_map, _cache_string))
    {
        var _scribble_array = global.__scribble_global_cache_map[? _cache_string];
    }
    else
    {
        _scribble_array = scribble_cache(_string);
    }
}

return _scribble_array[SCRIBBLE.PAGES];