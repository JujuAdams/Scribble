/// Destroys a Scribble data structure and frees up the memory it was using
///
/// @param scribbleArray_or_cacheGroup

var _target = argument0;

if (is_array(_target))
{
    if (!scribble_exists(_target))
    {
        show_debug_message("Scribble: WARNING! Data structure \"" + string(_target) + "\" doesn't exist!\n ");
        exit;
    }
    
    ds_map_delete(global.__scribble_alive, _target[__SCRIBBLE.GLOBAL_INDEX]);
    
    var _vbuff_list = _target[__SCRIBBLE.VERTEX_BUFFER_LIST];
    var _count = ds_list_size(_vbuff_list);
    for(var _i = 0; _i < _count; _i++)
    {
        var _vbuff_data = _vbuff_list[| _i];
        var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
        vertex_delete_buffer(_vbuff);
    }
    
    ds_list_destroy(_target[@ __SCRIBBLE.LINE_LIST         ]);
    ds_list_destroy(_target[@ __SCRIBBLE.VERTEX_BUFFER_LIST]);
    
    _target[@ __SCRIBBLE.FREED] = true;
}
else if (ds_map_exists(global.__scribble_cache_group_map, _target))
{
    if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Trying to clear cache group " + string(_target));
    
    var _list = global.__scribble_cache_group_map[? _target];
    var _i = 0;
    repeat(ds_list_size(_list))
    {
        scribble_free(global.__scribble_global_cache_map[? _list[| _i]]);
        ++_i;
    }
    ds_list_clear(_list);
}
else
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: WARNING! Cache group \"" + string(_target) + "\" has not yet been created");
}