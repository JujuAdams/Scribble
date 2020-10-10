/// @param string
/// @param elementCacheName

function __scribble_class_element(_string, _element_cache_name) constructor
{
    text = _string;
    cache_name = _element_cache_name;
    global.__scribble_element_cache[? _element_cache_name] = self;
    
    model = undefined;
    auto_refresh_typewriter = false;
    
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
    
    max_width      = -1;
    max_height     = -1;
    character_wrap = false;
    
    line_height_min = -1;
    line_height_max = -1;
    
    __page = 0;
    __ignore_command_tags = false;
    
    bezier_array = array_create(6, 0.0);
    
    tw_window       = 0;
    tw_window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, 0.0);
    tw_do           = false;
    tw_in           = true;
    tw_speed        = 1;
    tw_smoothness   = 0;
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
    
    animation_time  = current_time;
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
    starting_format = function(_font_name, _colour)
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
        
        return self;
    }
    
    align = function(_halign, _valign)
    {
        starting_halign = _halign;
        starting_valign = _valign;
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
    /// @param [maxHeight]
    /// @param [characterWrap]
    wrap = function()
    {
        max_width      = argument[0];
        max_height     = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : -1;
        character_wrap = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;
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
        var _old_page = __page;
        __page = _page;
        if (_old_page != __page) __refresh_typewriter_for_page();
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
    
    reset = function()
    {
        throw ".reset() not yet implemented";
        return self;
    }
    
    #endregion
    
    #region Typewriter Setters
    
    typewriter_off = function()
    {
        if (tw_do) __refresh_typewriter_for_page();
        tw_do = false;
        return undefined;
    }
    
    typewriter_in = function(_speed, _smoothness)
    {
        var _refresh = !tw_do || !tw_in;
        
        tw_do         = true;
        tw_in         = true;
        tw_speed      = _speed;
        tw_smoothness = _smoothness;
        
        if (_refresh) __refresh_typewriter_for_page();
        return self;
    }
    
    typewriter_out = function(_speed, _smoothness)
    {
        var _refresh = !tw_do || tw_in;
        
        tw_do         = true;
        tw_in         = false;
        tw_speed      = _speed;
        tw_smoothness = _smoothness;
        
        if (_refresh) __refresh_typewriter_for_page();
        return self;
    }
    
    typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        tw_sound_array     = _sound_array;
        tw_sound_overlap   = _overlap;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = false;
        return self;
    }
    
    typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
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
    
    typewriter_pause = function()
    {
        tw_paused = true;
        return self;
    }
    
    typewriter_unpause = function()
    {
        if (tw_paused)
        {
        	var _old_head_pos = tw_window_array[@ tw_window];
            
            //Increment the window index
        	tw_window = (tw_window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
            
        	tw_window_array[@ tw_window  ] = _old_head_pos;
        	tw_window_array[@ tw_window+1] = _old_head_pos - tw_smoothness;
        }
        
        tw_paused = false;
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
        
        var _model = __get_model();
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
                 
                 x0: _x0, y0: _y0,
                 x1: _x1, y1: _y1,
                 x2: _x2, y2: _y2,
                 x3: _x3, y3: _y3 };
    }
    
    get_width = function()
    {
        return __get_model().get_width();
    }
    
    get_height = function()
    {
        return __get_model().get_height();
    }
    
    get_page = function()
    {
        return __page;
    }
    
    get_pages = function()
    {
        return __get_model().get_pages();
    }
    
    get_typewriter_state = function()
    {
    	//Early out if the method is NONE
    	if (!tw_do) return 1.0; //No fade in/out set
        
	    var _page_data = __get_model().pages_array[__page];
        
    	var _min = _page_data.start_char;
    	var _max = _page_data.last_char;
        
        if (_max <= _min) return 1.0;
        _max += 2; //Bit of a hack
        
        var _t = clamp((tw_window_array[tw_window] - _min) / (_max - _min), 0, 1);
        return tw_in? _t : (_t + 1);
    }
    
    get_typewriter_paused = function()
    {
        return tw_paused;
    }
    
    #endregion
    
    #region Public Methods
    
    draw = function(_x, _y)
    {
        var _model = __get_model();
        
        if (current_time - last_drawn > __SCRIBBLE_EXPECTED_FRAME_TIME)
        {
            animation_time += SCRIBBLE_STEP_SIZE;
            if (tw_do) __update_typewriter();
        }
        
        last_drawn = current_time;
        _model.draw(_x, _y, self);
        
        return self;
    }
    
    flush_now = function()
    {
        if (is_struct(model)) model.flush();
        model = undefined;
        
        return self;
    }
    
    cache_now = function(_freeze)
    {
        freeze = _freeze;
        
    	var _model_cache_name = text +
                                string(starting_font  ) + ":" +
    	                        string(starting_colour) + ":" +
    	                        string(starting_halign) + ":" +
    	                        string(starting_valign) + ":" +
    	                        string(line_height_min) + ":" +
    	                        string(line_height_max) + ":" +
    	                        string(max_width      ) + ":" +
    	                        string(max_height     ) + ":" +
    	                        string(character_wrap ) + ":" +
                                string(bezier_array   ) + ":" +
                                string(__ignore_command_tags);
        
        model = global.__scribble_global_cache_map[? _model_cache_name];
        if (model == undefined) model = new __scribble_class_model(self, _model_cache_name);
        
        if (auto_refresh_typewriter)
        {
            auto_refresh_typewriter = false;
            if (SCRIBBLE_VERBOSE) __scribble_trace("Auto-resetting typewriter state for \"", text, "\"");
            __refresh_typewriter_for_page();
        }
        
        return self;
    }
    
    #endregion
    
    #region Private Methods
    
    __refresh_typewriter_for_page = function()
    {
	    var _page_data = __get_model().pages_array[__page];
        
        tw_window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, _page_data.start_char - tw_smoothness);
        tw_window_array[@ 0] += tw_smoothness;
        
        if (tw_in)
        {
            tw_event_previous       = _page_data.start_event - 1;
            tw_event_char_previous  = _page_data.start_char - 1;
            tw_event_visited_struct = {};
        }
    }
    
    __get_model = function()
    {
        cache_now(freeze);
        return model;
    }
    
    __update_typewriter = function()
    {
	    if (tw_do) //No fade in/out set
	    {
	        var _typewriter_speed = tw_speed*SCRIBBLE_STEP_SIZE;
            var _skipping         = (tw_speed >= SCRIBBLE_SKIP_SPEED_THRESHOLD);
            
	        var _typewriter_head_pos = tw_window_array[tw_window];
            
	        //Handle pausing
	        if (tw_paused)
	        {
	            _typewriter_speed = 0;
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
	                tw_window_array[@ tw_window+1] = _typewriter_head_pos - tw_smoothness;
	            }
	            else
	            {
	                _typewriter_speed = 0;
	            }
	        }
            
            #region Scan for autotype events
            
	        if (tw_in && (_typewriter_speed > 0))
	        {
                var _model     = __get_model();
	            var _page_data = _model.pages_array[__page];
                
	            //Find the last character we need to scan
	            var _typewriter_count = _page_data.last_char + 2;
	            _scan_b = min(ceil(_typewriter_head_pos + _typewriter_speed), _typewriter_count);
                
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
	                                    _typewriter_speed = _scan - _typewriter_head_pos;
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
                
	            _typewriter_head_pos = clamp(_typewriter_head_pos + _typewriter_speed, 0, _typewriter_count);
	            tw_window_array[@ tw_window] = _typewriter_head_pos;
	        }
            
            #endregion
            
            //Move the typewriter head/tail
    	    var _i = 0;
    	    repeat(__SCRIBBLE_WINDOW_COUNT)
    	    {
    	        tw_window_array[@ _i+1] = min(tw_window_array[_i+1] + _typewriter_speed, tw_window_array[_i]);
    	        _i += 2;
    	    }
            
    	    if ((_typewriter_speed > 0) && (floor(_scan_b) > floor(_scan_a)))
    	    {
                #region Play a sound effect as the text is revealed
                
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
    	                tw_sound_finish_time = current_time + 1000*audio_sound_length(_sound) - tw_sound_overlap;
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
    scribble_default_template();
}