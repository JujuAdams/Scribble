/// @param scribbleArray_or_cacheGroup   The target memory to free. See below.
/// 
/// 
/// Scribble uses cache groups to help manage memory. Scribble text that has been added to a cache group will be automatically destroyed if...
/// 1) scribble_free() has been called targetting the text's cache group
/// 2) or the text has not been drawn for a period of time (SCRIBBLE_CACHE_TIMEOUT milliseconds).
/// By default, all Scribble data is put into the same cache group: SCRIBBLE_DEFAULT_CACHE_GROUP. You can specify a different cache group
/// to manage memory more easily (e.g. one cache group for dialogue, another for an inventory screen). Setting SCRIBBLE_CACHE_TIMEOUT to 0
/// halts all time-based memory management; instead, you'll need to manually called scribble_free(), targetting the relevant cache group(s).
/// 
/// If you're manually creating Scribble data structures by calling scribble_create() directly, you can choose to opt out of using the cache.
/// By setting the "cacheGroup" argument to <undefined>, Scribble will skip adding the data to the cache. However, this means that the data
/// you create *will not be automatically destroyed*. To free memory you will have to call scribble_free() manually, using the Scribble text
/// array as the argument.
/// 
/// To track how much Scribble data exists at any one time, call ds_map_size(global.scribble_alive).

var _target = argument0;

if (is_array(_target))
{
    if (!scribble_exists(_target))
    {
        show_debug_message("Scribble: WARNING! Data structure \"" + string(_target) + "\" doesn't exist!\n ");
        exit;
    }
    
    ds_map_delete(global.scribble_alive, _target[__SCRIBBLE.GLOBAL_INDEX]);
    
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