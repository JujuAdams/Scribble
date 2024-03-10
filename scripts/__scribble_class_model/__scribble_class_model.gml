// Feather disable all
/// @param element
/// @param modelCacheName

function __scribble_class_model(_element, _model_cache_name) constructor
{
    static __scribble_state    = __scribble_get_state();
    static __mcache_dict       = __scribble_get_cache_state().__mcache_dict;
    static __mcache_name_array = __scribble_get_cache_state().__mcache_name_array;
    
    //Record the start time so we can get a duration later
    if (SCRIBBLE_VERBOSE) var _timer_total = get_timer();
    
    __cache_name = _model_cache_name;
    
    
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching model \"", __cache_name, "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = __mcache_dict[$ __cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
    {
        __scribble_trace("Warning! Rebuilding model \"", __cache_name, "\"");
        _weak.ref.__flush();
    }
    
    //Add this model to the global cache
    __mcache_dict[$ __cache_name] = weak_ref_create(self);
    array_push(__mcache_name_array, __cache_name);
    
    __last_drawn = __scribble_state.__frames;
    __frozen     = undefined;
    __flushed    = false;
    
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
    
    __pad_bbox_l = false;
    __pad_bbox_t = false;
    __pad_bbox_r = false;
    __pad_bbox_b = false;
    
    __has_r2l        = false;
    __has_arabic     = false;
    __has_thai       = false;
    __has_hebrew     = false;
    __has_devanagari = false;
    __has_animation  = false;
    
    __pages_array = []; //Stores each page of text
    
    
    
    static __submit = function(_page, _double_draw)
    {
        if (__flushed) return undefined;
        
        __last_drawn = __scribble_state.__frames;
        
        __pages_array[_page].__submit((SCRIBBLE_ALWAYS_DOUBLE_DRAW || __has_arabic || __has_thai) && _double_draw);
    }
    
    static __freeze = function()
    {
        if (!__frozen)
        {
            var _i = 0;
            repeat(__pages)
            {
                __pages_array[_i].__freeze();
                ++_i;
            }
            
            __frozen = true;
        }
    }
    
    static __flush = function()
    {
        if (__flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing model \"" + string(__cache_name) + "\"");
        
        __reset();
        
        //Remove reference from cache
        variable_struct_remove(__mcache_dict, __cache_name);
        
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
    static __get_bbox = function(_page, _padding_l, _padding_t, _padding_r, _padding_b)
    {
        if (_page != undefined)
        {
            if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
            if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
            
            var _page_data = __pages_array[_page];
            var _left   = _page_data.__min_x;
            var _top    = _page_data.__min_y;
            var _right  = _page_data.__max_x;
            var _bottom = _page_data.__max_y;
            
        }
        else
        {
            var _left   = __min_x;
            var _top    = __min_y;
            var _right  = __max_x;
            var _bottom = __max_y;
        }
        
        if (__pad_bbox_l) _left   -= _padding_l; else _right  += _padding_l;
        if (__pad_bbox_t) _top    -= _padding_t; else _bottom += _padding_t;
        if (__pad_bbox_r) _right  += _padding_r; else _left   -= _padding_r;
        if (__pad_bbox_b) _bottom += _padding_b; else _top    -= _padding_b;
        
        return {
            left:   _left,
            top:    _top,
            right:  _right,
            bottom: _bottom,
        };
    }
    
    /// @param page
    /// @param startCharacter
    /// @param endCharacter
    static __get_bbox_revealed = function(_page, _in_start, _in_end, _padding_l, _padding_t, _padding_r, _padding_b)
    {
        //TODO - Optimize by returning page bounds if the number of characters revealed is the same as the whole page
        
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Getting the revealed glyph bounding box requires SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to be set to <true>");
        
        var _glyph_grid = __get_glyph_data_grid(_page);
        
        var _start = _in_start - 1;
        var _end   = _in_end   - 1;
        
        if (_end < 0)
        {
            var _left   = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT  ];
            var _top    = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__TOP   ];
            var _right  = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT  ];
            var _bottom = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM];
        }
        else
        {
            var _left   = ds_grid_get_min(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.__LEFT,   _end, __SCRIBBLE_GLYPH_LAYOUT.__LEFT  );
            var _top    = ds_grid_get_min(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.__TOP,    _end, __SCRIBBLE_GLYPH_LAYOUT.__TOP   );
            var _right  = ds_grid_get_max(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.__RIGHT,  _end, __SCRIBBLE_GLYPH_LAYOUT.__RIGHT );
            var _bottom = ds_grid_get_max(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM, _end, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM);
        }
        
        if (__pad_bbox_l) _left   -= _padding_l; else _right  += _padding_l;
        if (__pad_bbox_t) _top    -= _padding_t; else _bottom += _padding_t;
        if (__pad_bbox_r) _right  += _padding_r; else _left   -= _padding_r;
        if (__pad_bbox_b) _bottom += _padding_b; else _bottom -= _padding_b;
        
        return {
            left:   _left,
            top:    _top,
            right:  _right,
            bottom: _bottom,
        };
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
    
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        __Reset();
        
        __element      = _element;
        __overall_bidi = _element.__bidi_hint;
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
    __scribble_gen_10_set_padding_flags();
    
    if (SCRIBBLE_VERBOSE)
    {
        var _elapsed = (get_timer() - _timer_total)/1000;
        __scribble_trace("__scribble_class_model() took ", _elapsed, "ms");
    }
}
