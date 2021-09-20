/// @param string
/// @param uniqueID

function __scribble_class_element(_string, _unique_id) constructor
{
    text       = _string;
    unique_id  = _unique_id;
    cache_name = _string + ":" + _unique_id;
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching element \"" + cache_name + "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = global.__scribble_ecache_dict[? cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.flushed)
    {
        __scribble_trace("Warning! Flushing element \"", cache_name, "\" due to cache name collision");
        _weak.ref.flush();
    }
    
    //Add this text element to the global cache
    global.__scribble_ecache_dict[? cache_name] = weak_ref_create(self);
    ds_list_add(global.__scribble_ecache_list, self);
    ds_list_add(global.__scribble_ecache_name_list, cache_name);
    
    flushed = false;
    
    model_cache_name_dirty = true;
    model_cache_name = undefined;
    model = undefined;
    
    last_drawn = current_time;
    freeze = false;
    
    starting_font   = SCRIBBLE_DEFAULT_FONT;
    starting_colour = c_white;
    starting_halign = fa_left;
    starting_valign = fa_top;
    
    blend_colour = c_white;
    blend_alpha  = 1.0;
    
    fog_colour = c_white;
    fog_alpha  = 0.0;
    
    gradient_colour = c_black;
    gradient_alpha  = 0.0;
    
    xscale = 1.0;
    yscale = 1.0;
    angle  = 0.0;
    
    origin_x = 0.0;
    origin_y = 0.0;
    
    wrap_max_width  = -1;
    wrap_max_height = -1;
    wrap_per_char   = false;
    wrap_no_pages   = false;
    
    line_height_min = -1;
    line_height_max = -1;
    
    __page = 0;
    __ignore_command_tags = false;
    __template = __scribble_config_default_template;
    
    bezier_array = array_create(6, 0.0);
    
    __tw_reveal              = undefined;
    __tw_reveal_window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, 0.0);
    
    if (!SCRIBBLE_WARNING_LEGACY_TYPEWRITER)
    {
        //If we're permitting use of legacy typewriter functions, create a private typist for this specific text element
        __tw_legacy_typist = scribble_typist();
        __tw_legacy_typist.__associate(self);
        
        __tw_legacy_typist_use = false;
    }
    
    animation_time               = current_time;
    animation_tick_speed__       = 1;
    animation_array              = array_create(__SCRIBBLE_ANIM.__SIZE, 0.0);
    animation_blink_on_duration  = 8;
    animation_blink_off_duration = 8;
    animation_blink_time_offset  = 0;
    animation_blink_state        = true;
    
    msdf_shadow_colour  = c_black;
    msdf_shadow_alpha   = 0.0;
    msdf_shadow_xoffset = 0;
    msdf_shadow_yoffset = 0;
    
    msdf_border_colour    = c_black;
    msdf_border_thickness = 0.0;
    
    msdf_feather_thickness = 1.0;
    
    
    
    #region Setters
    
    /// @param string
    /// @param [uniqueID]
    static overwrite = function(_text, _unique_id = unique_id)
    {
        text      = _text;
        unique_id = _unique_id;
        
        var _new_cache_name = text + ":" + unique_id;
        if (cache_name != _new_cache_name)
        {
            flush();
            flushed = false;
            
            model_cache_name_dirty = true;
            cache_name = _new_cache_name;
            
            var _weak = global.__scribble_ecache_dict[? cache_name];
            if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.flushed)
            {
                __scribble_trace("Warning! Flushing element \"", cache_name, "\" due to cache name collision (try choosing a different unique ID)");
                _weak.ref.flush();
            }
            
            //Add this text element to the global cache
            global.__scribble_ecache_dict[? cache_name] = weak_ref_create(self);
            ds_list_add(global.__scribble_ecache_list, self);
            ds_list_add(global.__scribble_ecache_name_list, cache_name);
        }
        
        return self;
    }
    
    /// @param fontName
    /// @param colour
    static starting_format = function(_font_name, _colour)
    {
        if (is_string(_font_name))
        {
            if (_font_name != starting_font)
            {
                model_cache_name_dirty = true;
                starting_font = _font_name;
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
                if (_colour != starting_colour)
                {
                    model_cache_name_dirty = true;
                    starting_colour = _colour & 0xFFFFFF;
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
        
        if (_halign != starting_halign)
        {
            model_cache_name_dirty = true;
            starting_halign = _halign;
        }
        
        if (_valign != starting_valign)
        {
            model_cache_name_dirty = true;
            starting_valign = _valign;
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
        
        if (_colour != undefined) blend_colour = _colour & 0xFFFFFF;
        if (_alpha  != undefined) blend_alpha  = _alpha;
        
        return self;
    }
    
    /// @param xScale
    /// @param yScale
    /// @param angle
    static transform = function(_xscale, _yscale, _angle)
    {
        xscale = _xscale;
        yscale = _yscale;
        angle  = _angle;
        return self;
    }
    
    /// @param xOffset
    /// @param yOffset
    static origin = function(_x, _y)
    {
        origin_x = _x;
        origin_y = _y;
        return self;
    }
    
    /// @param maxWidth
    /// @param [maxHeight=-1]
    /// @param [characterWrap=false]
    static wrap = function(_wrap_max_width, _wrap_max_height = -1, _wrap_per_char = false)
    {
        var _wrap_no_pages   = false;
        
        if ((_wrap_max_width  != wrap_max_width)
        ||  (_wrap_max_height != wrap_max_height)
        ||  (_wrap_per_char   != wrap_per_char)
        ||  (_wrap_no_pages   != wrap_no_pages))
        {
            model_cache_name_dirty = true;
            wrap_max_width  = _wrap_max_width;
            wrap_max_height = _wrap_max_height;
            wrap_per_char   = _wrap_per_char;
            wrap_no_pages   = _wrap_no_pages;
        }
        
        return self;
    }
    
    /// @param maxWidth
    /// @param maxHeight
    /// @param [characterWrap=false]
    static fit_to_box = function(_wrap_max_width, _wrap_max_height, _wrap_per_char = false)
    {
        var _wrap_no_pages = true;
        
        if ((_wrap_max_width  != wrap_max_width)
        ||  (_wrap_max_height != wrap_max_height)
        ||  (_wrap_per_char   != wrap_per_char)
        ||  (_wrap_no_pages   != wrap_no_pages))
        {
            model_cache_name_dirty = true;
            wrap_max_width  = _wrap_max_width;
            wrap_max_height = _wrap_max_height;
            wrap_per_char   = _wrap_per_char;
            wrap_no_pages   = _wrap_no_pages;
        }
        
        return self;
    }
    
    /// @param min
    /// @param max
    static line_height = function(_min, _max)
    {
        if (_min != line_height_min)
        {
            model_cache_name_dirty = true;
            line_height_min = _min;
        }
        
        if (_max != line_height_max)
        {
            model_cache_name_dirty = true;
            line_height_max = _max;
        }
        
        return self;
    }
    
    /// @param templateFunction/Array
    /// @param [executeOnlyOnChange=false]
    static template = function(_template, _on_change = false)
    {
        if (is_array(_template))
        {
            if (!_on_change || !is_array(__template) || !array_equals(__template, _template))
            {
                __template = _template;
                
                var _i = 0;
                repeat(array_length(_template))
                {
                    _template[_i]();
                    ++_i;
                }
            }
        }
        else
        {
            if (!_on_change || is_array(__template) || (__template != _template))
            {
                __template = _template;
                
                _template();
            }
        }
        
        return self;
    }
    
    /// @param page
    static page = function(_page)
    {
        __page = _page;
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    static fog = function(_colour, _alpha)
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
        
        fog_colour = _colour & 0xFFFFFF;
        fog_alpha  = _alpha;
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
        
        gradient_colour = _colour & 0xFFFFFF;
        gradient_alpha  = _alpha;
        return self;
    }
    
    /// @param state
    static ignore_command_tags = function(_state)
    {
        if (__ignore_command_tags != _state)
        {
            model_cache_name_dirty = true;
            __ignore_command_tags = _state;
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
        
        var _bezier_array = [_x2 - _x1, _y2 - _y1,
                             _x3 - _x1, _y3 - _y1,
                             _x4 - _x1, _y4 - _y1];
        
        if (!array_equals(bezier_array, _bezier_array))
        {
            model_cache_name_dirty = true;
            bezier_array = _bezier_array;
        }
        
        return self;
    }
    
    static reveal = function(_character)
    {
        //Don't regenerate the array unless we really have to
        if (__tw_reveal != _character)
        {
            __tw_reveal = _character;
            __tw_reveal_window_array[@ 0] = _character;
        }
        
        return self;
    }
    
    static reveal_get = function()
    {
        return __tw_reveal;
    }
    
    static events_get = function()
    {
        var _position = argument[0];
        var _page     = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return [];
        
        var _page = _model.pages_array[_page];
        
        var _events = _page.__events[$ _position];
        if (!is_array(_events)) return [];
        
        return _events;
    }
    
    #endregion
    
    
    
    #region Animation
    
    /// @param tickSpeed
    static animation_tick_speed = function(_speed)
    {
        animation_tick_speed__ = _speed;
        return self;
    }
    
    /// @param sourceElement
    static animation_sync = function(_source_element)
    {
        if (scribble_is_text_element(_source_element))
        {
            animation_time         = _source_element.animation_time;
            animation_tick_speed__ = _source_element.animation_tick_speed__;
        }
        
        return self;
    }
    
    /// @param size
    /// @param frequency
    /// @param speed
    static animation_wave = function(_size, _frequency, _speed)
    {
        animation_array[@ __SCRIBBLE_ANIM.WAVE_SIZE ] = _size;
        animation_array[@ __SCRIBBLE_ANIM.WAVE_FREQ ] = _frequency;
        animation_array[@ __SCRIBBLE_ANIM.WAVE_SPEED] = _speed;
        return self;
    }
    
    /// @param size
    /// @param speed
    static animation_shake = function(_size, _speed)
    {
        animation_array[@ __SCRIBBLE_ANIM.SHAKE_SIZE ] = _size;
        animation_array[@ __SCRIBBLE_ANIM.SHAKE_SPEED] = _speed;
        return self;
    }
    
    /// @param weight
    /// @param speed
    static animation_rainbow = function(_weight, _speed)
    {
        animation_array[@ __SCRIBBLE_ANIM.RAINBOW_WEIGHT] = _weight;
        animation_array[@ __SCRIBBLE_ANIM.RAINBOW_SPEED ] = _speed;
        return self;
    }
    
    /// @param angle
    /// @param frequency
    static animation_wobble = function(_angle, _frequency)
    {
        animation_array[@ __SCRIBBLE_ANIM.WOBBLE_ANGLE] = _angle;
        animation_array[@ __SCRIBBLE_ANIM.WOBBLE_FREQ ] = _frequency;
        return self;
    }
    
    /// @param scale
    /// @param speed
    static animation_pulse = function(_scale, _speed)
    {
        animation_array[@ __SCRIBBLE_ANIM.PULSE_SCALE] = _scale;
        animation_array[@ __SCRIBBLE_ANIM.PULSE_SPEED] = _speed;
        return self;
    }
    
    /// @param size
    /// @param frequency
    /// @param speed
    static animation_wheel = function(_size, _frequency, _speed)
    {
        animation_array[@ __SCRIBBLE_ANIM.WHEEL_SIZE ] = _size;
        animation_array[@ __SCRIBBLE_ANIM.WHEEL_FREQ ] = _frequency;
        animation_array[@ __SCRIBBLE_ANIM.WHEEL_SPEED] = _speed;
        return self;
    }
    
    /// @param size
    /// @param saturation
    /// @param value
    static animation_cycle = function(_speed, _saturation, _value)
    {
        animation_array[@ __SCRIBBLE_ANIM.CYCLE_SPEED     ] = _speed;
        animation_array[@ __SCRIBBLE_ANIM.CYCLE_SATURATION] = _saturation;
        animation_array[@ __SCRIBBLE_ANIM.CYCLE_VALUE     ] = _value;
        return self;
    }
    
    /// @param minScale
    /// @param maxScale
    /// @param speed
    static animation_jitter = function(_min, _max, _speed)
    {
        animation_array[@ __SCRIBBLE_ANIM.JITTER_MINIMUM] = _min;
        animation_array[@ __SCRIBBLE_ANIM.JITTER_MAXIMUM] = _max;
        animation_array[@ __SCRIBBLE_ANIM.JITTER_SPEED  ] = _speed;
        return self;
    }
    
    /// @param onDuration
    /// @param offDuration
    /// @param timeOffset
    static animation_blink = function(_on, _off, _offset)
    {
        animation_blink_on_duration  = _on;
        animation_blink_off_duration = _off;
        animation_blink_time_offset  = _offset;
        return self;
    }
    
    #endregion
    
    
    
    #region MSDF
    
    static msdf_shadow = function(_colour, _alpha, _x_offset, _y_offset)
    {
        msdf_shadow_colour  = _colour;
        msdf_shadow_alpha   = _alpha;
        msdf_shadow_xoffset = _x_offset;
        msdf_shadow_yoffset = _y_offset;
        
        return self;
    }
    
    static msdf_border = function(_colour, _thickness)
    {
        msdf_border_colour    = _colour;
        msdf_border_thickness = _thickness;
        
        return self;
    }
    
    static msdf_feather = function(_thickness)
    {
        msdf_feather_thickness = _thickness;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Getters
    
    /// @param [x=0]
    /// @param [y=0]
    /// @param [leftPad=0]
    /// @param [topPad=0]
    /// @param [rightPad=0]
    /// @param [bottomPad=0]
    static get_bbox = function(_x = 0, _y = 0, _margin_l = 0, _margin_t = 0, _margin_r = 0, _margin_b = 0)
    {
        var _model = __get_model(true);
        if (!is_struct(_model))
        {
            //No extant model, return an empty bounding box
            var _l = _x - _margin_l;
            var _t = _y - _margin_t;
            var _r = _x + _margin_r;
            var _b = _y + _margin_b;
            
            var _x0 = _l;   var _y0 = _t;
            var _x1 = _r;   var _y1 = _t;
            var _x2 = _l;   var _y2 = _b;
            var _x3 = _r;   var _y3 = _b;
        }
        else
        {
            var _model_bbox = _model.get_bbox(SCRIBBLE_BOX_ALIGN_TO_PAGE? __page : undefined);
        
            switch(_model.valign)
            {
                case fa_top:
                    var _bbox_t = 0;
                    var _bbox_b = _model_bbox.height;
                break;
        
                case fa_middle:
                    var _bbox_t = -(_model_bbox.height div 2);
                    var _bbox_b = -_bbox_t;
                break;
        
                case fa_bottom:
                    var _bbox_t = -_model_bbox.height;
                    var _bbox_b = 0;
                break;
            }
        
            if ((xscale == 1) && (yscale == 1) && (angle == 0))
            {
                //Avoid using matrices if we can
                var _l = _x - origin_x + _model_bbox.left  - _margin_l;
                var _t = _y - origin_y + _bbox_t           - _margin_t;
                var _r = _x - origin_x + _model_bbox.right + _margin_r;
                var _b = _y - origin_y + _bbox_b           + _margin_b;
            
                var _x0 = _l;   var _y0 = _t;
                var _x1 = _r;   var _y1 = _t;
                var _x2 = _l;   var _y2 = _b;
                var _x3 = _r;   var _y3 = _b;
            }
            else
            {
                //TODO - Make this faster with custom code
                var _matrix = matrix_build(-origin_x, -origin_y, 0,   0,0,0,   1,1,1);
                    _matrix = matrix_multiply(_matrix, matrix_build(_x, _y, 0,
                                                                    0, 0, angle,
                                                                    xscale, yscale, 1));
            
                var _l = _model_bbox.left  - _margin_l;
                var _t = _bbox_t           - _margin_t;
                var _r = _model_bbox.right + _margin_r;
                var _b = _bbox_b           + _margin_b;
            
                var _vertex = matrix_transform_vertex(_matrix, _l, _t, 0); var _x0 = _vertex[0]; var _y0 = _vertex[1];
                var _vertex = matrix_transform_vertex(_matrix, _r, _t, 0); var _x1 = _vertex[0]; var _y1 = _vertex[1];
                var _vertex = matrix_transform_vertex(_matrix, _l, _b, 0); var _x2 = _vertex[0]; var _y2 = _vertex[1];
                var _vertex = matrix_transform_vertex(_matrix, _r, _b, 0); var _x3 = _vertex[0]; var _y3 = _vertex[1];
            
                var _l = min(_x0, _x1, _x2, _x3);
                var _t = min(_y0, _y1, _y2, _y3);
                var _r = max(_x0, _x1, _x2, _x3);
                var _b = max(_y0, _y1, _y2, _y3);
            }
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
    
    static get_width = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.get_width();
    }
    
    static get_height = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.get_height();
    }
    
    static get_page = function()
    {
        return __page;
    }
    
    static get_pages = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.get_pages();
    }
	
	/// @param [page]
	static get_page_height = function()
	{
		var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
		
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
		return _model.get_page_height(_page);
	}
	
	/// @param [page]
	static get_page_width = function()
	{
		var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
		
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
		return _model.get_page_width(_page);
	}
    
    static on_last_page = function()
    {
        return (get_page() >= get_pages() - 1);
    }
    
    static get_wrapped = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return false;
        return _model.get_wrapped();
    }
    
    /// @param [page]
    static get_line_count = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 0;
        return _model.get_line_count(_page);
    }
    
    static get_ltrb_array = function()
    {
        var _model = __get_model(true);
        if (!is_struct(_model)) return [];
        return _model.get_ltrb_array();
    }
    
    #endregion
    
    
    
    #region Public Methods
    
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
        if (current_time - last_drawn > __SCRIBBLE_EXPECTED_FRAME_TIME)
        {
            animation_time += animation_tick_speed__*SCRIBBLE_TICK_SIZE;
            if (SCRIBBLE_SAFELY_WRAP_TIME) animation_time = animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        last_drawn = current_time;
        
        //Update the blink state
        if (animation_blink_on_duration + animation_blink_off_duration > 0)
        {
            animation_blink_state = (((animation_time + animation_blink_time_offset) mod (animation_blink_on_duration + animation_blink_off_duration)) < animation_blink_on_duration);
        }
        else
        {
            animation_blink_state = true;
        }
        
        #region Prepare shaders for drawing
        
        if (_model.uses_standard_font)
        {
            shader_set(__shd_scribble);
            shader_set_uniform_f(global.__scribble_u_fTime, animation_time);
            
            //TODO - Optimise
            shader_set_uniform_f(global.__scribble_u_vColourBlend, colour_get_red(  blend_colour)/255,
                                                                   colour_get_green(blend_colour)/255,
                                                                   colour_get_blue( blend_colour)/255,
                                                                   blend_alpha);
            
            shader_set_uniform_f(global.__scribble_u_vFog, colour_get_red(  fog_colour)/255,
                                                           colour_get_green(fog_colour)/255,
                                                           colour_get_blue( fog_colour)/255,
                                                           fog_alpha);
            
            shader_set_uniform_f(global.__scribble_u_vGradient, colour_get_red(  gradient_colour)/255,
                                                                colour_get_green(gradient_colour)/255,
                                                                colour_get_blue( gradient_colour)/255,
                                                                gradient_alpha);
            
            shader_set_uniform_f_array(global.__scribble_u_aDataFields, animation_array);
            shader_set_uniform_f_array(global.__scribble_u_aBezier, bezier_array);
            shader_set_uniform_f(global.__scribble_u_fBlinkState, animation_blink_state);
            
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
        
        if (_model.uses_msdf_font)
        {
            shader_set(__shd_scribble_msdf);
            shader_set_uniform_f(global.__scribble_msdf_u_fTime, animation_time);
            
            //TODO - Optimise
            shader_set_uniform_f(global.__scribble_msdf_u_vColourBlend, colour_get_red(  blend_colour)/255,
                                                                        colour_get_green(blend_colour)/255,
                                                                        colour_get_blue( blend_colour)/255,
                                                                        blend_alpha);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vFog, colour_get_red(  fog_colour)/255,
                                                                colour_get_green(fog_colour)/255,
                                                                colour_get_blue( fog_colour)/255,
                                                                fog_alpha);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vGradient, colour_get_red(  gradient_colour)/255,
                                                                     colour_get_green(gradient_colour)/255,
                                                                     colour_get_blue( gradient_colour)/255,
                                                                     gradient_alpha);
            
            shader_set_uniform_f_array(global.__scribble_msdf_u_aDataFields, animation_array);
            shader_set_uniform_f_array(global.__scribble_msdf_u_aBezier, bezier_array);
            shader_set_uniform_f(global.__scribble_msdf_u_fBlinkState, animation_blink_state);
            
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
                shader_set_uniform_i(global.__scribble_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
            }
            
            shader_set_uniform_f(global.__scribble_msdf_u_vShadowOffset, msdf_shadow_xoffset, msdf_shadow_yoffset);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vShadowColour, colour_get_red(  msdf_shadow_colour)/255,
                                                                         colour_get_green(msdf_shadow_colour)/255,
                                                                         colour_get_blue( msdf_shadow_colour)/255,
                                                                         msdf_shadow_alpha);
            
            shader_set_uniform_f(global.__scribble_msdf_u_vBorderColour, colour_get_red(  msdf_border_colour)/255,
                                                                         colour_get_green(msdf_border_colour)/255,
                                                                         colour_get_blue( msdf_border_colour)/255);
            
            shader_set_uniform_f(global.__scribble_msdf_u_fBorderThickness, msdf_border_thickness);
            
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
        
        //Draw the model using ourselves as the context
        _model.draw(_x, _y, self);
        
        //Run the garbage collecter
        __scribble_gc_collect();
        
        return undefined;
    }
    
    static flush = function()
    {
        if (flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing element \"" + string(cache_name) + "\"");
        
        //Remove reference from cache
        ds_map_delete(global.__scribble_ecache_dict, cache_name);
        var _index = ds_list_find_index(global.__scribble_ecache_list, self);
        if (_index >= 0) ds_list_delete(global.__scribble_ecache_list, _index);
        
        //Set as flushed
        flushed = true;
        
        return undefined;
    }
    
     /// @param freeze
    static build = function(_freeze)
    {
        freeze = _freeze;
        
        __get_model(true);
        
        return undefined;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __get_model = function(_allow_create)
    {
        if (flushed || (text == ""))
        {
            model = undefined;
        }
        else
        {
            if (model_cache_name_dirty)
            {
                model_cache_name_dirty = false;
                model_cache_name = text + ":" +
                                   string(starting_font  ) + ":" +
                                   string(starting_colour) + ":" +
                                   string(starting_halign) + ":" +
                                   string(starting_valign) + ":" +
                                   string(line_height_min) + ":" +
                                   string(line_height_max) + ":" +
                                   string(wrap_max_width ) + ":" +
                                   string(wrap_max_height) + ":" +
                                   string(wrap_per_char  ) + ":" +
                                   string(wrap_no_pages  ) + ":" +
                                   string(bezier_array   ) + ":" +
                                   string(__ignore_command_tags);
            }
            
            var _weak = global.__scribble_mcache_dict[? model_cache_name];
            if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.flushed)
            {
                model = _weak.ref;
            }
            else if (_allow_create)
            {
                //Create a new model if required
                model = new __scribble_class_model(self, model_cache_name);
            }
            else
            {
                model = undefined;
            }
        }
        
        return model;
    }
    
    #endregion
    
    
    
    #region Legacy Typewriter Code
    
    static typewriter_off = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (__tw_legacy_typist_use) __tw_legacy_typist.reset();
        __tw_legacy_typist_use = false;
        
        return self;
    }
    
    static typewriter_reset = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        
        __tw_legacy_typist = scribble_typist();
        __tw_legacy_typist.__associate(self);
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    static typewriter_in = function(_speed, _smoothness)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist_use = true;
        __tw_legacy_typist.in(_speed, _smoothness);
        
        if (_speed > SCRIBBLE_SKIP_SPEED_THRESHOLD) __tw_legacy_typist.skip();
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards=false]
    static typewriter_out = function(_speed, _smoothness, _backwards = false)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist_use = true;
        __tw_legacy_typist.out(_speed, _smoothness, _backwards);
        
        if (_speed > SCRIBBLE_SKIP_SPEED_THRESHOLD) __tw_legacy_typist.skip();
        
        return self;
    }
    
    static typewriter_skip = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.skip();
        
        return self;
    }
    
    /// @param soundArray
    /// @param overlap
    /// @param pitchMin
    /// @param pitchMax
    static typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.sound(_sound_array, _overlap, _pitch_min, _pitch_max);
        
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    static typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.sound_per_char(_sound_array, _pitch_min, _pitch_max);
        
        return self;
    }
    
    static typewriter_function = function(_function)
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.function_per_char(_function);
        
        return self;
    }
    
    static typewriter_pause = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.pause();
        
        return self;
    }
    
    static typewriter_unpause = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
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
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        __tw_legacy_typist.ease(_ease_method, _dx, _dy, _xscale, _yscale, _rotation, _alpha_duration);
        
        return self;
    }
    
    static get_typewriter_state = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return 1.0;
        
        return __tw_legacy_typist.get_state();
    }
    
    static get_typewriter_paused = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return false;
        
        return __tw_legacy_typist.get_paused();
    }
    
    static get_typewriter_pos = function()
    {
        if (SCRIBBLE_WARNING_LEGACY_TYPEWRITER) __scribble_error(".typewriter_*() methods have been deprecated\nIt is recommend you move to the new \"typist\" system\nPlease visit https://github.com/JujuAdams/Scribble/wiki/scribble_typist\n \n(Set SCRIBBLE_WARNING_LEGACY_TYPEWRITER to <false> to turn off this warning)");
        
        if (!__tw_legacy_typist_use) return 0;
        
        return __tw_legacy_typist.get_position();
    }
    
    #endregion
    
    
    
    //Apply the default template
    __scribble_config_default_template();
}