// Feather disable all
/// @param string
/// @param uniqueID

function __scribble_class_element(_string, _unique_id) constructor
{
    static __scribble_state    = __scribble_initialize().__state;
    static __ecache_array      = __scribble_initialize().__cache_state.__ecache_array;
    static __ecache_dict       = __scribble_initialize().__cache_state.__ecache_dict;
    static __ecache_weak_array = __scribble_initialize().__cache_state.__ecache_weak_array;
    static __ecache_name_array = __scribble_initialize().__cache_state.__ecache_name_array;
    
    __text       = _string;
    __unique_id  = _unique_id;
    __cache_name = _string + ((_unique_id == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (":" + string(_unique_id)));
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching element \"" + __cache_name + "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = __ecache_dict[$ __cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
    {
        __scribble_trace("Warning! Flushing element \"", __cache_name, "\" due to cache name collision");
        _weak.ref.flush();
    }
    
    //Add this text element to the global cache
    __ecache_dict[$ __cache_name] = weak_ref_create(self);
    array_push(__ecache_array, self);
    array_push(__ecache_weak_array, weak_ref_create(self));
    array_push(__ecache_name_array, __cache_name);
    
    __flushed = false;
    
    __model_cache_name_dirty = true;
    __model_cache_name = undefined;
    __model = undefined;
    
    __last_drawn = __scribble_state.__frames;
    __freeze = false;
    
    
    
    __preprocessorFunc = undefined;
    
    __starting_font   = __scribble_state.__default_font;
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
    
    __origin_x       = 0.0;
    __origin_y       = 0.0;
    
    __pre_scale      = 1.0;
    
    __post_xscale    = 1.0;
    __post_yscale    = 1.0;
    __post_angle     = 0.0;
    
    __matrix_dirty   = true;
    __matrix         = undefined;
    __matrix_inverse = undefined;
    __matrix_x       = undefined;
    __matrix_y       = undefined;
    
    __wrap_apply      = false;
    __wrap_max_width  = -1;
    __wrap_max_height = -1;
    __wrap_per_char   = false;
    __wrap_no_pages   = false;
    __wrap_max_scale  = 1;
    
    __scale_to_box_dirty    = true;
    __scale_to_box_width    = 0;
    __scale_to_box_height   = 0;
    __scale_to_box_maximise = false;
    __scale_to_box_scale    = undefined;
    
    __line_height_min = -1;
    __line_height_max = -1;
    __line_spacing  = "100%";
    
    __page = 0;
    __ignore_command_tags = false;
    __template = undefined;
    
    __bezier_array = array_create(6, 0.0);
    __bezier_using = false;
    
    __tw_reveal              = undefined;
    __tw_reveal_window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, 0.0);
    
    __animation_time        = current_time;
    __animation_speed       = 1;
    __animation_blink_state = true;
    
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
    __bbox_matrix      = undefined;
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
    
    /// @param x
    /// @param y
    /// @param [typist]
    static draw = function(_x, _y, _typist = undefined)
    {
        static _scribble_state = __scribble_initialize().__state;
        
        var _function_scope = other;
        
        //Get our model, and create one if needed
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (__last_drawn < __scribble_state.__frames)
        {
            __animation_time += __animation_speed*SCRIBBLE_TICK_SIZE;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animation_time = __animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __last_drawn = __scribble_state.__frames;
        
        with(_scribble_state)
        {
            //Update the blink state
            if ((not __shader_anim_disabled) && __blink_on_duration + __blink_off_duration > 0)
            {
                other.__animation_blink_state = (((other.__animation_time + __blink_time_offset) mod (__blink_on_duration + __blink_off_duration)) < __blink_on_duration);
            }
            else
            {
                other.__animation_blink_state = true;
            }
        }
        
        shader_set(__shd_scribble);
        __set_standard_uniforms(_typist, _function_scope);
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__update_matrix(_model, _x, _y), _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__submit(__page, (__sdf_outline_thickness > 0) || (__sdf_shadow_alpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
        shader_reset();
        
        if (SCRIBBLE_SHOW_WRAP_BOUNDARY) debug_draw_bbox(_x, _y);
        
        if (SCRIBBLE_DRAW_RETURNS_SELF)
        {
            return self;
        }
        else
        {
            static _null = new __scribble_class_null_element();
            return _null;
        }
    }
    
    /// @param fontName
    /// @param colour
    static starting_format = function(_font_name, _in_colour)
    {
        if (is_string(_font_name))
        {
            if (_font_name != __starting_font)
            {
                __model_cache_name_dirty = true;
                __starting_font = _font_name;
            }
        }
        else if (!is_undefined(_font_name))
        {
            __scribble_error("Fonts should be specified using their name as a string\nUse <undefined> to not set a new font");
        }
        
        if (_in_colour != undefined)
        {
            var _colour = __scribble_process_colour(_in_colour);
            if ((_colour != undefined) && (_colour >= 0) && (_colour != __starting_colour))
            {
                __model_cache_name_dirty = true;
                __starting_colour = _colour & 0xFFFFFF;
            }
        }
        
        return self;
    }
    
    /// @param halign
    /// @param valign
    static align = function(_halign = __starting_halign, _valign = __starting_valign)
    {
        if (_halign == "pin_left"  ) _halign = __SCRIBBLE_PIN_LEFT;
        if (_halign == "pin_centre") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_center") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_right" ) _halign = __SCRIBBLE_PIN_RIGHT;
        if (_halign == "fa_justify") _halign = __SCRIBBLE_FA_JUSTIFY;
        
        if (_halign != __starting_halign)
        {
            __model_cache_name_dirty = true;
            __bbox_dirty             = true;
            
            __starting_halign = _halign;
        }
        
        if (_valign != __starting_valign)
        {
            __model_cache_name_dirty = true;
            __bbox_dirty             = true;
            
            __starting_valign = _valign;
        }
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static blend = function(_colour, _alpha)
    {
        static _colors_struct = __scribble_config_colours();
        
        if (is_string(_colour))
        {
            _colour = _colors_struct[$ _colour];
            if (_colour == undefined)
            {
                __scribble_error("Colour name \"", _colour, "\" not recognised");
                exit;
            }
        }
        
        if (_colour != undefined) __blend_colour = _colour & 0xFFFFFF;
        if (_alpha  != undefined) __blend_alpha  = _alpha;
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static gradient = function(_colour, _alpha)
    {
        static _colors_struct = __scribble_config_colours();
        
        if (is_string(_colour))
        {
            _colour = _colors_struct[$ _colour];
            if (_colour == undefined)
            {
                __scribble_error("Colour name \"", _colour, "\" not recognised");
                exit;
            }
        }
        
        __gradient_colour = _colour & 0xFFFFFF;
        __gradient_alpha  = _alpha;
        return self;
    }
    
    static fog = function()
    {
        __scribble_error(".fog() has been replaced by .flash()");
    }
    
    /// @param colour
    /// @param alpha
    static flash = function(_colour, _alpha)
    {
        static _colors_struct = __scribble_config_colours();
        
        if (is_string(_colour))
        {
            _colour = _colors_struct[$ _colour];
            if (_colour == undefined)
            {
                __scribble_error("Colour name \"", _colour, "\" not recognised");
                exit;
            }
        }
        
        __flash_colour = _colour & 0xFFFFFF;
        __flash_alpha  = _alpha;
        return self;
    }
    
    #endregion
    
    
    
    #region Layout
    
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
    static scale = function(_scale)
    {
        if (__pre_scale != _scale)
        {
            __model_cache_name_dirty = true;
            __bbox_dirty             = true;
            
            __pre_scale = _scale;
        }
        
        return self;
    }
    
    static skew = function(_skew_x, _skew_y)
    {
        __skew_x = _skew_x;
        __skew_y = _skew_y;
        
        return self;
    }
    
    /// @param maxWidth
    /// @param maxHeight
    /// @param [maximise=false]
    static scale_to_box = function(_max_width, _max_height, _maximise = false)
    {
        _max_width  = ((_max_width  == undefined) || (_max_width  < 0))? 0 : _max_width;
        _max_height = ((_max_height == undefined) || (_max_height < 0))? 0 : _max_height;
        
        if ((_max_width != __scale_to_box_width) || (_max_height != __scale_to_box_height) || (_maximise != __scale_to_box_maximise))
        {
            __scale_to_box_width    = _max_width;
            __scale_to_box_height   = _max_height;
            __scale_to_box_maximise = _maximise;
            __scale_to_box_dirty    = true;
        }
        
        return self;
    }
    
    /// @param maxWidth
    /// @param [maxHeight=-1]
    /// @param [characterWrap=false]
    static wrap = function(_wrap_max_width, _wrap_max_height = -1, _wrap_per_char = false)
    {
        if (!__wrap_apply
        ||  (_wrap_max_width  != __wrap_max_width)
        ||  (_wrap_max_height != __wrap_max_height)
        ||  (_wrap_per_char   != __wrap_per_char)
        ||  __wrap_no_pages
        ||  (__wrap_max_scale != 1))
        {
            __model_cache_name_dirty = true;
            __bbox_dirty             = true;
            __scale_to_box_dirty     = true;
            
            __wrap_apply      = ((_wrap_max_width >= 0) && !is_infinity(_wrap_max_width)); //Turn off wrapping logic if we have an invalid width
            __wrap_max_width  = _wrap_max_width;
            __wrap_max_height = _wrap_max_height;
            __wrap_per_char   = _wrap_per_char;
            __wrap_no_pages   = false;
            __wrap_max_scale  = 1;
        }
        
        return self;
    }
    
    /// @param maxWidth
    /// @param maxHeight
    /// @param [characterWrap=false]
    /// @param [maxScale=1]
    static fit_to_box = function(_wrap_max_width, _wrap_max_height, _wrap_per_char = false, _wrap_max_scale = 1)
    {
        if (!__wrap_apply
        ||  (_wrap_max_width  != __wrap_max_width)
        ||  (_wrap_max_height != __wrap_max_height)
        ||  (_wrap_per_char   != __wrap_per_char)
        ||  !__wrap_no_pages
        ||  (_wrap_max_scale  != __wrap_max_scale))
        {
            __model_cache_name_dirty = true;
            __matrix_dirty           = true; //By changing the .fit_to_box() properties we'll very likely change the __fit_scale variable used to shape text in the world matrix
            __bbox_dirty             = true;
            __scale_to_box_dirty     = true;
            
            __wrap_apply      = ((_wrap_max_width >= 0) && !is_infinity(_wrap_max_width)); //Turn off wrapping logic if we have an invalid width
            __wrap_max_width  = _wrap_max_width;
            __wrap_max_height = _wrap_max_height;
            __wrap_per_char   = _wrap_per_char;
            __wrap_no_pages   = true;
            __wrap_max_scale  = _wrap_max_scale;
        }
        
        return self;
    }
    
    static pin_guide_width = function(_width)
    {
        if (__wrap_apply
        ||  (__wrap_max_width != _width)
        ||  (__wrap_max_height != -1)
        ||  __wrap_per_char
        ||  __wrap_no_pages
        ||  (__wrap_max_scale != 1))
        {
            __model_cache_name_dirty = true;
            __bbox_dirty             = true;
            __scale_to_box_dirty     = true;
            
            __wrap_apply      = false; //Turn off wrapping entirely
            __wrap_max_width  = _width;
            __wrap_max_height = -1;
            __wrap_per_char   = false;
            __wrap_no_pages   = false;
            __wrap_max_scale  = 1;
        }
        
        return self;
    }
    
    /// @param min
    /// @param max
    static line_height = function(_min, _max)
    {
        if (_min != __line_height_min)
        {
            __model_cache_name_dirty = true;
            __line_height_min = _min;
        }
        
        if (_max != __line_height_max)
        {
            __model_cache_name_dirty = true;
            __line_height_max = _max;
        }
        
        return self;
    }
    
    /// @param spacing
    static line_spacing = function(_spacing)
    {
        if (_spacing != __line_spacing)
        {
            __model_cache_name_dirty = true;
            __line_spacing = _spacing;
        }
        
        return self;
    }
    
    static padding = function(_l, _t, _r, _b)
    {
        if ((_l != __padding_l) || (_t != __padding_t) || (_r != __padding_r) || (_b != __padding_b))
        {
            __model_cache_name_dirty = true;
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
            __model_cache_name_dirty = true;
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
            var _new_bidi_hint = _state? __SCRIBBLE_BIDI.R2L : __SCRIBBLE_BIDI.L2R;
        }
        
        if (__bidi_hint != _new_bidi_hint)
        {
            __model_cache_name_dirty = true;
            __bidi_hint = _new_bidi_hint;
        }
        
        return self;
    }
    
    #endregion
    
    
    
    #region Regions
    
    static region_detect = function(_element_x, _element_y, _pointer_x, _pointer_y)
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        var _page         = _model.__pages_array[__page];
        var _region_array = _page.__region_array;
        
        var _matrix = __update_matrix(_model, _element_x, _element_y);
        if (__matrix_inverse == undefined) __matrix_inverse = __scribble_matrix_inverse(matrix_multiply(_matrix, matrix_get(matrix_world)));
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
        
        var _model = __get_model(true);
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
                return;
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
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return _emptyArray;
        
        return _model.__pages_array[__page].__region_array;
    }
    
    #endregion
    
    
    
    #region Dimensions
    
    static __update_bbox_matrix = function()
    {
        __update_scale_to_box_scale();
        
        if (__bbox_dirty)
        {
            __bbox_dirty = false;
            
            var _model = __get_model(true);
            if (!is_struct(_model))
            {
                __bbox_matrix      = matrix_build(-__origin_x, -__origin_y, 0,    0,0,0,    1,1,1);
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
            
            var _xscale = __scale_to_box_scale*_model.__fit_scale*__post_xscale;
            var _yscale = __scale_to_box_scale*_model.__fit_scale*__post_yscale;
            
            //Left/top padding is baked into the model
            var _bbox = _model.__get_bbox(SCRIBBLE_BOUNDING_BOX_USES_PAGE? __page : undefined, __padding_l, __padding_t, __padding_r, __padding_b);
            
            __bbox_raw_width  = 1 + _bbox.right - _bbox.left;
            __bbox_raw_height = 1 + _bbox.bottom - _bbox.top;
            
            if ((_xscale == 1) && (_yscale == 1) && (__post_angle == 0))
            {
                __bbox_matrix = matrix_build(-__origin_x, -__origin_y, 0,    0,0,0,    1,1,1);
                
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
                //TODO - Optimize this
                __bbox_matrix = matrix_multiply(matrix_build(-__origin_x, -__origin_y, 0,    0, 0,       0,          1,       1, 1),
                                matrix_multiply(matrix_build(          0,           0, 0,    0, 0,       0,    _xscale, _yscale, 1),
                                                matrix_build(          0,           0, 0,    0, 0, __post_angle,          1,       1, 1)));
                
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
    /// @param [typist]
    static get_bbox_revealed = function(_x, _y, _typist)
    {
        //No typist set up, return the whole bounding box
        if ((_typist == undefined) && (__tw_reveal == undefined))
        {
            return get_bbox(_x, _y);
        }
        
        var _model = __get_model(true);
        if (!is_struct(_model))
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
            var _bbox = _model.__get_bbox_revealed(__page, 0, _typist.__window_array[_typist.__window_index], __padding_l, __padding_t, __padding_r, __padding_b);
        }
        else if (__tw_reveal != undefined)
        {
            var _bbox = _model.__get_bbox_revealed(__page, 0, __tw_reveal, __padding_l, __padding_t, __padding_r, __padding_b);
        }
        
        __update_bbox_matrix();
        var _xscale = __scale_to_box_scale*_model.__fit_scale*__post_xscale;
        var _yscale = __scale_to_box_scale*_model.__fit_scale*__post_yscale;
        
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
    static page = function(_page)
    {
        var _old_page = __page;
        
        var _model = __get_model(false);
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
        
        if (_old_page != __page) __bbox_dirty = true;
        
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
        var _model = __get_model(true);
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
        var _model = __get_model(true);
        if (!is_struct(_model)) return false;
        return _model.__get_wrapped();
    }
    
    /// @param [page]
    static get_text = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_text(_page);
    }
    
    /// @param [page]
    static get_glyph_data = function()
    {
        var _index = argument[0];
        var _page  = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_glyph_data(_index, _page);
    }
    
    /// @param [page]
    static get_glyph_count = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_glyph_count(_page);
    }
    
    /// @param [page]
    static get_line_count = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_line_count(_page);
    }
    
    #endregion
    
    
    
    #region Typewriter
    
    static pre_update_typist = function(_typist)
    {
        var _function_scope = other;
        
        if (is_struct(_typist))
        {
            with(_typist)
            {
                //Tick over the typist
                __tick(other, _function_scope);
            }
        }
        
        return self;
    }
    
    static reveal = function(_character)
    {
        if (__tw_reveal != _character)
        {
            __tw_reveal = _character;
            __tw_reveal_window_array[@ 0] = _character;
        }
        
        return self;
    }
    
    static get_reveal = function()
    {
        return __tw_reveal;
    }
    
    #endregion
    
    
    
    #region Animation
    
    static animation_tick_speed = function()
    {
        __scribble_error(".animation_tick_speed() has been replaced by .animation_speed()");
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
        var _model = __get_model(true);
        if (!is_struct(_model)) return false;
        
        return _model.__has_animation;
    }
    
    static animation_sync = function()
    {
        __scribble_error(".animation_sync() has been removed\nPlease get in touch if this feature is essential for your project");
    }
    
    static animation_wave = function()
    {
        __scribble_error(".animation_wave() has been replaced by scribble_anim_wave()");
    }
    
    static animation_shake = function()
    {
        __scribble_error(".animation_wave() has been replaced by scribble_anim_shake()");
    }
    
    static animation_rainbow = function()
    {
        __scribble_error(".animation_rainbow() has been replaced by scribble_anim_rainbow()");
    }
    
    static animation_wobble = function()
    {
        __scribble_error(".animation_wobble() has been replaced by scribble_anim_wobble()");
    }
    
    static animation_pulse = function()
    {
        __scribble_error(".animation_pulse() has been replaced by scribble_anim_pulse()");
    }
    
    static animation_wheel = function()
    {
        __scribble_error(".animation_wheel() has been replaced by scribble_anim_wheel()");
    }
    
    static animation_cycle = function()
    {
        __scribble_error(".animation_cycle() has been replaced by scribble_anim_cycle()");
    }
    
    static animation_jitter = function()
    {
        __scribble_error(".animation_jitter() has been replaced by scribble_anim_jitter()");
    }
    
    static animation_blink = function()
    {
        __scribble_error(".animation_blink() has been replaced by scribble_anim_blink()");
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
    
    //TODO - DEPRECATED, remove in v10
    static sdf_border = function(_colour, _thickness)
    {
        __sdf_outline_colour    = _colour;
        __sdf_outline_thickness = _thickness;
        
        return self;
    }
    
    static sdf_outline = function(_colour, _thickness)
    {
        __sdf_outline_colour    = _colour;
        __sdf_outline_thickness = _thickness;
        
        return self;
    }
    
    static msdf_shadow = function(_colour, _alpha, _x_offset, _y_offset, _softness = 0.25)
    {
        __scribble_error(".msdf_shadow(), and MSDF fonts as a whole, have been removed from Scribble\nInstead, please use GameMaker's native SDF fonts");
        return self;
    }
    
    static msdf_border = function(_colour, _thickness)
    {
        __scribble_error(".msdf_border(), and MSDF fonts as a whole, have been removed from Scribble\nInstead, please use GameMaker's native SDF fonts");
        return self;
    }
    
    static msdf_feather = function(_thickness)
    {
        __scribble_error(".msdf_feather(), and MSDF fonts as a whole, have been removed from Scribble\nInstead, please use GameMaker's native SDF fonts");
        return self;
    }
    
    #endregion
    
    
    
    #region Cache Management
    
     /// @param freeze
    static build = function(_freeze)
    {
        __freeze = _freeze;
        
        __get_model(true);
        
        if (SCRIBBLE_BUILD_RETURNS_SELF)
        {
            return self;
        }
        else
        {
            static _null = new __scribble_class_null_element();
            return _null;
        }
    }
    
    static refresh = function()
    {
        var _model = __get_model(false);
        if (_model != undefined)
        {
            _model.__flush();
            
            __model_cache_name_dirty = true;
            __matrix_dirty           = true;
            __bbox_dirty             = true;
            __scale_to_box_dirty     = true;
            
            __get_model(true);
        }
        
        return self;
    }
    
    static flush = function()
    {
        if (__flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing element \"" + string(__cache_name) + "\"");
        
        //Remove reference from cache
        variable_struct_remove(__ecache_dict, __cache_name);
        
        var _array = __ecache_array;
        var _i = 0;
        repeat(array_length(_array))
        {
            if (_array[_i] == self)
            {
                array_delete(_array, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        //Set as __flushed
        __flushed = true;
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
            
            __model_cache_name_dirty = true;
            __preprocessorFunc = _function;
        }
        
        return self;
    }
    
    static get_events = function(_position, _page_index = __page, _use_lines = false)
    {
        static _empty_array = [];
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return _empty_array;
        
        var _page = _model.__pages_array[_page_index];
        var _event_struct = _use_lines? _page.__line_events : _page.__char_events;
        
        var _events = _event_struct[$ _position];
        if (!is_array(_events)) return _empty_array;
        
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
            __model_cache_name_dirty = true;
            __ignore_command_tags = _state;
        }
        
        return self;
    }
    
    static randomize_animation = function(_state)
    {
        if (__randomize_animation != _state)
        {
            __model_cache_name_dirty = true;
            __randomize_animation = _state;
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
    /// @param [uniqueID]
    static overwrite = function(_text, _unique_id = __unique_id)
    {
        __text      = _text;
        __unique_id = _unique_id;
        
        var _new_cache_name = __text + ((_unique_id == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (":" + string(_unique_id)));
        if (__cache_name != _new_cache_name)
        {
            flush();
            __flushed = false;
            
            __model_cache_name_dirty = true;
            __cache_name = _new_cache_name;
            
            var _weak = __ecache_dict[$ __cache_name];
            if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
            {
                __scribble_trace("Warning! Flushing element \"", __cache_name, "\" due to cache name collision (try choosing a different unique ID)");
                _weak.ref.flush();
            }
            
            //Add this text element to the global cache
            __ecache_dict[$ __cache_name] = weak_ref_create(self);
            array_push(__ecache_array, self);
            array_push(__ecache_name_array, __cache_name);
        }
        
        return self;
    }
    
    static debug_draw_bbox = function(_x, _y)
    {
        //FIXME - Reimplement properly
        
        var _oldColour = draw_get_colour();
        draw_set_colour(c_red);
        
        switch(__starting_halign)
        {
            case fa_left:                             break;
            case fa_center: _x -= __wrap_max_width/2; break;
            case fa_right:  _x -= __wrap_max_width;   break;
        }
        
        switch(__starting_valign)
        {
            case fa_top:                               break;
            case fa_middle: _y -= __wrap_max_height/2; break;
            case fa_bottom: _y -= __wrap_max_height;   break;
        }
        
        draw_rectangle(_x, _y, _x + __wrap_max_width, _y + __wrap_max_height, true);
        draw_rectangle(_x+1, _y+1, _x-1 + __wrap_max_width, _y-1 + __wrap_max_height, true);
        
        draw_set_colour(_oldColour);
        
        return self;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __get_model = function(_allow_create)
    {
        static _mcache_dict = __scribble_initialize().__cache_state.__mcache_dict;
        
        if (__flushed || (__text == ""))
        {
            __model = undefined;
        }
        else
        {
            if (__model_cache_name_dirty)
            {
                __model_cache_name_dirty = false;
                __bbox_dirty             = true;
                __scale_to_box_dirty     = true; //The dimensions of the text element might change as a result of a model change
                
                static _buffer = __scribble_initialize().__buffer_a;
                buffer_seek(_buffer, buffer_seek_start, 0);
                buffer_write(_buffer, buffer_text, string(__text           ));     buffer_write(_buffer, buffer_u8,  0x3A); //colon
                buffer_write(_buffer, buffer_text, string(__starting_font  ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__starting_colour));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__starting_halign));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__starting_valign));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__pre_scale      ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__line_height_min));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__line_height_max));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__line_spacing   ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__wrap_apply     ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__wrap_max_width  - (__padding_l + __padding_r))); buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__wrap_max_height - (__padding_t + __padding_b))); buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__wrap_per_char  ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__wrap_no_pages  ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__wrap_max_scale ));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__bezier_array[0]));     buffer_write(_buffer, buffer_u8,  0x2C); //comma
                buffer_write(_buffer, buffer_text, string(__bezier_array[1]));     buffer_write(_buffer, buffer_u8,  0x2C);
                buffer_write(_buffer, buffer_text, string(__bezier_array[2]));     buffer_write(_buffer, buffer_u8,  0x2C);
                buffer_write(_buffer, buffer_text, string(__bezier_array[3]));     buffer_write(_buffer, buffer_u8,  0x2C);
                buffer_write(_buffer, buffer_text, string(__bezier_array[4]));     buffer_write(_buffer, buffer_u8,  0x2C);
                buffer_write(_buffer, buffer_text, string(__bezier_array[5]));     buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__bidi_hint));           buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__ignore_command_tags)); buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(__randomize_animation)); buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_text, string(ptr(__preprocessorFunc ?? pointer_null))); buffer_write(_buffer, buffer_u8,  0x3A);
                buffer_write(_buffer, buffer_u8, 0x00);
                buffer_seek(_buffer, buffer_seek_start, 0);
                
                __model_cache_name = buffer_read(_buffer, buffer_string);
            }
            
            var _weak = _mcache_dict[$ __model_cache_name];
            if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
            {
                __model = _weak.ref;
            }
            else if (_allow_create)
            {
                //Create a new model if required
                __model = new __scribble_class_model(self, __model_cache_name);
            }
            else
            {
                __model = undefined;
            }
        }
        
        return __model;
    }
    
    static __set_standard_uniforms = function(_typist, _function_scope)
    {
        static _u_fTime         = shader_get_uniform(__shd_scribble, "u_fTime"        );
        static _u_vColourBlend  = shader_get_uniform(__shd_scribble, "u_vColourBlend" );
        static _u_fBlinkState   = shader_get_uniform(__shd_scribble, "u_fBlinkState"  );
        static _u_vGradient     = shader_get_uniform(__shd_scribble, "u_vGradient"    );
        static _u_vSkew         = shader_get_uniform(__shd_scribble, "u_vSkew"        );
        static _u_vFlash        = shader_get_uniform(__shd_scribble, "u_vFlash"       );
        static _u_vRegionActive = shader_get_uniform(__shd_scribble, "u_vRegionActive");
        static _u_vRegionColour = shader_get_uniform(__shd_scribble, "u_vRegionColour");
        static _u_aDataFields   = shader_get_uniform(__shd_scribble, "u_aDataFields"  );
        static _u_aBezier       = shader_get_uniform(__shd_scribble, "u_aBezier"      );
        
        static _u_iTypewriterUseLines      = shader_get_uniform(__shd_scribble, "u_iTypewriterUseLines"     );
        static _u_iTypewriterMethod        = shader_get_uniform(__shd_scribble, "u_iTypewriterMethod"       );
        static _u_iTypewriterCharMax       = shader_get_uniform(__shd_scribble, "u_iTypewriterCharMax"      );
        static _u_fTypewriterWindowArray   = shader_get_uniform(__shd_scribble, "u_fTypewriterWindowArray"  );
        static _u_fTypewriterSmoothness    = shader_get_uniform(__shd_scribble, "u_fTypewriterSmoothness"   );
        static _u_vTypewriterStartPos      = shader_get_uniform(__shd_scribble, "u_vTypewriterStartPos"     );
        static _u_vTypewriterStartScale    = shader_get_uniform(__shd_scribble, "u_vTypewriterStartScale"   );
        static _u_fTypewriterStartRotation = shader_get_uniform(__shd_scribble, "u_fTypewriterStartRotation");
        static _u_fTypewriterAlphaDuration = shader_get_uniform(__shd_scribble, "u_fTypewriterAlphaDuration");
    
        static _u_vShadowOffsetAndSoftness = shader_get_uniform(__shd_scribble, "u_vShadowOffsetAndSoftness");
        static _u_vShadowColour            = shader_get_uniform(__shd_scribble, "u_vShadowColour"           );
        static _u_vOutlineColour            = shader_get_uniform(__shd_scribble, "u_vOutlineColour"         );
        static _u_fOutlineThickness         = shader_get_uniform(__shd_scribble, "u_fOutlineThickness"      );
        
        static _scribble_state        = __scribble_initialize().__state;
        static _anim_properties_array = __scribble_initialize().__anim_properties;
        
        static _shader_uniforms_dirty    = true;
        static _shader_set_to_use_bezier = false;
        static _shader_uniforms_disabled = (function()
        {
            var _array = array_create(__SCRIBBLE_ANIM.__SIZE, 0);
            _array[__SCRIBBLE_ANIM.__JITTER_MINIMUM] = 1;
            _array[__SCRIBBLE_ANIM.__JITTER_MAXIMUM] = 1;
            _array[__SCRIBBLE_ANIM.__CYCLE_VALUE   ] = 255;
            return _array;
        })();
        
        shader_set_uniform_f(_u_fTime, __animation_time);
        
        //TODO - Optimise
        shader_set_uniform_f(_u_vColourBlend, colour_get_red(  __blend_colour)/255,
                                              colour_get_green(__blend_colour)/255,
                                              colour_get_blue( __blend_colour)/255,
                                              __blend_alpha);
        
        shader_set_uniform_f(_u_fBlinkState, __animation_blink_state);
        
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
        
        if (_typist != undefined)
        {
            with(_typist)
            {
                //Tick over the typist
                __tick(other, _function_scope);
                    
                //Let the typist set the shader uniforms
                __set_shader_uniforms();
            }
        }
        else if (__tw_reveal != undefined)
        {
            shader_set_uniform_i(_u_iTypewriterUseLines,          0);
            shader_set_uniform_i(_u_iTypewriterMethod,            SCRIBBLE_EASE.LINEAR);
            shader_set_uniform_i(_u_iTypewriterCharMax,           0);
            shader_set_uniform_f(_u_fTypewriterSmoothness,        0);
            shader_set_uniform_f(_u_vTypewriterStartPos,          0, 0);
            shader_set_uniform_f(_u_vTypewriterStartScale,        1, 1);
            shader_set_uniform_f(_u_fTypewriterStartRotation,     0);
            shader_set_uniform_f(_u_fTypewriterAlphaDuration,     1.0);
            shader_set_uniform_f_array(_u_fTypewriterWindowArray, __tw_reveal_window_array);
        }
        else
        {
            shader_set_uniform_i(_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
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
    
    static __update_scale_to_box_scale = function()
    {
        if (!__scale_to_box_dirty) return;
        __scale_to_box_dirty = false;
        
        var _model = __get_model(true);
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
            var _xscale   = __scale_to_box_scale*_model.__fit_scale*__post_xscale;
            var _yscale   = __scale_to_box_scale*_model.__fit_scale*__post_yscale;
            var _angle    = __post_angle;
            
            if (!_model.__pad_bbox_l) _x_offset += __padding_l;
            if (!_model.__pad_bbox_t) _y_offset += __padding_t;
            if (!_model.__pad_bbox_r) _x_offset -= __padding_r;
            if (!_model.__pad_bbox_b) _y_offset -= __padding_b;
            
            //Build a matrix to transform the text...
            if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
            {
                //Faster than creating our own array
                __matrix = matrix_build(_x_offset + _x, _y_offset + _y, __z,   0,0,0,   1,1,1);
            }
            else
            {
                //FIXME - Re-optimise
                __matrix = matrix_multiply(matrix_build(_x_offset, _y_offset, 0,    0,0,0,          1,1,1),
                           matrix_multiply(matrix_build(0,0,0,                      0,0,0,          _xscale, _yscale, 1),
                           matrix_multiply(matrix_build(0,0,0,                      0,0,__post_angle,    1,1,1),
                                           matrix_build(_x, _y, __z,                0,0,0,          1,1,1))));
                
                //var _sin = dsin(_angle);
                //var _cos = dcos(_angle);
                //
                //var _m00 =  _xscale*_cos;
                //var _m10 = -_yscale*_sin;
                //var _m01 =  _xscale*_sin;
                //var _m11 =  _yscale*_cos;
                //
                //var _m03 = _x_offset*_m00 + _y_offset*_m10 + _x;
                //var _m13 = _x_offset*_m01 + _y_offset*_m11 + _y;
                //
                //__matrix = [_m00, _m10,   0, 0,
                //            _m01, _m11,   0, 0,
                //               0,    0,   1, 0,
                //            _m03, _m13, __z, 1];
            }
        }
        
        return __matrix;
    }
    
    #endregion
}
