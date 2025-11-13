// Feather disable all

/// @param text

function __ScribbleClassElementParent(_text) constructor
{
    static _system = __ScribbleSystem();
    
    
    
    __text = _text;
    
    __flushed = false;
    
    __modelDirty = true;
    __model = undefined;
    __lastDrawn = _system.__frames;
    
    
    
    //We define this for all text elements because it gets used in the model key builder
    __revealMode = SCRIBBLE_DEFAULT_REVEAL_MODE;
    __spritesDontScale = true;
    
    __preprocessorArray      = undefined;
    __preprocessorArrayDirty = true;
    __preprocessorBakedArray = undefined;
    
    __startingFont   = _system.__state.__defaultFont;
    __startingColor  = __ScribbleProcessColor(SCRIBBLE_DEFAULT_COLOR);
    __startingHAlign = SCRIBBLE_DEFAULT_HALIGN;
    __startingVAlign = SCRIBBLE_DEFAULT_VALIGN;
    __blendColor     = c_white;
    __blendAlpha     = 1.0;
    __skewX          = 0;
    __skewY          = 0;
    __gradientColor  = c_black;
    __gradientAlpha  = 0.0;
    __flashColor     = c_white;
    __flashAlpha     = 0.0;
    
    __randomizeAnimation = false;
    
    __allowTextGetter      = SCRIBBLE_FORCE_TEXT_GETTER;
    __allowGlyphDataGetter = SCRIBBLE_FORCE_GLYPH_DATA_GETTER;
    
    __originX = 0.0;
    __originY = 0.0;
    
    __preScale = 1.0;
    
    __postXScale = 1.0;
    __postYScale = 1.0;
    __postAngle  = 0.0;
    
    __matrixDirty   = true;
    __matrix        = matrix_build_identity();
    __matrixInverse = undefined;
    __matrixX       = undefined;
    __matrixY       = undefined;
    
    __layoutType         = SCRIBBLE_LAYOUT_NONE;
    __layoutMaxWidth     = infinity;
    __layoutMaxHeight    = infinity;
    __layoutForcePerChar = false;
    __wrapNoPages        = false;
    __layoutMaxScale     = 1;
    
    __clip = false;
    
    __scrollXArray = [];
    __scrollYArray = [];
    
    __panState        = SCRIBBLE_AUTO_START;
    __panSpeed        = SCRIBBLE_DEFAULT_PAN_SPEED;
    __panPause        = SCRIBBLE_DEFAULT_AUTOPAN_PAUSE_TIME;
    __panAuto         = false;
    __panWasClamped   = true;
    __panPauseCounter = 0;
    
    __scrollState        = SCRIBBLE_AUTO_START;
    __scrollSpeed        = SCRIBBLE_DEFAULT_SCROLL_SPEED;
    __scrollPause        = SCRIBBLE_DEFAULT_AUTOSCROLL_PAUSE_TIME;
    __scrollAuto         = false;
    __scrollWasClamped   = true;
    __scrollPauseCounter = 0;
    
    __blockTrim = 0;
    
    __scaleToBoxDirty    = true;
    __scaleToBoxWidth    = 0;
    __scaleToBoxHeight   = 0;
    __scaleToBoxMaximize = false;
    __scaleToBoxScale    = undefined;
    
    __lineHeight  = -1;
    __lineSpacing = "100%";
    
    __visualBboxes = SCRIBBLE_DEFAULT_VISUAL_BBOXES;
    
    __pageInteger = 0;
    __pageFraction = 0;
    
    __ignoreCommandTags = false;
    __template = undefined;
    
    __bezierArray = array_create(6, 0.0);
    __bezierUsing = false;
    
    __animationTime  = 0;
    __animationSpeed = 1;
    
    __paddingL = 0;
    __paddingT = 0;
    __paddingR = 0;
    __paddingB = 0;
    
    __sdfShadowColor    = c_black;
    __sdfShadowAlpha    = 0.0;
    __sdfShadowXOffset  = 0;
    __sdfShadowYOffset  = 0;
    __sdfShadowSoftness = 0;
    
    __sdfOutlineColor     = c_black;
    __sdfOutlineThickness = 0.0;
    
    __bidiHint = undefined;
    
    __z = SCRIBBLE_DEFAULT_Z;
    
    __regionActive     = undefined;
    __regionGlyphStart = 0;
    __regionGlyphEnd   = 0;
    __regionColor      = c_black;
    __regionBlend      = 0.0;
    
    
    
    __bboxDirty      = true;
    __bboxMatrix     = matrix_build_identity();
    __bboxRawWidth   = 1;
    __bboxRawHeight  = 1;
    __bboxAABBLeft   = 0;
    __bboxAABBTop    = 0;
    __bboxAABBRight  = 0;
    __bboxAABBBottom = 0;
    __bboxAABBWidth  = 1;
    __bboxAABBHeight = 1;
    __bboxOOBx0      = 0;
    __bboxOOBy0      = 0;
    __bboxOOBx1      = 0;
    __bboxOOBy1      = 0;
    __bboxOOBx2      = 0;
    __bboxOOBy2      = 0;
    __bboxOOBx3      = 0;
    __bboxOOBy3      = 0;
    
    
    
    #region Basics
    
    /// @param font
    static font = function(_font)
    {
        if (is_string(_font))
        {
            var _fontName = _font;
        }
        else if (is_handle(_font))
        {
            if (asset_get_type(_font) == asset_font)
            {
                var _fontName = font_get_name(_font);
            }
            else if (asset_get_type(_font) == asset_sprite)
            {
                var _fontName = sprite_get_name(_font);
            }
            else
            {
                __ScribbleError("You may only set a font using one of the following:\n- Font name as a string\n- Font handle\n- Sprite name as a string (if it has been used to create a spritefont)\n- Sprite handle (if it has been used to create a spritefont)");
            }
        }
        else if (_font == undefined)
        {
            return self;
        }
        else
        {
            __ScribbleError("Fonts should be specified using their name as a string\nUse <undefined> to not set a new font");
        }
        
        if (_fontName != __startingFont)
        {
            __modelDirty = true;
            __startingFont = _fontName;
        }
        
        return self;
    }
    
    /// @param colour
    static color = function(_in_colour)
    {
        if (_in_colour != undefined)
        {
            var _color = __ScribbleProcessColor(_in_colour);
            if ((_color != undefined) && (_color >= 0) && (_color != __startingColor))
            {
                __modelDirty = true;
                __startingColor = _color & 0xFFFFFF;
            }
        }
        
        return self;
    }
    
    /// @param colour
    static colour = color;
    
    /// @param halign
    /// @param valign
    static align = function(_hAlign = __startingHAlign, _vAlign = __startingVAlign)
    {
        _hAlign = __ScribbleConvertHAlignName(_hAlign);
        _vAlign = __ScribbleConvertVAlignName(_vAlign);
        
        if (_hAlign != __startingHAlign)
        {
            __modelDirty = true;
            __bboxDirty  = true;
            
            __startingHAlign = _hAlign;
        }
        
        if (_vAlign != __startingVAlign)
        {
            __modelDirty = true;
            __bboxDirty  = true;
            
            __startingVAlign = _vAlign;
        }
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static blend = function(_color, _alpha)
    {
        _color = __ScribbleProcessColor(_color);
        
        if (_color != undefined) __blendColor = _color & 0xFFFFFF;
        if (_alpha != undefined) __blendAlpha = clamp(_alpha, 0, 1);
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static gradient = function(_color, _alpha)
    {
        _color = __ScribbleProcessColor(_color);
        
        __gradientColor = _color & 0xFFFFFF;
        __gradientAlpha = _alpha;
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static flash = function(_color, _alpha)
    {
        _color = __ScribbleProcessColor(_color);
        
        __flashColor = _color & 0xFFFFFF;
        __flashAlpha = _alpha;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Layout
    
    static max_size = function(_width = __layoutMaxWidth, _height = __layoutMaxHeight)
    {
        _width  = max(0, _width);
        _height = max(0, _height);
        
        if ((_width != __layoutMaxWidth) || (_height != __layoutMaxHeight))
        {
            __layoutMaxWidth  = _width;
            __layoutMaxHeight = _height;
            
            if (__layoutType == SCRIBBLE_LAYOUT_SCALE)
            {
                __scaleToBoxDirty = true;
            }
            else
            {
                __modelDirty = true;
            }
        }
        
        return self;
    }
    
    static get_max_width = function()
    {
        return __layoutMaxWidth;
    }
    
    static get_max_height = function()
    {
        return __layoutMaxHeight;
    }
    
    static layout_ext = function(_layout, _forcePerChar = false, _maxScale = 1)
    {
        if ((_layout != __layoutType) || (_forcePerChar != __layoutForcePerChar))
        {
            __layoutType = _layout;
            __layoutForcePerChar = _forcePerChar;
            
            __modelDirty = true;
        }
        
        if (_maxScale != __layoutMaxScale)
        {
            __layoutMaxScale = _maxScale;
            
            if ((_layout == SCRIBBLE_LAYOUT_SCALE) || (_layout == SCRIBBLE_LAYOUT_FIT))
            {
                __modelDirty = true;
            }
        }
        
        return self;
    }
    
    static layout_none = function()
    {
        if (__layoutType != SCRIBBLE_LAYOUT_NONE)
        {
            __layoutType = SCRIBBLE_LAYOUT_NONE;
            __modelDirty = true;
        }
        
        return self;
    }
    
    static layout_wrap = function(_forcePerChar = false)
    {
        if ((__layoutType != SCRIBBLE_LAYOUT_WRAP) || (_forcePerChar != __layoutForcePerChar))
        {
            __layoutType         = SCRIBBLE_LAYOUT_WRAP;
            __layoutForcePerChar = _forcePerChar;
            __modelDirty         = true;
        }
        
        return self;
    }
    
    static layout_trim = function(_forcePerChar = false)
    {
        if ((__layoutType != SCRIBBLE_LAYOUT_TRIM) || (_forcePerChar != __layoutForcePerChar))
        {
            __layoutType         = SCRIBBLE_LAYOUT_TRIM;
            __layoutForcePerChar = _forcePerChar;
            __modelDirty         = true;
        }
        
        return self;
    }
    
    static layout_trim_ellipsis = function(_forcePerChar = false)
    {
        if ((__layoutType != SCRIBBLE_LAYOUT_TRIM_ELLIPSIS) || (_forcePerChar != __layoutForcePerChar))
        {
            __layoutType         = SCRIBBLE_LAYOUT_TRIM_ELLIPSIS;
            __layoutForcePerChar = _forcePerChar;
            __modelDirty         = true;
        }
        
        return self;
    }
    
    static layout_paginate = function(_forcePerChar = false)
    {
        if ((__layoutType != SCRIBBLE_LAYOUT_PAGINATE) || (_forcePerChar != __layoutForcePerChar))
        {
            __layoutType         = SCRIBBLE_LAYOUT_PAGINATE;
            __layoutForcePerChar = _forcePerChar;
            __modelDirty         = true;
        }
        
        return self;
    }
    
    static layout_scale = function(_forcePerChar = false, _maxScale = 1)
    {
        if ((__layoutType != SCRIBBLE_LAYOUT_SCALE) || (_forcePerChar != __layoutForcePerChar) || (_maxScale != __layoutMaxScale))
        {
            __layoutType         = SCRIBBLE_LAYOUT_SCALE;
            __layoutForcePerChar = _forcePerChar;
            __layoutMaxScale     = _maxScale;
            __modelDirty         = true;
        }
        
        return self;
    }
    
    static layout_fit = function(_forcePerChar = false, _maxScale = 1)
    {
        if ((__layoutType != SCRIBBLE_LAYOUT_FIT) || (_forcePerChar != __layoutForcePerChar) || (_maxScale != __layoutMaxScale))
        {
            __layoutType         = SCRIBBLE_LAYOUT_FIT;
            __layoutForcePerChar = _forcePerChar;
            __layoutMaxScale     = _maxScale;
            __modelDirty         = true;
        }
        
        return self;
    }
    
    static get_layout = function()
    {
        return __layoutType;
    }
    
    #endregion
    
    
    
    #region Pan
    
    static pan_auto = function(_speed = SCRIBBLE_DEFAULT_PAN_SPEED, _pauseTime = SCRIBBLE_DEFAULT_AUTOPAN_PAUSE_TIME)
    {
        //Skip the pause if we're starting autoscroll
        if (not __panAuto)
        {
            if (__panState == SCRIBBLE_AUTO_MOVE_TO_END)
            {
                __panState = SCRIBBLE_AUTO_END;
            }
            else if (__panState == SCRIBBLE_AUTO_MOVE_TO_START)
            {
                __panState = SCRIBBLE_AUTO_START;
            }
        }
        
        __panAuto = true;
        
        __panSpeed = _speed;
        __panPause = _pauseTime;
        
        return self;
    }
    
    static pan_to_glyph = function(_index)
    {
        var _model = __EnsureModel();
        
        if (not _model.__allowGlyphDataGetter)
        {
            __ScribbleError("Panning to a glyph requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        }
        
        var _glyphData = _model.__GetGlyphData(_index, __pageInteger);
        return pan_to(_glyphData.left, _glyphData.right);
    }
    
    static pan = function(_x, _clamp = true, _page = __pageInteger)
    {
        __EnsureModel();
        
        __panAuto = false;
        
        __panXArray[@ _page] = _clamp? clamp(_x, 0, get_pan_max()) : _x;
        __panWasClamped = _clamp;
        
        return self;
    }
    
    static pan_to = function(_min, _max, _page = __pageInteger)
    {
        __EnsureModel();
        
        if (1 + _max - _min > __layoutMaxWidth)
        {
            //Range is bigger than can be displayed, centre the line
            __scrollXArray[@ _page] = clamp(((_min + _max) div 2) - (__layoutMaxWidth div 2), 0, get_pan_max());
        }
        else if (_min < __scrollXArray[_page])
        {
            //Range is above the top of the region
            __scrollXArray[@ _page] = clamp(_min, 0, get_pan_max());
        }
        else if (_max >= __layoutMaxWidth + __scrollXArray[_page])
        {
            //Range is below the bottom of the region
            __scrollXArray[@ _page] = clamp(_max - __layoutMaxWidth, 0, get_pan_max());
        }
        else
        {
            //Range is visible, do nothing
        }
        
        return self;
    }
    
    static get_pan = function(_page = __pageInteger)
    {
        __EnsureModel();
        
        return __scrollXArray[_page];
    }
    
    static get_pan_max = function(_page = __pageInteger)
    {
        return __EnsureModel().__GetScrollMaxX(_page);
    }
    
    static __AutoPan = function(_page = __pageInteger)
    {
        //N.B. This is an *unsafe* method. Please check `__panAuto` prior to calling it
        
        if (__panState == SCRIBBLE_AUTO_START)
        {
            __scrollXArray[@ _page] += __panSpeed*_system.__tickSize;
            
            if (__scrollXArray[_page] >= get_pan_max())
            {
                __scrollXArray[@ _page] = get_pan_max();
                __panPauseCounter = 0;
                __panState = SCRIBBLE_AUTO_MOVE_TO_END;
            }
        }
        else if (__panState == SCRIBBLE_AUTO_MOVE_TO_END)
        {
            __panPauseCounter += _system.__tickSize
            
            if (__panPauseCounter >= __panPause)
            {
                __panState = SCRIBBLE_AUTO_END;
            }
        }
        else if (__panState == SCRIBBLE_AUTO_END)
        {
            __scrollXArray[@ _page] -= __panSpeed*_system.__tickSize;
            
            if (__scrollXArray[_page] <= 0)
            {
                __scrollXArray[@ _page] = 0;
                __panPauseCounter = 0;
                __panState = SCRIBBLE_AUTO_MOVE_TO_START;
            }
        }
        else if (__panState == SCRIBBLE_AUTO_MOVE_TO_START)
        {
            __panPauseCounter += _system.__tickSize
            
            if (__panPauseCounter >= __panPause)
            {
                __panState = SCRIBBLE_AUTO_START;
            }
        }
    }
    
    #endregion
    
    
    
    #region Clip & Scroll
    
    static clip = function(_state = true)
    {
        __clip = _state;
        
        return self;
    }
    
    static get_clip = function()
    {
        return __clip;
    }
    
    static scroll_auto = function(_speed = SCRIBBLE_DEFAULT_SCROLL_SPEED, _pauseTime = SCRIBBLE_DEFAULT_AUTOSCROLL_PAUSE_TIME)
    {
        //Skip the pause if we're starting autoscroll
        if (not __scrollAuto)
        {
            if (__scrollState == SCRIBBLE_AUTO_MOVE_TO_END)
            {
                __scrollState = SCRIBBLE_AUTO_END;
            }
            else if (__scrollState == SCRIBBLE_AUTO_MOVE_TO_START)
            {
                __scrollState = SCRIBBLE_AUTO_START;
            }
        }
        
        __scrollAuto = true;
        
        __scrollSpeed = _speed;
        __scrollPause = _pauseTime;
        
        return self;
    }
    
    static scroll_to_glyph = function(_index)
    {
        var _model = __EnsureModel();
        if (_model.__allowGlyphDataGetter)
        {
            var _glyphData = _model.__GetGlyphData(_index, __pageInteger);
            return scroll_to(_glyphData.top, _glyphData.bottom);
        }
        else
        {
            var _lineArray = _model.__pagesArray[__pageInteger].__lineDataArray;
            var _i = 0;
            repeat(array_length(_lineArray))
            {
                if ((_index >= _lineArray[_i].glyphStart) && (_index <= _lineArray[_i].glyphEnd))
                {
                    return scroll_to_line(_i);
                }
                
                ++_i;
            }
        }
        
        return self;
    }
    
    static scroll_to_line = function(_index)
    {
        var _model = __EnsureModel();
        var _line_data = _model.__GetLineData(_index, __pageInteger);
        return scroll_to(_line_data.y, _line_data.y + _line_data.height-1);
    }
    
    static scroll_to = function(_min, _max, _page = __pageInteger)
    {
        __EnsureModel();
        
        if (1 + _max - _min > __layoutMaxHeight)
        {
            //Range is bigger than can be displayed, centre the line
            __scrollYArray[@ _page] = clamp(((_min + _max) div 2) - (__layoutMaxHeight div 2), 0, get_scroll_max());
        }
        else if (_min < __scrollYArray[_page])
        {
            //Range is above the top of the region
            __scrollYArray[@ _page] = clamp(_min, 0, get_scroll_max());
        }
        else if (_max >= __layoutMaxHeight + __scrollYArray[_page])
        {
            //Range is below the bottom of the region
            __scrollYArray[@ _page] = clamp(_max - __layoutMaxHeight, 0, get_scroll_max());
        }
        else
        {
            //Range is visible, do nothing
        }
        
        return self;
    }
    
    static scroll = function(_y, _clamp = true, _page = __pageInteger)
    {
        __EnsureModel();
        
        __scrollAuto = false;
        
        __scrollYArray[@ _page] = _clamp? clamp(_y, 0, get_scroll_max()) : _y;
        __scrollWasClamped = _clamp;
        
        return self;
    }
    
    static get_scroll = function(_page = __pageInteger)
    {
        __EnsureModel();
        
        return __scrollYArray[_page];
    }
    
    static get_scroll_max = function(_page = __pageInteger)
    {
        return __EnsureModel().__GetScrollMaxY(_page);
    }
    
    static __AutoScroll = function(_page = __pageInteger)
    {
        //N.B. This is an *unsafe* method. Please check `__scrollAuto` prior to calling it
        
        if (__scrollState == SCRIBBLE_AUTO_START)
        {
            __scrollYArray[@ _page] += __scrollSpeed*_system.__tickSize;
            
            if (__scrollYArray[_page] >= get_scroll_max())
            {
                __scrollYArray[@ _page] = get_scroll_max();
                __scrollPauseCounter = 0;
                __scrollState = SCRIBBLE_AUTO_MOVE_TO_END;
            }
        }
        else if (__scrollState == SCRIBBLE_AUTO_MOVE_TO_END)
        {
            __scrollPauseCounter += _system.__tickSize
            
            if (__scrollPauseCounter >= __scrollPause)
            {
                __scrollState = SCRIBBLE_AUTO_END;
            }
        }
        else if (__scrollState == SCRIBBLE_AUTO_END)
        {
            __scrollYArray[@ _page] -= __scrollSpeed*_system.__tickSize;
            
            if (__scrollYArray[_page] <= 0)
            {
                __scrollYArray[@ _page] = 0;
                __scrollPauseCounter = 0;
                __scrollState = SCRIBBLE_AUTO_MOVE_TO_START;
            }
        }
        else if (__scrollState == SCRIBBLE_AUTO_MOVE_TO_START)
        {
            __scrollPauseCounter += _system.__tickSize
            
            if (__scrollPauseCounter >= __scrollPause)
            {
                __scrollState = SCRIBBLE_AUTO_START;
            }
        }
    }
    
    static block_trim = function(_value)
    {
        __blockTrim = _value;
        
        return self;
    }
    
    static get_block_trim = function()
    {
        return __blockTrim;
    }
    
    #endregion
    
    
    
    #region Positioning
    
    /// @param xOffset
    /// @param yOffset
    static origin = function(_x, _y)
    {
        if ((__originX != _x) || (__originY != _y))
        {
            __matrixDirty = true;
            __bboxDirty   = true;
            
            __originX = _x;
            __originY = _y;
        }
        
        return self;
    }
    
    /// @param xScale
    /// @param [yScale=xScale]
    /// @param [angle=0]
    static transform = function(_xScale, _yScale = _xScale, _angle = 0)
    {
        if ((__postXScale != _xScale) || (__postYScale != _yScale) || (__postAngle != _angle))
        {
            __matrixDirty = true;
            __bboxDirty   = true;
            
            __postXScale = _xScale;
            __postYScale = _yScale;
            __postAngle  = _angle;
        }
        
        return self;
    }
    
    /// @param scale
    /// @param [spritesDontScale=false]
    static scale = function(_scale, _spritesDontScale = false)
    {
        if ((__preScale != _scale)
        ||  (__spritesDontScale != _spritesDontScale))
        {
            __modelDirty = true;
            __bboxDirty  = true;
            
            __preScale = _scale;
            __spritesDontScale = _spritesDontScale;
        }
        
        return self;
    }
    
    static skew = function(_skew_x, _skew_y)
    {
        __skewX = _skew_x;
        __skewY = _skew_y;
        
        return self;
    }
    
    /// @param height
    static line_height = function(_height)
    {
        if (_height != __lineHeight)
        {
            __modelDirty = true;
            __lineHeight = _height;
        }
        
        return self;
    }
    
    /// @param spacing
    static line_spacing = function(_spacing)
    {
        if (_spacing != __lineSpacing)
        {
            __modelDirty = true;
            __lineSpacing = _spacing;
        }
        
        return self;
    }
    
    /// @param left
    /// @param top
    /// @param right
    /// @param bottom
    static padding = function(_l, _t, _r, _b)
    {
        if ((_l != __paddingL) || (_t != __paddingT) || (_r != __paddingR) || (_b != __paddingB))
        {
            __modelDirty      = true;
            __matrixDirty     = true;
            __bboxDirty       = true;
            __scaleToBoxDirty = true;
            
            __paddingL = _l;
            __paddingT = _t;
            __paddingR = _r;
            __paddingB = _b;
        }
        
        return self;
    }
    
    /// @param state
    static visual_bboxes = function(_state)
    {
        if (__visualBboxes != _state)
        {
            __modelDirty      = true;
            __matrixDirty     = true;
            __bboxDirty       = true;
            __scaleToBoxDirty = true;
            
            __visualBboxes = _state;
        }
        
        return self;
    }
    
    /// @param [x1=0]
    /// @param [y1=0]
    /// @param [x2=0]
    /// @param [y2=0]
    /// @param [x3=0]
    /// @param [y3=0]
    /// @param [x4=0]
    /// @param [y4=0]
    static bezier = function(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4)
    {
        if (argument_count <= 0)
        {
            var _bezierArray = array_create(6, 0.0);
        }
        else if (argument_count == 8)
        {
            if ((not is_numeric(_x1)) || (not is_numeric(_y1))
            ||  (not is_numeric(_x2)) || (not is_numeric(_y2))
            ||  (not is_numeric(_x3)) || (not is_numeric(_y3))
            ||  (not is_numeric(_x4)) || (not is_numeric(_y4)))
            {
                __ScribbleTrace("Warning! One or more Bezier parameters were not numeric (", _x1, ", ", _y1, ", ", _x2, ", ", _y2, ", ", _x3, ", ", _y3, ", ", _x4, ", ", _y4, ")");
                
                _x1 = 0;
                _y1 = 0;
                _x2 = 0;
                _y2 = 0;
                _x3 = 0;
                _y3 = 0;
                _x4 = 0;
                _y4 = 0;
            }
        }
        else
        {
            __ScribbleError("Wrong number of arguments (", argument_count, ") provided\nExpecting 0 or 8");
        }
        
        var _bezierArray = [_x2 - _x1, _y2 - _y1,
                             _x3 - _x1, _y3 - _y1,
                             _x4 - _x1, _y4 - _y1];
        
        if (not array_equals(__bezierArray, _bezierArray))
        {
            __modelDirty  = true;
            __bezierArray = _bezierArray;
            __bezierUsing = true;
        }
        
        return self;
    }
    
    static right_to_left = function(_state)
    {
        if (_state == undefined)
        {
            var _newBidiHint = undefined;
        }
        else
        {
            var _newBidiHint = _state? __SCRIBBLE_BIDI_R2L : __SCRIBBLE_BIDI_L2R;
        }
        
        if (__bidiHint != _newBidiHint)
        {
            __modelDirty = true;
            __bidiHint = _newBidiHint;
        }
        
        return self;
    }
    
    #endregion
    
    
    
    #region Regions
    
    static region_detect = function(_elementX, _elementY, _pointerX, _pointerY)
    {
        var _page        = __EnsureModel().__pagesArray[__pageInteger];
        var _regionArray = _page.__regionArray;
        
        var _matrix = __UpdateMatrix(_elementX, _elementY);
        
        if (__matrixInverse == undefined)
        {
            __matrixInverse = __ScribbleMatrixInverse(matrix_multiply(_matrix, matrix_get(matrix_world)));
        }
        
        var _vector = matrix_transform_vertex(__matrixInverse, _pointerX, _pointerY, 0);
        var _x = _vector[0];
        var _y = _vector[1];
        
        var _found = undefined;
        var _i = array_length(_regionArray)-1;
        repeat(_i+1)
        {
            var _region = _regionArray[_i];
            var _bboxArray = _region.bboxArray;
            
            var _j = 0;
            repeat(array_length(_bboxArray))
            {
                var _bbox = _bboxArray[_j];
                if ((_x >= _bbox.x1) && (_y >= _bbox.y1) && (_x <= _bbox.x2) && (_y <= _bbox.y2))
                {
                    _found = _region.name;
                    break;
                }
                
                ++_j;
            }
            
            if (_found != undefined) break;
            --_i;
        }
        
        return _found;
    }
    
    static region_set_active = function(_name, _color, _blend_amount)
    {
        if (not is_string(_name))
        {
            __regionActive     = undefined;
            __regionGlyphStart = 0;
            __regionGlyphEnd   = 0;
            __regionColor      = c_black;
            __regionBlend      = 0.0;
            return;
        }
        
        var _page        = __EnsureModel().__pagesArray[__pageInteger];
        var _regionArray = _page.__regionArray;
        
        var _i = 0;
        repeat(array_length(_regionArray))
        {
            var _region = _regionArray[_i];
            if (_region.name == _name)
            {
                __regionActive     = _name;
                __regionGlyphStart = _region.startGlyph;
                __regionGlyphEnd   = _region.endGlyph;
                __regionColor      = _color;
                __regionBlend      = _blend_amount;
                return self;
            }
            
            ++_i;
        }
        
        __ScribbleError("Region \"", _name, "\" not found");
    }
    
    static region_get_active = function()
    {
        return __regionActive;
    }
    
    static region_clear = function()
    {
        region_set_active(undefined, undefined, undefined);
        return self;
    }
    
    static region_get_bboxes = function()
    {
        return __EnsureModel().__pagesArray[__pageInteger].__regionArray;
    }
    
    static region_draw = function(_elementX, _elementY, _name, _padding = 0, _sprite = sprScribbleFallbackDot, _image = 0, _color = c_white, _alpha = 1)
    {
        var _page        = __EnsureModel().__pagesArray[__pageInteger];
        var _regionArray = _page.__regionArray;
        
        var _i = 0;
        repeat(array_length(_regionArray))
        {
            var _region = _regionArray[_i];
            if (_region.name == _name)
            {
                var _oldMatrix = matrix_get(matrix_world); //FIXME - Use a stack here
                var _matrix = matrix_multiply(__UpdateMatrix(_elementX, _elementY), _oldMatrix);
                matrix_set(matrix_world, _matrix);
                
                //TODO - Make regions a class and move this code to a method?
                
                var _bboxArray = _region.bboxArray;
                var _j = 0;
                repeat(array_length(_bboxArray))
                {
                    var _bbox = _bboxArray[_j];
                    draw_sprite_stretched_ext(_sprite, _image,
                                              _bbox.x1 - _padding, _bbox.y1 - _padding,
                                              1 + _bbox.x2 - _bbox.x1 + 2*_padding, 1 + _bbox.y2 - _bbox.y1 + 2*_padding,
                                              _color, _alpha);
                    ++_j;
                }
                
                //Make sure we reset the world matrix
                matrix_set(matrix_world, _oldMatrix);
                shader_reset();
                
                return self;
            }
            
            ++_i;
        }
        
        return self;
    }
    
    #endregion
    
    
    
    #region Dimensions
    
    static __UpdateBboxMatrix = function()
    {
        __UpdateScaleToBoxScale();
        
        if (__bboxDirty)
        {
            __bboxDirty = false;
            var _bboxMatrix = __bboxMatrix;
            
            var _model  = __EnsureModel();
            var _xScale = __scaleToBoxScale*_model.__fitScale*__postXScale;
            var _yScale = __scaleToBoxScale*_model.__fitScale*__postYScale;
            
            //Left/top padding is baked into the model
            var _bbox = _model.__GetBbox(SCRIBBLE_BOUNDING_BOX_USES_PAGE? __pageInteger : undefined, __paddingL, __paddingT, __paddingR, __paddingB);
            
            __bboxRawWidth  = 1 + _bbox.right - _bbox.left;
            __bboxRawHeight = 1 + _bbox.bottom - _bbox.top;
            
            if ((_xScale == 1) && (_yScale == 1) && (__postAngle == 0))
            {
                _bboxMatrix[@  0] = 1;
                _bboxMatrix[@  1] = 0;
                _bboxMatrix[@  4] = 0;
                _bboxMatrix[@  5] = 1;
                _bboxMatrix[@ 12] = -__originX;
                _bboxMatrix[@ 13] = -__originY;
                
                //Avoid using matrices if we can
                __bboxAABBLeft   = -__originX + _bbox.left;
                __bboxAABBTop    = -__originY + _bbox.top;
                __bboxAABBRight  = -__originX + _bbox.right;
                __bboxAABBBottom = -__originY + _bbox.bottom;
                
                __bboxOOBx0 = __bboxAABBLeft;   __bboxOOBy0 = __bboxAABBTop;
                __bboxOOBx1 = __bboxAABBRight;  __bboxOOBy1 = __bboxAABBTop;
                __bboxOOBx2 = __bboxAABBLeft;   __bboxOOBy2 = __bboxAABBBottom;
                __bboxOOBx3 = __bboxAABBRight;  __bboxOOBy3 = __bboxAABBBottom;
            }
            else
            {
                var  _sin = dsin(-__postAngle);
                var  _cos = dcos(-__postAngle);
                var _xSin = _xScale*_sin;
                var _xCos = _xScale*_cos;
                var _ySin = _yScale*_sin;
                var _yCos = _yScale*_cos;
                
                _bboxMatrix[@  0] =  _xCos;
                _bboxMatrix[@  1] =  _xSin;
                _bboxMatrix[@  4] = -_ySin;
                _bboxMatrix[@  5] =  _yCos;
                _bboxMatrix[@ 12] = -(__originX*_xCos - __originY*_ySin);
                _bboxMatrix[@ 13] = -(__originX*_xSin + __originY*_yCos);
                
                var _l = _bbox.left;
                var _t = _bbox.top;
                var _r = _bbox.right;
                var _b = _bbox.bottom;
                
                var _vertex = matrix_transform_vertex(__bboxMatrix, _l, _t, 0); __bboxOOBx0 = _vertex[0]; __bboxOOBy0 = _vertex[1];
                var _vertex = matrix_transform_vertex(__bboxMatrix, _r, _t, 0); __bboxOOBx1 = _vertex[0]; __bboxOOBy1 = _vertex[1];
                var _vertex = matrix_transform_vertex(__bboxMatrix, _l, _b, 0); __bboxOOBx2 = _vertex[0]; __bboxOOBy2 = _vertex[1];
                var _vertex = matrix_transform_vertex(__bboxMatrix, _r, _b, 0); __bboxOOBx3 = _vertex[0]; __bboxOOBy3 = _vertex[1];
                
                __bboxAABBLeft   = min(__bboxOOBx0, __bboxOOBx1, __bboxOOBx2, __bboxOOBx3);
                __bboxAABBTop    = min(__bboxOOBy0, __bboxOOBy1, __bboxOOBy2, __bboxOOBy3);
                __bboxAABBRight  = max(__bboxOOBx0, __bboxOOBx1, __bboxOOBx2, __bboxOOBx3);
                __bboxAABBBottom = max(__bboxOOBy0, __bboxOOBy1, __bboxOOBy2, __bboxOOBy3);
            }
            
            __bboxAABBWidth  = 1 + __bboxAABBRight - __bboxAABBLeft;
            __bboxAABBHeight = 1 + __bboxAABBBottom - __bboxAABBTop;
        }
    }
    
    static get_left = function(_x = 0)
    {
        __UpdateBboxMatrix();
        return __bboxAABBLeft + _x;
    }
    
    static get_top = function(_y = 0)
    {
        __UpdateBboxMatrix();
        return __bboxAABBTop + _y;
    }
    
    static get_right = function(_x = 0)
    {
        __UpdateBboxMatrix();
        return __bboxAABBRight + _x;
    }
    
    static get_bottom = function(_y = 0)
    {
        __UpdateBboxMatrix();
        return __bboxAABBBottom + _y;
    }
    
    static get_width = function()
    {
        __UpdateBboxMatrix();
        return __bboxRawWidth;
    }
    
    static get_height = function()
    {
        __UpdateBboxMatrix();
        return __bboxRawHeight;
    }
    
    /// @param x
    /// @param y
    static get_bbox = function(_x = 0, _y = 0)
    {
        __UpdateBboxMatrix();
        
        return {
            x: _x,
            y: _y,
            
            left:   _x + __bboxAABBLeft,
            top:    _y + __bboxAABBTop,
            right:  _x + __bboxAABBRight,
            bottom: _y + __bboxAABBBottom,
            
            width:  __bboxAABBWidth,
            height: __bboxAABBHeight,
            
            x0: _x + __bboxOOBx0,  y0: _y + __bboxOOBy0,
            x1: _x + __bboxOOBx1,  y1: _y + __bboxOOBy1,
            x2: _x + __bboxOOBx2,  y2: _y + __bboxOOBy2,
            x3: _x + __bboxOOBx3,  y3: _y + __bboxOOBy3
        };
    }
    
    #endregion
    
    
    
    #region Pages
    
    /// @param page
    static __SetPage = function(_page)
    {
        var _oldPage = __pageInteger;
        _page = clamp(_page, 0, __EnsureModel().__GetPageCount()-1);
        
        __pageInteger = round(_page);
        __pageFraction = _page - __pageInteger;
        
        if (_oldPage != __pageInteger)
        {
            __bboxDirty = true;
        }
        
        return self;
    }
    
    static get_page = function()
    {
        return __pageInteger + __pageFraction;
    }
    
    static get_pages = function()
    {
        __ScribbleError(".get_pages() has been replaced by .get_page_count()");
    }
    
    static get_page_count = function()
    {
        return __EnsureModel().__GetPageCount();
    }
    
    static on_last_page = function()
    {
        return (get_page() >= get_page_count()-1);
    }
    
    #endregion
    
    
    
    #region Reveal
    
    static reveal_mode = function(_state)
    {
        if (__revealMode != _state)
        {
            __revealMode = _state;
            __modelDirty = true;
        }
        
        return self;
    }
    
    static get_reveal_mode = function()
    {
        return __revealMode;
    }
    
    static get_reveal_count = function()
    {
        //FIXME - This value appears to be wrong when using section reveal
        var _pagesArray = __EnsureModel().__pagesArray;
        if (array_length(_pagesArray) <= 0) return 0;
        return array_last(_pagesArray).__revealEnd;
    }
    
    #endregion
    
    
    
    #region Other Getters
    
    static get_wrapped = function()
    {
        return __EnsureModel().__GetWrapped();
    }
    
    /// @param [page]
    static get_text = function(_page = __pageInteger)
    {
        return __EnsureModel().__GetText(_page);
    }
    
    /// @param [page]
    static get_line_data = function(_index, _page = __pageInteger)
    {
        return __EnsureModel().__GetLineData(_index, _page);
    }
    
    /// @param index
    /// @param [page]
    static get_glyph_data = function(_index, _page = __pageInteger)
    {
        return __EnsureModel().__GetGlyphData(_index, _page);
    }
    
    /// @param [page]
    static get_glyph_count = function(_page = __pageInteger)
    {
        return __EnsureModel().__GetGlyphCount(_page);
    }
    
    /// @param [page]
    static get_line_count = function(_page = __pageInteger)
    {
        return __EnsureModel().__GetLineCount(_page);
    }
    
    /// @param [page]
    static get_block_size = function(_integer = true)
    {
        return __EnsureModel().__GetLinesVisible(_integer);
    }
    
    #endregion
    
    
    
    #region Animation
    
    static set_animation_time = function(_time)
    {
        __animationTime = _time;
        
        return self;
    }
    
    static get_animation_time = function()
    {
        return __animationTime;
    }
    
    static animation_speed = function(_speed)
    {
        __animationSpeed = _speed;
        return self;
        
    }
    
    static get_animation_speed = function()
    {
        return __animationSpeed;
    }
    
    static is_animated = function()
    {
        return __EnsureModel().__hasAnimation;
    }
    
    #endregion
    
    
    
    #region Outline & Shadow
    
    static shadow = function(_color, _alpha)
    {
        __sdfShadowColor    = _color;
        __sdfShadowAlpha    = _alpha;
        __sdfShadowXOffset  = 0;
        __sdfShadowYOffset  = 0;
        __sdfShadowSoftness = 0;
        
        return self;
    }
    
    static outline = function(_color)
    {
        __sdfOutlineColor     = _color;
        __sdfOutlineThickness = 0;
        
        return self;
    }
    
    #endregion
    
    
    
    #region SDF
    
    static sdf_shadow = function(_color, _alpha, _xOffset, _yOffset, _softness = 0.25)
    {
        __sdfShadowColor    = _color;
        __sdfShadowAlpha    = _alpha;
        __sdfShadowXOffset  = _xOffset;
        __sdfShadowYOffset  = _yOffset;
        __sdfShadowSoftness = max(0, _softness);
        
        return self;
    }
    
    static sdf_outline = function(_color, _thickness)
    {
        __sdfOutlineColor     = _color;
        __sdfOutlineThickness = _thickness;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Cache Management
    
     /// @param freeze
    static build = function(_freeze)
    {
        var _model = __EnsureModel();
        
        if (_freeze)
        {
            _model.__Freeze();
        }
    }
    
    static refresh = function()
    {
        __modelDirty      = true;
        __matrixDirty     = true;
        __bboxDirty       = true;
        __scaleToBoxDirty = true;
        
        __EnsureModel();
        
        return self;
    }
    
    static flush = function()
    {
        //Unimplemented. Please see child constructors
    }
    
    #endregion
    
    
    
    #region Miscellaneous
    
    static preprocessor = function(_functionOrArray)
    {
        __preprocessorArray = variable_clone(_functionOrArray);
        __preprocessorArrayDirty = true;
        
        return self;
    }
    
    static preprocessor_before = function(_functionOrArray)
    {
        if (__preprocessorArray == undefined)
        {
            //If we don't have any preprocessor defined then presume we want to keep the default preprocessor around
            __preprocessorArray = variable_clone(__defaultPreprocessorFunc);
        }
        
        if (is_array(_functionOrArray))
        {
            //Add some dummy entries to the start
            repeat(array_length(_functionOrArray))
            {
                array_insert(__preprocessorArray, 0, undefined);
            }
            
            array_copy(__preprocessorArray, 0, _functionOrArray, 0, array_length(_functionOrArray));
        }
        else
        {
            array_insert(__preprocessorArray, 0, _functionOrArray);
        }
        
        __preprocessorArrayDirty = true;
        return self;
    }
    
    static preprocessor_after = function(_functionOrArray)
    {
        if (__preprocessorArray == undefined)
        {
            //If we don't have any preprocessor defined then presume we want to keep the default preprocessor around
            __preprocessorArray = variable_clone(__defaultPreprocessorFunc);
        }
        
        if (is_array(_functionOrArray))
        {
            array_copy(__preprocessorArray, array_length(__preprocessorArray), _functionOrArray, 0, array_length(_functionOrArray));
        }
        else
        {
            array_push(__preprocessorArray, _functionOrArray);
        }
        
        __preprocessorArrayDirty = true;
        return self;
    }
    
    static get_events = function(_revealIndex, _array = [])
    {
        //Copy events from the page
        var _eventsArray = __EnsureModel().__eventsDict[$ _revealIndex];
        if (is_array(_eventsArray))
        {
            array_copy(_array, array_length(_array), _eventsArray, 0, array_length(_eventsArray));
        }
        
        //Handle various typist features
        var _delay = 0;
        var _commandTag = undefined;
        
        if (__revealMode == SCRIBBLE_REVEAL_PER_CHAR)
        {
            if (__GetLinebreakAfterGlyph(_revealIndex))
            {
                _delay = max(_delay, __typistOptions.__lineDelay ?? infinity);
                _commandTag = __SCRIBBLE_EVENT_NEXT_LINE;
            }
            
            if (__GetBlockbreakAfterGlyph(_revealIndex))
            {
                _delay = max(_delay, __typistOptions.__blockDelay ?? infinity);
                _commandTag = __SCRIBBLE_EVENT_NEXT_BLOCK;
            }
            
            if (__GetPagebreakAfterGlyph(_revealIndex))
            {
                _delay = max(_delay, __typistOptions.__pageDelay ?? infinity);
                _commandTag = __SCRIBBLE_EVENT_NEXT_PAGE;
            }
        }
        else if (__revealMode == SCRIBBLE_REVEAL_PER_LINE)
        {
            _delay = __typistOptions.__lineDelay ?? infinity;
            _commandTag = __SCRIBBLE_EVENT_NEXT_LINE;
            
            if (__GetBlockbreakAfterLine(_revealIndex))
            {
                _delay = max(_delay, __typistOptions.__blockDelay ?? infinity);
                _commandTag = __SCRIBBLE_EVENT_NEXT_BLOCK;
            }
            
            if (__GetPagebreakAfterLine(_revealIndex))
            {
                _delay = max(_delay, __typistOptions.__pageDelay ?? infinity);
                _commandTag = __SCRIBBLE_EVENT_NEXT_PAGE;
            }
        }
        else
        {
            //FIXME - Implement `SCRIBBLE_REVEAL_PER_WORD` and section reveal
        }
        
        if (_delay > 0)
        {
            //Add a pause or delay if required
            if (is_infinity(_delay))
            {
                array_push(_array, new __ScribbleClassEvent(__SCRIBBLE_COMMAND_TAG_PAUSE, undefined));
            }
            else
            {
                array_push(_array, new __ScribbleClassEvent(__SCRIBBLE_EVENT_SYSTEM_DELAY, _delay));
            }
            
        }
        
        if (_commandTag != undefined)
        {
            //Add an instruction for the typist to move to the next block or page
            array_push(_array, new __ScribbleClassEvent(_commandTag, undefined));
        }
        
        return _array;
    }
    
    /// @param templateFunction/Array
    /// @param [executeOnlyOnChange=true]
    static template = function(_template, _onChange = true)
    {
        if (is_array(_template))
        {
            if ((not _onChange) || (not is_array(__template)) || (not array_equals(__template, _template)))
            {
                if (_onChange)
                {
                    __template = array_create(array_length(_template));
                    array_copy(__template, 0, _template, 0, array_length(_template));
                }
                else
                {
                    __template = _template;
                }
                
                var _i = 0;
                repeat(array_length(_template))
                {
                    method(self, _template[_i])();
                    ++_i;
                }
            }
        }
        else
        {
            if (not _onChange || is_array(__template) || (__template != _template))
            {
                __template = _template;
                
                method(self, _template)();
            }
        }
        
        return self;
    }
    
    /// @param state
    static ignore_command_tags = function(_state)
    {
        if (__ignoreCommandTags != _state)
        {
            __modelDirty = true;
            __ignoreCommandTags = _state;
        }
        
        return self;
    }
    
    static randomize_animation = function(_state)
    {
        if (__randomizeAnimation != _state)
        {
            __modelDirty = true;
            __randomizeAnimation = _state;
        }
        
        return self;
    }
    
    static allow_text_getter = function()
    {
        if (not __allowTextGetter)
        {
            __modelDirty = true;
            __allowTextGetter = true;
        }
        
        return self;
    }
    
    static allow_glyph_data_getter = function()
    {
        if (not __allowGlyphDataGetter)
        {
            __modelDirty = true;
            __allowGlyphDataGetter = true;
        }
        
        return self;
    }
    
    static z = function(_z)
    {
        __z = _z;
        
        return self;
    }
    
    static get_z = function()
    {
        return __z;
    }
    
    /// @param string
    static overwrite = function(_text, _uniqueID = undefined)
    {
        //Unimplemented
    }
    
    static debug_draw_bbox = function(_x, _y)
    {
        //FIXME - Reimplement properly
        
        var _oldColour = draw_get_colour();
        draw_set_colour(c_red);
        
        switch(__startingHAlign)
        {
            case fa_left:                             break;
            case fa_center: _x -= __layoutMaxWidth/2; break;
            case fa_right:  _x -= __layoutMaxWidth;   break;
        }
        
        switch(__startingVAlign)
        {
            case fa_top:                               break;
            case fa_middle: _y -= __layoutMaxHeight/2; break;
            case fa_bottom: _y -= __layoutMaxHeight;   break;
        }
        
        draw_rectangle(_x, _y, _x + __layoutMaxWidth, _y + __layoutMaxHeight, true);
        draw_rectangle(_x+1, _y+1, _x-1 + __layoutMaxWidth, _y-1 + __layoutMaxHeight, true);
        
        draw_set_colour(_oldColour);
        
        return self;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __EnsureModel = function()
    {
        if (__preprocessorArrayDirty)
        {
            __preprocessorArrayDirty = false;
            
            if (is_array(__preprocessorArray) && is_array(__preprocessorBakedArray))
            {
                if (not array_equals(__preprocessorArray, __preprocessorBakedArray))
                {
                    __modelDirty = true;
                    __preprocessorBakedArray = variable_clone(__preprocessorArray);
                }
            }
            else if (__preprocessorArray != __preprocessorBakedArray)
            {
                __modelDirty = true;
                __preprocessorBakedArray = variable_clone(__preprocessorArray);
            }
        }
        
        if (__modelDirty)
        {
            __modelDirty      = false;
            __bboxDirty       = true;
            __scaleToBoxDirty = true; //The dimensions of the text element might change as a result of a model change
            
            var _model = __weakRef.__Refresh();
            
            var _newPageCount = _model.__GetPageCount();
            if (array_length(__scrollXArray) != _newPageCount)
            {
                array_resize(__scrollXArray, _newPageCount);
                array_resize(__scrollYArray, _newPageCount);
            }
            
            return _model;
        }
        else
        {
            return __weakRef.__model;
        }
    }
    
    static __SetStandardUniforms = function()
    {
        static _u_sCycle = shader_get_sampler_index(__shdScribble, "u_sCycle");
        
        static _u_fTime         = shader_get_uniform(__shdScribble, "u_fTime"        );
        static _u_vColourBlend  = shader_get_uniform(__shdScribble, "u_vColourBlend" );
        static _u_vGradient     = shader_get_uniform(__shdScribble, "u_vGradient"    );
        static _u_vSkew         = shader_get_uniform(__shdScribble, "u_vSkew"        );
        static _u_vFlash        = shader_get_uniform(__shdScribble, "u_vFlash"       );
        static _u_vRegionActive = shader_get_uniform(__shdScribble, "u_vRegionActive");
        static _u_vRegionColour = shader_get_uniform(__shdScribble, "u_vRegionColour");
        static _u_aDataFields   = shader_get_uniform(__shdScribble, "u_aDataFields"  );
        static _u_aBezier       = shader_get_uniform(__shdScribble, "u_aBezier"      );
        
        static _u_vShadowOffsetAndSoftness = shader_get_uniform(__shdScribble, "u_vShadowOffsetAndSoftness");
        static _u_vShadowColour            = shader_get_uniform(__shdScribble, "u_vShadowColour"           );
        static _u_vOutlineColour           = shader_get_uniform(__shdScribble, "u_vOutlineColour"          );
        static _u_fOutlineThickness        = shader_get_uniform(__shdScribble, "u_fOutlineThickness"       );
        
        static _scribbleState       = __ScribbleSystem().__state;
        static _animPropertiesArray = __ScribbleSystem().__animPropertiesArray;
        
        static _shaderUniformsDirty    = true;
        static _shaderSetToUseBezier   = false;
        static _shaderUniformsDisabled = (function()
        {
            var _array = array_create(__SCRIBBLE_ANIM_SIZE, 0);
            _array[__SCRIBBLE_ANIM_JITTER_MINIMUM] = 1;
            _array[__SCRIBBLE_ANIM_JITTER_MAXIMUM] = 1;
            return _array;
        })();
        
        if (__EnsureModel().__hasCycle)
        {
            var _texture = surface_get_texture(__ScribbleEnsureCycleSurface());
            texture_set_stage(_u_sCycle, _texture);
            gpu_set_tex_filter_ext(_u_sCycle, true);
            gpu_set_tex_repeat_ext(_u_sCycle, true);
        }
        
        shader_set_uniform_f(_u_fTime, __animationTime);
        
        //TODO - Optimise
        shader_set_uniform_f(_u_vColourBlend, colour_get_red(  __blendColor)/255,
                                              colour_get_green(__blendColor)/255,
                                              colour_get_blue( __blendColor)/255,
                                              __blendAlpha);
        
        if ((__gradientAlpha != 0) || (__skewX != 0) || (__skewY != 0) || (__flashAlpha != 0) || (__regionBlend != 0))
        {
            _shaderUniformsDirty = true;
            
            shader_set_uniform_f(_u_vGradient, colour_get_red(  __gradientColor)/255,
                                               colour_get_green(__gradientColor)/255,
                                               colour_get_blue( __gradientColor)/255,
                                               __gradientAlpha);
            
            shader_set_uniform_f(_u_vSkew, __skewX, __skewY);
            
            shader_set_uniform_f(_u_vFlash, colour_get_red(  __flashColor)/255,
                                            colour_get_green(__flashColor)/255,
                                            colour_get_blue( __flashColor)/255,
                                            __flashAlpha);
            
            //FIXME - Regions use reveal index
            shader_set_uniform_f(_u_vRegionActive, __regionGlyphStart, __regionGlyphEnd);
            
            shader_set_uniform_f(_u_vRegionColour, colour_get_red(  __regionColor)/255,
                                                   colour_get_green(__regionColor)/255,
                                                   colour_get_blue( __regionColor)/255,
                                                   __regionBlend);
        }
        else if (_shaderUniformsDirty)
        {
            _shaderUniformsDirty = false;
            
            shader_set_uniform_f(_u_vGradient, 0, 0, 0, 0);
            shader_set_uniform_f(_u_vSkew, 0, 0);
            shader_set_uniform_f(_u_vFlash, 0, 0, 0, 0);
            shader_set_uniform_f(_u_vRegionActive, 0, 0);
            shader_set_uniform_f(_u_vRegionColour, 0, 0, 0, 0);
        }
        
        //Update the animation properties for this shader if they've changed since the last time we drew an element
        if (_scribbleState.__shaderAnimDesync)
        {
            with(_scribbleState)
            {
                __shaderAnimDesync  = false;
                __shaderAnimDefault = __shaderAnimDesyncToDefault;
                shader_set_uniform_f_array(_u_aDataFields, __shaderAnimDisabled? _shaderUniformsDisabled : _animPropertiesArray);
            }
        }
        
        if (__bezierUsing)
        {
            //If we're using a Bezier curve for this element, push that value into the shader
            _shaderSetToUseBezier = true;
            shader_set_uniform_f_array(_u_aBezier, __bezierArray);
        }
        else if (_shaderSetToUseBezier)
        {
            //If we're *not* using a Bezier curve but we have a previous Bezier curve cached, reset the curve in the shader
            _shaderSetToUseBezier = false;
            
            static _null_array = array_create(6, 0);
            shader_set_uniform_f_array(_u_aBezier, _null_array);
        }
        
        shader_set_uniform_f(_u_vShadowOffsetAndSoftness, __sdfShadowXOffset, __sdfShadowYOffset, __sdfShadowSoftness);
        
        shader_set_uniform_f(_u_vShadowColour, colour_get_red(  __sdfShadowColor)/255,
                                               colour_get_green(__sdfShadowColor)/255,
                                               colour_get_blue( __sdfShadowColor)/255,
                                               __sdfShadowAlpha);
        
        shader_set_uniform_f(_u_vOutlineColour,colour_get_red(  __sdfOutlineColor)/255,
                                               colour_get_green(__sdfOutlineColor)/255,
                                               colour_get_blue( __sdfOutlineColor)/255);
        
        shader_set_uniform_f(_u_fOutlineThickness, __sdfOutlineThickness);
    }
    
    static __SetRevealUniforms = function(_revealIndex)
    {
        static _u_iTypewriterMethod         = shader_get_uniform(__shdScribble, "u_iTypewriterMethod"        );
        static _u_fTypewriterHeadArray      = shader_get_uniform(__shdScribble, "u_fTypewriterHeadArray"     );
        static _u_fTypewriterHeadLimitArray = shader_get_uniform(__shdScribble, "u_fTypewriterHeadLimitArray");
        static _u_fTypewriterSmoothness     = shader_get_uniform(__shdScribble, "u_fTypewriterSmoothness"    );
        static _u_vTypewriterStartPos       = shader_get_uniform(__shdScribble, "u_vTypewriterStartPos"      );
        static _u_vTypewriterStartScale     = shader_get_uniform(__shdScribble, "u_vTypewriterStartScale"    );
        static _u_fTypewriterStartRotation  = shader_get_uniform(__shdScribble, "u_fTypewriterStartRotation" );
        static _u_fTypewriterAlphaDuration  = shader_get_uniform(__shdScribble, "u_fTypewriterAlphaDuration" );
        static _u_vTypewriterOffsetRange    = shader_get_uniform(__shdScribble, "u_vTypewriterOffsetRange"   );
        
        static _revealHeadArray = array_create(3, 0);
        
        if (_revealIndex != undefined)
        {
            _revealHeadArray[@ 0] = _revealIndex;
            
            shader_set_uniform_i(_u_iTypewriterMethod,               SCRIBBLE_EASE_LINEAR);
            shader_set_uniform_f(_u_fTypewriterSmoothness,           0);
            shader_set_uniform_f(_u_vTypewriterStartPos,             0, 0);
            shader_set_uniform_f(_u_vTypewriterStartScale,           1, 1);
            shader_set_uniform_f(_u_fTypewriterStartRotation,        0);
            shader_set_uniform_f(_u_fTypewriterAlphaDuration,        1.0);
            shader_set_uniform_f(_u_vTypewriterOffsetRange,          0, 0, 0);
            shader_set_uniform_f_array(_u_fTypewriterHeadArray,      _revealHeadArray);
            shader_set_uniform_f_array(_u_fTypewriterHeadLimitArray, _revealHeadArray);
        }
        else
        {
            shader_set_uniform_i(_u_iTypewriterMethod, SCRIBBLE_EASE_NONE);
        }
    }
    
    static __UpdateScaleToBoxScale = function()
    {
        if (not __scaleToBoxDirty) return;
        __scaleToBoxDirty = false;
        
        var _model = __EnsureModel();
        
        var _xScale = 1.0;
        var _yScale = 1.0;
        if (__scaleToBoxWidth  > 0) _xScale = __scaleToBoxWidth  / (_model.__GetWidth()  + __paddingL + __paddingR);
        if (__scaleToBoxHeight > 0) _yScale = __scaleToBoxHeight / (_model.__GetHeight() + __paddingT + __paddingB);
        
        var _prevScaleToBoxScale = __scaleToBoxScale;
        __scaleToBoxScale = min(_xScale, _yScale);
        if (not __scaleToBoxMaximize) __scaleToBoxScale = min(1, __scaleToBoxScale);
        
        if (__scaleToBoxScale != _prevScaleToBoxScale)
        {
            __matrixDirty = true;
            __bboxDirty   = true;
        }
    }
    
    static __UpdateMatrix = function(_x, _y)
    {
        __UpdateScaleToBoxScale();
        
        if (__matrixDirty || (__matrixX != _x) || (__matrixY != _y))
        {
            var _model = __EnsureModel();
            
            __matrixDirty   = false;
            __matrixInverse = undefined;
            __matrixX       = _x;
            __matrixY       = _y;
            
            var _xOffset = -__originX;
            var _yOffset = -__originY;
            var _xScale  = __scaleToBoxScale*_model.__fitScale*__postXScale;
            var _yScale  = __scaleToBoxScale*_model.__fitScale*__postYScale;
            var _angle   = __postAngle;
            
            if (not _model.__padBboxL) _xOffset += __paddingL;
            if (not _model.__padBboxT) _yOffset += __paddingT;
            if (not _model.__padBboxR) _xOffset -= __paddingR;
            if (not _model.__padBboxB) _yOffset -= __paddingB;
            
            //Build a matrix to transform the text...
            var _matrix = __matrix;
            
            if ((_xScale == 1) && (_yScale == 1) && (_angle == 0))
            {
                _matrix[@  0] = 1;
                _matrix[@  1] = 0;
                _matrix[@  4] = 0;
                _matrix[@  5] = 1;
                _matrix[@ 12] = _xOffset + _x;
                _matrix[@ 13] = _yOffset + _y;
                _matrix[@ 14] = __z;
            }
            else
            {
                var  _sin = dsin(-__postAngle);
                var  _cos = dcos(-__postAngle);
                var _xSin = _xScale*_sin;
                var _xCos = _xScale*_cos;
                var _ySin = _yScale*_sin;
                var _yCos = _yScale*_cos;
                
                _matrix[@  0] =  _xCos;
                _matrix[@  1] =  _xSin;
                _matrix[@  4] = -_ySin;
                _matrix[@  5] =  _yCos;
                _matrix[@ 12] =  _x + (_xOffset*_xCos - _yOffset*_ySin);
                _matrix[@ 13] =  _y + (_xOffset*_xSin + _yOffset*_yCos);
                _matrix[@ 14] =  __z;
            }
        }
        
        return __matrix;
    }
    
    #endregion
    
    
    
    #region Line / Block / Page helper functions
    
    //Returns if there is a linebreak after the target glyph
    //Glyph indexes are 0-indexed for this function
    static __GetLinebreakAfterGlyph = function(_index)
    {
        if (__GetBlockbreakAfterGlyph(_index))
        {
            return true;
        }
        
        return (__GetGlyphLine(_index) < __GetGlyphLine(_index+1));
    }
    
    //Returns if there is a blockbreak after the target glyph
    //Glyph indexes are 0-indexed for this function
    static __GetBlockbreakAfterGlyph = function(_index)
    {
        if (__GetPagebreakAfterGlyph(_index))
        {
            return true;
        }
        
        return (__GetGlyphBlock(_index) < __GetGlyphBlock(_index+1));
    }
    
    //Returns if there is a pagebreak after the target glyph
    //Glyph indexes are 0-indexed for this function
    static __GetPagebreakAfterGlyph = function(_index)
    {
        return (__GetGlyphPage(_index) < __GetGlyphPage(_index+1));
    }
    
    //Returns if there is a blockbreak after the target glyph
    //Glyph indexes are 0-indexed for this function
    static __GetBlockbreakAfterLine = function(_index)
    {
        if (__GetPagebreakAfterLine(_index))
        {
            return true;
        }
        
        return (__GetLineBlock(_index) < __GetLineBlock(_index+1));
    }
    
    //Returns if there is a blockbreak after the target glyph
    //Glyph indexes are 0-indexed for this function
    static __GetPagebreakAfterLine = function(_index, _page = __pageInteger)
    {
        return (_index+1 >= __EnsureModel().__pagesArray[_page].__lineCount);
    }
    
    //Returns which page a particular glyph is on
    //Glyph indexes are 0-indexed for this function
    //Glyph indexes are global across pages and are 0-indexed
    static __GetGlyphPage = function(_index)
    {
        if (_index <= 0)
        {
            return 0;
        }
        
        _index = floor(_index);
        
        var _pageArray = __EnsureModel().__pagesArray;
        var _i = 0;
        repeat(array_length(_pageArray))
        {
            if (_index < _pageArray[_i].__glyphStart)
            {
                return _i-1;
            }
            
            ++_i;
        }
        
        return _i-1;
    }
    
    //Returns which page a particular reveal index is on
    //Reveal indexes are global across pages and are 0-indexed
    static __GetRevealPage = function(_index)
    {
        if (_index <= 0)
        {
            return 0;
        }
        
        _index = floor(_index);
        
        var _pageArray = __EnsureModel().__pagesArray;
        var _i = 0;
        repeat(array_length(_pageArray))
        {
            if (_index < _pageArray[_i].__revealStart)
            {
                return _i-1;
            }
            
            ++_i;
        }
        
        return _i-1;
    }
    
    //Returns which line a particular glyph is on on a page
    //Glyph indexes are 0-indexed for this function
    //Lines indexes are local per page and are 0-indexed
    static __GetGlyphLine = function(_index, _page = __pageInteger)
    {
        if (_index <= 0)
        {
            return 0;
        }
        
        _index = floor(_index);
        
        var _lineArray = __EnsureModel().__pagesArray[_page].__lineDataArray;
        var _i = 0;
        repeat(array_length(_lineArray))
        {
            if ((_index >= _lineArray[_i].glyphStart) && (_index <= _lineArray[_i].glyphEnd))
            {
                return _i;
            }
            
            ++_i;
        }
        
        return array_length(_lineArray)-1;
    }
    
    //Returns which block a particular glyph is in on a page
    //Glyph indexes are 0-indexed for this function
    //Block indexes are local per page and are 0-indexed
    static __GetGlyphBlock = function(_index)
    {
        return __GetLineBlock(__GetGlyphLine(_index));
    }
    
    //Returns which block a particular line is in on a page
    //Block indexes are local per page and are 0-indexed
    static __GetLineBlock = function(_index)
    {
        var _blockSize = get_block_size();
        if (_index < _blockSize)
        {
            return 0;
        }
        else
        {
            return 1 + ((_index - _blockSize) div (_blockSize - __blockTrim));
        }
    }
    
    //Returns the y position of a block locally to a page
    static __GetBlockY = function(_index)
    {
        return (_index*(get_block_size() - __blockTrim))*__EnsureModel().__lineHeight;
    }
    
    static __GetGlyphThisBlockGlyphEnd = function(_index, _page = __pageInteger)
    {
        return __GetBlockGlyphEnd(__GetLineBlock(__GetGlyphLine(_index, _page)), _page);
    }
    
    static __GetBlockGlyphEnd = function(_index, _page = __pageInteger)
    {
        var _blockSize = get_block_size();
        var _line = _blockSize-1 + max(0, _index)*(_blockSize - __blockTrim);
        
        var _pageStruct = __EnsureModel().__GetPage(_page);
        _line = clamp(_line, 0, _pageStruct.__lineEnd);
        
        return _pageStruct.__lineDataArray[_line].glyphEnd;
    }
    
    static __GetBlockLineEnd = function(_index, _page = __pageInteger)
    {
        var _blockSize = get_block_size();
        var _line = _blockSize-1 + max(0, _index)*(_blockSize - __blockTrim);
        return clamp(_line, 0, __EnsureModel().__GetPage(_page).__lineEnd);
    }
    
    /// @param x
    /// @param y
    /// @param revealIndex
    static __GetBboxRevealed = function(_x, _y, _revealIndex)
    {
        //Default to the entire bounding box
        if (_revealIndex == undefined)
        {
            return get_bbox(_x, _y);
        }
        
        var _model = __EnsureModel();
        var _bbox = _model.__GetBboxRevealed(__GetRevealPage(_revealIndex), _revealIndex, __paddingL, __paddingT, __paddingR, __paddingB);
        
        __UpdateBboxMatrix();
        var _xScale = __scaleToBoxScale*_model.__fitScale*__postXScale;
        var _yScale = __scaleToBoxScale*_model.__fitScale*__postYScale;
        
        if ((_xScale == 1) && (_yScale == 1) && (__postAngle == 0))
        {
            //Avoid using matrices if we can
            var _l = _x - __originX + _bbox.left;
            var _t = _y - __originY + _bbox.top;
            var _r = _x - __originX + _bbox.right;
            var _b = _y - __originY + _bbox.bottom;
                
            var _x0 = _l;   var _y0 = _t;
            var _x1 = _r;   var _y1 = _t;
            var _x2 = _l;   var _y2 = _b;
            var _x3 = _r;   var _y3 = _b;
        }
        else
        {
            var _l = _bbox.left;
            var _t = _bbox.top;
            var _r = _bbox.right;
            var _b = _bbox.bottom;
                
            var _vertex = matrix_transform_vertex(__bboxMatrix, _l, _t, 0); var _x0 = _x + _vertex[0]; var _y0 = _y + _vertex[1];
            var _vertex = matrix_transform_vertex(__bboxMatrix, _r, _t, 0); var _x1 = _x + _vertex[0]; var _y1 = _y + _vertex[1];
            var _vertex = matrix_transform_vertex(__bboxMatrix, _l, _b, 0); var _x2 = _x + _vertex[0]; var _y2 = _y + _vertex[1];
            var _vertex = matrix_transform_vertex(__bboxMatrix, _r, _b, 0); var _x3 = _x + _vertex[0]; var _y3 = _y + _vertex[1];
                
            var _l = min(_x0, _x1, _x2, _x3);
            var _t = min(_y0, _y1, _y2, _y3);
            var _r = max(_x0, _x1, _x2, _x3);
            var _b = max(_y0, _y1, _y2, _y3);
        }
        
        return {
            left:   _l,
            top:    _t,
            right:  _r,
            bottom: _b,
            
            width:  1 + _r - _l,
            height: 1 + _b - _t,
            
            x0: _x0,  y0: _y0,
            x1: _x1,  y1: _y1,
            x2: _x2,  y2: _y2,
            x3: _x3,  y3: _y3
        };
    }
    
    #endregion
}
