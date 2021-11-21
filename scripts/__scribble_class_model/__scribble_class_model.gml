/// @param element
/// @param modelCacheName

function __scribble_class_model(_element, _model_cache_name) constructor
{
    //Record the start time so we can get a duration later
    if (SCRIBBLE_VERBOSE) var _timer_total = get_timer();
    
    cache_name = _model_cache_name;
    
    
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching model \"" + cache_name + "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = global.__scribble_mcache_dict[? cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.flushed)
    {
        __scribble_trace("Warning! Rebuilding model \"", cache_name, "\"");
        _weak.ref.flush();
    }
    
    //Add this model to the global cache
    global.__scribble_mcache_dict[? cache_name] = weak_ref_create(self);
    ds_list_add(global.__scribble_mcache_name_list, cache_name);
    
    last_drawn = current_time;
    flushed    = false;
    
    uses_standard_font = false;
    uses_msdf_font     = false;
    
    characters = 0;
    lines      = 0;
    pages      = 0;
    width      = 0;
    height     = 0;
    min_x      = 0;
    max_x      = 0;
    valign     = undefined; // If this is still <undefined> after the main string parsing then we set the valign to fa_top
    fit_scale  = 1.0;
    wrapped    = false;
    has_arabic = false; // Set to <true> if any Arabic text is detected during the string parsing phase
    
    pages_array      = []; //Stores each page of text
    character_array  = SCRIBBLE_CREATE_CHARACTER_ARRAY? [] : undefined;
    glyph_ltrb_array = undefined;
    
    
    
    #region Public Methods
    
    static draw = function(_x, _y, _element, _arabic_double_draw)
    {
        if (flushed) return undefined;
        if (_element == undefined) return undefined;
        
        last_drawn = current_time;
        
        var _page_data = pages_array[_element.__page];
        if (SCRIBBLE_BOX_ALIGN_TO_PAGE)
        {
            var _model_w = _page_data.width;
            var _model_h = _page_data.height;
        }
        else
        {
            var _model_w = width;
            var _model_h = height;
        }
        
        with(_element)
        {
            __update_scale_to_box_scale();
            
            var _x_offset = -origin_x;
            var _y_offset = -origin_y;
            var _xscale   = xscale*scale_to_box_scale;
            var _yscale   = yscale*scale_to_box_scale;
            var _angle    = angle;
        }
        
        _xscale *= fit_scale;
        _yscale *= fit_scale;
        
        var _left = _x_offset;
        var _top  = _y_offset;
        if (valign == fa_middle) _top -= _model_h div 2;
        if (valign == fa_bottom) _top -= _model_h;
        
        var _old_matrix = matrix_get(matrix_world);
        
        //Build a matrix to transform the text...
        //TODO - Cache this
        if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
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
        _matrix = matrix_multiply(_matrix, _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Now iterate over the text element's vertex buffers and submit them
        _page_data.__submit(_element, has_arabic && _arabic_double_draw);
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
    }
    
    static flush = function()
    {
        if (flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing model \"" + string(cache_name) + "\"");
        
        reset();
        
        //Remove reference from cache
        ds_map_delete(global.__scribble_mcache_dict, cache_name);
        
        //Set as flushed
        flushed = true;
    }
    
    static reset = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Resetting model \"" + string(cache_name) + "\"");
        
        //Flush our pages
        var _i = 0;
        repeat(array_length(pages_array))
        {
            pages_array[_i].__flush();
            ++_i;
        }
        
        characters = 0;
        lines      = 0;
        pages      = 0;
        width      = 0;
        height     = 0;
        min_x      = 0;
        max_x      = 0;
        valign     = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
        fit_scale  = 1.0;
        
        pages_array      = []; //Stores each page of text
        character_array  = SCRIBBLE_CREATE_CHARACTER_ARRAY? [] : undefined;
        glyph_ltrb_array = undefined;
    }
    
    /// @param page
    static get_bbox = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            var _page_data = pages_array[_page];
            return { left:   _page_data.min_x,
                     top:    0,
                     right:  _page_data.max_x,
                     bottom: _page_data.height,
                     width:  _page_data.width,
                     height: _page_data.height };
        }
        else
        {
            return { left:   min_x,
                     top:    0,
                     right:  max_x,
                     bottom: height,
                     width:  width,
                     height: height };
        }
    }
    
    /// @page
    static get_width = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            return fit_scale*pages_array[_page].width;
        }
        else
        {
            return fit_scale*width;
        }
    }
    
    /// @page
    static get_height = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            return fit_scale*pages_array[_page].height;
        }
        else
        {
            return fit_scale*height;
        }
    }
    
    static get_page_array = function()
    {
        return pages_array;
    }
    
    static get_pages = function()
    {
        return pages;
    }
	
	/// @param page
	static get_page_height = function(_page)
	{
		if ((_page == undefined) || (_page < 0)) _page = 0;
		
		return pages_array[_page].height;
	}
	
	/// @param page
	static get_page_width = function(_page)
	{
		if ((_page == undefined) || (_page < 0)) _page = 0;
		
		return pages_array[_page].width;
	}
    
    static get_wrapped = function()
    {
        return wrapped;
    }
    
    /// @param page
    static get_line_count = function(_page)
    {
        if ((_page == undefined) || (_page < 0)) _page = 0;
        
        return pages_array[_page].lines;
    }
    
    static get_ltrb_array = function()
    {
        if (!SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY)
        {
            __scribble_error("SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY is not enabled\nPlease set this macro to <true> to use this function");
            return [];
        }
        
        return glyph_ltrb_array;
    }
    
    #endregion
    
    #region Private Methods
    
    static __new_page = function()
    {
        var _page_data = new __scribble_class_page();
        
        pages_array[@ pages] = _page_data;
        pages++;
        
        return _page_data;
    }
    
    static __finalize_vertex_buffers = function(_freeze)
    {
        var _i = 0;
        repeat(array_length(pages_array))
        {
            pages_array[_i].__finalize_vertex_buffers(_freeze);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    with(global.__scribble_generator_state)
    {
        element          = _element;
        glyph_count      = 0;
        control_count    = 0;
        word_count       = 0;
        line_count       = 0;
        line_height_min  = 0;
        line_height_max  = 0;
        model_max_width  = 0;
        model_max_height = 0;
        overall_bidi     = _element.__bidi_hint;
        
        bezier_lengths_array = undefined; //TODO
    };
    
    //TODO - Number these
    __scribble_gen_1_model_limits_and_bezier_curves()
    __scribble_gen_2_line_heights();
    __scribble_gen_3_parser(); //TODO - Write caching system for state and use ds_grid_set_region() to optimise/minimise ds_grid write operations
    __scribble_gen_4_determine_overall_bidi();
    __scribble_gen_5_build_words();
    __scribble_gen_6_finalize_bidi();
    __scribble_gen_7_build_lines();
    __scribble_gen_8_build_pages();
    __scribble_gen_9_position_glyphs();
    __scribble_gen_10_write_vbuffs();
    
    //Wipe the control grid so we don't accidentally hold references to event structs
    ds_grid_clear(global.__scribble_control_grid, 0);
    
    
    
    if (SCRIBBLE_VERBOSE)
    {
        var _elapsed = (get_timer() - _timer_total)/1000;
        __scribble_trace("scribble_cache() took ", _elapsed, "ms for ", characters, " characters (ratio=", string_format(_elapsed/characters, 0, 6), ")");
    }
}