/// @param string
/// @param uniqueID

function __scribble_class_element(_string, _unique_id) constructor
{
    __text       = _string;
    __unique_id  = _unique_id;
    __cache_name = _string + ":" + _unique_id;
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching element \"" + __cache_name + "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = global.__scribble_ecache_dict[$ __cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
    {
        __scribble_trace("Warning! Flushing element \"", __cache_name, "\" due to cache name collision");
        _weak.ref.flush();
    }
    
    //Add this text element to the global cache
    global.__scribble_ecache_dict[$ __cache_name] = weak_ref_create(self);
    array_push(global.__scribble_ecache_array, self);
    array_push(global.__scribble_ecache_name_array, __cache_name);
    
    __flushed = false;
    
    __model_cache_name_dirty = true;
    __model_cache_name = undefined;
    __model = undefined;
    
    __last_drawn = current_time;
    __freeze = false;
    
    
    
    __starting_font   = global.__scribble_default_font;
    __starting_colour = SCRIBBLE_DEFAULT_COLOR;
    __starting_halign = SCRIBBLE_DEFAULT_HALIGN;
    __starting_valign = SCRIBBLE_DEFAULT_VALIGN;
    __blend_colour    = c_white;
    __blend_alpha     = 1.0;
    
    __gradient_colour = c_black;
    __gradient_alpha  = 0.0;
    
    __origin_x       = 0.0;
    __origin_y       = 0.0;
    __xscale         = 1.0;
    __yscale         = 1.0;
    __angle          = 0.0;
    __matrix_dirty   = true;
    __matrix         = undefined;
    __matrix_inverse = undefined;
    __matrix_x       = undefined;
    __matrix_y       = undefined;
    
    __wrap_max_width  = -1;
    __wrap_max_height = -1;
    __wrap_per_char   = false;
    __wrap_no_pages   = false;
    __wrap_max_scale  = 1;
    
    __scale_to_box_max_width  = 0;
    __scale_to_box_max_height = 0;
    __scale_to_box_scale      = undefined;
    
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
    
    if (!SCRIBBLE_WARNING_LEGACY_TYPEWRITER)
    {
        //If we're permitting use of legacy typewriter functions, create a private typist for this specific text element
        __tw_legacy_typist = scribble_typist();
        __tw_legacy_typist.__associate(self);
        
        __tw_legacy_typist_use = false;
    }
    
    __animation_time         = current_time;
    __animation_tick_speed = 1;
    __animation_blink_state  = true;
    
    __padding_l = 0;
    __padding_t = 0;
    __padding_r = 0;
    __padding_b = 0;
    
    __msdf_shadow_colour   = c_black;
    __msdf_shadow_alpha    = 0.0;
    __msdf_shadow_xoffset  = 0;
    __msdf_shadow_yoffset  = 0;
    __msdf_shadow_softness = 0;
    
    __msdf_border_colour    = c_black;
    __msdf_border_thickness = 0.0;
    
    __msdf_feather_thickness = 1.0;
    
    __bidi_hint = undefined;
    
    __z = SCRIBBLE_DEFAULT_Z;
    
    __region_active      = undefined;
    __region_glyph_start = 0;
    __region_glyph_end   = 0;
    __region_colour      = c_black;
    __region_blend       = 0.0;
    
    
    
    #region Basics
    
    /// @param x
    /// @param y
    /// @param [typist]
    static draw = function(_x, _y, _typist = undefined)
    {
        var _function_scope = other;
        
        if (!SCRIBBLE_WARNING_LEGACY_TYPEWRITER)
        {
            if (__tw_legacy_typist_use && (_typist == undefined)) _typist = __tw_legacy_typist;
        }
        
        //Get our model, and create one if needed
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (current_time - __last_drawn > __SCRIBBLE_EXPECTED_FRAME_TIME)
        {
            __animation_time += __animation_tick_speed*SCRIBBLE_TICK_SIZE;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animation_time = __animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __last_drawn = current_time;
        
        //Update the blink state
        if (global.__scribble_anim_blink_on_duration + global.__scribble_anim_blink_off_duration > 0)
        {
            __animation_blink_state = (((__animation_time + global.__scribble_anim_blink_time_offset) mod (global.__scribble_anim_blink_on_duration + global.__scribble_anim_blink_off_duration)) < global.__scribble_anim_blink_on_duration);
        }
        else
        {
            __animation_blink_state = true;
        }
        
        #region Prepare shaders for drawing
        
        if (_model.__uses_standard_font)
        {
            shader_set(__shd_scribble);
            shader_set_uniform_f(global.__scribble_u_fTime, __animation_time);
            
            //TODO - Optimise
            shader_set_uniform_f(global.__scribble_u_vColourBlend, colour_get_red(  __blend_colour)/255,
                                                                   colour_get_green(__blend_colour)/255,
                                                                   colour_get_blue( __blend_colour)/255,
                                                                   __blend_alpha);
            
            shader_set_uniform_f(global.__scribble_u_vGradient, colour_get_red(  __gradient_colour)/255,
                                                                colour_get_green(__gradient_colour)/255,
                                                                colour_get_blue( __gradient_colour)/255,
                                                                __gradient_alpha);
            
            shader_set_uniform_f(global.__scribble_u_vRegionActive, __region_glyph_start, __region_glyph_end);
            
            shader_set_uniform_f(global.__scribble_u_vRegionColour, colour_get_red(  __region_colour)/255,
                                                                    colour_get_green(__region_colour)/255,
                                                                    colour_get_blue( __region_colour)/255,
                                                                    __region_blend);
            
            shader_set_uniform_f(global.__scribble_u_fBlinkState, __animation_blink_state);
            
            //Update the animation properties for this shader if they've changed since the last time we drew an element
            if (global.__scribble_anim_shader_desync)
            {
                global.__scribble_anim_shader_desync = false;
                global.__scribble_anim_shader_default = global.__scribble_anim_shader_desync_to_default;
                shader_set_uniform_f_array(global.__scribble_u_aDataFields, global.__scribble_anim_properties);
            }
            
            if (__bezier_using)
            {
                //If we're using a Bezier curve for this element, push that value into the shader
                global.__scribble_bezier_using = true;
                shader_set_uniform_f_array(global.__scribble_u_aBezier, __bezier_array);
            }
            else if (global.__scribble_bezier_using)
            {
                //If we're *not* using a Bezier curve but we have a previous Bezier curve cached, reset the curve in the shader
                global.__scribble_bezier_using = false;
                shader_set_uniform_f_array(global.__scribble_u_aBezier, global.__scribble_bezier_null_array);
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
                shader_set_uniform_i(global.__scribble_u_iTypewriterMethod,            SCRIBBLE_EASE.LINEAR);
                shader_set_uniform_i(global.__scribble_u_iTypewriterCharMax,           0);
                shader_set_uniform_f(global.__scribble_u_fTypewriterSmoothness,        0);
                shader_set_uniform_f(global.__scribble_u_vTypewriterStartPos,          0, 0);
                shader_set_uniform_f(global.__scribble_u_vTypewriterStartScale,        1, 1);
                shader_set_uniform_f(global.__scribble_u_fTypewriterStartRotation,     0);
                shader_set_uniform_f(global.__scribble_u_fTypewriterAlphaDuration,     1.0);
                shader_set_uniform_f_array(global.__scribble_u_fTypewriterWindowArray, __tw_reveal_window_array);
            }
            else
            {
                shader_set_uniform_i(global.__scribble_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
            }
            
            shader_reset();
        }
        
        if (_model.__uses_msdf_font)
        {
            shader_set(__shd_scribble_msdf);
            shader_set_uniform_f(global.__scribble_msdf_u_fTime, __animation_time);
            
            //TODO - Optimise
            shader_set_uniform_f(global.__scribble_msdf_u_vColourBlend, colour_get_red(  __blend_colour)/255,
                                                                        colour_get_green(__blend_colour)/255,
                                                                        colour_get_blue( __blend_colour)/255,
                                                                        __blend_alpha);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vGradient, colour_get_red(  __gradient_colour)/255,
                                                                     colour_get_green(__gradient_colour)/255,
                                                                     colour_get_blue( __gradient_colour)/255,
                                                                     __gradient_alpha);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vRegionActive, __region_glyph_start, __region_glyph_end);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vRegionColour, colour_get_red(  __region_colour)/255,
                                                                         colour_get_green(__region_colour)/255,
                                                                         colour_get_blue( __region_colour)/255,
                                                                         __region_blend);
            
            shader_set_uniform_f(global.__scribble_msdf_u_fBlinkState, __animation_blink_state);
            
            //Update the animation properties for this shader if they've changed since the last time we drew an element
            if (global.__scribble_anim_shader_msdf_desync)
            {
                global.__scribble_anim_shader_msdf_desync = false;
                global.__scribble_anim_shader_msdf_default = global.__scribble_anim_shader_msdf_desync_to_default;
                shader_set_uniform_f_array(global.__scribble_msdf_u_aDataFields, global.__scribble_anim_properties);
            }
            
            if (__bezier_using)
            {
                //If we're using a Bezier curve for this element, push that value into the shader
                global.__scribble_bezier_msdf_using = true;
                shader_set_uniform_f_array(global.__scribble_msdf_u_aBezier, __bezier_array);
            }
            else if (global.__scribble_bezier_msdf_using)
            {
                //If we're *not* using a Bezier curve but we have a previous Bezier curve cached, reset the curve in the shader
                global.__scribble_bezier_msdf_using = false;
                shader_set_uniform_f_array(global.__scribble_msdf_u_aBezier, global.__scribble_bezier_null_array);
            }
            
            if (_typist != undefined)
            {
                with(_typist)
                {
                    //Tick over the typist
                    __tick(other, _function_scope);
                    
                    //Let the typist set the shader uniforms
                    __set_msdf_shader_uniforms();
                }
            }
            else if (__tw_reveal != undefined)
            {
                shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod,            SCRIBBLE_EASE.LINEAR);
                shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterCharMax,           0);
                shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterSmoothness,        0);
                shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartPos,          0, 0);
                shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartScale,        1, 1);
                shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterStartRotation,     0);
                shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterAlphaDuration,     1.0);
                shader_set_uniform_f_array(global.__scribble_msdf_u_fTypewriterWindowArray, __tw_reveal_window_array);
            }
            else
            {
                shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
            }
            
            shader_set_uniform_f(global.__scribble_msdf_u_vShadowOffsetAndSoftness, __msdf_shadow_xoffset, __msdf_shadow_yoffset, __msdf_shadow_softness);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vShadowColour, colour_get_red(  __msdf_shadow_colour)/255,
                                                                         colour_get_green(__msdf_shadow_colour)/255,
                                                                         colour_get_blue( __msdf_shadow_colour)/255,
                                                                         __msdf_shadow_alpha);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vBorderColour, colour_get_red(  __msdf_border_colour)/255,
                                                                         colour_get_green(__msdf_border_colour)/255,
                                                                         colour_get_blue( __msdf_border_colour)/255);
            
            shader_set_uniform_f(global.__scribble_msdf_u_fBorderThickness, __msdf_border_thickness);
            
            var _surface = surface_get_target();
            if (_surface >= 0)
            {
                var _surface_width  = surface_get_width( _surface);
                var _surface_height = surface_get_height(_surface);
            }
            else
            {
                var _surface_width  = window_get_width();
                var _surface_height = window_get_height();
            }
            
            shader_set_uniform_f(global.__scribble_msdf_u_vOutputSize, _surface_width, _surface_height);
            
            shader_reset();
        }
        
        #endregion
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__update_matrix(_x, _y), _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__submit(__page, __msdf_feather_thickness, (__msdf_border_thickness > 0) || (__msdf_shadow_alpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
        
        //Run the garbage collecter
        __scribble_gc_collect();
        
        if (SCRIBBLE_SHOW_WRAP_BOUNDARY) debug_draw_bbox(_x, _y);
        
        return SCRIBBLE_DRAW_RETURNS_SELF? self : undefined;
    }
    
    /// @param fontName
    /// @param colour
    static starting_format = function(_font_name, _colour)
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
        
        if (_colour != undefined)
        {
            if (is_string(_colour))
            {
                _colour = global.__scribble_colours[? _colour];
                if (_colour == undefined)
                {
                    __scribble_error("Colour name \"", _colour, "\" not recognised");
                }
            }
        
            if ((_colour != undefined) && (_colour >= 0))
            {
                if (_colour != __starting_colour)
                {
                    __model_cache_name_dirty = true;
                    __starting_colour = _colour & 0xFFFFFF;
                }
            }
        }
        
        return self;
    }
    
    /// @param halign
    /// @param valign
    static align = function(_halign, _valign)
    {
        if (_halign == "pin_left"  ) _halign = __SCRIBBLE_PIN_LEFT;
        if (_halign == "pin_centre") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_center") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_right" ) _halign = __SCRIBBLE_PIN_RIGHT;
        if (_halign == "justify"   ) _halign = __SCRIBBLE_JUSTIFY;
        
        if (_halign != __starting_halign)
        {
            __model_cache_name_dirty = true;
            __starting_halign = _halign;
        }
        
        if (_valign != __starting_valign)
        {
            __model_cache_name_dirty = true;
            __starting_valign = _valign;
        }
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static blend = function(_colour, _alpha)
    {
        if (is_string(_colour))
        {
            _colour = global.__scribble_colours[? _colour];
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
        if (is_string(_colour))
        {
            _colour = global.__scribble_colours[? _colour];
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
    
    #endregion
    
    
    
    #region Layout
    
    /// @param xOffset
    /// @param yOffset
    static origin = function(_x, _y)
    {
        if ((__origin_x != _x) || (__origin_y != _y))
        {
            __matrix_dirty = true;
            
            __origin_x = _x;
            __origin_y = _y;
        }
        
        return self;
    }
    
    /// @param xScale
    /// @param yScale
    /// @param angle
    static transform = function(_xscale, _yscale, _angle)
    {
        if ((__xscale != _xscale) || (__yscale != _yscale) || (__angle != _angle))
        {
            __matrix_dirty = true;
            
            __xscale = _xscale;
            __yscale = _yscale;
            __angle  = _angle;
        }
        
        return self;
    }
    
    /// @param maxWidth
    /// @param maxHeight
    static scale_to_box = function(_max_width, _max_height)
    {
        __scale_to_box_max_width  = ((_max_width  == undefined) || (_max_width  < 0))? 0 : _max_width;
        __scale_to_box_max_height = ((_max_height == undefined) || (_max_height < 0))? 0 : _max_height;
        
        return self;
    }
    
    /// @param maxWidth
    /// @param [maxHeight=-1]
    /// @param [characterWrap=false]
    static wrap = function(_wrap_max_width, _wrap_max_height = -1, _wrap_per_char = false)
    {
        var _wrap_no_pages = false;
        var _wrap_max_scale = 1;
        
        if ((_wrap_max_width  != __wrap_max_width)
        ||  (_wrap_max_height != __wrap_max_height)
        ||  (_wrap_per_char   != __wrap_per_char)
        ||  (_wrap_no_pages   != __wrap_no_pages)
        ||  (_wrap_max_scale  != __wrap_max_scale))
        {
            __model_cache_name_dirty = true;
            __wrap_max_width  = _wrap_max_width;
            __wrap_max_height = _wrap_max_height;
            __wrap_per_char   = _wrap_per_char;
            __wrap_no_pages   = _wrap_no_pages;
            __wrap_max_scale  = _wrap_max_scale;
        }
        
        return self;
    }
    
    /// @param maxWidth
    /// @param maxHeight
    /// @param [characterWrap=false]
    /// @param [maxScale=1]
    static fit_to_box = function(_wrap_max_width, _wrap_max_height, _wrap_per_char = false, _wrap_max_scale = 1)
    {
        var _wrap_no_pages = true;
        
        if ((_wrap_max_width  != __wrap_max_width)
        ||  (_wrap_max_height != __wrap_max_height)
        ||  (_wrap_per_char   != __wrap_per_char)
        ||  (_wrap_no_pages   != __wrap_no_pages))
        {
            __model_cache_name_dirty = true;
            __wrap_max_width  = _wrap_max_width;
            __wrap_max_height = _wrap_max_height;
            __wrap_per_char   = _wrap_per_char;
            __wrap_no_pages   = _wrap_no_pages;
            __wrap_max_scale  = _wrap_max_scale;
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
        var _model        = __get_model(true);
        var _page         = _model.__pages_array[__page];
        var _region_array = _page.__region_array;
        
        var _matrix = __update_matrix(_element_x, _element_y);
        if (__matrix_inverse == undefined) __matrix_inverse = __scribble_matrix_inverse(matrix_multiply(_matrix, matrix_get(matrix_world)));
        var _vector = matrix_transform_vertex(__matrix_inverse, _pointer_x, _pointer_y, 0);
        var _x = _vector[0];
        var _y = _vector[1];
        
        var _found = undefined;
        var _i = 0;
        repeat(array_length(_region_array))
        {
            var _region = _region_array[_i];
            var _bbox_array = _region.__bbox_array;
            
            var _j = 0;
            repeat(array_length(_bbox_array))
            {
                var _bbox = _bbox_array[_j];
                if ((_x >= _bbox.__x1) && (_y >= _bbox.__y1) && (_x <= _bbox.__x2) && (_y <= _bbox.__y2))
                {
                    _found = _region.__name;
                    break;
                }
                
                ++_j;
            }
            
            if (_found != undefined) break;
            ++_i;
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
        
        var _model        = __get_model(true);
        var _page         = _model.__pages_array[__page];
        var _region_array = _page.__region_array;
        
        var _i = 0;
        repeat(array_length(_region_array))
        {
            var _region = _region_array[_i];
            if (_region.__name == _name)
            {
                __region_active      = _name;
                __region_glyph_start = _region.__start_glyph;
                __region_glyph_end   = _region.__end_glyph;
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
    
    #endregion
    
    
    
    #region Dimensions
    
    /// @param x
    /// @param y
    static get_bbox = function(_x, _y)
    {
        var _model = __get_model(true);
        if (!is_struct(_model))
        {
            //No extant model, return an empty bounding box
            return __get_bbox_transform(_x, _y, _model, {
                left   : _x,
                top    : _y,
                right  : _x,
                bottom : _y,
            });
        }
        else
        {
            var _model_bbox = _model.__get_bbox(SCRIBBLE_BOX_ALIGN_TO_PAGE? __page : undefined);
            return __get_bbox_transform(_x, _y, _model, _model_bbox);
        }
    }
    
    /// @param x
    /// @param y
    /// @param [typist]
    static get_bbox_revealed = function(_x, _y, _typist)
    {
        var _model = __get_model(true);
        if (!is_struct(_model))
        {
            //No extant model, return an empty bounding box
            return __get_bbox_transform(_x, _y, _model, {
                left   : _x,
                top    : _y,
                right  : _x,
                bottom : _y,
            });
        }
        else
        {
            if (_typist != undefined)
            {
                return __get_bbox_transform(_x, _y, _model, _model.__get_bbox_revealed(__page, 0, _typist.__window_array[_typist.__window_index]));
            }
            else if (__tw_reveal != undefined)
            {
                return __get_bbox_transform(_x, _y, _model, _model.__get_bbox_revealed(__page, 0, __tw_reveal));
            }
            else
            {
                return get_bbox(_x, _y);
            }
        }
    }
    
    static get_width = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        __update_scale_to_box_scale();
        return __scale_to_box_scale*(_model.__get_width() + __padding_l + __padding_r);
    }
    
    static get_height = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        __update_scale_to_box_scale();
        return __scale_to_box_scale*(_model.__get_height() + __padding_t + __padding_b);
    }
	
	/// @param [page]
	static get_page_width = function()
	{
		var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
		
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
		return __scale_to_box_scale*(_model.__get_page_width(_page) + __padding_l + __padding_r);
	}
	
	/// @param [page]
	static get_page_height = function()
	{
		var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
		
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
		return __scale_to_box_scale*(_model.__get_page_height(_page) + __padding_t + __padding_b);
	}
    
    #endregion
    
    
    
    #region Pages
    
    /// @param page
    static page = function(_page)
    {
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
        return (get_page() >= get_pages() - 1);
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
    
    
    
    #region MSDF
    
    static msdf_shadow = function(_colour, _alpha, _x_offset, _y_offset, _softness = 0.1)
    {
        __msdf_shadow_colour   = _colour;
        __msdf_shadow_alpha    = _alpha;
        __msdf_shadow_xoffset  = _x_offset;
        __msdf_shadow_yoffset  = _y_offset;
        __msdf_shadow_softness = clamp(_softness, 0, 1);
        
        return self;
    }
    
    static msdf_border = function(_colour, _thickness)
    {
        __msdf_border_colour    = _colour;
        __msdf_border_thickness = _thickness;
        
        return self;
    }
    
    static msdf_feather = function(_thickness)
    {
        __msdf_feather_thickness = _thickness;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Cache Management
    
     /// @param freeze
    static build = function(_freeze)
    {
        __freeze = _freeze;
        
        __get_model(true);
        
        return SCRIBBLE_BUILD_RETURNS_SELF? self : undefined;
    }
    
    static flush = function()
    {
        if (__flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing element \"" + string(__cache_name) + "\"");
        
        //Remove reference from cache
        variable_struct_remove(global.__scribble_ecache_dict, __cache_name);
        
        var _array = global.__scribble_ecache_array;
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
        
        return undefined;
    }
    
    #endregion
    
    
    
    #region Miscellaneous
    
    static get_events = function()
    {
        var _position = argument[0];
        var _page     = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return [];
        
        var _page = _model.__pages_array[_page];
        
        var _events = _page.__events[$ _position];
        if (!is_array(_events)) return [];
        
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
        
        var _new_cache_name = __text + ":" + __unique_id;
        if (__cache_name != _new_cache_name)
        {
            flush();
            __flushed = false;
            
            __model_cache_name_dirty = true;
            __cache_name = _new_cache_name;
            
            var _weak = global.__scribble_ecache_dict[$ __cache_name];
            if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
            {
                __scribble_trace("Warning! Flushing element \"", __cache_name, "\" due to cache name collision (try choosing a different unique ID)");
                _weak.ref.flush();
            }
            
            //Add this text element to the global cache
            global.__scribble_ecache_dict[$ __cache_name] = weak_ref_create(self);
            array_push(global.__scribble_ecache_array, self);
            array_push(global.__scribble_ecache_name_array, __cache_name);
        }
        
        return self;
    }
    
    static debug_draw_bbox = function(_x, _y)
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        if ((__scale_to_box_max_width > 0) && (__scale_to_box_max_height > 0))
        {
            var _w = __scale_to_box_max_width  - (__padding_l + __padding_r);
            var _h = __scale_to_box_max_height - (__padding_t + __padding_b);
        }
        else
        {
            var _w = __wrap_max_width  - (__padding_l + __padding_r);
            var _h = __wrap_max_height - (__padding_t + __padding_b);
        }
        
        _w *= __xscale;
        _h *= __yscale;
        
        var _l = _x + __padding_l;
        var _t = _y + __padding_t;
        var _r = _l + _w;
        var _b = _t + _h;
        
        switch(__starting_halign)
        {
            case fa_left:               break;
            case fa_center: _l -= _w/2; break;
            case fa_right:  _l -= _w;   break;
        }
        
        switch(_model.__valign)
        {
            case fa_top:                break;
            case fa_middle: _t -= _h/2; break;
            case fa_bottom: _t -= _h;   break;
        }
        
        if (((__scale_to_box_max_width > 0) && (__scale_to_box_max_height > 0))
        ||  ((__wrap_max_width > 0) && (__wrap_max_height > 0)))
        {
            draw_set_color(c_red);
            draw_rectangle(_l, _t, _r, _b, true);
            draw_set_color(c_white);
        }
        else if (__wrap_max_width > 0)
        {
            _h = _model.get_height();
            _b = _t + _h;
            
            draw_set_color(c_red);
            draw_line(_l, _t, _l, _t + _h);
            draw_line(_r, _t, _r, _t + _h);
            draw_set_color(c_white);
        }
        
        return self;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __get_model = function(_allow_create)
    {
        if (__flushed || (__text == ""))
        {
            __model = undefined;
        }
        else
        {
            if (__model_cache_name_dirty)
            {
                __model_cache_name_dirty = false;
                __model_cache_name = __text + ":" +
                                     string(__starting_font  ) + ":" +
                                     string(__starting_colour) + ":" +
                                     string(__starting_halign) + ":" +
                                     string(__starting_valign) + ":" +
                                     string(__line_height_min) + ":" +
                                     string(__line_height_max) + ":" +
                                     string(__line_spacing ) + ":" +
                                     string(__wrap_max_width ) + ":" +
                                     string(__wrap_max_height) + ":" +
                                     string(__wrap_per_char  ) + ":" +
                                     string(__wrap_no_pages  ) + ":" +
                                     string(__wrap_max_scale ) + ":" +
                                     string(__bezier_array   ) + ":" +
                                     string(__bidi_hint    ) + ":" +
                                     string(__padding_l      ) + ":" +
                                     string(__padding_t      ) + ":" +
                                     string(__padding_r      ) + ":" +
                                     string(__padding_b      ) + ":" +
                                     string(__ignore_command_tags);
            }
            
            var _weak = global.__scribble_mcache_dict[$ __model_cache_name];
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
    
    static __update_scale_to_box_scale = function()
    {
        var _model = __get_model(true);
        
        var _xscale = 1.0;
        var _yscale = 1.0;
        
        if (__scale_to_box_max_width  > 0) _xscale = __scale_to_box_max_width  / (_model.get_width()  + __padding_l + __padding_r);
        if (__scale_to_box_max_height > 0) _yscale = __scale_to_box_max_height / (_model.get_height() + __padding_t + __padding_b);
        
        var _previous_scale_to_box_scale = __scale_to_box_scale;
        __scale_to_box_scale = min(1.0, _xscale, _yscale);
        if (__scale_to_box_scale != _previous_scale_to_box_scale) __matrix_dirty = true;
    }
    
    static __update_matrix = function(_x, _y)
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
            var _xscale   = __xscale*__scale_to_box_scale;
            var _yscale   = __yscale*__scale_to_box_scale;
            var _angle    = __angle;
            
            with(__get_model(true))
            {
                _xscale *= __fit_scale;
                _yscale *= __fit_scale;
            }
            
            //Build a matrix to transform the text...
            if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
            {
                //Faster than creating our own array
                __matrix = matrix_build(_x_offset + _x, _y_offset + _y, __z,   0,0,0,   1,1,1);
            }
            else
            {
                var _sin = dsin(_angle);
                var _cos = dcos(_angle);
                
                var _m00 =  _xscale*_cos;
                var _m10 = -_yscale*_sin;
                var _m01 =  _xscale*_sin;
                var _m11 =  _yscale*_cos;
                
                var _m03 = _x_offset*_m00 + _y_offset*_m10 + _x;
                var _m13 = _x_offset*_m01 + _y_offset*_m11 + _y;
                
                __matrix = [_m00, _m10,   0, 0,
                            _m01, _m11,   0, 0,
                               0,    0,   1, 0,
                            _m03, _m13, __z, 1];
            }
        }
        
        return __matrix;
    }
    
    static __get_bbox_transform = function(_x, _y, _model, _bbox)
    {
        __update_scale_to_box_scale();
        var _xscale = __scale_to_box_scale*_model.__fit_scale*__xscale;
        var _yscale = __scale_to_box_scale*_model.__fit_scale*__yscale;
        
        //Left/top padding is baked into the model
        _bbox.left   -= __padding_l;
        _bbox.top    -= __padding_t;
        _bbox.right  += __padding_r;
        _bbox.bottom += __padding_b;
        
        if ((_xscale == 1) && (_yscale == 1) && (__angle == 0))
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
            //TODO - Optimize or cache this
            var _matrix = matrix_multiply(matrix_build(-__origin_x, -__origin_y, 0,    0, 0,       0,          1,       1, 1),
                          matrix_multiply(matrix_build(          0,           0, 0,    0, 0,       0,    _xscale, _yscale, 1),
                                          matrix_build(         _x,          _y, 0,    0, 0, __angle,          1,       1, 1)));
                
            var _l = _bbox.left;
            var _t = _bbox.top;
            var _r = _bbox.right;
            var _b = _bbox.bottom;
                
            var _vertex = matrix_transform_vertex(_matrix, _l, _t, 0); var _x0 = _vertex[0]; var _y0 = _vertex[1];
            var _vertex = matrix_transform_vertex(_matrix, _r, _t, 0); var _x1 = _vertex[0]; var _y1 = _vertex[1];
            var _vertex = matrix_transform_vertex(_matrix, _l, _b, 0); var _x2 = _vertex[0]; var _y2 = _vertex[1];
            var _vertex = matrix_transform_vertex(_matrix, _r, _b, 0); var _x3 = _vertex[0]; var _y3 = _vertex[1];
                
            var _l = min(_x0, _x1, _x2, _x3);
            var _t = min(_y0, _y1, _y2, _y3);
            var _r = max(_x0, _x1, _x2, _x3);
            var _b = max(_y0, _y1, _y2, _y3);
        }
        
        var _w = 1 + _r - _l;
        var _h = 1 + _b - _t;
        
        return { left:   _l,
                 top:    _t,
                 right:  _r,
                 bottom: _b,
                 
                 width:  _w,
                 height: _h,
                 
                 x0: _x0, y0: _y0,
                 x1: _x1, y1: _y1,
                 x2: _x2, y2: _y2,
                 x3: _x3, y3: _y3 };
    }
    
    #endregion
    
    
    
    #region Legacy Typewriter
    
    static typewriter_off = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (__tw_legacy_typist_use) __tw_legacy_typist.reset();
        __tw_legacy_typist_use = false;
        
        return self;
    }
    
    static typewriter_reset = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        
        __tw_legacy_typist = scribble_typist();
        __tw_legacy_typist.__associate(self);
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    static typewriter_in = function(_speed, _smoothness)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist_use = true;
        __tw_legacy_typist.in(_speed, _smoothness);
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards=false]
    static typewriter_out = function(_speed, _smoothness, _backwards = false)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist_use = true;
        __tw_legacy_typist.out(_speed, _smoothness, _backwards);
        
        return self;
    }
    
    static typewriter_skip = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.skip();
        
        return self;
    }
    
    /// @param soundArray
    /// @param overlap
    /// @param pitchMin
    /// @param pitchMax
    static typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.sound(_sound_array, _overlap, _pitch_min, _pitch_max);
        
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    static typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.sound_per_char(_sound_array, _pitch_min, _pitch_max);
        
        return self;
    }
    
    static typewriter_function = function(_function)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.function_per_char(_function);
        
        return self;
    }
    
    static typewriter_pause = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.pause();
        
        return self;
    }
    
    static typewriter_unpause = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.unpause();
        
        return self;
    }
    
    /// @param easeMethod
    /// @param dx
    /// @param dy
    /// @param xscale
    /// @param yscale
    /// @param rotation
    /// @param alphaDuration
    static typewriter_ease = function(_ease_method, _dx, _dy, _xscale, _yscale, _rotation, _alpha_duration)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.ease(_ease_method, _dx, _dy, _xscale, _yscale, _rotation, _alpha_duration);
        
        return self;
    }
    
    static get_typewriter_state = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return 1.0;
        
        return __tw_legacy_typist.get_state();
    }
    
    static get_typewriter_paused = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return false;
        
        return __tw_legacy_typist.get_paused();
    }
    
    static get_typewriter_pos = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return 0;
        
        return __tw_legacy_typist.get_position();
    }
    
    #endregion
}