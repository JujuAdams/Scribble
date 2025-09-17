// Feather disable all

/// @param element

function __ScribbleClassModel(_element) constructor
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    
    
    if (__SCRIBBLE_DEBUG) __ScribbleTrace("Caching model \"", __cacheName, "\"");
    
    __frozen  = undefined;
    __flushed = false;
    
    //FIXME - Refresh elements that rely on this model
    
    __text              = _element.__text;
    __startingFont      = _element.__startingFont;
    __startingColor     = _element.__startingColor;
    __startingHAlign    = _element.__startingHAlign;
    __startingVAlign    = _element.__startingVAlign;
    __preScale          = _element.__preScale;
    __spritesDontScale  = _element.__spritesDontScale;
    __elementLineHeight = _element.__lineHeight;
    __lineSpacing       = _element.__lineSpacing;
    
    __layoutType         = _element.__layoutType;
    __layoutMaxWidth     = _element.__layoutMaxWidth;
    __layoutMaxHeight    = _element.__layoutMaxHeight;
    __layoutForcePerChar = _element.__layoutForcePerChar;
    __wrapNoPages        = _element.__wrapNoPages;
    __layoutMaxScale     = _element.__layoutMaxScale;
    
    __bezier_array = _element.__bezier_array;
    
    __bidiHint           = _element.__bidiHint;
    __ignoreCommandTags  = _element.__ignoreCommandTags;
    __randomizeAnimation = _element.__randomizeAnimation;
    __newlineDelay       = _element.__newlineDelay;
    
    __paddingL = _element.__paddingL;
    __paddingT = _element.__paddingT;
    __paddingR = _element.__paddingR;
    __paddingB = _element.__paddingB;
    
    __allowTextGetter      = _element.__allowTextGetter;
    __allowGlyphDataGetter = _element.__allowGlyphDataGetter;
    
    __visualBboxes     = _element.__visualBboxes;
    __revealType       = _element.__revealType;
    __preprocessorFunc = _element.__preprocessorFunc;
    
    __build();
    
    
    
    static __build = function()
    {
        //Record the start time so we can get a duration later
        if (SCRIBBLE_VERBOSE) var _timer_total = get_timer();
        
        __pages      = 0;
        __width      = 0;
        __height     = 0;
        __lineHeight = __elementLineHeight;
        __minX       = 0;
        __minY       = 0;
        __maxX       = 0;
        __maxY       = 0;
        __vAlign     = undefined; // If this is still <undefined> after the main string parsing then we set the valign to fa_top
        __fitScale   = 1.0;
        __wrapped    = false;
        
        __padBboxL = false;
        __padBboxT = false;
        __padBboxR = false;
        __padBboxB = false;
        
        var _result = __ScribbleParseLineSpacing(__lineSpacing);
        __lineSpacingAdd      = _result.__add;
        __lineSpacingMultiply = _result.__multiply;
        
        __hasR2L        = false;
        __hasArabic     = false;
        __hasThai       = false;
        __hasHebrew     = false;
        __hasDevanagari = false;
        __hasAnimation  = false;
        __hasCycle      = false;
        
        __pagesArray = []; //Stores each page of text
        __dynamicMacroArray = [];
        
        with(_generatorState)
        {
            __Reset();
            __overallBidi = other.__bidiHint;
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
            __ScribbleTrace("__ScribbleClassModel() took ", _elapsed, "ms");
        }
    }
    
    static __rebuild = function()
    {
        __Reset();
        __build();
    }
    
    static __Draw = function(_page, _scrollX, _scrollY, _serial, _serialOffset, _clip, _doubleDraw)
    {
        static _u_vClip   = shader_get_uniform(__shd_scribble, "u_vClip");
        static _u_vScroll = shader_get_uniform(__shd_scribble, "u_vScroll");
        
        static _usedClip = true;
        
        if (SCRIBBLE_ALWAYS_DOUBLE_DRAW || __hasArabic || __hasThai)
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
            __pagesArray[_page].__Submit(_doubleDraw);
        }
        else
        {
            //Otherwise, draw the two pages that are visible
            
            if (not _clip)
            {
                __ScribbleError("Somehow you've managed to enable serial display without clipping. Please report this bug!");
            }
            
            _usedClip = true;
            
            _page = clamp(_serialOffset / __layoutMaxHeight, 0, array_length(__pagesArray)-1);
            if ((_page == floor(_page)) || (_page == array_length(__pagesArray)-1))
            {
                //FIXME - Implement offsets for different h/v alignments
                shader_set_uniform_f(_u_vClip, 0, 0, __layoutMaxWidth, __layoutMaxHeight - _scrollY);
                shader_set_uniform_f(_u_vScroll, _scrollX, _scrollY);
                __pagesArray[_page].__Submit(_doubleDraw);
            }
            else
            {
                _page = floor(_page);
                
                //FIXME - Implement offsets for different h/v alignments
                var _serialScroll = (_serialOffset - _page*__layoutMaxHeight);
                shader_set_uniform_f(_u_vClip, 0, 0, __layoutMaxWidth, __layoutMaxHeight - _serialScroll);
                shader_set_uniform_f(_u_vScroll, _scrollX, _scrollY + _serialScroll);
                __pagesArray[_page].__Submit(_doubleDraw);
                
                //FIXME - Implement offsets for different h/v alignments
                var _serialScroll = (_serialOffset - (_page+1)*__layoutMaxHeight);
                shader_set_uniform_f(_u_vClip, 0, _serialScroll, __layoutMaxWidth, __layoutMaxHeight);
                shader_set_uniform_f(_u_vScroll, _scrollX, _serialScroll);
                __pagesArray[_page+1].__Submit(_doubleDraw);
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
                __pagesArray[_i].__Freeze();
                ++_i;
            }
            
            __frozen = true;
        }
    }
    
    static __Flush = function()
    {
        if (__flushed) return;
        if (__SCRIBBLE_DEBUG) __ScribbleTrace("Flushing model \"" + string(__cacheName) + "\"");
        
        __Reset();
        __flushed = true;
    }
    
    static __Reset = function()
    {
        if (__SCRIBBLE_DEBUG) __ScribbleTrace("Resetting model \"" + string(__cacheName) + "\"");
        
        //Flush our pages
        var _i = 0;
        repeat(__pages)
        {
            __pagesArray[_i].__Flush();
            ++_i;
        }
        
        __pages    = 0;
        __width    = 0;
        __height   = 0;
        __minX    = 0;
        __minY    = 0;
        __maxX    = 0;
        __maxY    = 0;
        __vAlign   = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
        __fitScale = 1.0;
        
        __pagesArray = []; //Stores each page of text
    }
    
    /// @param page
    static __GetBbox = function(_page, _paddingL, _paddingT, _paddingR, _paddingB)
    {
        if (_page != undefined)
        {
            if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
            if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
            
            var _pageData = __pagesArray[_page];
            var _left   = _pageData.__minX;
            var _top    = _pageData.__minY;
            var _right  = _pageData.__maxX;
            var _bottom = _pageData.__maxY;
        }
        else
        {
            var _left   = __minX;
            var _top    = __minY;
            var _right  = __maxX;
            var _bottom = __maxY;
        }
        
        if (__padBboxL) _left   -= _paddingL; else _right  += _paddingL;
        if (__padBboxT) _top    -= _paddingT; else _bottom += _paddingT;
        if (__padBboxR) _right  += _paddingR; else _left   -= _paddingR;
        if (__padBboxB) _bottom += _paddingB; else _top    -= _paddingB;
        
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
    static __GetBboxRevealed = function(_page, _inStart, _inEnd, _paddingL, _paddingT, _paddingR, _paddingB)
    {
        //TODO - Optimize by returning page bounds if the number of characters revealed is the same as the whole page
        
        if (not __allowGlyphDataGetter) __ScribbleError("Getting the revealed glyph bounding box requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        
        var _glyphGrid = __GetGlyphDataGrid(_page);
        
        var _start = _inStart-1;
        var _end   = _inEnd-1;
        
        if (_end < 0)
        {
            var _left   = _glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT  ];
            var _top    = _glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_TOP   ];
            var _right  = _glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT  ];
            var _bottom = _glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM];
        }
        else
        {
            var _left   = ds_grid_get_min(_glyphGrid, _start, __SCRIBBLE_GLYPH_LAYOUT_LEFT,   _end, __SCRIBBLE_GLYPH_LAYOUT_LEFT  );
            var _top    = ds_grid_get_min(_glyphGrid, _start, __SCRIBBLE_GLYPH_LAYOUT_TOP,    _end, __SCRIBBLE_GLYPH_LAYOUT_TOP   );
            var _right  = ds_grid_get_max(_glyphGrid, _start, __SCRIBBLE_GLYPH_LAYOUT_RIGHT,  _end, __SCRIBBLE_GLYPH_LAYOUT_RIGHT );
            var _bottom = ds_grid_get_max(_glyphGrid, _start, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM, _end, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM);
        }
        
        if (__padBboxL) _left   -= _paddingL; else _right  += _paddingL;
        if (__padBboxT) _top    -= _paddingT; else _bottom += _paddingT;
        if (__padBboxR) _right  += _paddingR; else _left   -= _paddingR;
        if (__padBboxB) _bottom += _paddingB; else _bottom -= _paddingB;
        
        return {
            left:   _left,
            top:    _top,
            right:  _right,
            bottom: _bottom,
        };
    }
    
    /// @page
    static __GetWidth = function(_page)
    {
        return __fitScale*__width;
    }
    
    /// @page
    static __GetHeight = function(_page)
    {
        return __fitScale*__height;
    }
    
    static __GetPageCount = function()
    {
        return __pages; //FIXME - Use `array_length()`
    }
    
    static __GetScrollMaxX = function(_page)
    {
        if ((_page < 0) || (_page > array_length(__pagesArray)))
        {
            return 0;
        }
        
        return max(0, __pagesArray[_page].__maxX - __layoutMaxWidth);
    }
    
    static __GetScrollMaxY = function(_page)
    {
        if ((_page < 0) || (_page > array_length(__pagesArray)))
        {
            return 0;
        }
        
        return max(0, __pagesArray[_page].__maxY - __layoutMaxHeight);
    }
    
    static __GetSerialY = function(_page)
    {
        return __layoutMaxHeight*clamp(_page, 0, array_length(__pagesArray)-1);
    }
    
    static __GetSerialMax = function()
    {
        return __layoutMaxHeight*max(0, array_length(__pagesArray)-1);
    }
    
    /// @param page
    static __GetText = function(_page)
    {
        if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (not __allowTextGetter)
        {
            __ScribbleError("Getting element text requires either:\n- Call `.allow_text_getter()` on the element\n- Set `SCRIBBLE_FORCE_TEXT_GETTER` to `true`");
        }
        
        return __pagesArray[_page].__text;
    }
    
    /// @param page
    static __GetLineData = function(_index, _page)
    {
        if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        return __pagesArray[_page].__GetLineData(_index);
    }
    
    /// @param index
    /// @param page
    static __GetGlyphData = function(_index, _page)
    {
        if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (not __allowGlyphDataGetter)
        {
            __ScribbleError("Getting glyph data requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        }
        
        return __pagesArray[_page].__GetGlyphData(_index);
    }
    
    static __GetWrapped = function()
    {
        return __wrapped;
    }
    
    /// @param page
    static __GetLineCount = function(_page)
    {
        if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        return __pagesArray[_page].__lineCount;
    }
    
    static __GetLinesVisible = function(_integer)
    {
        var _count = (__layoutMaxHeight + __lineSpacingAdd) / max(1, __lineHeight*__lineSpacingMultiply + __lineSpacingAdd);
        return _integer? floor(_count) : _count;
    }
    
    /// @param page
    static __GetGlyphCount = function(_page)
    {
        if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        //N.B. Off by one since we consider the terminating null as a glyph for the purposes of typists
        return __pagesArray[_page].__glyphCount-1;
    }
    
    static __GetGlyphDataGrid = function(_page)
    {
        if (_page < 0) __ScribbleError("Page index ", _page, " doesn't exist. Minimum page index is 0");
        if (_page >= __pages) __ScribbleError("Page index ", _page, " doesn't exist. Maximum page index is ", __pages-1);
        
        if (not __allowGlyphDataGetter) __ScribbleError("Getting glyph data requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        
        return __pagesArray[_page].__glyphGrid;
    }
    
    static __AddPage = function(_lineStart)
    {
        static _generatorState = __ScribbleSystem().__generatorState;
        
        var _pageData = new __ScribbleClassPage(self);
        _pageData.__lineStart  = _lineStart
        _pageData.__glyphStart = _generatorState.__word_grid[# _generatorState.__line_array[_lineStart].wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
        
        array_push(__pagesArray, _pageData);
        __pages++;
        
        return _pageData;
    }
    
    static __FinalizeVertexBuffers = function()
    {
        var _i = 0;
        repeat(array_length(__pagesArray))
        {
            __pagesArray[_i].__FinalizeVertexBuffers();
            ++_i;
        }
    }
}
