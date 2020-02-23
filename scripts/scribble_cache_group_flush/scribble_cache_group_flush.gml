/// Frees up memory used by Scribble, targetting either a cache group or a specific text element.
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
/// 
/// By default, all Scribble data is put into the same cache group: SCRIBBLE_DEFAULT_CACHE_GROUP. You can specify a different cache group
/// to manage memory more easily (e.g. one cache group for dialogue, another for an inventory screen). Setting SCRIBBLE_CACHE_TIMEOUT to 0
/// halts all time-based memory management; instead, you'll need to manually call scribble_flush(), targetting the relevant cache group(s).
/// 
/// If you're manually creating text element by calling scribble_draw() directly, you can choose to opt out of using the cache.  By setting
/// the "cacheGroup" argument to <undefined>, Scribble will skip adding the data to the cache. However, this means that the data you create
/// *will not be automatically destroyed*. To free memory you will have to call scribble_flush() manually, using the Scribble text  array as
/// the argument.
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
        var _scribble_array = global.__scribble_global_cache_map[? _list[| _i]];
        
        if (is_array(_scribble_array)
        && (array_length_1d(_scribble_array) == __SCRIBBLE.__SIZE)
        && (_scribble_array[__SCRIBBLE.VERSION] == __SCRIBBLE_VERSION)
        && _scribble_array[__SCRIBBLE.FREED])
        {
            ds_map_delete(global.scribble_alive, _scribble_array[__SCRIBBLE.GLOBAL_INDEX]);
            
            var _element_pages_array = _scribble_array[__SCRIBBLE.PAGES_ARRAY];
            var _p = 0;
            repeat(array_length_1d(_element_pages_array))
            {
                var _page_array = _element_pages_array[_p];
                var _vertex_buffers_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
                var _v = 0;
                repeat(array_length_1d(_vertex_buffers_array))
                {
                    var _vbuff_data = _vertex_buffers_array[_v];
                    var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
                    vertex_delete_buffer(_vbuff);
                    ++_v;
                }
                ++_p;
            }
        
            _scribble_array[@ __SCRIBBLE.FREED] = true;
        }
        
        ++_i;
    }
    
    ds_list_clear(_list);
    
    return true;
}

if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: WARNING! Cache group \"" + string(_target) + "\" has not yet been created");
return false;