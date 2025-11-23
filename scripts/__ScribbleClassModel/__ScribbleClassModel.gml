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
    __layoutMaxScale     = _element.__layoutMaxScale;
    
    __path      = _element.__path;
    __pathStart = _element.__pathStart;
    __pathEnd   = _element.__pathEnd;
    __pathScale = _element.__pathScale;
    
    __bidiHint           = _element.__bidiHint;
    __ignoreCommandTags  = _element.__ignoreCommandTags;
    __randomizeAnimation = _element.__randomizeAnimation;
    
    __paddingL = _element.__paddingL;
    __paddingT = _element.__paddingT;
    __paddingR = _element.__paddingR;
    __paddingB = _element.__paddingB;
    
    __allowTextGetter      = _element.__allowTextGetter;
    __allowGlyphDataGetter = _element.__allowGlyphDataGetter;
    
    __visualBboxes      = _element.__visualBboxes;
    __revealMode        = _element.__revealMode;
    __preprocessorArray = _element.__preprocessorBakedArray;
    
    __Build();
    
    
    
    static __Build = function()
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
        
        __clipLeft   = -999999;
        __clipTop    = -999999;
        __clipRight  =  999999;
        __clipBottom =  999999;
        
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
        __hasOutline    = false;
        
        __pagesArray = []; //Stores each page of text
        __dynamicMacroArray = [];
        
        __eventsDict = {};
        
        __dynamicFontUseGridArray = [];
        
        with(_generatorState)
        {
            __Reset();
            __overallBidi = other.__bidiHint;
        };
        
        __ScribbleGen1_ModelLimitsAndPaths();
        __ScribbleGen2_Parser();
        __ScribbleGen2b_PostParse();
        __ScribbleGen3_Devanagari();
        __ScribbleGen4_BuildWords();
        __ScribbleGen5_FinalizeBidi();
        __ScribbleGen6_BuildLines();
        __ScribbleGen7_BuildPages();
        __ScribbleGen8_PositionGlyphs();
        __ScribbleGen9_BuildVBuffGrids();
        __ScribbleGen10_WriteVBuffs();
        __ScribbleGen11_PaddingAndClipping();
        __ScribbleGen12_DynamicMacros();
        
        if (SCRIBBLE_VERBOSE)
        {
            var _elapsed = (get_timer() - _timer_total)/1000;
            __ScribbleTrace("__ScribbleClassModel() took ", _elapsed, "ms");
        }
    }
    
    static __Rebuild = function()
    {
        __Reset();
        __Build();
    }
    
    static __Draw = function(_page, _scrollXArray, _scrollYArray, _clip, _doubleDraw)
    {
        static _u_vClip   = shader_get_uniform(__shdScribble, "u_vClip");
        static _u_vScroll = shader_get_uniform(__shdScribble, "u_vScroll");
        
        static _usedClip = true;
        
        if (SCRIBBLE_ALWAYS_DOUBLE_DRAW || __hasArabic || __hasThai || __hasOutline)
        {
            _doubleDraw = true;
        }
        
        if (_page == floor(_page))
        {
            //Only draw one page
            
            var _pageStruct = __pagesArray[_page];
            
            if (_clip)
            {
                _usedClip = true;
                shader_set_uniform_f(_u_vClip, __clipLeft, __clipTop, __clipRight, __clipBottom);
                shader_set_uniform_f(_u_vScroll, _pageStruct.__scrollOffsetX + _scrollXArray[_page], _pageStruct.__scrollOffsetY + _scrollYArray[_page]);
            }
            else
            {
                if (_usedClip)
                {
                    _usedClip = false;
                    shader_set_uniform_f(_u_vClip, -999999, -999999, 999999, 999999);
                }
                
                shader_set_uniform_f(_u_vScroll, _scrollXArray[_page], _scrollYArray[_page]);
            }
            
            _pageStruct.__Submit(_doubleDraw);
        }
        else
        {
            //Otherwise, draw the two pages that are visible. We always enable clipping here
            _usedClip = true;
            
            var _offset = frac(_page)*__layoutMaxHeight;
            var _pageInteger = floor(_page);
            
            var _pageStruct = __pagesArray[_pageInteger];
            shader_set_uniform_f(_u_vClip, __clipLeft, __clipTop, __clipRight, __clipBottom - _offset);
            shader_set_uniform_f(_u_vScroll, _pageStruct.__scrollOffsetX + _scrollXArray[_page], _pageStruct.__scrollOffsetY + _scrollYArray[_page] + _offset);
            _pageStruct.__Submit(_doubleDraw);
            
            var _pageStruct = __pagesArray[_pageInteger+1];
            shader_set_uniform_f(_u_vClip, __clipLeft, __clipTop - _offset, __clipRight, __clipBottom);
            shader_set_uniform_f(_u_vScroll, _pageStruct.__scrollOffsetX + _scrollXArray[_pageInteger+1], _pageStruct.__scrollOffsetY + _scrollYArray[_pageInteger+1] + _offset - __layoutMaxHeight);
            _pageStruct.__Submit(_doubleDraw);
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
        
        var _dynamicFontUseGridArray = __dynamicFontUseGridArray;
        var _i = 0;
        repeat(array_length(_dynamicFontUseGridArray))
        {
            with(_dynamicFontUseGridArray[_i])
            {
                ds_grid_multiply_region(__grid, 0, 0, __count-1, 0, -1);
                ds_grid_add_grid_region(__font.__dynSlotDataGrid, __grid,   0, 0, __count-1, 0,   0, __SCRIBBLE_DYN_SLOT_DATA_USED_COUNT);
                ds_grid_destroy(__grid);
                
                __font.__dynCleanUpIndex = 0;
            }
            
            ++_i;
        }
        
        array_resize(_dynamicFontUseGridArray, 0);
    }
    
    /// @param page
    static __GetBbox = function(_page, _paddingL, _paddingT, _paddingR, _paddingB, _clip)
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
        
        if (_clip)
        {
            //Clipping is relative to the model
            if (__startingHAlign == fa_center)
            {
                _left  = max(floor(-0.5*__layoutMaxWidth), _left);
                _right = min(floor( 0.5*__layoutMaxWidth), _right);
            }
            else if (__startingHAlign == fa_right)
            {
                _left  = max(-__layoutMaxWidth, _left);
                _right = min(0, _right);
            }
            else
            {
                _left  = max(0, _left);
                _right = min(__layoutMaxWidth, _right);
            }
        
            if (__startingVAlign == fa_middle)
            {
                _top    = max(floor(-0.5*__layoutMaxHeight), _top);
                _bottom = min(floor( 0.5*__layoutMaxHeight), _bottom);
            }
            else if (__startingVAlign == fa_bottom)
            {
                _top    = max(-__layoutMaxHeight, _top);
                _bottom = min(0, _bottom);
            }
            else
            {
                _top    = max(0, _top);
                _bottom = min(__layoutMaxHeight, _bottom);
            }
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
    
    static __GetBboxRevealed = function(_page, _glyphIndex, _paddingL, _paddingT, _paddingR, _paddingB, _clip)
    {
        //TODO - Optimize by returning page bounds if the number of characters revealed is the same as the whole page
        //FIXME - Implement for non-glyph reveal
        
        if (not __allowGlyphDataGetter) __ScribbleError("Getting the revealed glyph bounding box requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        
        var _pageStruct = __pagesArray[_page];
        var _glyphGrid = __GetGlyphDataGrid(_page);
        
        var _start = _pageStruct.__glyphStart;
        var _end   = _glyphIndex;
        
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
        
        if (_clip)
        {
            //Clipping is relative to the model
            if (__startingHAlign == fa_center)
            {
                _left  = max(floor(-0.5*__layoutMaxWidth), _left);
                _right = min(floor( 0.5*__layoutMaxWidth), _right);
            }
            else if (__startingHAlign == fa_right)
            {
                _left  = max(-__layoutMaxWidth, _left);
                _right = min(0, _right);
            }
            else
            {
                _left  = max(0, _left);
                _right = min(__layoutMaxWidth, _right);
            }
        
            if (__startingVAlign == fa_middle)
            {
                _top    = max(floor(-0.5*__layoutMaxHeight), _left);
                _bottom = min(floor( 0.5*__layoutMaxHeight), _right);
            }
            else if (__startingVAlign == fa_bottom)
            {
                _top    = max(-__layoutMaxHeight, _top);
                _bottom = min(0, _bottom);
            }
            else
            {
                _top    = max(0, _top);
                _bottom = min(__layoutMaxHeight, _bottom);
            }
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
    
    /// @param page
    static __GetWidth = function(_page)
    {
        return __fitScale*__width;
    }
    
    /// @param page
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
        return ((_page < 0) || (_page > array_length(__pagesArray)))? 0 : __pagesArray[_page].__scrollMaxX;
    }
    
    static __GetScrollMaxY = function(_page)
    {
        return ((_page < 0) || (_page > array_length(__pagesArray)))? 0 : __pagesArray[_page].__scrollMaxY;
    }
    
    //TODO - These are unused
    //
    //static __GetSerialY = function(_page)
    //{
    //    return __layoutMaxHeight*clamp(_page, 0, array_length(__pagesArray)-1);
    //}
    //
    //static __GetSerialMax = function()
    //{
    //    return __layoutMaxHeight*max(0, array_length(__pagesArray)-1);
    //}
    
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
        var _count = (min(__layoutMaxHeight, __height) + __lineSpacingAdd) / max(1, __lineHeight*__lineSpacingMultiply + __lineSpacingAdd);
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
        _pageData.__glyphStart = _generatorState.__wordGrid[# _generatorState.__lineArray[_lineStart].wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
        
        array_push(__pagesArray, _pageData);
        __pages++;
        
        return _pageData;
    }
    
    static __GetPage = function(_index)
    {
        return __pagesArray[clamp(_index, 0, array_length(__pagesArray)-1)];
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
