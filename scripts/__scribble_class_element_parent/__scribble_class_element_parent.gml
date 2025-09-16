// Feather disable all

/// @param text

function __scribble_class_element_parent(_text) constructor
{
    static _system = __scribble_system();
    
    
    
    __text = _text;
    
    __flushed = false;
    
    __modelDirty = true;
    __model = undefined;
    __lastDrawn = _system.__frames;
    
    
    
    //We define this for all text elements because it gets used in the model key builder
    __revealType = SCRIBBLE_DEFAULT_REVEAL_TYPE;
    __spritesDontScale = true;
    
    __preprocessorFunc = undefined;
    
    __starting_font   = _system.__state.__default_font;
    __starting_colour = __scribble_process_colour(SCRIBBLE_DEFAULT_COLOR);
    __starting_halign = SCRIBBLE_DEFAULT_HALIGN;
    __starting_valign = SCRIBBLE_DEFAULT_VALIGN;
    __blend_colour    = c_white;
    __blend_alpha     = 1.0;
    __skew_x          = 0;
    __skew_y          = 0;
    __gradient_colour = c_black;
    __gradient_alpha  = 0.0;
    __flash_colour    = c_white;
    __flash_alpha     = 0.0;
    
    __randomize_animation = false;
    __newline_delay       = 0; //Only relevant for unique text elements but needs to be available regardless
    
    __allow_text_getter       = SCRIBBLE_FORCE_TEXT_GETTER;
    __allow_glyph_data_getter = SCRIBBLE_FORCE_GLYPH_DATA_GETTER;
    
    __origin_x    = 0.0;
    __origin_y    = 0.0;
    
    __pre_scale   = 1.0;
    
    __post_xscale = 1.0;
    __post_yscale = 1.0;
    __post_angle  = 0.0;
    
    __matrix_dirty   = true;
    __matrix         = matrix_build_identity();
    __matrix_inverse = undefined;
    __matrix_x       = undefined;
    __matrix_y       = undefined;
    
    __layoutType         = SCRIBBLE_LAYOUT_NONE;
    __layoutMaxWidth     = infinity;
    __layoutMaxHeight    = infinity;
    __layoutForcePerChar = false;
    __wrap_no_pages      = false;
    __layoutMaxScale     = 1;
    
    __clip = false;
    
    __scrollX = 0;
    __scrollY = 0;
    __scrollWasClamped = true;
    __scrollSpeed = 0;
    __scrollPause = 0;
    __scrollAuto  = 0; //0 = off, 1 = x-axis, 2 = y-axis
    __scrollState = 0;
    __scrollPauseCounter = 0;
    
    __scale_to_box_dirty    = true;
    __scale_to_box_width    = 0;
    __scale_to_box_height   = 0;
    __scale_to_box_maximise = false;
    __scale_to_box_scale    = undefined;
    
    __line_height  = -1;
    __line_spacing = "100%";
    
    __visual_bboxes = SCRIBBLE_DEFAULT_VISUAL_BBOXES;
    
    __page = 0;
    __ignore_command_tags = false;
    __template = undefined;
    
    __bezier_array = array_create(6, 0.0);
    __bezier_using = false;
    
    __animation_time  = 0;
    __animation_speed = 1;
    
    __padding_l = 0;
    __padding_t = 0;
    __padding_r = 0;
    __padding_b = 0;
    
    __sdf_shadow_colour   = c_black;
    __sdf_shadow_alpha    = 0.0;
    __sdf_shadow_xoffset  = 0;
    __sdf_shadow_yoffset  = 0;
    __sdf_shadow_softness = 0;
    
    __sdf_outline_colour    = c_black;
    __sdf_outline_thickness = 0.0;
    
    __bidi_hint = undefined;
    
    __z = SCRIBBLE_DEFAULT_Z;
    
    __region_active      = undefined;
    __region_glyph_start = 0;
    __region_glyph_end   = 0;
    __region_colour      = c_black;
    __region_blend       = 0.0;
    
    
    
    __bbox_dirty       = true;
    __bbox_matrix      = matrix_build_identity();
    __bbox_raw_width   = 1;
    __bbox_raw_height  = 1;
    __bbox_aabb_left   = 0;
    __bbox_aabb_top    = 0;
    __bbox_aabb_right  = 0;
    __bbox_aabb_bottom = 0;
    __bbox_aabb_width  = 1;
    __bbox_aabb_height = 1;
    __bbox_obb_x0      = 0;
    __bbox_obb_y0      = 0;
    __bbox_obb_x1      = 0;
    __bbox_obb_y1      = 0;
    __bbox_obb_x2      = 0;
    __bbox_obb_y2      = 0;
    __bbox_obb_x3      = 0;
    __bbox_obb_y3      = 0;
    
    
    
    #region Basics
    
    /// @param font
    static font = function(_font)
    {
        if (is_string(_font))
        {
            var _font_name = _font;
        }
        else if (is_handle(_font))
        {
            if (asset_get_type(_font) == asset_font)
            {
                var _font_name = font_get_name(_font);
            }
            else if (asset_get_type(_font) == asset_sprite)
            {
                var _font_name = sprite_get_name(_font);
            }
            else
            {
                __scribble_error("You may only set a font using one of the following:\n- Font name as a string\n- Font handle\n- Sprite name as a string (if it has been used to create a spritefont)\n- Sprite handle (if it has been used to create a spritefont)");
            }
        }
        else if (_font == undefined)
        {
            return self;
        }
        else
        {
            __scribble_error("Fonts should be specified using their name as a string\nUse <undefined> to not set a new font");
        }
        
        if (_font_name != __starting_font)
        {
            __modelDirty = true;
            __starting_font = _font_name;
        }
        
        return self;
    }
    
    /// @param colour
    static color = function(_in_colour)
    {
        if (_in_colour != undefined)
        {
            var _colour = __scribble_process_colour(_in_colour);
            if ((_colour != undefined) && (_colour >= 0) && (_colour != __starting_colour))
            {
                __modelDirty = true;
                __starting_colour = _colour & 0xFFFFFF;
            }
        }
        
        return self;
    }
    
    /// @param colour
    static colour = color;
    
    /// @param halign
    /// @param valign
    static align = function(_halign = __starting_halign, _valign = __starting_valign)
    {
        if (_halign == "pin_left"  ) _halign = __SCRIBBLE_PIN_LEFT;
        if (_halign == "pin_centre") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_center") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_right" ) _halign = __SCRIBBLE_PIN_RIGHT;
        if (_valign == "pin_top"   ) _valign = __SCRIBBLE_PIN_TOP;
        if (_valign == "pin_middle") _valign = __SCRIBBLE_PIN_MIDDLE;
        if (_valign == "pin_bottom") _valign = __SCRIBBLE_PIN_BOTTOM;
        if (_halign == "fa_justify") _halign = __SCRIBBLE_FA_JUSTIFY;
        
        if (_halign != __starting_halign)
        {
            __modelDirty = true;
            __bbox_dirty             = true;
            
            __starting_halign = _halign;
        }
        
        if (_valign != __starting_valign)
        {
            __modelDirty = true;
            __bbox_dirty             = true;
            
            __starting_valign = _valign;
        }
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static blend = function(_colour, _alpha)
    {
        _colour = __scribble_process_colour(_colour);
        
        if (_colour != undefined) __blend_colour = _colour & 0xFFFFFF;
        if (_alpha  != undefined) __blend_alpha  = clamp(_alpha, 0, 1);
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static gradient = function(_colour, _alpha)
    {
        _colour = __scribble_process_colour(_colour);
        
        __gradient_colour = _colour & 0xFFFFFF;
        __gradient_alpha  = _alpha;
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static flash = function(_colour, _alpha)
    {
        _colour = __scribble_process_colour(_colour);
        
        __flash_colour = _colour & 0xFFFFFF;
        __flash_alpha  = _alpha;
        
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
                __scale_to_box_dirty = true;
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
            __modelDirty        = true;
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
    
    static layout_page = function(_forcePerChar = false)
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
    
    static scroll_auto_x = function(_speed = SCRIBBLE_DEFAULT_AUTOSCROLL_SPEED, _pauseTime = SCRIBBLE_DEFAULT_AUTOSCROLL_PAUSE_TIME)
    {
        //Skip the pause if we're starting autoscroll
        if (__scrollAuto == 0)
        {
            if (__scrollState == 1)
            {
                __scrollState = 2;
            }
            else if (__scrollState == 3)
            {
                __scrollState = 0;
            }
        }
        
        __scrollAuto = 1;
        
        __scrollSpeed = _speed;
        __scrollPause = _pauseTime;
        
        return self;
    }
    
    static scroll_auto_y = function(_speed = SCRIBBLE_DEFAULT_AUTOSCROLL_SPEED, _pauseTime = SCRIBBLE_DEFAULT_AUTOSCROLL_PAUSE_TIME)
    {
        //Skip the pause if we're starting autoscroll
        if (__scrollAuto == 0)
        {
            if (__scrollState == 1)
            {
                __scrollState = 2;
            }
            else if (__scrollState == 3)
            {
                __scrollState = 0;
            }
        }
        
        __scrollAuto = 2;
        
        __scrollSpeed = _speed;
        __scrollPause = _pauseTime;
        
        return self;
    }
    
    static scroll_to_glyph_x = function(_index)
    {
        var _model = __EnsureModel();
        if (not is_struct(_model)) return undefined;
        
        if (not _model.__allow_glyph_data_getter)
        {
            __scribble_error("Scrolling to a glyph's x position requires either:\n- Call `.allow_glyph_data_getter()` on the element\n- Set `SCRIBBLE_FORCE_GLYPH_DATA_GETTER` to `true`");
        }
        
        var _glyphData = _model.__get_glyph_data(_index, __page);
        return scroll_to_x(_glyphData.left, _glyphData.right);
    }
    
    static scroll_to_glyph_y = function(_index)
    {
        var _model = __EnsureModel();
        if (not is_struct(_model)) return undefined;
        
        if (_model.__allow_glyph_data_getter)
        {
            var _glyphData = _model.__get_glyph_data(_index, __page);
            return scroll_to_y(_glyphData.top, _glyphData.bottom);
        }
        else
        {
            var _lineArray = _model.__pages_array[__page].__line_data_array;
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
        if (not is_struct(_model)) return undefined;
        var _line_data = _model.__get_line_data(_index, __page);
        return scroll_to_y(_line_data.y, _line_data.y + _line_data.height-1);
    }
    
    static scroll_to_x = function(_min, _max)
    {
        if (1 + _max - _min > __layoutMaxWidth)
        {
            //Line is bigger than can be displayed, centre the line
            __scrollX = clamp(((_min + _max) div 2) - (__layoutMaxWidth div 2), 0, get_scroll_max_x());
        }
        else if (_min < __scrollX)
        {
            //Line is above the top of the region
            __scrollX = clamp(_min, 0, get_scroll_max_x());
        }
        else if (_max >= __layoutMaxWidth + __scrollX)
        {
            //Line is below the bottom of the region
            __scrollX = clamp(_max - __layoutMaxWidth, 0, get_scroll_max_x());
        }
        else
        {
            //Line is visible, do nothing
        }
        
        return self;
    }
    
    static scroll_to_y = function(_min, _max)
    {
        if (1 + _max - _min > __layoutMaxHeight)
        {
            //Line is bigger than can be displayed, centre the line
            __scrollY = clamp(((_min + _max) div 2) - (__layoutMaxHeight div 2), 0, get_scroll_max_y());
        }
        else if (_min < __scrollY)
        {
            //Line is above the top of the region
            __scrollY = clamp(_min, 0, get_scroll_max_y());
        }
        else if (_max >= __layoutMaxHeight + __scrollY)
        {
            //Line is below the bottom of the region
            __scrollY = clamp(_max - __layoutMaxHeight, 0, get_scroll_max_y());
        }
        else
        {
            //Line is visible, do nothing
        }
        
        return self;
    }
    
    static scroll = function(_y, _clamp = true)
    {
        __scrollAuto = 0;
        
        __scrollY = _clamp? clamp(_y, 0, get_scroll_max_y()) : _y;
        __scrollWasClamped = _clamp;
        
        return self;
    }
    
    static scroll_ext = function(_x, _y, _clamp = true)
    {
        __scrollAuto = 0;
        
        __scrollX = _clamp? clamp(_x, 0, get_scroll_max_x()) : _x;
        __scrollY = _clamp? clamp(_y, 0, get_scroll_max_y()) : _y;
        __scrollWasClamped = _clamp;
        
        return self;
    }
    
    static get_scroll_x = function()
    {
        return __scrollX;
    }
    
    static get_scroll_y = function()
    {
        return __scrollY;
    }
    
    static get_scroll_max_x = function(_page = __page)
    {
        var _model = __EnsureModel();
        if (not is_struct(_model)) return 0;
        return _model.__GetScrollMaxX(_page);
    }
    
    static get_scroll_max_y = function(_page = __page)
    {
        var _model = __EnsureModel();
        if (not is_struct(_model)) return 0;
        return _model.__GetScrollMaxY(_page);
    }
    
    static __AutoScroll = function()
    {
        if (__scrollAuto == 1)
        {
            if (__scrollState == 0)
            {
                __scrollX += __scrollSpeed*_system.__tickSize;
                
                if (__scrollX >= get_scroll_max_x())
                {
                    __scrollX = get_scroll_max_x();
                    __scrollPauseCounter = 0;
                    __scrollState = 1;
                }
            }
            else if (__scrollState == 1)
            {
                __scrollPauseCounter += _system.__tickSize
                
                if (__scrollPauseCounter >= __scrollPause)
                {
                    __scrollState = 2;
                }
            }
            else if (__scrollState == 2)
            {
                __scrollX -= __scrollSpeed*_system.__tickSize;
                
                if (__scrollX <= 0)
                {
                    __scrollX = 0;
                    __scrollPauseCounter = 0;
                    __scrollState = 3;
                }
            }
            else if (__scrollState == 3)
            {
                __scrollPauseCounter += _system.__tickSize
                
                if (__scrollPauseCounter >= __scrollPause)
                {
                    __scrollState = 0;
                }
            }
        }
        else if (__scrollAuto == 2)
        {
            if (__scrollState == 0)
            {
                __scrollY += __scrollSpeed*_system.__tickSize;
                
                if (__scrollY >= get_scroll_max_y())
                {
                    __scrollY = get_scroll_max_y();
                    __scrollPauseCounter = 0;
                    __scrollState = 1;
                }
            }
            else if (__scrollState == 1)
            {
                __scrollPauseCounter += _system.__tickSize
                
                if (__scrollPauseCounter >= __scrollPause)
                {
                    __scrollState = 2;
                }
            }
            else if (__scrollState == 2)
            {
                __scrollY -= __scrollSpeed*_system.__tickSize;
                
                if (__scrollY <= 0)
                {
                    __scrollY = 0;
                    __scrollPauseCounter = 0;
                    __scrollState = 3;
                }
            }
            else if (__scrollState == 3)
            {
                __scrollPauseCounter += _system.__tickSize
                
                if (__scrollPauseCounter >= __scrollPause)
                {
                    __scrollState = 0;
                }
            }
        }
    }
    
    #endregion
    
    
    
    #region Positioning
    
    /// @param xOffset
    /// @param yOffset
    static origin = function(_x, _y)
    {
        if ((__origin_x != _x) || (__origin_y != _y))
        {
            __matrix_dirty = true;
            __bbox_dirty   = true;
            
            __origin_x = _x;
            __origin_y = _y;
        }
        
        return self;
    }
    
    /// @param xScale
    /// @param [yScale=xScale]
    /// @param [angle=0]
    static transform = function(_xscale, _yscale = _xscale, _angle = 0)
    {
        if ((__post_xscale != _xscale) || (__post_yscale != _yscale) || (__post_angle != _angle))
        {
            __matrix_dirty = true;
            __bbox_dirty   = true;
            
            __post_xscale = _xscale;
            __post_yscale = _yscale;
            __post_angle  = _angle;
        }
        
        return self;
    }
    
    /// @param scale
    /// @param [spritesDontScale=false]
    static scale = function(_scale, _spritesDontScale = false)
    {
        if ((__pre_scale != _scale)
        ||  (__spritesDontScale != _spritesDontScale))
        {
            __modelDirty = true;
            __bbox_dirty             = true;
            
            __pre_scale = _scale;
            __spritesDontScale = _spritesDontScale;
        }
        
        return self;
    }
    
    static skew = function(_skew_x, _skew_y)
    {
        __skew_x = _skew_x;
        __skew_y = _skew_y;
        
        return self;
    }
    
    /// @param height
    static line_height = function(_height)
    {
        if (_height != __line_height)
        {
            __modelDirty = true;
            __line_height = _height;
        }
        
        return self;
    }
    
    /// @param spacing
    static line_spacing = function(_spacing)
    {
        if (_spacing != __line_spacing)
        {
            __modelDirty = true;
            __line_spacing = _spacing;
        }
        
        return self;
    }
    
    /// @param left
    /// @param top
    /// @param right
    /// @param bottom
    static padding = function(_l, _t, _r, _b)
    {
        if ((_l != __padding_l) || (_t != __padding_t) || (_r != __padding_r) || (_b != __padding_b))
        {
            __modelDirty = true;
            __matrix_dirty           = true;
            __bbox_dirty             = true;
            __scale_to_box_dirty     = true;
            
            __padding_l = _l;
            __padding_t = _t;
            __padding_r = _r;
            __padding_b = _b;
        }
        
        return self;
    }
    
    /// @param state
    static visual_bboxes = function(_state)
    {
        if (__visual_bboxes != _state)
        {
            __modelDirty = true;
            __matrix_dirty           = true;
            __bbox_dirty             = true;
            __scale_to_box_dirty     = true;
            
            __visual_bboxes = _state;
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
            var _bezier_array = array_create(6, 0.0);
        }
        else if (argument_count == 8)
        {
            if (!is_numeric(_x1) || !is_numeric(_y1)
            ||  !is_numeric(_x2) || !is_numeric(_y2)
            ||  !is_numeric(_x3) || !is_numeric(_y3)
            ||  !is_numeric(_x4) || !is_numeric(_y4))
            {
                __scribble_trace("Warning! One or more Bezier parameters were not numeric (", _x1, ", ", _y1, ", ", _x2, ", ", _y2, ", ", _x3, ", ", _y3, ", ", _x4, ", ", _y4, ")");
                
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
            __scribble_error("Wrong number of arguments (", argument_count, ") provided\nExpecting 0 or 8");
        }
        
        var _bezier_array = [_x2 - _x1, _y2 - _y1,
                             _x3 - _x1, _y3 - _y1,
                             _x4 - _x1, _y4 - _y1];
        
        if (!array_equals(__bezier_array, _bezier_array))
        {
            __modelDirty = true;
            __bezier_array = _bezier_array;
            __bezier_using = true;
        }
        
        return self;
    }
    
    static right_to_left = function(_state)
    {
        if (_state == undefined)
        {
            var _new_bidi_hint = undefined;
        }
        else
        {
            var _new_bidi_hint = _state? __SCRIBBLE_BIDI_R2L : __SCRIBBLE_BIDI_L2R;
        }
        
        if (__bidi_hint != _new_bidi_hint)
        {
            __modelDirty = true;
            __bidi_hint = _new_bidi_hint;
        }
        
        return self;
    }
    
    #endregion
    
    
    
    #region Regions
    
    static region_detect = function(_element_x, _element_y, _pointer_x, _pointer_y)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return undefined;
        
        var _page         = _model.__pages_array[__page];
        var _region_array = _page.__region_array;
        
        var _matrix = __update_matrix(_model, _element_x, _element_y);
        
        if (__matrix_inverse == undefined)
        {
            __matrix_inverse = __scribble_matrix_inverse(matrix_multiply(_matrix, matrix_get(matrix_world)));
        }
        
        var _vector = matrix_transform_vertex(__matrix_inverse, _pointer_x, _pointer_y, 0);
        var _x = _vector[0];
        var _y = _vector[1];
        
        var _found = undefined;
        var _i = array_length(_region_array)-1;
        repeat(_i+1)
        {
            var _region = _region_array[_i];
            var _bbox_array = _region.bbox_array;
            
            var _j = 0;
            repeat(array_length(_bbox_array))
            {
                var _bbox = _bbox_array[_j];
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
    
    static region_set_active = function(_name, _colour, _blend_amount)
    {
        if (!is_string(_name))
        {
            __region_active      = undefined;
            __region_glyph_start = 0;
            __region_glyph_end   = 0;
            __region_colour      = c_black;
            __region_blend       = 0.0;
            return;
        }
        
        var _model = __EnsureModel();
        if (!is_struct(_model)) return undefined;
        
        var _page         = _model.__pages_array[__page];
        var _region_array = _page.__region_array;
        
        var _i = 0;
        repeat(array_length(_region_array))
        {
            var _region = _region_array[_i];
            if (_region.name == _name)
            {
                __region_active      = _name;
                __region_glyph_start = _region.start_glyph;
                __region_glyph_end   = _region.end_glyph;
                __region_colour      = _colour;
                __region_blend       = _blend_amount;
                return self;
            }
            
            ++_i;
        }
        
        __scribble_error("Region \"", _name, "\" not found");
    }
    
    static region_get_active = function()
    {
        return __region_active;
    }
    
    static region_clear = function()
    {
        region_set_active(undefined, undefined, undefined);
        return self;
    }
    
    static region_get_bboxes = function()
    {
        static _emptyArray = [];
        
        var _model = __EnsureModel();
        if (!is_struct(_model)) return _emptyArray;
        
        return _model.__pages_array[__page].__region_array;
    }
    
    static region_draw = function(_elementX, _elementY, _name, _padding = 0, _sprite = scribble_fallback_dot, _image = 0, _color = c_white, _alpha = 1)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return undefined;
        
        var _page         = _model.__pages_array[__page];
        var _region_array = _page.__region_array;
        
        var _i = 0;
        repeat(array_length(_region_array))
        {
            var _region = _region_array[_i];
            if (_region.name == _name)
            {
                var _old_matrix = matrix_get(matrix_world);
                var _matrix = matrix_multiply(__update_matrix(_model, _elementX, _elementY), _old_matrix);
                matrix_set(matrix_world, _matrix);
                
                //TODO - Make regions a class and move this code to a method?
                
                var _bbox_array = _region.bbox_array;
                var _j = 0;
                repeat(array_length(_bbox_array))
                {
                    var _bbox = _bbox_array[_j];
                    draw_sprite_stretched_ext(_sprite, _image,
                                              _bbox.x1 - _padding, _bbox.y1 - _padding,
                                              1 + _bbox.x2 - _bbox.x1 + 2*_padding, 1 + _bbox.y2 - _bbox.y1 + 2*_padding,
                                              _color, _alpha);
                    ++_j;
                }
                
                //Make sure we reset the world matrix
                matrix_set(matrix_world, _old_matrix);
                shader_reset();
                
                return self;
            }
            
            ++_i;
        }
        
        return self;
    }
    
    #endregion
    
    
    
    #region Dimensions
    
    static __update_bbox_matrix = function()
    {
        __update_scale_to_box_scale();
        
        if (__bbox_dirty)
        {
            __bbox_dirty = false;
            var _bbox_matrix = __bbox_matrix;
            
            var _model = __EnsureModel();
            if (!is_struct(_model))
            {
                _bbox_matrix[@  0] = 1;
                _bbox_matrix[@  1] = 0;
                _bbox_matrix[@  4] = 0;
                _bbox_matrix[@  5] = 1;
                _bbox_matrix[@ 12] = -__origin_x;
                _bbox_matrix[@ 13] = -__origin_y;
                
                __bbox_aabb_left   = 0;
                __bbox_aabb_top    = 0;
                __bbox_aabb_right  = 0;
                __bbox_aabb_bottom = 0;
                __bbox_obb_x0      = 0;
                __bbox_obb_y0      = 0;
                __bbox_obb_x1      = 0;
                __bbox_obb_y1      = 0;
                __bbox_obb_x2      = 0;
                __bbox_obb_y2      = 0;
                __bbox_obb_x3      = 0;
                __bbox_obb_y3      = 0;
                return;
            }
            
            var _xscale = __scale_to_box_scale*_model.__fitScale*__post_xscale;
            var _yscale = __scale_to_box_scale*_model.__fitScale*__post_yscale;
            
            //Left/top padding is baked into the model
            var _bbox = _model.__get_bbox(SCRIBBLE_BOUNDING_BOX_USES_PAGE? __page : undefined, __padding_l, __padding_t, __padding_r, __padding_b);
            
            __bbox_raw_width  = 1 + _bbox.right - _bbox.left;
            __bbox_raw_height = 1 + _bbox.bottom - _bbox.top;
            
            if ((_xscale == 1) && (_yscale == 1) && (__post_angle == 0))
            {
                _bbox_matrix[@  0] = 1;
                _bbox_matrix[@  1] = 0;
                _bbox_matrix[@  4] = 0;
                _bbox_matrix[@  5] = 1;
                _bbox_matrix[@ 12] = -__origin_x;
                _bbox_matrix[@ 13] = -__origin_y;
                
                //Avoid using matrices if we can
                __bbox_aabb_left   = -__origin_x + _bbox.left;
                __bbox_aabb_top    = -__origin_y + _bbox.top;
                __bbox_aabb_right  = -__origin_x + _bbox.right;
                __bbox_aabb_bottom = -__origin_y + _bbox.bottom;
                
                __bbox_obb_x0 = __bbox_aabb_left;   __bbox_obb_y0 = __bbox_aabb_top;
                __bbox_obb_x1 = __bbox_aabb_right;  __bbox_obb_y1 = __bbox_aabb_top;
                __bbox_obb_x2 = __bbox_aabb_left;   __bbox_obb_y2 = __bbox_aabb_bottom;
                __bbox_obb_x3 = __bbox_aabb_right;  __bbox_obb_y3 = __bbox_aabb_bottom;
            }
            else
            {
                var  _sin = dsin(-__post_angle);
                var  _cos = dcos(-__post_angle);
                var _xSin = _xscale*_sin;
                var _xCos = _xscale*_cos;
                var _ySin = _yscale*_sin;
                var _yCos = _yscale*_cos;
                
                _bbox_matrix[@  0] =  _xCos;
                _bbox_matrix[@  1] =  _xSin;
                _bbox_matrix[@  4] = -_ySin;
                _bbox_matrix[@  5] =  _yCos;
                _bbox_matrix[@ 12] = -(__origin_x*_xCos - __origin_y*_ySin);
                _bbox_matrix[@ 13] = -(__origin_x*_xSin + __origin_y*_yCos);
                
                var _l = _bbox.left;
                var _t = _bbox.top;
                var _r = _bbox.right;
                var _b = _bbox.bottom;
                
                var _vertex = matrix_transform_vertex(__bbox_matrix, _l, _t, 0); __bbox_obb_x0 = _vertex[0]; __bbox_obb_y0 = _vertex[1];
                var _vertex = matrix_transform_vertex(__bbox_matrix, _r, _t, 0); __bbox_obb_x1 = _vertex[0]; __bbox_obb_y1 = _vertex[1];
                var _vertex = matrix_transform_vertex(__bbox_matrix, _l, _b, 0); __bbox_obb_x2 = _vertex[0]; __bbox_obb_y2 = _vertex[1];
                var _vertex = matrix_transform_vertex(__bbox_matrix, _r, _b, 0); __bbox_obb_x3 = _vertex[0]; __bbox_obb_y3 = _vertex[1];
                
                __bbox_aabb_left   = min(__bbox_obb_x0, __bbox_obb_x1, __bbox_obb_x2, __bbox_obb_x3);
                __bbox_aabb_top    = min(__bbox_obb_y0, __bbox_obb_y1, __bbox_obb_y2, __bbox_obb_y3);
                __bbox_aabb_right  = max(__bbox_obb_x0, __bbox_obb_x1, __bbox_obb_x2, __bbox_obb_x3);
                __bbox_aabb_bottom = max(__bbox_obb_y0, __bbox_obb_y1, __bbox_obb_y2, __bbox_obb_y3);
            }
            
            __bbox_aabb_width  = 1 + __bbox_aabb_right - __bbox_aabb_left;
            __bbox_aabb_height = 1 + __bbox_aabb_bottom - __bbox_aabb_top;
        }
    }
    
    static get_left = function(_x = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_left + _x;
    }
    
    static get_top = function(_y = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_top + _y;
    }
    
    static get_right = function(_x = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_right + _x;
    }
    
    static get_bottom = function(_y = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_bottom + _y;
    }
    
    static get_width = function()
    {
        __update_bbox_matrix();
        return __bbox_raw_width;
    }
    
    static get_height = function()
    {
        __update_bbox_matrix();
        return __bbox_raw_height;
    }
    
    /// @param x
    /// @param y
    static get_bbox = function(_x = 0, _y = 0)
    {
        __update_bbox_matrix();
        
        return {
            x: _x,
            y: _y,
            
            left:   _x + __bbox_aabb_left,
            top:    _y + __bbox_aabb_top,
            right:  _x + __bbox_aabb_right,
            bottom: _y + __bbox_aabb_bottom,
            
            width:  __bbox_aabb_width,
            height: __bbox_aabb_height,
            
            x0: _x + __bbox_obb_x0,  y0: _y + __bbox_obb_y0,
            x1: _x + __bbox_obb_x1,  y1: _y + __bbox_obb_y1,
            x2: _x + __bbox_obb_x2,  y2: _y + __bbox_obb_y2,
            x3: _x + __bbox_obb_x3,  y3: _y + __bbox_obb_y3
        };
    }
    
    /// @param x
    /// @param y
    /// @param [revealIndex]
    static get_bbox_revealed = function(_x, _y, _revealIndex = undefined)
    {
        //Default to the entire bounding box
        if ((_revealIndex == undefined) && (not is_instanceof(self, __scribble_class_unique_element)))
        {
            return get_bbox(_x, _y);
        }
        
        var _model = __EnsureModel();
        if (not is_struct(_model))
        {
            //No extant model, return an empty bounding box
            return {
                left:   _x,
                top:    _y,
                right:  _x,
                bottom: _y,
                
                width:  1,
                height: 1,
                
                x0: _x,  y0: _y,
                x1: _x,  y1: _y,
                x2: _x,  y2: _y,
                x3: _x,  y3: _y
            };
        }
        
        if (_typist != undefined)
        {
            var _bbox = _model.__get_bbox_revealed(__page, 0, _revealIndex ?? __typistHeadArray[0], __padding_l, __padding_t, __padding_r, __padding_b);
        }
        else if (__tw_reveal != undefined)
        {
            var _bbox = _model.__get_bbox_revealed(__page, 0, __tw_reveal, __padding_l, __padding_t, __padding_r, __padding_b);
        }
        
        __update_bbox_matrix();
        var _xscale = __scale_to_box_scale*_model.__fitScale*__post_xscale;
        var _yscale = __scale_to_box_scale*_model.__fitScale*__post_yscale;
        
        if ((_xscale == 1) && (_yscale == 1) && (__post_angle == 0))
        {
            //Avoid using matrices if we can
            var _l = _x - __origin_x + _bbox.left;
            var _t = _y - __origin_y + _bbox.top;
            var _r = _x - __origin_x + _bbox.right;
            var _b = _y - __origin_y + _bbox.bottom;
                
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
                
            var _vertex = matrix_transform_vertex(__bbox_matrix, _l, _t, 0); var _x0 = _x + _vertex[0]; var _y0 = _y + _vertex[1];
            var _vertex = matrix_transform_vertex(__bbox_matrix, _r, _t, 0); var _x1 = _x + _vertex[0]; var _y1 = _y + _vertex[1];
            var _vertex = matrix_transform_vertex(__bbox_matrix, _l, _b, 0); var _x2 = _x + _vertex[0]; var _y2 = _y + _vertex[1];
            var _vertex = matrix_transform_vertex(__bbox_matrix, _r, _b, 0); var _x3 = _x + _vertex[0]; var _y3 = _y + _vertex[1];
                
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
    
    
    
    #region Pages
    
    /// @param page
    static __set_page = function(_page)
    {
        var _old_page = __page;
        
        var _model = __EnsureModel();
        if (is_struct(_model))
        {
            if (_page < 0)
            {
                __scribble_trace("Warning! Cannot set a text element's page to less than 0");
                __page = 0;
            }
            else if (_page > _model.__get_page_count()-1)
            {
                __page = _model.__get_page_count()-1;
                __scribble_trace("Warning! Page ", _page, " is too big. Valid pages are from 0 to ", __page, " (pages are 0-indexed)");
            }
            else
            {
                __page = _page;
            }
        }
        else
        {
            __page = 0;
        }
        
        if (_old_page != __page)
        {
            __bbox_dirty = true;
            
            //Update our scroll limits if the user wants to clamp position
            if (__scrollWasClamped)
            {
                __scrollX = clamp(__scrollX, 0, get_scroll_max_x());
                __scrollY = clamp(__scrollY, 0, get_scroll_max_y());
            }
        }
        
        return self;
    }
    
    static get_page = function()
    {
        return __page;
    }
    
    static get_pages = function()
    {
        __scribble_error(".get_pages() has been replaced by .get_page_count()");
    }
    
    static get_page_count = function()
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return 0;
        return _model.__get_page_count();
    }
    
    static on_last_page = function()
    {
        return (get_page() >= get_page_count() - 1);
    }
    
    #endregion
    
    
    
    #region Other Getters
    
    static get_wrapped = function()
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return false;
        return _model.__get_wrapped();
    }
    
    /// @param [page]
    static get_text = function(_page = __page)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return "";
        return _model.__get_text(_page);
    }
    
    /// @param [page]
    static get_line_data = function(_index, _page = __page)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return undefined;
        return _model.__get_line_data(_index, _page);
    }
    
    /// @param index
    /// @param [page]
    static get_glyph_data = function(_index, _page = __page)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return undefined;
        return _model.__get_glyph_data(_index, _page);
    }
    
    /// @param [page]
    static get_glyph_count = function(_page = __page)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return 0;
        return _model.__get_glyph_count(_page);
    }
    
    /// @param [page]
    static get_line_count = function(_page = __page)
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return 0;
        return _model.__get_line_count(_page);
    }
    
    /// @param [page]
    static get_lines_visible = function(_integer = true)
    {
        var _model = __EnsureModel();
        if (not is_struct(_model)) return 0;
        return _model.__get_lines_visible(_integer);
    }
    
    #endregion
    
    
    
    #region Animation
    
    static animation_tick_speed = function()
    {
        __scribble_error(".animation_tick_speed() has been replaced by .animation_speed()");
    }
    
    static set_animation_time = function(_time)
    {
        __animation_time = _time;
        return self;
    }
    
    static get_animation_time = function()
    {
        return __animation_time;
    }
    
    static animation_speed = function(_speed)
    {
        __animation_speed = _speed;
        return self;
    }
    
    static get_animation_speed = function()
    {
        return __animation_speed;
    }
    
    static is_animated = function()
    {
        var _model = __EnsureModel();
        if (!is_struct(_model)) return false;
        
        return _model.__has_animation;
    }
    
    #endregion
    
    
    
    #region Outline & Shadow
    
    static shadow = function(_colour, _alpha)
    {
        __sdf_shadow_colour   = _colour;
        __sdf_shadow_alpha    = _alpha;
        __sdf_shadow_xoffset  = 0;
        __sdf_shadow_yoffset  = 0;
        __sdf_shadow_softness = 0;
        
        return self;
    }
    
    static outline = function(_colour)
    {
        __sdf_outline_colour    = _colour;
        __sdf_outline_thickness = 0;
        
        return self;
    }
    
    #endregion
    
    
    
    #region SDF
    
    static sdf_shadow = function(_colour, _alpha, _x_offset, _y_offset, _softness = 0.25)
    {
        __sdf_shadow_colour   = _colour;
        __sdf_shadow_alpha    = _alpha;
        __sdf_shadow_xoffset  = _x_offset;
        __sdf_shadow_yoffset  = _y_offset;
        __sdf_shadow_softness = max(0, _softness);
        
        return self;
    }
    
    static sdf_outline = function(_colour, _thickness)
    {
        __sdf_outline_colour    = _colour;
        __sdf_outline_thickness = _thickness;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Cache Management
    
     /// @param freeze
    static build = function(_freeze)
    {
        var _model = __EnsureModel();
        if (_freeze && is_struct(_model))
        {
            _model.__Freeze();
        }
    }
    
    static refresh = function()
    {
        __modelDirty         = true;
        __matrix_dirty       = true;
        __bbox_dirty         = true;
        __scale_to_box_dirty = true;
        
        __EnsureModel();
        
        return self;
    }
    
    static flush = function()
    {
        //Unimplemented. Please see child constructors
    }
    
    #endregion
    
    
    
    #region Miscellaneous
    
    static preprocessor = function(_function)
    {
        if (_function != __preprocessorFunc)
        {
            if ((_function != undefined) && (not script_exists(_function)))
            {
                __scribble_error("Preprocessor functions must be stored in scripts in global scope");
            }
            
            __modelDirty = true;
            __preprocessorFunc = _function;
        }
        
        return self;
    }
    
    static get_events = function(_position, _page_index = __page)
    {
        static _empty_array = [];
        
        var _model = __EnsureModel();
        if (not is_struct(_model)) return _empty_array;
        
        var _page = _model.__pages_array[_page_index];
        var _event_struct = _page.__events_dict;
        
        var _events = _event_struct[$ _position];
        if (not is_array(_events)) return _empty_array;
        
        return _events;
    }
    
    /// @param templateFunction/Array
    /// @param [executeOnlyOnChange=true]
    static template = function(_template, _on_change = true)
    {
        if (is_array(_template))
        {
            if (!_on_change || !is_array(__template) || !array_equals(__template, _template))
            {
                if (_on_change)
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
            if (!_on_change || is_array(__template) || (__template != _template))
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
        if (__ignore_command_tags != _state)
        {
            __modelDirty = true;
            __ignore_command_tags = _state;
        }
        
        return self;
    }
    
    static randomize_animation = function(_state)
    {
        if (__randomize_animation != _state)
        {
            __modelDirty = true;
            __randomize_animation = _state;
        }
        
        return self;
    }
    
    static allow_text_getter = function()
    {
        if (not __allow_text_getter)
        {
            __modelDirty = true;
            __allow_text_getter = true;
        }
        
        return self;
    }
    
    static allow_glyph_data_getter = function()
    {
        if (not __allow_glyph_data_getter)
        {
            __modelDirty = true;
            __allow_glyph_data_getter = true;
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
        
        switch(__starting_halign)
        {
            case fa_left:                             break;
            case fa_center: _x -= __layoutMaxWidth/2; break;
            case fa_right:  _x -= __layoutMaxWidth;   break;
        }
        
        switch(__starting_valign)
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
        if (__modelDirty)
        {
            __modelDirty         = false;
            __bbox_dirty         = true;
            __scale_to_box_dirty = true; //The dimensions of the text element might change as a result of a model change
            
            var _model = __weakRef.__Refresh();
            
            //Update our scroll limits if the user wants to clamp position
            if (__scrollWasClamped)
            {
                __scrollX = clamp(__scrollX, 0, get_scroll_max_x());
                __scrollY = clamp(__scrollY, 0, get_scroll_max_y());
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
        static _u_sCycle = shader_get_sampler_index(__shd_scribble, "u_sCycle");
        
        static _u_fTime         = shader_get_uniform(__shd_scribble, "u_fTime"        );
        static _u_vColourBlend  = shader_get_uniform(__shd_scribble, "u_vColourBlend" );
        static _u_vGradient     = shader_get_uniform(__shd_scribble, "u_vGradient"    );
        static _u_vSkew         = shader_get_uniform(__shd_scribble, "u_vSkew"        );
        static _u_vFlash        = shader_get_uniform(__shd_scribble, "u_vFlash"       );
        static _u_vRegionActive = shader_get_uniform(__shd_scribble, "u_vRegionActive");
        static _u_vRegionColour = shader_get_uniform(__shd_scribble, "u_vRegionColour");
        static _u_aDataFields   = shader_get_uniform(__shd_scribble, "u_aDataFields"  );
        static _u_aBezier       = shader_get_uniform(__shd_scribble, "u_aBezier"      );
        static _u_vClip         = shader_get_uniform(__shd_scribble, "u_vClip"        );
        static _u_vScroll       = shader_get_uniform(__shd_scribble, "u_vScroll"      );
        
        static _u_vShadowOffsetAndSoftness = shader_get_uniform(__shd_scribble, "u_vShadowOffsetAndSoftness");
        static _u_vShadowColour            = shader_get_uniform(__shd_scribble, "u_vShadowColour"           );
        static _u_vOutlineColour           = shader_get_uniform(__shd_scribble, "u_vOutlineColour"          );
        static _u_fOutlineThickness        = shader_get_uniform(__shd_scribble, "u_fOutlineThickness"       );
        
        static _scribble_state        = __scribble_system().__state;
        static _anim_properties_array = __scribble_system().__anim_properties;
        
        static _shader_uniforms_dirty    = true;
        static _shader_set_to_use_bezier = false;
        static _shader_uniforms_disabled = (function()
        {
            var _array = array_create(__SCRIBBLE_ANIM_SIZE, 0);
            _array[__SCRIBBLE_ANIM_JITTER_MINIMUM] = 1;
            _array[__SCRIBBLE_ANIM_JITTER_MAXIMUM] = 1;
            return _array;
        })();
        
        if (__EnsureModel().__has_cycle)
        {
            var _texture = surface_get_texture(__scribble_ensure_cycle_surface());
            texture_set_stage(_u_sCycle, _texture);
            gpu_set_tex_filter_ext(_u_sCycle, true);
            gpu_set_tex_repeat_ext(_u_sCycle, true);
        }
        
        shader_set_uniform_f(_u_fTime, __animation_time);
        
        //TODO - Optimise
        shader_set_uniform_f(_u_vColourBlend, colour_get_red(  __blend_colour)/255,
                                              colour_get_green(__blend_colour)/255,
                                              colour_get_blue( __blend_colour)/255,
                                              __blend_alpha);
        
        if ((__gradient_alpha != 0) || (__skew_x != 0) || (__skew_y != 0) || (__flash_alpha != 0) || (__region_blend != 0))
        {
            _shader_uniforms_dirty = true;
            
            shader_set_uniform_f(_u_vGradient, colour_get_red(  __gradient_colour)/255,
                                               colour_get_green(__gradient_colour)/255,
                                               colour_get_blue( __gradient_colour)/255,
                                               __gradient_alpha);
            
            shader_set_uniform_f(_u_vSkew, __skew_x, __skew_y);
            
            shader_set_uniform_f(_u_vFlash, colour_get_red(  __flash_colour)/255,
                                            colour_get_green(__flash_colour)/255,
                                            colour_get_blue( __flash_colour)/255,
                                            __flash_alpha);
            
            //FIXME - Regions use reveal index
            shader_set_uniform_f(_u_vRegionActive, __region_glyph_start, __region_glyph_end);
            
            shader_set_uniform_f(_u_vRegionColour, colour_get_red(  __region_colour)/255,
                                                   colour_get_green(__region_colour)/255,
                                                   colour_get_blue( __region_colour)/255,
                                                   __region_blend);
        }
        else if (_shader_uniforms_dirty)
        {
            _shader_uniforms_dirty = false;
            
            shader_set_uniform_f(_u_vGradient, 0, 0, 0, 0);
            shader_set_uniform_f(_u_vSkew, 0, 0);
            shader_set_uniform_f(_u_vFlash, 0, 0, 0, 0);
            shader_set_uniform_f(_u_vRegionActive, 0, 0);
            shader_set_uniform_f(_u_vRegionColour, 0, 0, 0, 0);
        }
        
        //Update the animation properties for this shader if they've changed since the last time we drew an element
        if (_scribble_state.__shader_anim_desync)
        {
            with(_scribble_state)
            {
                __shader_anim_desync  = false;
                __shader_anim_default = __shader_anim_desync_to_default;
                shader_set_uniform_f_array(_u_aDataFields, __shader_anim_disabled? _shader_uniforms_disabled : _anim_properties_array);
            }
        }
        
        if (__clip)
        {
            //FIXME - Implement offsets for different h/v alignments
            shader_set_uniform_f(_u_vClip, 0, 0, __layoutMaxWidth, __layoutMaxHeight);
        }
        else
        {
            shader_set_uniform_f(_u_vClip, -999999, -999999, 999999, 999999);
        }
        
        shader_set_uniform_f(_u_vScroll, __scrollX, __scrollY);
        
        if (__bezier_using)
        {
            //If we're using a Bezier curve for this element, push that value into the shader
            _shader_set_to_use_bezier = true;
            shader_set_uniform_f_array(_u_aBezier, __bezier_array);
        }
        else if (_shader_set_to_use_bezier)
        {
            //If we're *not* using a Bezier curve but we have a previous Bezier curve cached, reset the curve in the shader
            _shader_set_to_use_bezier = false;
            
            static _null_array = array_create(6, 0);
            shader_set_uniform_f_array(_u_aBezier, _null_array);
        }
        
        shader_set_uniform_f(_u_vShadowOffsetAndSoftness, __sdf_shadow_xoffset, __sdf_shadow_yoffset, __sdf_shadow_softness);
        
        shader_set_uniform_f(_u_vShadowColour, colour_get_red(  __sdf_shadow_colour)/255,
                                               colour_get_green(__sdf_shadow_colour)/255,
                                               colour_get_blue( __sdf_shadow_colour)/255,
                                               __sdf_shadow_alpha);
        
        shader_set_uniform_f(_u_vOutlineColour,colour_get_red(  __sdf_outline_colour)/255,
                                               colour_get_green(__sdf_outline_colour)/255,
                                               colour_get_blue( __sdf_outline_colour)/255);
        
        shader_set_uniform_f(_u_fOutlineThickness, __sdf_outline_thickness);
    }
    
    static __SetRevealUniforms = function(_revealIndex)
    {
        static _u_iTypewriterMethod         = shader_get_uniform(__shd_scribble, "u_iTypewriterMethod"        );
        static _u_fTypewriterHeadArray      = shader_get_uniform(__shd_scribble, "u_fTypewriterHeadArray"     );
        static _u_fTypewriterHeadLimitArray = shader_get_uniform(__shd_scribble, "u_fTypewriterHeadLimitArray");
        static _u_fTypewriterSmoothness     = shader_get_uniform(__shd_scribble, "u_fTypewriterSmoothness"    );
        static _u_vTypewriterStartPos       = shader_get_uniform(__shd_scribble, "u_vTypewriterStartPos"      );
        static _u_vTypewriterStartScale     = shader_get_uniform(__shd_scribble, "u_vTypewriterStartScale"    );
        static _u_fTypewriterStartRotation  = shader_get_uniform(__shd_scribble, "u_fTypewriterStartRotation" );
        static _u_fTypewriterAlphaDuration  = shader_get_uniform(__shd_scribble, "u_fTypewriterAlphaDuration" );
        static _u_vTypewriterOffsetRange    = shader_get_uniform(__shd_scribble, "u_vTypewriterOffsetRange"   );
        
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
    
    static __update_scale_to_box_scale = function()
    {
        if (!__scale_to_box_dirty) return;
        __scale_to_box_dirty = false;
        
        var _model = __EnsureModel();
        if (!is_struct(_model)) return undefined;
        
        var _xscale = 1.0;
        var _yscale = 1.0;
        if (__scale_to_box_width  > 0) _xscale = __scale_to_box_width  / (_model.__get_width()  + __padding_l + __padding_r);
        if (__scale_to_box_height > 0) _yscale = __scale_to_box_height / (_model.__get_height() + __padding_t + __padding_b);
        
        var _previous_scale_to_box_scale = __scale_to_box_scale;
        __scale_to_box_scale = min(_xscale, _yscale);
        if (!__scale_to_box_maximise) __scale_to_box_scale = min(1, __scale_to_box_scale);
        
        if (__scale_to_box_scale != _previous_scale_to_box_scale)
        {
            __matrix_dirty = true;
            __bbox_dirty   = true;
        }
    }
    
    static __update_matrix = function(_model, _x, _y)
    {
        __update_scale_to_box_scale();
        
        if (__matrix_dirty || (__matrix_x != _x) || (__matrix_y != _y))
        {
            __matrix_dirty   = false;
            __matrix_inverse = undefined;
            __matrix_x       = _x;
            __matrix_y       = _y;
            
            var _x_offset = -__origin_x;
            var _y_offset = -__origin_y;
            var _xscale   = __scale_to_box_scale*_model.__fitScale*__post_xscale;
            var _yscale   = __scale_to_box_scale*_model.__fitScale*__post_yscale;
            var _angle    = __post_angle;
            
            if (!_model.__pad_bbox_l) _x_offset += __padding_l;
            if (!_model.__pad_bbox_t) _y_offset += __padding_t;
            if (!_model.__pad_bbox_r) _x_offset -= __padding_r;
            if (!_model.__pad_bbox_b) _y_offset -= __padding_b;
            
            //Build a matrix to transform the text...
            var _matrix = __matrix;
            
            if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
            {
                _matrix[@  0] = 1;
                _matrix[@  1] = 0;
                _matrix[@  4] = 0;
                _matrix[@  5] = 1;
                _matrix[@ 12] = _x_offset + _x;
                _matrix[@ 13] = _y_offset + _y;
                _matrix[@ 14] = __z;
            }
            else
            {
                var  _sin = dsin(-__post_angle);
                var  _cos = dcos(-__post_angle);
                var _xSin = _xscale*_sin;
                var _xCos = _xscale*_cos;
                var _ySin = _yscale*_sin;
                var _yCos = _yscale*_cos;
                
                _matrix[@  0] =  _xCos;
                _matrix[@  1] =  _xSin;
                _matrix[@  4] = -_ySin;
                _matrix[@  5] =  _yCos;
                _matrix[@ 12] =  _x + (_x_offset*_xCos - _y_offset*_ySin);
                _matrix[@ 13] =  _y + (_x_offset*_xSin + _y_offset*_yCos);
                _matrix[@ 14] =  __z;
            }
        }
        
        return __matrix;
    }
    
    #endregion
}
