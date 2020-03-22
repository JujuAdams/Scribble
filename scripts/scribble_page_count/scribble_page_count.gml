/// @param string(orElement)

var _scribble_array = argument0;

if (!is_array(_scribble_array)
|| (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
|| (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
|| _scribble_array[__SCRIBBLE.FREED])
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
        var _old_allow_draw = global.scribble_state_allow_draw;
        global.scribble_state_allow_draw = false;
        _scribble_array = scribble_draw(0, 0, _string);
        global.scribble_state_allow_draw = _old_allow_draw;
    }
}

return _scribble_array[__SCRIBBLE.PAGES];