function __scribble_element(_string, _unique_id) constructor
{
    text = _string;
    unique_id = _unique_id;
    global.__scribble_element_cache[? _string + ":" + _unique_id] = self;
    
    model = undefined;
    
    last_drawn = current_time;
    freeze = false;
    
    animation_array = array_create(SCRIBBLE_ANIM.__SIZE, 0.0);
    animation_array[@ SCRIBBLE_ANIM.WAVE_SIZE       ] =  4;
    animation_array[@ SCRIBBLE_ANIM.WAVE_FREQ       ] = 50;
    animation_array[@ SCRIBBLE_ANIM.WAVE_SPEED      ] =  0.2;
    animation_array[@ SCRIBBLE_ANIM.SHAKE_SIZE      ] =  2;
    animation_array[@ SCRIBBLE_ANIM.SHAKE_SPEED     ] =  0.4;
    animation_array[@ SCRIBBLE_ANIM.RAINBOW_WEIGHT  ] =  0.5;
    animation_array[@ SCRIBBLE_ANIM.RAINBOW_SPEED   ] =  0.01;
    animation_array[@ SCRIBBLE_ANIM.WOBBLE_ANGLE    ] = 40;
    animation_array[@ SCRIBBLE_ANIM.WOBBLE_FREQ     ] =  0.15;
    animation_array[@ SCRIBBLE_ANIM.PULSE_SCALE     ] =  0.4;
    animation_array[@ SCRIBBLE_ANIM.PULSE_SPEED     ] =  0.1;
    animation_array[@ SCRIBBLE_ANIM.WHEEL_SIZE      ] =  1;
    animation_array[@ SCRIBBLE_ANIM.WHEEL_FREQ      ] =  0.5;
    animation_array[@ SCRIBBLE_ANIM.WHEEL_SPEED     ] =  0.2;
    animation_array[@ SCRIBBLE_ANIM.CYCLE_SPEED     ] =  0.3;
    animation_array[@ SCRIBBLE_ANIM.CYCLE_SATURATION] =  255;
    animation_array[@ SCRIBBLE_ANIM.CYCLE_VALUE     ] =  255;
    animation_array[@ SCRIBBLE_ANIM.JITTER_MINIMUM  ] =  0.8;
    animation_array[@ SCRIBBLE_ANIM.JITTER_MAXIMUM  ] =  1.2;
    animation_array[@ SCRIBBLE_ANIM.JITTER_SPEED    ] =  0.4;
    
    #region Setters
    
    /// @param fontName
    /// @param colour
    /// @param halign
    /// @param valign
    starting_format = function(_font_name, _colour, _halign, _valign)
    {
        if (is_string(_font_name))
        {
            starting_font = _font_name;
        }
        else if (!is_undefined(_font_name))
        {
            show_error("Scribble:\nFonts should be specified using their name as a string\nUse <undefined> to not set a new font\n ", false);
        }
        
        if (_colour != undefined)
        {
            if (is_string(_colour))
            {
                _colour = global.__scribble_colours[? _colour];
                if (_colour == undefined)
                {
                    show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
                }
            }
        
            if ((_colour != undefined) && (_colour >= 0)) starting_colour = _colour;
        }
        
        if ((_halign != undefined) && (_halign >= 0)) starting_halign = _halign;
        if ((_valign != undefined) && (_valign >= 0)) starting_valign = _valign;
        
        return self;
    }
    
    /// @param colour
    /// @param alpha
    blend = function(_colour, _alpha)
    {
        if (is_string(_colour))
        {
            _colour = global.__scribble_colours[? _colour];
            if (_colour == undefined)
            {
                show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
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
    transform = function(_xscale, _yscale, _angle)
    {
        xscale = _xscale;
        yscale = _yscale;
        angle  = _angle;
        return self;
    }
    
    /// @param xOffset
    /// @param yOffset
    origin = function(_x, _y)
    {
        origin_x = _x;
        origin_y = _y;
        return self;
    }
    
    /// @param maxWidth
    /// @param maxHeight
    /// @param characterWrap
    wrap = function(_max_width, _max_height, _character_wrap)
    {
        max_width      = _max_width;
        max_height     = _max_height;
        character_wrap = _character_wrap;
        return self;
    }
    
    /// @param min
    /// @param max
    line_height = function(_min, _max)
    {
        line_height_min = _min;
        line_height_max = _max;
        return self;
    }
    
    /// @param templateFunction/array
    template = function(_template)
    {
        if (is_array(_template))
        {
            var _i = 0;
            repeat(array_length(_template))
            {
                _template[_i]();
                ++_i;
            }
        }
        else
        {
            _template();
        }
        
        return self;
    }
    
    /// @param page
    page = function(_page)
    {
        if ((_page < 0) || (_page >= get_pages())) throw "!";
        
        __page = _page;
        return self;
    }
    
    /// @param property
    /// @param value
    animation = function(_property, _value)
    {
        animation_array[@ _property] = _value;
        return self;
    }
    
    /// @param colour
    /// @param alpha
    fog = function(_colour, _alpha)
    {
        if (is_string(_colour))
        {
            _colour = global.__scribble_colours[? _colour];
            if (_colour == undefined)
            {
                show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
                exit;
            }
        }
        
        fog_colour = _colour;
        fog_alpha  = _alpha;
        return self;
    }
    
    /// @param state
    ignore_command_tags = function(_state)
    {
        __ignore_command_tags = _state;
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
    bezier = function()
    {
        if (argument_count <= 0)
        {
    	    bezier_array = array_create(6, 0.0);
        }
        else if (argument_count == 8)
        {
    	    bezier_array = [argument[2] - argument[0], argument[3] - argument[1],
                            argument[4] - argument[0], argument[5] - argument[1],
                            argument[6] - argument[0], argument[7] - argument[1]];
        }
        else
        {
            show_error("Scribble:\nWrong number of arguments (" + string(argument_count) + ") provided\nExpecting 0 or 8\n ", false);
        }
    }
    
    #endregion
    
    #region Typewriter Setters
    
    typewriter_off = function()
    {
        tw_do = false;
        return undefined;
    }
    
    typewriter_in = function(_speed, _smoothness)
    {
        tw_do         = true;
        tw_in         = true;
        tw_speed      = _speed;
        tw_smoothness = _smoothness;
        return self;
    }
    
    typewriter_out = function(_speed, _smoothness)
    {
        tw_do         = true;
        tw_in         = false;
        tw_speed      = _speed;
        tw_smoothness = _smoothness;
        return self;
    }
    
    typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        tw_sound_array     = _sound_array;
        tw_sound_overlap   = _overlap;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = false;
        return self;
    }
    
    typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        tw_sound_array     = _sound_array;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = true;
        return self;
    }
    
    typewriter_function = function(_function)
    {
        tw_function = _function;
        return self;
    }
    
    typewriter_character_delay = function(_character, _delay)
    {
        __scribble_trace("typewriter_character_delay() not implemented");
        return self;
    }
    
    set_typewriter_paused = function(_state)
    {
        tw_paused = _state;
        return self;
    }
    
    #endregion
    
    #region Getters
    
    get_bbox = function()
    {
        var _x        = argument[0];
        var _y        = argument[1];
        var _margin_l = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
        var _margin_t = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
        var _margin_r = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
        var _margin_b = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
        
        var _model_bbox = __get_cache().get_bbox(SCRIBBLE_BOX_ALIGN_TO_PAGE? __page : undefined);
        
        switch(valign)
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
        	var _l = _x + _model_bbox.left  - _margin_l;
        	var _t = _y + _bbox_t           - _margin_t;
        	var _r = _x + _model_bbox.right + _margin_r;
        	var _b = _y + _bbox_b           + _margin_b;
            
        	var _x0 = _l;   var _y0 = _t;
        	var _x1 = _r;   var _y1 = _t;
        	var _x2 = _l;   var _y2 = _b;
        	var _x3 = _r;   var _y3 = _b;
        }
        else
        {
            //TODO - Make this faster with custom code
        	var _matrix = matrix_build(_x, _y, 0, 
        	                            0, 0, angle,
        	                            xscale, yscale, 1);
            
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
                 
                 x0: _x0,
                 y0: _y0,
                 x1: _x1,
                 y1: _y1,
                 x2: _x2,
                 y2: _y2,
                 x3: _x3,
                 y3: _y3 };
    }
    
    get_width = function()
    {
        return __get_cache().get_width();
    }
    
    get_height = function()
    {
        return __get_cache().get_height();
    }
    
    get_page = function()
    {
        return __page;
    }
    
    get_pages = function()
    {
        return __get_cache().get_pages();
    }
    
    get_typewriter_state = function()
    {
        __scribble_trace("get_typewriter_state() not implemented");
        return undefined;
    }
    
    get_typewriter_paused = function()
    {
        return tw_paused;
    }
    
    #endregion
    
    draw = function(_x, _y)
    {
        __get_model().draw(_x, _y);
        return undefined;
    }
    
    flush_now = function()
    {
        if (is_struct(model)) model.flush();
        model = undefined;
        
        return undefined;
    }
    
    cache_now = function(_freeze)
    {
        freeze = _freeze;
        
    	var _model_cache_name = text +
                                string(starting_font  ) + ":" +
    	                        string(starting_color ) + ":" +
    	                        string(starting_halign) + ":" +
    	                        string(starting_valign) + ":" +
    	                        string(line_height_min) + ":" +
    	                        string(line_height_max) + ":" +
    	                        string(max_width      ) + ":" +
    	                        string(max_height     ) + ":" +
    	                        string(character_wrap ) + ":" +
                                string(bezier_array   ) + ":" +
                                string(__ignore_command_tags);
        
        model = global.__scribble_model_cache[? _model_cache_name];
        if (model == undefined) model = new __scribble_model(self);
        
        return undefined;
    }
    
    __get_model = function()
    {
        cache_now(freeze);
        return model;
    }
    
    //Apply the default template
    template(scribble_default_template);
}