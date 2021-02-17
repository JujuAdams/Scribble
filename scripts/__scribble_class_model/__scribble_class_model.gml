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
    valign     = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
    fit_scale  = 1.0;
    wrapped    = false;
    
    pages_array      = []; //Stores each page of text
    character_array  = SCRIBBLE_CREATE_CHARACTER_ARRAY? [] : undefined;
    glyph_ltrb_array = undefined;
    
    events_char_array = []; //Stores each event's triggering character
    events_name_array = []; //Stores each event's name
    events_data_array = []; //Stores each event's parameters
    
    
    
    #region Public Methods
    
    static draw = function(_x, _y, _element)
    {
        if (flushed) return undefined;
        if (_element == undefined) _element = global.__scribble_default_element;
        
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
            var _x_offset = -origin_x;
            var _y_offset = -origin_y;
            var _xscale   = xscale;
            var _yscale   = yscale;
            var _angle    = angle;
        }
        
        _xscale *= fit_scale;
        _yscale *= fit_scale;
        
        var _left = _x_offset;
        var _top  = _y_offset;
        if (valign == fa_middle) _top -= _model_h div 2;
        if (valign == fa_bottom) _top -= _model_h;
        
        //Build a matrix to transform the text...
        if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
        {
            //TODO - Optimise
            var _matrix = matrix_build(_left + _x, _top + _y, 0,   0,0,0,   1,1,1);
        }
        else
        {
            //TODO - Optimise
            var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
                _matrix = matrix_multiply(_matrix, matrix_build(_x, _y, 0,
                                                                0, 0, _angle,
                                                                _xscale, _yscale, 1));
        }
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world);
        _matrix = matrix_multiply(_matrix, _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Now iterate over the text element's vertex buffers and submit them
        _page_data.__submit(_element);
        
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
        
        events_char_array = []; //Stores each event's triggering character
        events_name_array = []; //Stores each event's name
        events_data_array = []; //Stores each event's parameters
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
            return pages_array[_page].width;
        }
        else
        {
            return width;
        }
    }
    
    /// @page
    static get_height = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            return pages_array[_page].height;
        }
        else
        {
            return height;
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
    
    static __new_event = function(_character, _event_name, _data)
    {
        var _count = array_length(events_char_array);
        events_char_array[@ _count] = _character;
        events_name_array[@ _count] = _event_name;
        events_data_array[@ _count] = _data;
    }
    
    #endregion
    
    
    
    
    
    //Generate the model
    __scribble_generate_model(_element);
    
    //If we're using fit-to-box, test our height
    if (_element.wrap_no_pages && (height > _element.wrap_max_height))
    {
        //If our first attempt is unsuccessful, start the fitting algorithm
        
        //Estimate a lower limit
        var _lower_limit = _element.wrap_max_height / height;
        var _upper_limit = 1.0;
        
        //Regenerate the vertex buffers using the lower limit
        //TODO - Using the new parser, rearrange words
        reset();
        fit_scale = _lower_limit;
        __scribble_generate_model(_element);
        
        //If the lower limit generates a model that's still too tall, brute force a lower limit
        while(height*fit_scale > _element.wrap_max_height)
        {
            _upper_limit = fit_scale;
            _lower_limit -= 0.1;
            
            reset();
            fit_scale = _lower_limit;
            __scribble_generate_model(_element);
        }
        
        //Oscillate between the upper and lower limits, calculating a more and more accurate fit scale
        repeat(SCRIBBLE_FIT_TO_BOX_ITERATIONS)
        {
            reset();
            fit_scale = 0.5*(_upper_limit - _lower_limit) + _lower_limit; //Choose a scale halfway between the limits
            __scribble_generate_model(_element);
            
            if (height*fit_scale > _element.wrap_max_height)
            {
                //If we're too big, adjust the upper limit down
                _upper_limit = fit_scale;
            }
            else
            {
                //If we're too small, adjust the lower limit up
                _lower_limit = fit_scale;
            }
        }
        
        //If the last iteration was too big, reset the fit scale to the lower limit (which is guaranteed to fit)
        if (height*fit_scale > _element.wrap_max_height)
        {
            reset();
            fit_scale = _lower_limit;
            __scribble_generate_model(_element);
        }
        
        //Correct our width/height values
        //TODO - Do this in __scribble_generate_model()
        width  *= fit_scale;
        height *= fit_scale;
        
        pages_array[0].width  *= fit_scale;
        pages_array[0].height *= fit_scale;
    }
    
    if (SCRIBBLE_VERBOSE)
    {
        var _elapsed = (get_timer() - _timer_total)/1000;
        __scribble_trace("scribble_cache() took ", _elapsed, "ms for ", characters, " characters (ratio=", string_format(_elapsed/characters, 0, 6), ")");
    }
}