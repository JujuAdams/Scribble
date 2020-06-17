/// Frees up memory used by Scribble, targetting either all text elements, or a specific text element
/// 
/// @param [textElement]   Which text element to target. Defaults to <all>, which will clear the memory for all text elements

function scribble_flush()
{
	var _scribble_array = (argument_count > 0)? argument[0] : all;

	if ((_scribble_array == all) || (_scribble_array == "all"))
	{
	    if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Clearing entire cache");
	    repeat(ds_list_size(global.__scribble_global_cache_list)) scribble_flush(global.__scribble_global_cache_list[| 0]);
	}
	else
	{
	    if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Clearing \"" + string(_scribble_array[SCRIBBLE.CACHE_STRING]) + "\"");
    
	    //Destroy vertex buffers
	    var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
	    var _p = 0;
	    repeat(array_length(_element_pages_array))
	    {
	        var _page_array = _element_pages_array[_p];
	        var _vertex_buffers_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
	        var _v = 0;
	        repeat(array_length(_vertex_buffers_array))
	        {
	            var _vbuff_data = _vertex_buffers_array[_v];
	            var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
	            vertex_delete_buffer(_vbuff);
            
	            ++_v;
	        }
            
	        ++_p;
	    }
    
	    //Destroy occurances as well
	    ds_map_destroy(_scribble_array[SCRIBBLE.OCCURANCES_MAP]);
    
	    //Remove reference from cache
	    ds_map_delete(global.__scribble_global_cache_map, _scribble_array[SCRIBBLE.CACHE_STRING]);
	    var _index = ds_list_find_index(global.__scribble_global_cache_list, _scribble_array);
	    if (_index >= 0) ds_list_delete(global.__scribble_global_cache_list, _index);
    
	    //Set as freed
	    _scribble_array[@ SCRIBBLE.FREED] = true;
	}
}