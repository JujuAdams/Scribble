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
    
    tw_window       = 0;
    tw_window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, 0.0);
    tw_do           = false;
    tw_in           = true;
    tw_skip         = false;
    tw_backwards    = false;
    tw_function     = undefined;
    tw_paused       = false;
    tw_delay_paused = false;
    tw_delay_end    = -1;
    
    tw_event_previous       = -1;
    tw_event_char_previous  = -1;
    tw_event_visited_struct = {};
    
    tw_sound_array       = undefined;
    tw_sound_overlap     = 0;
    tw_sound_pitch_min   = 1;
    tw_sound_pitch_max   = 1;
    tw_sound_per_char    = false;
    tw_sound_finish_time = current_time;
    
    tw_anim_speed          = 1;
    tw_anim_smoothness     = 0;
    tw_inline_speed        = 1;
    tw_anim_ease_method    = SCRIBBLE_EASE.LINEAR;
    tw_anim_dx             = 0;
    tw_anim_dy             = 0;
    tw_anim_xscale         = 1;
    tw_anim_yscale         = 1;
    tw_anim_rotation       = 0;
    tw_anim_alpha_duration = 1.0;
    
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
    static overwrite = function()
    {
        text      = argument[0];
        unique_id = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : unique_id;
        
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
                    starting_colour = _colour;
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
        
        blend_colour = _colour;
        blend_alpha  = _alpha;
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
    /// @param [maxHeight]
    /// @param [characterWrap]
    static wrap = function()
    {
        var _wrap_max_width  = argument[0];
        var _wrap_max_height = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : -1;
        var _wrap_per_char   = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;
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
    /// @param [characterWrap]
    static fit_to_box = function()
    {
        var _wrap_max_width  = argument[0];
        var _wrap_max_height = argument[1];
        var _wrap_per_char   = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;
        var _wrap_no_pages   = true;
        
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
    /// @param [executeOnlyOnChange]
    static template = function()
    {
        var _template  = argument[0];
        var _on_change = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : false;
        
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
        var _old_page = __page;
        __page = _page;
        if (_old_page != __page) __refresh_typewriter_for_page();
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
        
        fog_colour = _colour;
        fog_alpha  = _alpha;
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
    
    /// @param x1
    /// @param y1
    /// @param x2
    /// @param y2
    /// @param x3
    /// @param y3
    /// @param x4
    /// @param y4
    static bezier = function()
    {
        if (argument_count <= 0)
        {
            var _bezier_array = array_create(6, 0.0);
        }
        else if (argument_count == 8)
        {
            var _bezier_array = [argument[2] - argument[0], argument[3] - argument[1],
                                 argument[4] - argument[0], argument[5] - argument[1],
                                 argument[6] - argument[0], argument[7] - argument[1]];
        }
        else
        {
            __scribble_error("Wrong number of arguments (", argument_count, ") provided\nExpecting 0 or 8");
        }
        
        if (!array_equals(bezier_array, _bezier_array))
        {
            model_cache_name_dirty = true;
            bezier_array = _bezier_array;
        }
        
        return self;
    }
    
    #endregion
    
    #region Typewriter Setters
    
    static typewriter_off = function()
    {
        if (tw_do) __refresh_typewriter_for_page();
        tw_do = false;
        return self;
    }
    
    static typewriter_reset = function()
    {
        __refresh_typewriter_for_page();
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    static typewriter_in = function(_speed, _smoothness)
    {
        tw_do              = true;
        tw_in              = true;
        tw_backwards       = false;
        tw_anim_speed      = _speed;
        tw_anim_smoothness = _smoothness;
        
        if (!tw_do || !tw_in) __refresh_typewriter_for_page();
        if (_speed > SCRIBBLE_SKIP_SPEED_THRESHOLD) typewriter_skip();
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards]
    static typewriter_out = function()
    {
        var _speed      = argument[0];
        var _smoothness = argument[1];
        var _backwards  = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;
        
        tw_do              = true;
        tw_in              = false;
        tw_backwards       = _backwards;
        tw_anim_speed      = _speed;
        tw_anim_smoothness = _smoothness;
        
        if (!tw_do || tw_in) __refresh_typewriter_for_page();
        if (_speed > SCRIBBLE_SKIP_SPEED_THRESHOLD) typewriter_skip();
        
        return self;
    }
    
    static typewriter_skip = function()
    {
        tw_skip = true;
        return self;
    }
    
    /// @param soundArray
    /// @param overlap
    /// @param pitchMin
    /// @param pitchMax
    static typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        tw_sound_array     = _sound_array;
        tw_sound_overlap   = _overlap;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = false;
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    static typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        tw_sound_array     = _sound_array;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = true;
        return self;
    }
    
    static typewriter_function = function(_function)
    {
        tw_function = _function;
        return self;
    }
    
    static typewriter_pause = function()
    {
        tw_paused = true;
        return self;
    }
    
    static typewriter_unpause = function()
    {
        if (tw_paused)
        {
            var _old_head_pos = tw_window_array[@ tw_window];
            
            //Increment the window index
            tw_window = (tw_window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
            
            tw_window_array[@ tw_window  ] = _old_head_pos;
            tw_window_array[@ tw_window+1] = _old_head_pos - tw_anim_smoothness;
        }
        
        tw_paused = false;
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
        tw_anim_ease_method    = _ease_method;
        tw_anim_dx             = _dx;
        tw_anim_dy             = _dy;
        tw_anim_xscale         = _xscale;
        tw_anim_yscale         = _yscale;
        tw_anim_rotation       = _rotation;
        tw_anim_alpha_duration = _alpha_duration;
        return self;
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
        if (is_struct(_source_element) && (_source_element != SCRIBBLE_NULL_ELEMENT))
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
    
    /// @param [x]
    /// @param [y]
    /// @param [leftPad]
    /// @param [topPad]
    /// @param [rightPad]
    /// @param [bottomPad]
    static get_bbox = function()
    {
        var _x        = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 0;
        var _y        = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
        var _margin_l = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
        var _margin_t = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
        var _margin_r = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
        var _margin_b = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
        
        var _model = __get_model(true);
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
        return __get_model(true).get_width();
    }
    
    static get_height = function()
    {
        return __get_model(true).get_height();
    }
    
    static get_page = function()
    {
        return __page;
    }
    
    static get_pages = function()
    {
        return __get_model(true).get_pages();
    }
	
	/// @param [page]
	static get_page_height = function()
	{
		var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
		
		return __get_model(true).get_page_height(_page);
	}
	
	/// @param [page]
	static get_page_width = function()
	{
		var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
		
		return __get_model(true).get_page_width(_page);
	}
    
    static on_last_page = function()
    {
        return (get_page() >= get_pages() - 1);
    }
    
    static get_typewriter_state = function()
    {
        //Early out if the method is NONE
        if (!tw_do) return 1.0; //No fade in/out set
        
        var _pages_array = __get_model(true).get_page_array();
        if (array_length(_pages_array) == 0) return 1.0;
        
        var _page_data = _pages_array[__page];
        var _min = _page_data.start_char;
        var _max = _page_data.last_char;
        
        if (_max <= _min) return 1.0;
        _max += 2; //Bit of a hack
        
        var _t = clamp((tw_window_array[tw_window] - _min) / (_max - _min), 0, 1);
        return tw_in? _t : (_t + 1);
    }
    
    static get_typewriter_paused = function()
    {
        return tw_paused;
    }
    
    static get_typewriter_pos = function()
    {
        if (!tw_do || !tw_in) return 0.0;
        
        return tw_window_array[tw_window];
    }
    
    static get_wrapped = function()
    {
        return __get_model(true).get_wrapped();
    }
    
    /// @param [page]
    static get_line_count = function()
    {
        var _page = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __page;
        
        return __get_model(true).get_line_count(_page);
    }
    
    static get_ltrb_array = function()
    {
        return __get_model(true).get_ltrb_array();
    }
    
    #endregion
    
    #region Public Methods
    
    /// @param x
    /// @param y
    static draw = function(_x, _y)
    {
        //Get our model, and create one if needed
        var _model = __get_model(true);
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (current_time - last_drawn > __SCRIBBLE_EXPECTED_FRAME_TIME)
        {
            animation_time += animation_tick_speed__*SCRIBBLE_TICK_SIZE;
            if (SCRIBBLE_SAFELY_WRAP_TIME) animation_time = animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
            if (tw_do) __update_typewriter(); //Also update the typewriter too
        }
        
        last_drawn = current_time;
        
        //Update the blink state
        animation_blink_state = (((animation_time + animation_blink_time_offset) mod (animation_blink_on_duration + animation_blink_off_duration)) < animation_blink_on_duration);
        
        #region Prepare shaders for drawing
        
        if (tw_do)
        {
            var _tw_method = tw_anim_ease_method;
            var _tw_char_max = 0;
            
            if (!tw_in) _tw_method += SCRIBBLE_EASE.__SIZE;
            if (tw_backwards) _tw_char_max = 1 + last_char - start_char;
        }
        
        if (_model.uses_standard_font)
        {
            shader_set(__shd_scribble);
            shader_set_uniform_f(global.__scribble_u_fTime, animation_time);
            
            shader_set_uniform_f(global.__scribble_u_vColourBlend, colour_get_red(  blend_colour)/255,
                                                                   colour_get_green(blend_colour)/255,
                                                                   colour_get_blue( blend_colour)/255,
                                                                   blend_alpha);
            
            shader_set_uniform_f(global.__scribble_u_vFog, colour_get_red(  fog_colour)/255,
                                                           colour_get_green(fog_colour)/255,
                                                           colour_get_blue( fog_colour)/255,
                                                           fog_alpha);
            
            shader_set_uniform_f_array(global.__scribble_u_aDataFields, animation_array);
            shader_set_uniform_f_array(global.__scribble_u_aBezier, bezier_array);
            shader_set_uniform_f(global.__scribble_u_fBlinkState, animation_blink_state);
            
            if (tw_do)
            {
                shader_set_uniform_i(global.__scribble_u_iTypewriterMethod,            _tw_method);
                shader_set_uniform_i(global.__scribble_u_iTypewriterCharMax,           _tw_char_max);
                shader_set_uniform_f(global.__scribble_u_fTypewriterSmoothness,        tw_anim_smoothness);
                shader_set_uniform_f(global.__scribble_u_vTypewriterStartPos,          tw_anim_dx, tw_anim_dy);
                shader_set_uniform_f(global.__scribble_u_vTypewriterStartScale,        tw_anim_xscale, tw_anim_yscale);
                shader_set_uniform_f(global.__scribble_u_fTypewriterStartRotation,     tw_anim_rotation);
                shader_set_uniform_f(global.__scribble_u_fTypewriterAlphaDuration,     tw_anim_alpha_duration);
                shader_set_uniform_f_array(global.__scribble_u_fTypewriterWindowArray, tw_window_array);
            }
            else
            {
                shader_set_uniform_i(global.__scribble_u_iTypewriterMethod, 0);
            }
            
            shader_reset();
        }
        
        if (_model.uses_msdf_font)
        {
            shader_set(__shd_scribble_msdf);
            shader_set_uniform_f(global.__scribble_msdf_u_fTime, animation_time);
                    
            shader_set_uniform_f(global.__scribble_msdf_u_vColourBlend, colour_get_red(  blend_colour)/255,
                                                                        colour_get_green(blend_colour)/255,
                                                                        colour_get_blue( blend_colour)/255,
                                                                        blend_alpha);
                    
            shader_set_uniform_f(global.__scribble_msdf_u_vFog, colour_get_red(  fog_colour)/255,
                                                                colour_get_green(fog_colour)/255,
                                                                colour_get_blue( fog_colour)/255,
                                                                fog_alpha);
                    
            shader_set_uniform_f_array(global.__scribble_msdf_u_aDataFields, animation_array);
            shader_set_uniform_f_array(global.__scribble_msdf_u_aBezier, bezier_array);
            shader_set_uniform_f(global.__scribble_msdf_u_fBlinkState, animation_blink_state);
                    
            if (tw_do)
            {
                shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod,            _tw_method);
                shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterCharMax,           _tw_char_max);
                shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterSmoothness,        tw_anim_smoothness);
                shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartPos,          tw_anim_dx, tw_anim_dy);
                shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartScale,        tw_anim_xscale, tw_anim_yscale);
                shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterStartRotation,     tw_anim_rotation);
                shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterAlphaDuration,     tw_anim_alpha_duration);
                shader_set_uniform_f_array(global.__scribble_msdf_u_fTypewriterWindowArray, tw_window_array);
            }
            else
            {
                shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod, 0);
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
    
    static __refresh_typewriter_for_page = function()
    {
        var _pages_array = __get_model(true).get_page_array();
        if (array_length(_pages_array) == 0) exit;
        
        var _page_data = _pages_array[__page];
        
        tw_window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, _page_data.start_char - tw_anim_smoothness);
        tw_window_array[@ 0] += tw_anim_smoothness;
        
        tw_skip = false;
        
        if (tw_in)
        {
            tw_event_previous       = _page_data.start_event - 1;
            tw_event_char_previous  = _page_data.start_char - 1;
            tw_event_visited_struct = {};
        }
    }
    
    static __get_model = function(_allow_create)
    {
        if (flushed || (text == ""))
        {
            model = SCRIBBLE_NULL_MODEL;
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
            else
            {
                if (_allow_create)
                {
                    //Create a new model if required
                    model = new __scribble_class_model(self, model_cache_name);
                }
                else
                {
                    model = undefined;
                }
            }
            
            if (model == undefined) model = SCRIBBLE_NULL_MODEL;
        }
        
        return model;
    }
    
    static __update_typewriter = function()
    {
        if (tw_do) //No fade in/out set
        {
            var _scan_a = 0;
            var _scan_b = 0;
            
            var _skipping         = tw_skip;
            var _typewriter_speed = _skipping? 999999 : (tw_anim_speed*tw_inline_speed*SCRIBBLE_TICK_SIZE);
            var _head_speed       = _typewriter_speed;
            
            var _typewriter_head_pos = tw_window_array[tw_window];
            
            var _model = __get_model(true);
            if (!is_struct(_model)) return undefined;
            
            var _pages_array = __get_model(true).get_page_array();
            if (array_length(_pages_array) == 0) return undefined;
        
            var _page_data = _pages_array[__page];
            var _typewriter_count = _page_data.last_char + 2;
            
            //Handle pausing
            if (tw_paused)
            {
                _head_speed = 0;
            }
            else if (tw_delay_paused)
            {
                if (current_time > tw_delay_end)
                {
                    //We've waited long enough, start showing more text
                    tw_delay_paused = false;
                    
                    //Increment the window index
                    tw_window = (tw_window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
                    tw_window_array[@ tw_window  ] = _typewriter_head_pos;
                    tw_window_array[@ tw_window+1] = _typewriter_head_pos - tw_anim_smoothness;
                }
                else
                {
                    _head_speed = 0;
                }
            }
            
            if (_head_speed > 0)
            {
                if (tw_in)
                {
                    #region Scan for autotype events
                    
                    //Find the last character we need to scan
                    var _scan_b = min(ceil(_typewriter_head_pos + _head_speed), _typewriter_count);
                    
                    var _scan_a = tw_event_char_previous;
                    var _scan = _scan_a;
                    if (_scan_b > _scan_a)
                    {
                        var _events_char_array = _model.events_char_array;
                        var _events_name_array = _model.events_name_array;
                        var _events_data_array = _model.events_data_array;
                        var _event_count       = array_length(_events_char_array);
                        
                        var _event                 = tw_event_previous;
                        var _events_visited_struct = tw_event_visited_struct;
                        
                        //Always start scanning at the next event
                        ++_event;
                        if (_event < _event_count)
                        {
                            var _event_char = _events_char_array[_event];
                            
                            //Now iterate from our current character position to the next character position
                            var _break = false;
                            repeat(_scan_b - _scan_a)
                            {
                                while ((_event < _event_count) && (_event_char == _scan))
                                {
                                    var _event_name       = _events_name_array[_event];
                                    var _event_data_array = _events_data_array[_event];
                                    
                                    if (!variable_struct_exists(_events_visited_struct, _event))
                                    {
                                        variable_struct_set(_events_visited_struct, _event, true);
                                        tw_event_previous = _event;
                                        
                                        //Process pause and delay events
                                        if (_event_name == "pause")
                                        {
                                            if (!_skipping) tw_paused = true;
                                        }
                                        else if (_event_name == "delay")
                                        {
                                            if (!_skipping)
                                            {
                                                var _duration = (array_length(_event_data_array) >= 1)? real(_event_data_array[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                                                tw_delay_paused = true;
                                                tw_delay_end    = current_time + _duration;
                                            }
                                        }
                                        else if (_event_name == "speed")
                                        {
                                            if (array_length(_event_data_array) >= 1)
                                            {
                                                tw_inline_speed = real(_event_data_array[0]);
                                            }
                                        }
                                        else if (_event_name == "/speed")
                                        {
                                            tw_inline_speed = 1;
                                        }
                                        else if (_event_name == "__scribble_audio_playback__")
                                        {
                                            audio_play_sound(_event_data_array[0], 1, false);
                                        }
                                        else
                                        {
                                            //Otherwise try to find a custom event
                                            var _function = global.__scribble_typewriter_events[? _event_name];
                                            if (is_method(_function))
                                            {
                                                with(other) _function(self, _event_data_array, _scan);
                                            }
                                            else if (is_real(_function) && script_exists(_function))
                                            {
                                                with(other) script_execute(_function, self, _event_data_array, _scan);
                                            }
                                        }
                                        
                                        if (tw_paused || tw_delay_paused)
                                        {
                                            _head_speed = _scan - _typewriter_head_pos;
                                            _break = true;
                                            break;
                                        }
                                    }
                                    
                                    ++_event;
                                    if (_event < _event_count) _event_char = _events_char_array[_event];
                                }
                                
                                if (_break) break;
                                ++_scan;
                            }
                            
                            tw_event_char_previous = _scan;
                        }
                        else
                        {
                            tw_event_char_previous = _scan_b;
                        }
                    }
                    
                    _typewriter_head_pos = clamp(_typewriter_head_pos + _head_speed, 0, _typewriter_count);
                    tw_window_array[@ tw_window] = _typewriter_head_pos;
                    
                    #endregion
                }
                else
                {
                    _typewriter_head_pos = clamp(_typewriter_head_pos + _head_speed, 0, _typewriter_count);
                    tw_window_array[@ tw_window] = _typewriter_head_pos;
                }
            }
            
            //Move the typewriter head/tail
            var _i = 0;
            repeat(__SCRIBBLE_WINDOW_COUNT)
            {
                tw_window_array[@ _i+1] = min(tw_window_array[_i+1] + _typewriter_speed, tw_window_array[_i]);
                _i += 2;
            }
            
            //Execute per character code if...
            if (tw_in                             //We're fading in
            && (_head_speed > 0)                  //If we're going somewhere
            && (floor(_scan_b) > floor(_scan_a))) //If a new character has been revealed
            {
                #region Play a sound effect as the text is revealed
                
                if (floor(_scan_b) < _typewriter_count) //Don't play audio if the character we've revealed is outside the limits of this page's string
                {
                    var _sound_array = tw_sound_array;
                    if (is_array(_sound_array) && (array_length(_sound_array) > 0))
                    {
                        var _play_sound = false;
                        if (tw_sound_per_char)
                        {
                            _play_sound = true;
                        }
                        else if (current_time >= tw_sound_finish_time) 
                        {
                            _play_sound = true;
                        }
                        
                        if (_play_sound)
                        {
                            var _inst = audio_play_sound(_sound_array[floor(__scribble_random()*array_length(_sound_array))], 0, false);
                            audio_sound_pitch(_inst, lerp(tw_sound_pitch_min, tw_sound_pitch_max, __scribble_random()));
                            tw_sound_finish_time = current_time + 1000*audio_sound_length(_inst) - tw_sound_overlap;
                        }
                    }
                }
                
                #endregion
                
                if (is_method(tw_function))
                {
                    tw_function(self, tw_window_array[tw_window] - 1);
                }
                else if (is_real(tw_function) && script_exists(tw_function))
                {
                    script_execute(tw_function, self, tw_window_array[tw_window] - 1);
                }
            }
        }
    }
    
    #endregion
    
    //Apply the default template
    __scribble_config_default_template();
}