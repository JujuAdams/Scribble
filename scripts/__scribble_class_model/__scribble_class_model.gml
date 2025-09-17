// Feather disable all

/// @param element

function __scribble_class_model(_element) constructor
{
    static _generator_state = __scribble_system().__generator_state;
    
    
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching model \"", __cacheName, "\"");
    
    __frozen  = undefined;
    __flushed = false;
    
    //FIXME - Refresh elements that rely on this model
    
    __text                = _element.__text;
    __starting_font       = _element.__starting_font;
    __starting_colour     = _element.__starting_colour;
    __starting_halign     = _element.__starting_halign;
    __starting_valign     = _element.__starting_valign;
    __pre_scale           = _element.__pre_scale;
    __spritesDontScale    = _element.__spritesDontScale;
    __element_line_height = _element.__line_height;
    __line_spacing        = _element.__line_spacing;
    
    __layoutType         = _element.__layoutType;
    __layoutMaxWidth     = _element.__layoutMaxWidth;
    __layoutMaxHeight    = _element.__layoutMaxHeight;
    __layoutForcePerChar = _element.__layoutForcePerChar;
    __wrap_no_pages      = _element.__wrap_no_pages;
    __layoutMaxScale     = _element.__layoutMaxScale;
    
    __bezier_array = _element.__bezier_array;
    
    __bidi_hint           = _element.__bidi_hint;
    __ignore_command_tags = _element.__ignore_command_tags;
    __randomize_animation = _element.__randomize_animation;
    __newline_delay       = _element.__newline_delay;
    
    __padding_l = _element.__padding_l;
    __padding_t = _element.__padding_t;
    __padding_r = _element.__padding_r;
    __padding_b = _element.__padding_b;
    
    __allow_text_getter       = _element.__allow_text_getter;
    __allow_glyph_data_getter = _element.__allow_glyph_data_getter;
    
    __visual_bboxes    = _element.__visual_bboxes;
    __revealType       = _element.__revealType;
    __preprocessorFunc = _element.__preprocessorFunc;
    
    __build();
    
    
    
    static __build = function()
    {
        //Record the start time so we can get a duration later
        if (SCRIBBLE_VERBOSE) var _timer_total = get_timer();
        
        __pages       = 0;
        __width       = 0;
        __height      = 0;
        __line_height = __element_line_height;
        __min_x       = 0;
        __min_y       = 0;
        __max_x       = 0;
        __max_y       = 0;
        __valign      = undefined; // If this is still <undefined> after the main string parsing then we set the valign to fa_top
        __fitScale    = 1.0;
        __wrapped     = false;
        
        __pad_bbox_l = false;
        __pad_bbox_t = false;
        __pad_bbox_r = false;
        __pad_bbox_b = false;
        
        var _result = __scribble_parse_line_spacing(__line_spacing);
        __line_spacing_add      = _result.__add;
        __line_spacing_multiply = _result.__multiply;
        
        __has_r2l        = false;
        __has_arabic     = false;
        __has_thai       = false;
        __has_hebrew     = false;
        __has_devanagari = false;
        __has_animation  = false;
        __has_cycle      = false;
        
        __pages_array = []; //Stores each page of text
        __dynamicMacroArray = [];
        
        with(_generator_state)
        {
            __Reset();
            __overall_bidi = other.__bidi_hint;
        };
        
        __scribble_gen_1_model_limits_and_bezier_curves();
        __scribble_gen_2_parser();
        __scribble_gen_2b_post_parse();
        __scribble_gen_3_devanagari();
        __scribble_gen_4_build_words();
        __scribble_gen_5_finalize_bidi();
        __scribble_gen_6_build_lines();
        __scribble_gen_7_build_pages();
        __scribble_gen_8_position_glyphs();
        __scribble_gen_9_build_vbuff_grids();
        __scribble_gen_10_write_vbuffs();
        __scribble_gen_11_set_padding_flags();
        __scribble_gen_12_dynamic_macros();
        
        if (SCRIBBLE_VERBOSE)
        {
            var _elapsed = (get_timer() - _timer_total)/1000;
            __scribble_trace("__scribble_class_model() took ", _elapsed, "ms");
        }
    }
    
    static __rebuild = function()
    {
        __reset();
        __build();
    }
    
    static __Draw = function(_page, _scrollX, _scrollY, _serial, _serialOffset, _clip, _doubleDraw)
    {
        static _u_vClip   = shader_get_uniform(__shd_scribble, "u_vClip");
        static _u_vScroll = shader_get_uniform(__shd_scribble, "u_vScroll");
        
        static _usedClip = true;
        
        if (SCRIBBLE_ALWAYS_DOUBLE_DRAW || __has_arabic || __has_thai)
        {
            _doubleDraw = true;
        }
        
        if (not _serial)
        {
            //If we're not in serial mode then we can only draw one page at a time
            
            if (_clip)
            {
                //FIXME - Implement offsets for different h/v alignments
                _usedClip = true;
                shader_set_uniform_f(_u_vClip, 0, 0, __layoutMaxWidth, __layoutMaxHeight);
            }
            else
            {
                if (_usedClip)
                {
                    _usedClip = false;
                    shader_set_uniform_f(_u_vClip, -999999, -999999, 999999, 999999);
                }
            }
            
            shader_set_uniform_f(_u_vScroll, _scrollX, _scrollY);
            __pages_array[_page].__Submit(_doubleDraw);
        }
        else
        {
            //Otherwise, draw the two pages that are visible
            
            if (not _clip)
            {
                __scribble_error("Somehow you've managed to enable serial display without clipping. Please report this bug!");
            }
            
            _usedClip = true;
            
            _page = clamp(_serialOffset / __layoutMaxHeight, 0, array_length(__pages_array)-1);
            if ((_page == floor(_page)) || (_page == array_length(__pages_array)-1))
            {
                //FIXME - Implement offsets for different h/v alignments
                shader_set_uniform_f(_u_vClip, 0, 0, __layoutMaxWidth, __layoutMaxHeight - _scrollY);
                shader_set_uniform_f(_u_vScroll, _scrollX, _scrollY);
                __pages_array[_page].__Submit(_doubleDraw);
            }
            else
            {
                _page = floor(_page);
                
                //FIXME - Implement offsets for different h/v alignments
                var _serialScroll = (_serialOffset - _page*__layoutMaxHeight);
                shader_set_uniform_f(_u_vClip, 0, 0, __layoutMaxWidth, __layoutMaxHeight - _serialScroll);
                shader_set_uniform_f(_u_vScroll, _scrollX, _scrollY + _serialScroll);
                __pages_array[_page].__Submit(_doubleDraw);
                
                //FIXME - Implement offsets for different h/v alignments
                var _serialScroll = (_serialOffset - (_page+1)*__layoutMaxHeight);
                shader_set_uniform_f(_u_vClip, 0, _serialScroll, __layoutMaxWidth, __layoutMaxHeight);
                shader_set_uniform_f(_u_vScroll, _scrollX, _serialScroll);
                __pages_array[_page+1].__Submit(_doubleDraw);
            }
        }
    }
    
    static __Freeze = function()
    {
        if (not (__frozen ?? false))
        {
            var _i = 0;
            repeat(__pages)
            {
                __pages_array[_i].__Freeze();
                ++_i;
            }
            
            __frozen = true;
        }
    }
    
    static __Flush = function()
    {
        if (__flushed) return;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing model \"" + string(__cacheName) + "\"");
        
        __reset();
        __flushed = true;
    }
    
    static __reset = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Resetting model \"" + string(__cacheName) + "\"");
        
        //Flush our pages
        var _i = 0;
        repeat(__pages)
        {
            __pages_array[_i].__Flush();
            ++_i;
        }
        
        __pages    = 0;
        __width    = 0;
        __height   = 0;
        __min_x    = 0;
        __min_y    = 0;
        __max_x    = 0;
        __max_y    = 0;
        __valign   = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
        __fitScale = 1.0;
        
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
        
        if (not __allow_glyph_data_getter) __scribble_error("Getting the revealed glyph bounding box requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        
        var _glyph_grid = __get_glyph_data_grid(_page);
        
        var _start = _in_start - 1;
        var _end   = _in_end   - 1;
        
        if (_end < 0)
        {
            var _left   = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT  ];
            var _top    = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_TOP   ];
            var _right  = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT  ];
            var _bottom = _glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM];
        }
        else
        {
            var _left   = ds_grid_get_min(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT_LEFT,   _end, __SCRIBBLE_GLYPH_LAYOUT_LEFT  );
            var _top    = ds_grid_get_min(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT_TOP,    _end, __SCRIBBLE_GLYPH_LAYOUT_TOP   );
            var _right  = ds_grid_get_max(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT_RIGHT,  _end, __SCRIBBLE_GLYPH_LAYOUT_RIGHT );
            var _bottom = ds_grid_get_max(_glyph_grid, _start, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM, _end, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM);
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
        return __fitScale*__width;
    }
    
    /// @page
    static __get_height = function(_page)
    {
        return __fitScale*__height;
    }
    
    static __get_page_array = function()
    {
        return __pages_array;
    }
    
    static __get_page_count = function()
    {
        return __pages;
    }
    
    static __GetScrollMaxX = function(_page)
    {
        if ((_page < 0) || (_page > array_length(__pages_array)))
        {
            return 0;
        }
        
        return max(0, __pages_array[_page].__max_x - __layoutMaxWidth);
    }
    
    static __GetScrollMaxY = function(_page)
    {
        if ((_page < 0) || (_page > array_length(__pages_array)))
        {
            return 0;
        }
        
        return max(0, __pages_array[_page].__max_y - __layoutMaxHeight);
    }
    
    static __GetSerialY = function(_page)
    {
        return __layoutMaxHeight*clamp(_page, 0, array_length(__pages_array)-1);
    }
    
    static __GetSerialMax = function()
    {
        return __layoutMaxHeight*max(0, array_length(__pages_array)-1);
    }
    
    /// @param page
    static __get_text = function(_page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (not __allow_text_getter)
        {
            __scribble_error("Getting element text requires either:\n- Call `.allow_text_getter()` on the element\n- Set `SCRIBBLE_FORCE_TEXT_GETTER` to `true`");
        }
        
        return __pages_array[_page].__text;
    }
    
    /// @param page
    static __get_line_data = function(_index, _page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        return __pages_array[_page].__get_line_data(_index);
    }
    
    /// @param index
    /// @param page
    static __get_glyph_data = function(_index, _page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (not __allow_glyph_data_getter)
        {
            __scribble_error("Getting glyph data requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        }
        
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
    
    static __get_lines_visible = function(_integer)
    {
        var _count = (__layoutMaxHeight + __line_spacing_add) / max(1, __line_height*__line_spacing_multiply + __line_spacing_add);
        return _integer? floor(_count) : _count;
    }
    
    /// @param page
    static __get_glyph_count = function(_page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        //N.B. Off by one since we consider the terminating null as a glyph for the purposes of typists
        return __pages_array[_page].__glyph_count-1;
    }
    
    static __get_glyph_data_grid = function(_page)
    {
        if (_page < 0) __scribble_error("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __scribble_error("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (not __allow_glyph_data_getter) __scribble_error("Getting glyph data requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        
        return __pages_array[_page].__glyph_grid;
    }
    
    static __AddPage = function(_line_start)
    {
        static _generator_state = __scribble_system().__generator_state;
        
        var _page_data = new __scribble_class_page(self);
        _page_data.__line_start  = _line_start
        _page_data.__glyph_start = _generator_state.__word_grid[# _generator_state.__line_array[_line_start].wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
        
        array_push(__pages_array, _page_data);
        __pages++;
        
        return _page_data;
    }
    
    static __finalize_vertex_buffers = function()
    {
        var _i = 0;
        repeat(array_length(__pages_array))
        {
            __pages_array[_i].__finalize_vertex_buffers();
            ++_i;
        }
    }
}
