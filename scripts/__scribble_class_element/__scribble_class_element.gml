// Feather ignore all

/// @param {string} string
/// @param {real}   uniqueID
function __scribble_class_element(_string, _unique_id) constructor
{
    static __scribble_state    = __scribble_get_state();
    static __ecache_array      = __scribble_get_cache_state().__ecache_array;
    static __ecache_dict       = __scribble_get_cache_state().__ecache_dict;
    static __ecache_name_array = __scribble_get_cache_state().__ecache_name_array;
    
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
    array_push(__ecache_name_array, __cache_name);
    
    __flushed = false;
    
    __model_cache_name_dirty = true;
    __model_cache_name = undefined;
    __model = undefined;
    
    __last_drawn = __scribble_state.__frames;
    __freeze = false;
    
    
    
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
    
    if (!SCRIBBLE_WARNING_LEGACY_TYPEWRITER)
    {
        //If we're permitting use of legacy typewriter functions, create a private typist for this specific text element
        __tw_legacy_typist = scribble_typist();
        __tw_legacy_typist.__associate(self);
        
        __tw_legacy_typist_use = false;
    }
    
    __animation_time        = current_time;
    __animation_speed       = 1;
    __animation_blink_state = true;
    
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
    /** @desc
        Draws your text! This function will automatically build the required text model if required. 
        For very large amounts of text this may cause a slight hiccup in your framerate - to avoid this,
        split your text into smaller pieces or manually call the .build() method during a loading screen etc.
    */
    /// @param {real} x horizontal position in the room to draw at
    /// @param {real} y vertical position in the room to draw at
    /// @param {struct.__scribble_class_typist} [typist] Typist being used to render the text element. See scribble_typist() for more information.
    static draw = function(_x, _y, _typist = undefined)
    {
        static _scribble_state = __scribble_get_state();
        
        var _function_scope = other;
        
        if (!SCRIBBLE_WARNING_LEGACY_TYPEWRITER)
        {
            if (__tw_legacy_typist_use && (_typist == undefined)) _typist = __tw_legacy_typist;
        }
        
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
        
        //Update the blink state
        if (_scribble_state.__blink_on_duration + _scribble_state.__blink_off_duration > 0)
        {
            __animation_blink_state = (((__animation_time + _scribble_state.__blink_time_offset) mod (_scribble_state.__blink_on_duration + _scribble_state.__blink_off_duration)) < _scribble_state.__blink_on_duration);
        }
        else
        {
            __animation_blink_state = true;
        }
        
        if (_model.__uses_standard_font) __set_standard_uniforms(_typist, _function_scope);
        if (_model.__uses_msdf_font) __set_msdf_uniforms(_typist, _function_scope);
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__update_matrix(_model, _x, _y), _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__submit(__page, __msdf_feather_thickness, (__msdf_border_thickness > 0) || (__msdf_shadow_alpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
        
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
    
    /** @desc Sets the starting font and text colour for your text. 
        The values that are set with .starting_format() are applied if you use the [/] or [/f] or [/c] command tags to reset your text format.
    */
    /// @param {string}               fontName Name of the starting font, as a string. This is the font that is set when [/] or [/font] is used in a string
    /// @param {Constant.Colour|real} colour   Starting colour in the standard GameMaker 24-bit BGR format. This is the colour that is set when [/] or [/color] is used in a string
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        Sets the starting horizontal and vertical alignment for your text. You can change alignment using in-line command tags as well, 
        though do note there are some limitations when doing so.
        Scribble Halign Exclusive:
		
        1) pin_left     Horizontally align this line of text to the left of the entire textbox             
		
        2) pin_center   Horizontally align this line of text to the right of the entire textbox            
		
        3) pin_right    Horizontally align this line of text to the right of the entire textbox            
		
        4) fa_justify   Justify the text using all avaliable horizontal space*                             
    */
    /// @param {Constant.HAling|string} halign Starting horizontal alignment of each line of text.
    /// @param {Constant.VAlign|string} valign Starting vertical alignment of the entire textbox.
    /// @return {struct.__scribble_class_element}
    static align = function(_halign, _valign)
    {
        if (_halign == "pin_left"  ) _halign = __SCRIBBLE_PIN_LEFT;
        if (_halign == "pin_centre") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_center") _halign = __SCRIBBLE_PIN_CENTRE;
        if (_halign == "pin_right" ) _halign = __SCRIBBLE_PIN_RIGHT;
        if (_halign == "fa_justify") _halign = __SCRIBBLE_FA_JUSTIFY;
        
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
    
    /** @desc
        Sets the blend colour/alpha, which is applied at the end of the drawing pipeline. 
        This is a little different to the interaction between draw_set_color() and draw_text() functions. 
        Scribble’s blend colour is instead similar to draw_sprite_ext()‘s behaviour: The blend colour/alpha is applied multiplicatively with the source colour, 
        in this case the source colour is whatever colour has been set using formatting tags in the input text string.
    */
    /// @param {Constant.Colour|real} colour Blend colour used when drawing text, applied multiplicatively
    /// @param {real}                 alpha  Alpha used when drawing text, 0 being fully transparent and 1 being fully opaque
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        Sets up a gradient blend for each glyph in the text element. 
        The base blend colour (defined by a combination of .blend() and in-line colour modification) is the top of the gradient and the colour defined by this method is the bottom of the gradient.
    */
    /// @param {Constant.Colour|real} colour      Colour of the bottom of the gradient for each glyph
    /// @param {real}                 blendFactor Blending factor for the gradient, from 0 (no gradient applied) to 1 (base blend colour of the bottom of each glyph is replaced with colour)
    /// @return {struct.__scribble_class_element}
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
    
    /// @deprecated
    static fog = function()
    {
        __scribble_error(".fog() has been replaced by .flash()");
    }
    
    /** @desc
        Forces the colour of all text (and sprites) to change to the given specified colour. 
        This will override any effects (rainbow / colour cycling), gradient, or other colour effects.
    */
    /// @param {real} colour        Flash colour, in the standard GameMaker 24-bit BGR format
    /// @param {real} blendFactor   Blending factor for the flash, from 0 to 1
    /// @return {struct.__scribble_class_element}
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
    /** @desc
        Adds a scaling factor to a text element. This is applied before text layout and multiplicatively with [scale] tags; 
        as a result, setting a scale with the method will affect text wrapping (if enabled).
    */
    /// @param {real} factor Scaling factor to apply to the text element. 1.0 represents no change in scale
    /// @return {struct.__scribble_class_element}
    static scale = function(_scale)
    {
        if (__pre_scale != _scale)
        {
            __model_cache_name_dirty = true;
            
            __pre_scale = _scale;
        }
        
        return self;
    }
    
    /** @desc
        Sets the origin relative to the top-left corner of the text element. You can think of this similarly to a standard sprite’s origin as set in the GameMaker IDE. 
        Using this function with .get_width() and .get_height() will allow you to align the entire textbox as you see fit. 
        Please note that this function may interact in unexpected ways with in-line alignment commands so some trial and error is necessary to get the effect you’re looking for.
    */
    /// @param {real} xOffset x-coordinate of the origin, in model space
    /// @param {real} yOffset y-coordinate of the origin, in model space
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc 
        Rotates and scales a text element relative to the origin (set by .origin() ).
        This transformation is applied after text layout and should be used to animate e.g. pop-in animations. 
        If you’d like to apply a scaling factor before text layout, please use .scale()
    */
    /// @param xScale   x scale of the text element
    /// @param [yScale] y scale of the text element. Defaults to xScale
    /// @param [angle]  rotation angle of the text element. Defaults to 0
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        Skews glyph positions relative to the origin (set by .origin()).
    */
    /// @param {real} skewX Skew factor contributed by x-coordinate of glyphs in the text element. A value is 0 confers no skewing
    /// @param {real} skewY Skew factor contributed by y-coordinate of glyphs in the text element. A value of 0 confers no skewing
    /// @return {struct.__scribble_class_element}
    static skew = function(_skew_x, _skew_y)
    {
        __skew_x = _skew_x;
        __skew_y = _skew_y;
        
        return self;
    }
    
    /** @desc
        Scales the text element such that it always fits inside the maximum width and height specified. Scaling is equal in both the x and y axes. 
        This behaviour does not recalculate text wrapping so will not re-flow text. .scale_to_box() is a simple scaling operation therefore, 
        and one that is best used for single lines of text (e.g. for buttons).
    */
    /// @param {real} maxWidth     Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit
    /// @param {real} maxHeight    Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit
    /// @param {bool} [maximise]   Allows the scaling algorithm to increase the scale as well as decreasing. Defaults to false
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. 
        Scribble’s text wrapping operates in a very similar way to GameMaker’s native draw_text_ext(). 
        If text exceeds the horizontal maximum width then text will be pushed onto the next line. 
        If text exceeds the maximum height of the textbox then a new page will be created (see .page() and .get_page()). 
        Very long sequences of glyphs without spaces will be split across multiple lines.
    */
    /// @param {real} maxWidth        Maximum width for the whole textbox. Use a negative number (the default) for no limit
    /// @param {real} [maxHeight]     Maximum height for the whole textbox. Use a negative number (the default) for no limit. Defaults to -1
    /// @param {bool} [characterWrap] Whether to wrap text per character (rather than per word). Defaults to false. This is useful for tight textboxes and some East Asian languages
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        Fits text to a box by inserting line breaks and scaling text but will not insert any page breaks. 
        Text will take up as much space as possible without starting a new page. 
        The macro SCRIBBLE_FIT_TO_BOX_ITERATIONS controls how many iterations to perform (higher is slower but more accurate).
        N.B. This function is slow and should be used sparingly. It is recommended you manually cache text elements when using .fit_to_box().
    */
    /// @param {real} maxWidth        Maximum width for the whole textbox
    /// @param {real} maxHeight       Maximum height for the whole textbox
    /// @param {bool} [characterWrap] Whether to wrap text per character (rather than per word). Defaults to false. This is useful for very tight textboxes and some East Asian languages
    /// @param {real} [maxScale]      * *. Defaults to 1
    /// @return {struct.__scribble_class_element}
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
    /** @desc
        Description placeholder
    */
    /// @param {real} width Width to use for pin-type alignments. Use a negative number (the default) to use the width of the text instead of a fixed number
    /// @return {struct.__scribble_class_element}
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

    /** @desc
        Sets limits on the height of each line for the text element. This is useful when mixing and matching fonts that aren’t necessarily perfectly sized to each other.
    */
    /// @param {real} min Minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font
    /// @param {real} max Maximum line height for each line of text. Use a negative number (the default) for no limit
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        If a number is passed to this method then a fixed line spacing is used. 
        If a string is passed to this method then it must be a percentage string indication the fraction of the line height to use for spacing 
        ("100%" being normal spacing, "200%" being double spacing). The default value is "100%"
        The term “spacing” is being used a little inaccurately here. The value that is being adjusted is more properly called “leading” (as in the metal).
    */
    /// @param {number/string} spacing The spacing from one line of text to the next. Can be a number, or a percentage string e.g. "100%"
    /// @return {struct.__scribble_class_element}
    static line_spacing = function(_spacing)
    {
        if (_spacing != __line_spacing)
        {
            __model_cache_name_dirty = true;
            __line_spacing = _spacing;
        }
        
        return self;
    }

    /** @desc
        Description placeholder
    */
    /// @param {real} left   Extra space on the left-hand side of the textbox. Positive values create more space
    /// @param {real} top    Extra space on the top of the textbox. Positive values create more space
    /// @param {real} right  Extra space on the right-hand side of the textbox. Positive values create more space
    /// @param {real} bottom Extra space on the bottom of the textbox. Positive values create more space
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        This function defines a cubic Bézier curve to shape text to. The four x/y coordinate pairs provide a smooth curve that Scribble uses as a guide to position and rotate glyphs.
        
        The curve is positioned relative to the coordinate specified when calling .draw() so that the first Bézier coordinate is at the draw coordinate. 
        This enables you to move a curve without re-adjusting the values set in .bezier() (which would regenerate the text element, likely causing performance problems).
        
        If used in conjunction with .wrap(), the total length of the curve is used to wrap text horizontally and overrides the value specified in .wrap().
        .bezier() will not work with [fa_right] or [fa_center] alignment. Instead, you should use [pin_right] and [pin_center].
        
        This function can also be executed with zero arguments (e.g. scribble("text").bezier()) to turn off the Bézier curve for this text element
    */
    /// @param {real} [x1] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [y1] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [x2] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [y2] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [x3] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [y3] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [x4] Parameter for the cubic Bézier curve. Defaults to 0
    /// @param {real} [y4] Parameter for the cubic Bézier curve. Defaults to 0
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        Hints to the text parser whether the overall text direction is right-to-left (true) or left-to-right (false). 
        This method also accepts an input of undefined to use the default behaviour whereby Scribble attempts to figure out the overall text direction based on 
        the first glyph in the string.
    */
    /// @param {real} state Whether the overall text direction is right-to-left
    /// @return {struct.__scribble_class_element}
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
    
    /** @desc
        This function returns the name of a region if one is being hovered over. You can define a region in your text by using the [region,<name>] and [/region] formatting tags.
        
        !Using this function requires that SCRIBBLE_ALLOW_GLYPH_DATA_GETTER be set to true.
        
        Can return "undefined" if no region is being pointed to
    */
    /// @param {real} elementX x position of the text element in the room (usually the same as the coordinate you’d specify for .draw())
    /// @param {real} elementY y position of the text element in the room (usually the same as the coordinate you’d specify for .draw())
    /// @param {real} pointerX x position of the mouse/cursor
    /// @param {real} pointerY y position of the mouse/cursor
    /// @return {string}
    static region_detect = function(_element_x, _element_y, _pointer_x, _pointer_y)
    {
        var _model        = __get_model(true);
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
            --_i;
        }
        
        return _found;
    }
    
    /** @desc
        This function expects the name of a region that has been defined in your text using the [region,<name>] and [/region] formatting tags. 
        You can get the name of the region that the player is currently highlighting with their cursor by using .region_detect()
    */
    /// @param {string}               name        Name of the region to highlight. Use undefined to highlight no region
    /// @param {Constant.Colour|real} colour      Colour to highlight the region (a standard GameMaker BGR colour)
    /// @param {real}                 blendAmount Blend factor to apply for the highlighted region
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
    
    /** @desc
        Can return "undefined" if no region is active
    */
    /// @return {string}
    static region_get_active = function()
    {
        return __region_active;
    }
    
    #endregion
    
    
    
    #region Dimensions
    
	/// @ignore
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
    
    /** @desc
        This function takes into account the transformation and padding applied to the text element.
        
        return the left position of the text element’s axis-aligned bounding box in the room
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @param {real} x horizontal position of the text element in the room
    /// @return {real}
    static get_left = function(_x = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_left + _x;
    }

    /** @desc
        This function takes into account the transformation and padding applied to the text element.
        
        return the top position of the text element’s axis-aligned bounding box in the room
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @param {real} y vertical position of the text element in the room
    /// @return {real}
    static get_top = function(_y = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_top + _y;
    }

    /** @desc
        This function takes into account the transformation and padding applied to the text element.
        
        return the right position of the text element’s axis-aligned bounding box in the room
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @param {real} x horizontal position of the text element in the room
    /// @return {real}
    static get_right = function(_x = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_right + _x;
    }

    /** @desc
        This function takes into account the transformation and padding applied to the text element.
        
        return the bottom position of the text element’s axis-aligned bounding box in the room
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @param {real} y vertical position of the text element in the room
    /// @return {real}
    static get_bottom = function(_y = 0)
    {
        __update_bbox_matrix();
        return __bbox_aabb_bottom + _y;
    }

    /** @desc
        This function returns the untransformed width of the text element. This will not take into account rotation or scaling applied by the .transform() method but will take into account padding.
        
        return width of the text element in pixels (ignoring rotation and scaling)
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @return {real}
    static get_width = function()
    {
        __update_bbox_matrix();
        return __bbox_raw_width;
    }

    /** @desc
        This function returns the untransformed width of the text element. This will not take into account rotation or scaling applied by the .transform() method but will take into account padding.
        
        return height of the text element in pixels (ignoring rotation and scaling)
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @return {real}
    static get_height = function()
    {
        __update_bbox_matrix();
        return __bbox_raw_height;
    }

    /** @desc
        This functions returns the transformed width and height of the text element. 
        This will take into account rotation or scaling applied by the .transform() method as well as padding.
        
        If SCRIBBLE_BOUNDING_BOX_USES_PAGE is set to true, only text on the current page will be included in the bounding box.
    */
    /// @param {real} x
    /// @param {real} y
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
    
    /** @desc
        The struct returned by .get_bbox_revealed() contains the same member variables as .get_bbox(); see above for details. Only text that is visible will be considered for calculating the bounding boxes.
        
        This functions returns the transformed width and height of the text element. This will take into account rotation or scaling applied by the .transform() method as well as padding.
    */
    /// @param {real} x x position in the room
    /// @param {real} y y position in the room
    /// @param {struct.__scribble_class_typist} [typist] Typist being used to render the text element. If not specified, the manual reveal value is used instead (set by .reveal())
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
    
    /** @desc 
        Changes which page Scribble is display for the text element. Pages are created when using the .wrap() method or when inserting [/page] command tags into your input string. Pages are 0-indexed.
        
        Please note that changing the page will reset any typewriter animations started by a typist associated with the text element.
    */
    /// @param {real} page Page to display, starting at 0 for the first page
    /// @return {struct.__scribble_class_element}
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
    
    /// @desc Returns which page Scribble is showing, as set by .page(). Pages are 0-indexed; this function will return 0 for the first page.
    /// @return {real}
    static get_page = function()
    {
        return __page;
    }
    
    /// @deprecated
    static get_pages = function()
    {
        __scribble_error(".get_pages() has been replaced by .get_page_count()");
    }
    
    /// @desc Returns the total number of pages that this text element contains. In rare cases, this function can return 0.
    /// @return {real}
	static get_page_count = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_page_count();
    }
    
    /// @desc return "True" whether the current page is the last page for the text element
    /// @return {bool}
    static on_last_page = function()
    {
        return (get_page() >= get_page_count() - 1);
    }
    
    #endregion
    
    
    
    #region Other Getters
    
    /// @desc Will return true only if the .wrap() feature is used. Manual newlines (\n) included in the input string will not cause this function to return true.
    static get_wrapped = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return false;
        return _model.__get_wrapped();
    }
    
    /** @desc 
        The string that is returned is the raw text that is drawn i.e. all command tags and events have been stripped out. Sprites and surfaces are represented by a single glyph with the Unicode value of 26 (0x001A “substitute character”).The string that is returned is the raw text that is drawn i.e. all command tags and events have been stripped out. Sprites and surfaces are represented by a single glyph with the Unicode value of 26 (0x001A “substitute character”).
    */
    /// @param {real} [page] Page to get the raw text from. If not specified, the current page is used
    /// @return {string}
    static get_text = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_text(_page);
    }
    
    /// @desc Return a struct containing layout details for the glyph on the given page. If the page not exists it return undefined
    /// @param {real} glyphIndex Index of the glyph whose data will be returned
    /// @param {real} [page]     Page to get the raw text from. If not specified, the current page is used
    static get_glyph_data = function(_index, _page)
    {
        _page ??= __page;
        
        var _model = (__get_model(true) );
        if (is_struct(_model) ) {
            return _model.__get_glyph_data(_index, _page);
        } 
    }
    
    /// @desc return the number of glyphs on the given page
    /// @param {real} [page] Page to get the glyph count from. If not specified, the current page is used
    /// @return {real}
    static get_glyph_count = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_glyph_count(_page);
    }
    
    /// @desc retur how many lines of text are on the given pagen 
    /// @param {real} [page] Page to retrieve the number of lines for. Defaults to the current page that’s being shown
    static get_line_count = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.__get_line_count(_page);
    }
    
    #endregion
    
    
    
    #region Typewriter
    
    /// @desc Updates a typist associated with the text element. You will typically not need to call this method, but it is occasionally useful for resolving order-of-execution issues.
    /// @param {struct.__scribble_class_typist} [typist] Typist being used to render the text element. See scribble_typist() for more information
    /// @return {struct.__scribble_class_element}
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
    
    /// @param {real} character The number of characters to reveal
    /// @return {struct.__scribble_class_element}
    static reveal = function(_character)
    {
        if (__tw_reveal != _character)
        {
            __tw_reveal = _character;
            __tw_reveal_window_array[@ 0] = _character;
        }
        
        return self;
    }
    
    /// @desc Number, the amount of characters revealled, as set by .reveal()
    /// @return {real}
    static get_reveal = function()
    {
        return __tw_reveal;
    }
    
    #endregion
    
    
    
    #region Animation
    
    /// @deprecated
    static animation_tick_speed = function()
    {
        __scribble_error(".animation_tick_speed() has been replaced by .animation_speed()");
    }
    
    /** @desc 
        Setting the animation speed value to 0 will pause animation effects. This value can even be negative to play effects backwards!
        This setting does not impact typists. Instead, please use the .pause() typist method to pause typists.	
    */
    /// @param {real} speed The animation speed multiplier where 1 is normal speed, 2 is double speed, and 0.5 is half speed
    /// @return {struct.__scribble_class_element}
    static animation_speed = function(_speed)
    {
        __animation_speed = _speed;
        
        return self;
    }
    
    /// @desc The value returned from this function defaults to 1.
    /// @return {real}
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

    /// @deprecated
    static animation_sync = function()
    {
        __scribble_error(".animation_sync() has been removed\nPlease get in touch if this feature is essential for your project");
    }

    /// @deprecated
    static animation_wave = function()
    {
        __scribble_error(".animation_wave() has been replaced by scribble_anim_wave()");
    }

    /// @deprecated
    static animation_shake = function()
    {
        __scribble_error(".animation_wave() has been replaced by scribble_anim_shake()");
    }

    /// @deprecated
    static animation_rainbow = function()
    {
        __scribble_error(".animation_rainbow() has been replaced by scribble_anim_rainbow()");
    }

    /// @deprecated
    static animation_wobble = function()
    {
        __scribble_error(".animation_wobble() has been replaced by scribble_anim_wobble()");
    }

    /// @deprecated
    static animation_pulse = function()
    {
        __scribble_error(".animation_pulse() has been replaced by scribble_anim_pulse()");
    }

    /// @deprecated
    static animation_wheel = function()
    {
        __scribble_error(".animation_wheel() has been replaced by scribble_anim_wheel()");
    }
    /// @deprecated
    static animation_cycle = function()
    {
        __scribble_error(".animation_cycle() has been replaced by scribble_anim_cycle()");
    }

    /// @deprecated
    static animation_jitter = function()
    {
        __scribble_error(".animation_jitter() has been replaced by scribble_anim_jitter()");
    }

    /// @deprecated
    static animation_blink = function()
    {
        __scribble_error(".animation_blink() has been replaced by scribble_anim_blink()");
    }
    
    #endregion
    
    
    
    #region MSDF
    
    /** @desc
        !This method will only affect MSDF fonts. If you’d like to add shadows to standard fonts or spritefonts, you may want to consider baking this effect.!
        
        Sets the colour, alpha, and offset for a procedural MSDF shadow. Setting the alpha to 0 will prevent the shadow from being drawn at all. 
        If you find that your shadow(s) are being clipped or cut off when using large offset values, regenerate your MSDF fonts using a larger pxrange.
    */
    /// @param {Constant.colour|real} colour The colour of the shadow, as a standard GameMaker 24-bit BGR format
    /// @param {real} alpha      Opacity of the shadow, 0.0 being transparent and 1.0 being fully opaque
    /// @param {real} xOffset    x-coordinate of the shadow, relative to the parent glyph
    /// @param {real} yOffset    y-coordinate of the shadow, relative to the parent glyph
    /// @param {real} [softness] Optional. Larger values give a softer edge to the shadow. If not specified, this will default to 0.1 (which draws an antialiased but clean shadow edge)
    /// @return {struct.__scribble_class_element}
    static msdf_shadow = function(_colour, _alpha, _x_offset, _y_offset, _softness = 1)
    {
        __msdf_shadow_colour   = _colour;
        __msdf_shadow_alpha    = _alpha;
        __msdf_shadow_xoffset  = _x_offset;
        __msdf_shadow_yoffset  = _y_offset;
        __msdf_shadow_softness = max(0, _softness);
        
        return self;
    }

    /** @desc
        !This method will only affect MSDF fonts. If you’d like to add outlines to standard fonts or spritefonts, you may want to consider baking this effect.!
        
        Sets the colour and thickness for a procedural MSDF border. Setting the thickness to 0 will prevent the border from being drawn at all. 
        If you find that your glyphs have filled (or partially filled) backgrounds, regenerate your MSDF fonts using a larger pxrange.
    */
    /// @param {Constant.colour|real} colour    The colour of the shadow, as a standard GameMaker 24-bit BGR format
    /// @param {real}                 thickness Thickness of the border, in pixels
    /// @return {struct.__scribble_class_element}
    static msdf_border = function(_colour, _thickness)
    {
        __msdf_border_colour    = _colour;
        __msdf_border_thickness = _thickness;
        
        return self;
    }
    
    /** @desc
        !This method will only affect MSDF fonts!
        
        Sets the colour and thickness for a procedural MSDF border. Setting the thickness to 0 will prevent the border from being drawn at all. 
        If you find that your glyphs have filled (or partially filled) backgrounds, regenerate your MSDF fonts using a larger pxrange.
    */
    /// @param {real} thickness Feather thickness, in pixels
    /// @return {struct.__scribble_class_element}
    static msdf_feather = function(_thickness)
    {
        __msdf_feather_thickness = _thickness;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Cache Management
    
    /** @desc
        this function returns undefined, the intended use of this function is:
        
        Forces Scribble to build the text model for this text element. Calling this method twice will do nothing even if e.g. a macro command tag would return a different value (please use .refresh() instead). 
        You should call this function if you’re pre-caching (a.k.a. “stashing”) text elements e.g. during a loading screen. 
        Freezing vertex buffers will speed up rendering considerably but has a large up-front cost.
    */
    /// @param {bool} freeze Whether to freeze generated vertex buffers
    /// @return {Any}
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
    
    /// @desc Forces Scribble to rebuild the text model for this text element. This is particularly useful for situations where a stashed text element needs to update e.g. a macro command tag would return a different value.
    static refresh = function()
    {
        var _model = __get_model(false);
        if (_model != undefined)
        {
            _model.__flush();
            __get_model(true);
        }
        
        return self;
    }
    
    /** @desc
        Forces Scribble to remove this text element from the internal cache, invalidating the text element. If you have manually cached a reference to a flushed text element, 
        that text element will no longer be able to be drawn. Given that Scribble actively garbage collects used memory it is uncommon that you’d want to ever use this function, 
        but if you want to tightly manage your memory, this function is available.
    */
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
        
        if (SCRIBBLE_FLUSH_RETURNS_SELF)
        {
            return self;
        }
        else
        {
            static _null = new __scribble_class_null_element();
            return _null;
        }
    }
    
    #endregion
    
    
    
    #region Miscellaneous
    
    /** @desc 
        To match GameMaker’s native string behaviour for functions such as string_copy(), character positions are 1-indexed such that the character at position 1 in the string "abc" is a. 
        Events are indexed such that an event placed immediately before a character has an index one less than the character. Events placed immediately after a character have an index equal to the character e.g. "[event index 0]X[event index 1]".
    */
    /// @param {real} position Character to get events for. See below for more details
    /// @param {real} [page]   The page to get events for. If not specified, the current page will be used
    /// @return {array<Struct>}
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
    
    /// @desc Executes a function in the scope of this text element. If that function contains method calls then the methods will be applied to this text element.
    /// @param {function|array<function>}  templateFunction/Array Function to execute to set Scribble behaviour for this text element
    /// @param {bool} [executeOnlyOnChange] Whether to only execute the template function if it has changed. Defaults to true
    /// @return {struct.__scribble_class_element}
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
    
    /// @desc Directs Scribble to ignore all command tags in the string and instead render them as plaintext.
    /// @param {bool} state Whether to ignore command tags
    /// @return {struct.__scribble_class_element}
    static ignore_command_tags = function(_state)
    {
        if (__ignore_command_tags != _state)
        {
            __model_cache_name_dirty = true;
            __ignore_command_tags = _state;
        }
        
        return self;
    }
    
    /** @desc 
        Setting this method to true will also randomize any and all effects. This includes typewriter effects achieved with typists or .reveal(), 
        and also animated formatting via command tags such as [shake] [rainbow] etc.
    */
    /// @param {bool} state Whether to randomize the order that glyphs are animated
    /// @return {struct.__scribble_class_element}
    static randomize_animation = function(_state)
    {
        if (__randomize_animation != _state)
        {
            __model_cache_name_dirty = true;
            __randomize_animation = _state;
        }
        
        return self;
    }

    /** @desc
        Controls the z coordinate to draw the text element at. This is largely irrelevant in 2D games, but this functionality is occasionally useful nonetheless. 
        The z coordinate defaults to SCRIBBLE_DEFAULT_Z.
    */
    /// @param {real} The z coordinate to draw the text element at
    /// @return {struct.__scribble_class_element}
    static z = function(_z)
    {
        __z = _z;
        
        return self;
    }
    
    /// @desc returns the z-position of the text element as set by .z()
    /// @return {real}
    static get_z = function()
    {
        return __z;
    }
    
    /** @desc
        Replaces the string in an existing text element.
        
        This function may cause a recaching of the underlying text model so should be used sparingly. 
        Do not be surprised if this method resets associated typists, invalidates text element state, or causes outright crashes
    */
    /// @param {string}      string     New string to display using the text element
    /// @param {real|string} [uniqueID] A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states
    /// @return {struct.__scribble_class_element}
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
    
    /// @ignore
    /// @param {real} x
    /// @param {real} y
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
    
    /// @ignore
    /// @return {struct.__scribble_class_model}
    static __get_model = function(_allow_create)
    {
        static _mcache_dict = __scribble_get_cache_state().__mcache_dict;
        
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
                
                static _buffer = __scribble_get_buffer_a();
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
    
    /// @ignore
    static __set_standard_uniforms = function(_typist, _function_scope)
    {
        static _u_fTime         = shader_get_uniform(__shd_scribble, "u_fTime"                   );
        static _u_vColourBlend  = shader_get_uniform(__shd_scribble, "u_vColourBlend"            );
        static _u_fBlinkState   = shader_get_uniform(__shd_scribble, "u_fBlinkState"             );
        static _u_vGradient     = shader_get_uniform(__shd_scribble, "u_vGradient"               );
        static _u_vSkew         = shader_get_uniform(__shd_scribble, "u_vSkew"                   );
        static _u_vFlash        = shader_get_uniform(__shd_scribble, "u_vFlash"                  );
        static _u_vRegionActive = shader_get_uniform(__shd_scribble, "u_vRegionActive"           );
        static _u_vRegionColour = shader_get_uniform(__shd_scribble, "u_vRegionColour"           );
        static _u_aDataFields   = shader_get_uniform(__shd_scribble, "u_aDataFields"             );
        static _u_aBezier       = shader_get_uniform(__shd_scribble, "u_aBezier"                 );
        
        static _u_iTypewriterUseLines      = shader_get_uniform(__shd_scribble, "u_iTypewriterUseLines"     );
        static _u_iTypewriterMethod        = shader_get_uniform(__shd_scribble, "u_iTypewriterMethod"       );
        static _u_iTypewriterCharMax       = shader_get_uniform(__shd_scribble, "u_iTypewriterCharMax"      );
        static _u_fTypewriterWindowArray   = shader_get_uniform(__shd_scribble, "u_fTypewriterWindowArray"  );
        static _u_fTypewriterSmoothness    = shader_get_uniform(__shd_scribble, "u_fTypewriterSmoothness"   );
        static _u_vTypewriterStartPos      = shader_get_uniform(__shd_scribble, "u_vTypewriterStartPos"     );
        static _u_vTypewriterStartScale    = shader_get_uniform(__shd_scribble, "u_vTypewriterStartScale"   );
        static _u_fTypewriterStartRotation = shader_get_uniform(__shd_scribble, "u_fTypewriterStartRotation");
        static _u_fTypewriterAlphaDuration = shader_get_uniform(__shd_scribble, "u_fTypewriterAlphaDuration");
        
        static _scribble_state        = __scribble_get_state();
        static _anim_properties_array = __scribble_get_anim_properties();
        
        static _shader_uniforms_dirty    = true;
        static _shader_set_to_use_bezier = false;
        
        shader_set(__shd_scribble);
        shader_set_uniform_f(_u_fTime, __animation_time);
        
        //TODO - Optimise
        var _blend_colour = __blend_colour;
        shader_set_uniform_f(_u_vColourBlend, colour_get_red(  _blend_colour)/255,
                                              colour_get_green(_blend_colour)/255,
                                              colour_get_blue( _blend_colour)/255,
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
        if (_scribble_state.__standard_anim_desync)
        {
            with(_scribble_state)
            {
                __standard_anim_desync  = false;
                __standard_anim_default = __standard_anim_desync_to_default;
            }
            
            shader_set_uniform_f_array(_u_aDataFields, _anim_properties_array);
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
        
        shader_reset();
    }
    
    /// @ignore
    static __set_msdf_uniforms = function(_typist, _function_scope)
    {
        static _msdf_u_fTime         = shader_get_uniform(__shd_scribble_msdf, "u_fTime"        );
        static _msdf_u_vColourBlend  = shader_get_uniform(__shd_scribble_msdf, "u_vColourBlend" );
        static _msdf_u_fBlinkState   = shader_get_uniform(__shd_scribble_msdf, "u_fBlinkState"  );
        static _msdf_u_vGradient     = shader_get_uniform(__shd_scribble_msdf, "u_vGradient"    );
        static _msdf_u_vSkew         = shader_get_uniform(__shd_scribble_msdf, "u_vSkew"        );
        static _msdf_u_vFlash        = shader_get_uniform(__shd_scribble_msdf, "u_vFlash"       );
        static _msdf_u_vRegionActive = shader_get_uniform(__shd_scribble_msdf, "u_vRegionActive");
        static _msdf_u_vRegionColour = shader_get_uniform(__shd_scribble_msdf, "u_vRegionColour");
        static _msdf_u_aDataFields   = shader_get_uniform(__shd_scribble_msdf, "u_aDataFields"  );
        static _msdf_u_aBezier       = shader_get_uniform(__shd_scribble_msdf, "u_aBezier"      );
        
        static _msdf_u_iTypewriterUseLines      = shader_get_uniform(__shd_scribble_msdf, "u_iTypewriterUseLines"     );
        static _msdf_u_iTypewriterMethod        = shader_get_uniform(__shd_scribble_msdf, "u_iTypewriterMethod"       );
        static _msdf_u_iTypewriterCharMax       = shader_get_uniform(__shd_scribble_msdf, "u_iTypewriterCharMax"      );
        static _msdf_u_fTypewriterWindowArray   = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterWindowArray"  );
        static _msdf_u_fTypewriterSmoothness    = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterSmoothness"   );
        static _msdf_u_vTypewriterStartPos      = shader_get_uniform(__shd_scribble_msdf, "u_vTypewriterStartPos"     );
        static _msdf_u_vTypewriterStartScale    = shader_get_uniform(__shd_scribble_msdf, "u_vTypewriterStartScale"   );
        static _msdf_u_fTypewriterStartRotation = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterStartRotation");
        static _msdf_u_fTypewriterAlphaDuration = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterAlphaDuration");
    
        static _msdf_u_vShadowOffsetAndSoftness = shader_get_uniform(__shd_scribble_msdf, "u_vShadowOffsetAndSoftness");
        static _msdf_u_vShadowColour            = shader_get_uniform(__shd_scribble_msdf, "u_vShadowColour"           );
        static _msdf_u_vBorderColour            = shader_get_uniform(__shd_scribble_msdf, "u_vBorderColour"           );
        static _msdf_u_fBorderThickness         = shader_get_uniform(__shd_scribble_msdf, "u_fBorderThickness"        );
        static _msdf_u_vOutputSize              = shader_get_uniform(__shd_scribble_msdf, "u_vOutputSize"             );
        
        static _scribble_state        = __scribble_get_state();
        static _anim_properties_array = __scribble_get_anim_properties();
        
        static _shader_uniforms_dirty    = true;
        static _shader_set_to_use_bezier = false;
        
        shader_set(__shd_scribble_msdf);
        shader_set_uniform_f(_msdf_u_fTime, __animation_time);
        
        //TODO - Optimise
        shader_set_uniform_f(_msdf_u_vColourBlend, colour_get_red(  __blend_colour)/255,
                                                   colour_get_green(__blend_colour)/255,
                                                   colour_get_blue( __blend_colour)/255,
                                                   __blend_alpha);
        
        shader_set_uniform_f(_msdf_u_fBlinkState, __animation_blink_state);
        
        if ((__gradient_alpha != 0) || (__skew_x != 0) || (__skew_y != 0) || (__flash_alpha != 0) || (__region_blend != 0))
        {
            _shader_uniforms_dirty = true;
            
            shader_set_uniform_f(_msdf_u_vGradient, colour_get_red(  __gradient_colour)/255,
                                                    colour_get_green(__gradient_colour)/255,
                                                    colour_get_blue( __gradient_colour)/255,
                                                    __gradient_alpha);
            
            shader_set_uniform_f(_msdf_u_vSkew, __skew_x, __skew_y);
            
            shader_set_uniform_f(_msdf_u_vFlash, colour_get_red(  __flash_colour)/255,
                                                 colour_get_green(__flash_colour)/255,
                                                 colour_get_blue( __flash_colour)/255,
                                                 __flash_alpha);
            
            shader_set_uniform_f(_msdf_u_vRegionActive, __region_glyph_start, __region_glyph_end);
            
            shader_set_uniform_f(_msdf_u_vRegionColour, colour_get_red(  __region_colour)/255,
                                                        colour_get_green(__region_colour)/255,
                                                        colour_get_blue( __region_colour)/255,
                                                        __region_blend);
        }
        else if (_shader_uniforms_dirty)
        {
            _shader_uniforms_dirty = false;
            
            shader_set_uniform_f(_msdf_u_vGradient, 0, 0, 0, 0);
            shader_set_uniform_f(_msdf_u_vSkew, 0, 0);
            shader_set_uniform_f(_msdf_u_vFlash, 0, 0, 0, 0);
            shader_set_uniform_f(_msdf_u_vRegionActive, 0, 0);
            shader_set_uniform_f(_msdf_u_vRegionColour, 0, 0, 0, 0);
        }
        
        //Update the animation properties for this shader if they've changed since the last time we drew an element
        if (_scribble_state.__msdf_anim_desync)
        {
            with(_scribble_state)
            {
                __msdf_anim_desync  = false;
                __msdf_anim_default = __msdf_anim_desync_to_default;
            }
            
            shader_set_uniform_f_array(_msdf_u_aDataFields, _anim_properties_array);
        }
        
        if (__bezier_using)
        {
            //If we're using a Bezier curve for this element, push that value into the shader
            _shader_set_to_use_bezier = true;
            shader_set_uniform_f_array(_msdf_u_aBezier, __bezier_array);
        }
        else if (_shader_set_to_use_bezier)
        {
            //If we're *not* using a Bezier curve but we have a previous Bezier curve cached, reset the curve in the shader
            _shader_set_to_use_bezier = false;
            
            static _null_array = array_create(6, 0);
            shader_set_uniform_f_array(_msdf_u_aBezier, _null_array);
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
            shader_set_uniform_i(_msdf_u_iTypewriterUseLines,          0);
            shader_set_uniform_i(_msdf_u_iTypewriterMethod,            SCRIBBLE_EASE.LINEAR);
            shader_set_uniform_i(_msdf_u_iTypewriterCharMax,           0);
            shader_set_uniform_f(_msdf_u_fTypewriterSmoothness,        0);
            shader_set_uniform_f(_msdf_u_vTypewriterStartPos,          0, 0);
            shader_set_uniform_f(_msdf_u_vTypewriterStartScale,        1, 1);
            shader_set_uniform_f(_msdf_u_fTypewriterStartRotation,     0);
            shader_set_uniform_f(_msdf_u_fTypewriterAlphaDuration,     1.0);
            shader_set_uniform_f_array(_msdf_u_fTypewriterWindowArray, __tw_reveal_window_array);
        }
        else
        {
            shader_set_uniform_i(_msdf_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
        }
        
        shader_set_uniform_f(_msdf_u_vShadowOffsetAndSoftness, __msdf_shadow_xoffset, __msdf_shadow_yoffset, __msdf_shadow_softness);
        
        shader_set_uniform_f(_msdf_u_vShadowColour, colour_get_red(  __msdf_shadow_colour)/255,
                                                    colour_get_green(__msdf_shadow_colour)/255,
                                                    colour_get_blue( __msdf_shadow_colour)/255,
                                                    __msdf_shadow_alpha);
        
        shader_set_uniform_f(_msdf_u_vBorderColour, colour_get_red(  __msdf_border_colour)/255,
                                                    colour_get_green(__msdf_border_colour)/255,
                                                    colour_get_blue( __msdf_border_colour)/255);
        
        shader_set_uniform_f(_msdf_u_fBorderThickness, __msdf_border_thickness);
        
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
        
        shader_set_uniform_f(_msdf_u_vOutputSize, _surface_width, _surface_height);
        
        shader_reset();
    }
    
    /// @ignore
    static __update_scale_to_box_scale = function()
    {
        if (!__scale_to_box_dirty) return;
        __scale_to_box_dirty = false;
        
        var _model = __get_model(true);
        
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
    
    /// @ignore
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
    
    
    
    #region Legacy Typewriter
    
    /// @deprecated
    static typewriter_off = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (__tw_legacy_typist_use) __tw_legacy_typist.reset();
        __tw_legacy_typist_use = false;
        
        return self;
    }

    /// @deprecated
    static typewriter_reset = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        
        __tw_legacy_typist = scribble_typist();
        __tw_legacy_typist.__associate(self);
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @deprecated
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
    /// @deprecated
    static typewriter_out = function(_speed, _smoothness, _backwards = false)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist_use = true;
        __tw_legacy_typist.out(_speed, _smoothness, _backwards);
        
        return self;
    }

    /// @deprecated
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
    /// @deprecated
    static typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.sound(_sound_array, _overlap, _pitch_min, _pitch_max);
        
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    /// @deprecated
    static typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.sound_per_char(_sound_array, _pitch_min, _pitch_max);
        
        return self;
    }
    
    /// @deprecated
    static typewriter_function = function(_function)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.function_per_char(_function);
        
        return self;
    }

    /// @deprecated
    static typewriter_pause = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.pause();
        
        return self;
    }

    /// @deprecated    
    static typewriter_unpause = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.unpause();
        
        return self;
    }
    /// @deprecated    
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

    /// @deprecated    
    static get_typewriter_state = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return 1.0;
        
        return __tw_legacy_typist.get_state();
    }

     /// @deprecated   
    static get_typewriter_paused = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return false;
        
        return __tw_legacy_typist.get_paused();
    }
    
    /// @deprecated    
    static get_typewriter_pos = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://www.jujuadams.com/Scribble/\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return 0;
        
        return __tw_legacy_typist.get_position();
    }
    
    #endregion
}