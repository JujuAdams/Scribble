function __scribble_model(_element) constructor
{
    page_count = 0;
    
    draw = function(_x, _y)
    {
        
    }
    
    flush = function()
    {
	    if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing \"" + string(_scribble_array[SCRIBBLE.CACHE_STRING]) + "\"");
    
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
    
	    //Destroy occurrences as well
	    ds_map_destroy(_scribble_array[SCRIBBLE.OCCURRENCES_MAP]);
    
	    //Remove reference from cache
	    ds_map_delete(global.__scribble_global_cache_map, _scribble_array[SCRIBBLE.CACHE_STRING]);
	    var _index = ds_list_find_index(global.__scribble_global_cache_list, _scribble_array);
	    if (_index >= 0) ds_list_delete(global.__scribble_global_cache_list, _index);
    
	    //Set as freed
	    _scribble_array[@ SCRIBBLE.FREED] = true;
    }
    
    /// @param page
    get_bbox = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            //Find our occurrence data
            var _occurrences_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
            var _occurrence_array = _occurrences_map[? _occurrence_name];
            
            //Find our page data
            var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
            var _page_array = _element_pages_array[_occurrence_array[__SCRIBBLE_OCCURRENCE.PAGE]];
            
            return { left:   _page_array[__SCRIBBLE_PAGE.MIN_X ],
                     top:    0,
                     right:  _page_array[__SCRIBBLE_PAGE.MAX_X ],
                     bottom: _page_array[__SCRIBBLE_PAGE.HEIGHT],
                 
                     width:  _page_array[__SCRIBBLE_PAGE.WIDTH ],
                     height: _page_array[__SCRIBBLE_PAGE.HEIGHT] };
        }
        else
        {
            return { left:   _scribble_array[SCRIBBLE.MIN_X ],
                     top:    0,
                     right:  _scribble_array[SCRIBBLE.MAX_X ],
                     bottom: _scribble_array[SCRIBBLE.HEIGHT],
                 
                     width:  _scribble_array[SCRIBBLE.WIDTH ],
                     height: _scribble_array[SCRIBBLE.HEIGHT] };
        }
    }
    
    /// @page
    get_width = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            var _pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
            var _page_array = _pages_array[_page];
            return _page_array[__SCRIBBLE_PAGE.WIDTH];
        }
        else
        {
            return _scribble_array[SCRIBBLE.WIDTH];
        }
    }
    
    /// @page
    get_height = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            var _pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
            var _page_array = _pages_array[_page];
            return _page_array[__SCRIBBLE_PAGE.HEIGHT];
        }
        else
        {
            return _scribble_array[SCRIBBLE.HEIGHT];
        }
    }
    
    get_pages = function()
    {
        return page_count;
    }
}