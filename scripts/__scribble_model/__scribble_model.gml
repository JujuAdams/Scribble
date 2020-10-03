/// @param element
/// @param modelCacheName

function __scribble_model(_element, _model_cache_name) constructor
{
    cache_name = _model_cache_name;
    page_count = 0;
    flushed    = false;
    
    draw = function(_x, _y, _element)
    {
        if (flushed) return undefined;
        if (_element == undefined) _element = global.__scribble_default_element;
        
        var _page_struct = page_array[_element.__page];
        if (SCRIBBLE_BOX_ALIGN_TO_PAGE)
        {
            var _model_w = _page_struct.width;
            var _model_h = _page_struct.height;
        }
        else
        {
            var _model_w = width;
            var _model_h = height;
        }
        
        with(_element)
        {
            var _x_offset = -origin_x;
            var _y_offset = -origin_y;
            var _xscale   = xscale;
            var _yscale   = yscale;
            var _angle    = angle;
        }
        
        var _left = _x_offset;
        var _top  = _y_offset;
        if (valign == fa_middle) _top -= _model_h div 2;
        if (valign == fa_bottom) _top -= _model_h div 2;
        
	    //Build a matrix to transform the text...
	    if ((_xscale == 1) && (_yscale == 1) && (_angle  == 0))
	    {
	        var _matrix = matrix_build(_left + _x, _top + _y, 0,   0,0,0,   1,1,1);
	    }
	    else
	    {
	        var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
	            _matrix = matrix_multiply(_matrix, matrix_build(_x, _y, 0,
	                                                            0, 0, _angle,
	                                                            _xscale, _yscale, 1));
	    }
        
	    //...aaaand set the matrix
	    var _old_matrix = matrix_get(matrix_world);
	    _matrix = matrix_multiply(_matrix, _old_matrix);
	    matrix_set(matrix_world, _matrix);
        
        var _tw_method = 0;
        if (_element.tw_do) _tw_method = _element.tw_in? 1 : -1;
        
	    //Set the shader and its uniforms
	    shader_set(shd_scribble);
	    shader_set_uniform_f(global.__scribble_uniform_time, _element.animation_time);
        
	    shader_set_uniform_f(global.__scribble_uniform_tw_method, _tw_method);
	    shader_set_uniform_f(global.__scribble_uniform_tw_smoothness, _element.tw_smoothness);
	    shader_set_uniform_f_array(global.__scribble_uniform_tw_window_array, tw_do? _element.tw_window_array : global.__scribble_window_array_null);
        
	    shader_set_uniform_f(global.__scribble_uniform_colour_blend, colour_get_red(  _element.blend_colour)/255,
	                                                                 colour_get_green(_element.blend_colour)/255,
	                                                                 colour_get_blue( _element.blend_colour)/255,
	                                                                 _element.blend_alpha);
        
	    shader_set_uniform_f(global.__scribble_uniform_fog, colour_get_red(  _element.fog_colour)/255,
	                                                        colour_get_green(_element.fog_colour)/255,
	                                                        colour_get_blue( _element.fog_colour)/255,
	                                                        _element.fog_alpha);
        
	    shader_set_uniform_f_array(global.__scribble_uniform_data_fields,  _element.animation_array);
        shader_set_uniform_f_array(global.__scribble_uniform_bezier_array, _element.bezier_array);
        
	    //Now iterate over the text element's vertex buffers and submit them
        var _page_vbuff_array = _page_struct.vertex_buffer_array;
	    var _i = 0;
	    repeat(_page_struct.vertex_buffer_count)
	    {
	        var _vbuff_struct = _page_vbuff_array[_i];
	        vertex_submit(_vbuff_struct.vertex_buffer, pr_trianglelist, _vbuff_struct.texture);
	        ++_i;
	    }
        
	    shader_reset();
        
	    //Make sure we reset the world matrix
	    matrix_set(matrix_world, _old_matrix);
    }
    
    flush = function()
    {
        if (flushed) return undefined;
	    if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing \"" + string(cache_name) + "\"");
        
	    //Destroy vertex buffers
	    var _p = 0;
	    repeat(array_length(page_array))
	    {
	        var _vertex_buffers_array = page_array[_p].vertex_buffer_array;
	        var _v = 0;
	        repeat(array_length(_vertex_buffers_array))
	        {
	            vertex_delete_buffer(_vertex_buffers_array[_v].vertex_buffer);
	            ++_v;
	        }
            
	        ++_p;
	    }
        
	    //Remove reference from cache
	    ds_map_delete(global.__scribble_global_cache_map, cache_name);
	    var _index = ds_list_find_index(global.__scribble_global_cache_list, self);
	    if (_index >= 0) ds_list_delete(global.__scribble_global_cache_list, _index);
    
	    //Set as flushed
	    flushed = true;
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