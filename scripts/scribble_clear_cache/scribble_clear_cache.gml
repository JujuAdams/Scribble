if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Clearing " + string(ds_list_size(global.__scribble_cache_list)) + " scribble array(s) from memory");

var _i = 0;
repeat(ds_list_size(global.__scribble_cache_list))
{
    var _string = global.__scribble_cache_list[| _i];
    var _scribble_array = global.__scribble_cache_map[? _string];
    scribble_destroy(_scribble_array);
    ds_map_delete(global.__scribble_cache_map, _string);
    ++_i;
}

ds_list_clear(global.__scribble_cache_list);