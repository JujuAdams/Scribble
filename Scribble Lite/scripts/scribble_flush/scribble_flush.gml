/// Frees up memory used by Scribble, targetting either a cache group or a specific Scribble data structure.
/// 
/// This script is only meant to be called directly by advanced users. Please read the documentation carefully!
/// 
/// 
/// @param cacheGroup  The target memory to free. See below.
/// 
/// 
/// Scribble uses cache groups to help manage memory. Scribble text that has been added to a cache group will be automatically destroyed if...
/// 1) scribble_flush() has been called targetting the text's cache group
/// 2) or the text has not been drawn for a period of time (SCRIBBLE_CACHE_TIMEOUT milliseconds).
/// By default, all Scribble data is put into the same cache group: SCRIBBLE_DEFAULT_CACHE_GROUP. You can specify a different cache group
/// to manage memory more easily (e.g. one cache group for dialogue, another for an inventory screen). Setting SCRIBBLE_CACHE_TIMEOUT to 0
/// halts all time-based memory management; instead, you'll need to manually call scribble_flush(), targetting the relevant cache group(s).
/// 
/// If you're manually creating Scribble data structures by calling scribble_create() directly, you can choose to opt out of using the cache.
/// By setting the "cacheGroup" argument to <undefined>, Scribble will skip adding the data to the cache. However, this means that the data
/// you create *will not be automatically destroyed*. To free memory you will have to call scribble_flush() manually, using the Scribble text
/// array as the argument.
/// 
/// To track how much Scribble data exists at any one time, call ds_map_size(global.scribble_alive).

var _target = argument0;

if (ds_map_exists(global.__scribble_cache_group_map, _target))
{
    if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Trying to clear cache group " + string(_target));
    
    var _list = global.__scribble_cache_group_map[? _target];
    var _i = 0;
    repeat(ds_list_size(_list))
    {
        scribble_flush(global.__scribble_global_cache_map[? _list[| _i]]);
        ++_i;
    }
    
    ds_list_clear(_list);
    
    return true;
}
else if (is_array(_target))
{
    if (!is_array(_target)
    || (array_length_1d(_target) != __SCRIBBLE.__SIZE)
    || (_target[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
    {
        show_debug_message("Scribble: WARNING! Array \"" + string(_target) + "\" isn't a Scribble array!\n ");
        return false;
    }
    else if (!_target[__SCRIBBLE.FREED])
    {
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
        return true;
    }
    else
    {
        //Already been freed
        return true;
    }
}

if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: WARNING! Cache group \"" + string(_target) + "\" has not yet been created");
return false;