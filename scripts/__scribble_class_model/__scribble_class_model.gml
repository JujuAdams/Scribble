/// @param element
/// @param modelCacheName

function __scribble_class_model(_element, _model_cache_name) constructor
{
    //Record the start time so we can get a duration later
    if (SCRIBBLE_VERBOSE) var _timer_total = get_timer();
    
    __cache_name = _model_cache_name;
    
    
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching model \"", __cache_name, "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = global.__scribble_mcache_dict[$ __cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
    {
        __scribble_trace("Warning! Rebuilding model \"", __cache_name, "\"");
        _weak.ref.__flush();
    }
    
    //Add this model to the global cache
    global.__scribble_mcache_dict[$ __cache_name] = weak_ref_create(self);
    array_push(global.__scribble_mcache_name_array, __cache_name);
    
    __last_drawn = current_time;
    __flushed    = false;
    
    __uses_standard_font = false;
    __uses_msdf_font     = false;
    
    __pages      = 0;
    __width      = 0;
    __height     = 0;
    __min_x      = 0;
    __min_y      = 0;
    __max_x      = 0;
    __max_y      = 0;
    __valign     = undefined; // If this is still <undefined> after the main string parsing then we set the valign to fa_top
    __fit_scale  = 1.0;
    __wrapped    = false;
    
    __has_r2l        = false;
    __has_arabic     = false;
    __has_thai       = false;
    __has_hebrew     = false;
    __has_devanagari = false;
    
    __pages_array = []; //Stores each page of text
    
    
    
    static __submit = function(_page, _msdf_feather_thickness, _double_draw)
    {
        if (__flushed) return undefined;
        
        __last_drawn = current_time;
        
        __pages_array[_page].__submit(_msdf_feather_thickness, (__has_arabic || __has_thai) && _double_draw);
    }
    
    static __flush = function()
    {
        if (__flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing model \"" + string(__cache_name) + "\"");
        
        __reset();
        
        //Remove reference from cache
        variable_struct_remove(global.__scribble_mcache_dict, __cache_name);
        
        //Set as __flushed
        __flushed = true;
    }
    
    static __reset = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Resetting model \"" + string(__cache_name) + "\"");
        
        //Flush our pages
        var _i = 0;
        repeat(__pages)
        {
            __pages_array[_i].__flush();
            ++_i;
        }
        
        __pages      = 0;
        __width      = 0;
        __height     = 0;
        __min_x      = 0;
        __min_y      = 0;
        __max_x      = 0;
        __max_y      = 0;
        __valign     = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
        __fit_scale  = 1.0;
        
        __pages_array = []; //Stores each page of text
    }
    
    /// @param page
    static __get_bbox = function(_page)
    {
        if (_page != undefined)
        {
            if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
            if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
            
            var _page_data = __pages_array[_page];
            return { left:   _page_data.__min_x,
                     top:    _page_data.__min_y,
                     right:  _page_data.__max_x,
                     bottom: _page_data.__max_y, };
        }
        else
        {
            return { left:   __min_x,
                     top:    __min_y,
                     right:  __max_x,
                     bottom: __max_y, };
        }
    }
    
    /// @param page
    /// @param startCharacter
    /// @param endCharacter
    static __get_bbox_revealed = function(_page, _in_start, _in_end)
    {
        //TODO - Optimize by returning page bounds if the number of characters revealed is the same as the whole page
        
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Getting the revealed glyph bounding box requires SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to be set to <true>");
        
        var _glyph_grid = __get_glyph_data_grid(_page);
        
        var _start = _in_start - 1;
        var _end   = _in_end   - 1;
        
        if (_end < 0)
        {
            return { left:   _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.LEFT  ],
                     top:    _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.TOP   ],
                     right:  _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.LEFT  ],
                     bottom: _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.BOTTOM],
            };
        }
        else
        {
            var _left   = ds_grid_get_min(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.LEFT,   _end, __SCRIBBLE_GLYPH_LAYOUT.LEFT  );
            var _top    = ds_grid_get_min(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.TOP,    _end, __SCRIBBLE_GLYPH_LAYOUT.TOP   );
            var _right  = ds_grid_get_max(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.RIGHT,  _end, __SCRIBBLE_GLYPH_LAYOUT.RIGHT );
            var _bottom = ds_grid_get_max(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.BOTTOM, _end, __SCRIBBLE_GLYPH_LAYOUT.BOTTOM);
            
            return { left:   _left,
                     top:    _top,
                     right:  _right,
                     bottom: _bottom,
            };
        }
    }
    
    /// @page
    static __get_width = function(_page)
    {
        return __fit_scale*__width;
    }
    
    /// @page
    static __get_height = function(_page)
    {
        return __fit_scale*__height;
    }
    
    static __get_page_array = function()
    {
        return __pages_array;
    }
    
    static __get_page_count = function()
    {
        return __pages;
    }
	
	/// @param page
	static __get_page_width = function(_page)
	{
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
		
		return __fit_scale*__pages_array[_page].__width;
	}
	
	/// @param page
	static __get_page_height = function(_page)
	{
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
		
		return __fit_scale*__pages_array[_page].__height;
	}
	
	/// @param page
	static __get_text = function(_page)
	{
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
		
        if (!SCRIBBLE_ALLOW_TEXT_GETTER) __scribble_error("Cannot get text, SCRIBBLE_ALLOW_TEXT_GETTER = <false>\nPlease set SCRIBBLE_ALLOW_TEXT_GETTER to <true> to get text");
        
		return __pages_array[_page].__text;
	}
	
	/// @param page
	static __get_glyph_data = function(_index, _page)
	{
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
		
		return __pages_array[_page].__get_glyph_data(_index);
	}
    
    static __get_wrapped = function()
    {
        return __wrapped;
    }
    
    /// @param page
    static __get_line_count = function(_page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        return __pages_array[_page].__line_count;
    }
    
    /// @param page
    static __get_glyph_count = function(_page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        //N.B. Off by one since we consider the terminating null as a glyph for the purposes of typists
        return __pages_array[_page].__glyph_count - 1;
    }
    
    static __get_glyph_data_grid = function(_page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Getting glyph data requires SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to be set to <true>");
        
        return __pages_array[_page].__glyph_grid;
    }
    
    static __new_page = function()
    {
        var _page_data = new __scribble_class_page();
        array_push(__pages_array, _page_data);
        __pages++;
        
        return _page_data;
    }
    
    static __finalize_vertex_buffers = function(_freeze)
    {
        var _i = 0;
        repeat(array_length(__pages_array))
        {
            __pages_array[_i].__finalize_vertex_buffers(_freeze);
            ++_i;
        }
    }
    
    
    
    with(global.__scribble_generator_state)
    {
        __element          = _element;
        __glyph_count      = 0;
        __control_count    = 0;
        __word_count       = 0;
        __line_count       = 0;
        __line_height_min  = 0;
        __line_height_max  = 0;
        __model_max_width  = 0;
        __model_max_height = 0;
        __overall_bidi     = _element.__bidi_hint;
        
        __bezier_lengths_array = undefined;
    };
    
    __scribble_gen_1_model_limits_and_bezier_curves();
    __scribble_gen_2_parser();
    __scribble_gen_3_devanagari();
    __scribble_gen_4_build_words();
    __scribble_gen_5_finalize_bidi();
    __scribble_gen_6_build_lines();
    __scribble_gen_7_build_pages();
    __scribble_gen_8_position_glyphs();
    __scribble_gen_9_write_vbuffs();
    
    if (SCRIBBLE_VERBOSE)
    {
        var _elapsed = (get_timer() - _timer_total)/1000;
        __scribble_trace("scribble_cache() took ", _elapsed, "ms");
    }
}
