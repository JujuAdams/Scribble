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
    min_y      = 0;
    max_x      = 0;
    max_y      = 0;
    valign     = undefined; // If this is still <undefined> after the main string parsing then we set the valign to fa_top
    fit_scale  = 1.0;
    wrapped    = false;
    
    has_r2l        = false;
    has_arabic     = false;
    has_thai       = false;
    has_hebrew     = false;
    has_devanagari = false;
    
    pages_array = []; //Stores each page of text
    
    
    
    #region Public Methods
    
    static draw = function(_x, _y, _z, _element, _double_draw)
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
        
        var _old_matrix = matrix_get(matrix_world);
        
        //Build a matrix to transform the text...
        //TODO - Cache this
        if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
        {
            var _matrix = matrix_build(_x_offset + _x, _y_offset + _y, _z,   0,0,0,   1,1,1);
        }
        else
        {
            var _matrix = matrix_multiply(matrix_build(_x_offset, _y_offset,  0,   0, 0,      0,   _xscale, _yscale, 1),
                                          matrix_build(       _x,        _y, _z,   0, 0, _angle,         1,       1, 1));
        }
        
        //...aaaand set the matrix
        _matrix = matrix_multiply(_matrix, _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Now iterate over the text element's vertex buffers and submit them
        _page_data.__submit(_element, (has_arabic || has_thai) && _double_draw);
        
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
        min_y      = 0;
        max_x      = 0;
        max_y      = 0;
        valign     = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
        fit_scale  = 1.0;
        
        pages_array = []; //Stores each page of text
    }
    
    /// @param page
    static __get_bbox = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            var _page_data = pages_array[_page];
            return { left:   _page_data.min_x,
                     top:    _page_data.min_y,
                     right:  _page_data.max_x,
                     bottom: _page_data.max_y, };
        }
        else
        {
            return { left:   min_x,
                     top:    min_y,
                     right:  max_x,
                     bottom: max_y, };
        }
    }
    
    /// @param page
    /// @param startCharacter
    /// @param endCharacter
    static __get_bbox_revealed = function(_page, _in_start, _in_end)
    {
        //TODO - Optimize by returning page bounds if the number of characters revealed is the same as the whole page
        
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Getting the revealed glyph bounding box requires SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to be set to <true>");
        
        var _glyph_grid = get_glyph_data_grid(_page);
        
        var _start = _in_start - 1;
        var _end   = _in_end   - 1;
        
        if (_end < 0)
        {
            return { left:  _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.LEFT  ],
                     top:   _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.TOP   ],
                     right: _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.LEFT  ],
                     bottom:_glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.BOTTOM],
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
		
		return pages_array[_page].__height;
	}
	
	/// @param page
	static get_page_width = function(_page)
	{
		if ((_page == undefined) || (_page < 0)) _page = 0;
		
		return pages_array[_page].__width;
	}
	
	/// @param page
	static get_text = function(_page)
	{
		if ((_page == undefined) || (_page < 0)) _page = 0;
		
        if (!SCRIBBLE_ALLOW_TEXT_GETTER) __scribble_error("Cannot get text, SCRIBBLE_ALLOW_TEXT_GETTER = <false>\nPlease set SCRIBBLE_ALLOW_TEXT_GETTER to <true> to get text");
        
		return pages_array[_page].__text;
	}
	
	/// @param page
	static get_glyph_data = function(_index, _page)
	{
		if ((_page == undefined) || (_page < 0)) _page = 0;
		
		return pages_array[_page].__get_glyph_data(_index);
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
    
    /// @param page
    static get_glyph_count = function(_page)
    {
        if ((_page == undefined) || (_page < 0)) _page = 0;
        
        //N.B. Off by one since we consider the terminating null as a glyph for the purposes of typists
        return pages_array[_page].__glyph_count - 1;
    }
    
    static get_glyph_data_grid = function(_page)
    {
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Getting glyph data requires SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to be set to <true>");
        
        return pages_array[_page].__glyph_grid;
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
    
    __scribble_gen_1_model_limits_and_bezier_curves();
    //TODO - Fix numbering
    __scribble_gen_3_parser();
    __scribble_gen_4_devanagari();
    __scribble_gen_5_build_words();
    __scribble_gen_6_finalize_bidi();
    __scribble_gen_7_build_lines();
    __scribble_gen_8_build_pages();
    __scribble_gen_9_position_glyphs();
    __scribble_gen_10_write_vbuffs();
    
    if (SCRIBBLE_VERBOSE)
    {
        var _elapsed = (get_timer() - _timer_total)/1000;
        __scribble_trace("scribble_cache() took ", _elapsed, "ms for ", characters, " characters (ratio=", string_format(_elapsed/characters, 0, 6), ")");
    }
}