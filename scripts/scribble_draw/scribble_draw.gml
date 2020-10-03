/// Draws text using Scribble's formatting.
/// 
/// Returns: A Scribble text element (which is really a complex array)
/// @param x                    x-position in the room to draw at.
/// @param y                    y-position in the room to draw at.
/// @param string/textElement   Either a string to be drawn, or a previously created text element
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game
/// 
/// Formatting commands:
/// [/]                                 Reset formatting to the starting format, as set by scribble_set_starting_format(). For legacy reasons, [] is also accepted
/// [/page]                             Page break
/// [delay]                             Pause the autotype for a fixed amount of time at the tag's position. Only supported when using autotype. DUration is defined by SCRIBBLE_DEFAULT_DELAY_DURATION
/// [delay,<time>]                      Pause the autotype for a fixed amount of time at the tag's position. Only supported when using autotype
/// [pause]                             Pause the autotype at the tag's position. Call scribble_autotype_is_paused() to unpause the autotyper. User scribble_autotype_is_paused() to return if the autotyper is paused
/// [<name of colour>]                  Set colour to one previously defined via scribble_add_color()
/// [#<hex code>]                       Set colour via a hexcode, using the industry standard 24-bit RGB format (#RRGGBB)
/// [d#<decimal>]                       Set colour via a decimal integer, using GameMaker's BGR format
/// [/colour] [/color] [/c]             Reset colour to the default
/// [<name of font>] [/font] [/f]       Set font / Reset font
/// [<name of sprite>]                  Insert an animated sprite starting on image 0 and animating using SCRIBBLE_DEFAULT_SPRITE_SPEED
/// [<name of sprite>,<image>]          Insert a static sprite using the specified image index
/// [<name of sprite>,<image>,<speed>]  Insert animated sprite using the specified image index and animation speed
/// [fa_left]                           Align horizontally to the left. This will insert a line break if used in the middle of a line of text
/// [fa_right]                          Align horizontally to the right. This will insert a line break if used in the middle of a line of text
/// [fa_center] [fa_centre]             Align centrally. This will insert a line break if used in the middle of a line of text
/// [scale,<factor>] [/scale] [/s]      Scale text / Reset scale to x1
/// [slant] [/slant]                    Set/unset italic emulation
/// [<event name>,<arg0>,<arg1>...]     Execute a script bound to an event name,previously defined using scribble_add_event(), with the specified arguments
/// [<effect name>] [/<effect name>]    Set/unset an effect
/// 
/// Scribble has the following animated effects by default:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours
/// [wobble]  [/wobble]                 Set/unset text to wobble by rotating back and forth
/// [pulse]   [/pulse]                  Set/unset text to shrink and grow rhythmically
/// [wheel]   [/wheel]                  Set/unset text to circulate around their origin

function scribble_draw()
{
	var _draw_x         = argument[0];
	var _draw_y         = argument[1];
	var _draw_string    = argument[2];
	var _occurance_name = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	//Check the cache
	var _scribble_array = scribble_cache(_draw_string, _occurance_name);
	if (_scribble_array == undefined) return undefined;

	//Find our occurance data
	var _occurances_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
	var _occurance_array = _occurances_map[? _occurance_name];

	//Find our page data
	var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
	var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];
    
	//Handle the animation timer
	var _increment_timers = ((current_time - _occurance_array[__SCRIBBLE_OCCURANCE.DRAWN_TIME]) > __SCRIBBLE_EXPECTED_FRAME_TIME);
	var _animation_time   = _occurance_array[__SCRIBBLE_OCCURANCE.ANIMATION_TIME];
    
	if (_increment_timers)
	{
	    _animation_time += SCRIBBLE_STEP_SIZE;
	    _occurance_array[@ __SCRIBBLE_OCCURANCE.ANIMATION_TIME] = _animation_time;
	}

	//Update when this text element was last drawn
	_scribble_array[@ SCRIBBLE.DRAWN_TIME] = current_time;
	_occurance_array[@ __SCRIBBLE_OCCURANCE.DRAWN_TIME] = current_time;

	//Grab our vertex buffers for this page
	var _page_vbuffs_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
	var _count = array_length(_page_vbuffs_array);
	if (_count > 0)
	{
        #region Advance the autotyper, execute events, play sounds etc.
        
	    var _typewriter_method = _occurance_array[__SCRIBBLE_OCCURANCE.METHOD];
	    if (_typewriter_method == 0) //No fade in/out set
	    {
	        var _typewriter_method       = 0;
	        var _typewriter_smoothness   = 0;
	        var _typewriter_window_array = global.__scribble_window_array_null;
	        var _typewriter_fade_in      = 0;
	        var _typewriter_speed        = 0;
	    }
	    else
	    {
	        var _typewriter_smoothness     = _occurance_array[__SCRIBBLE_OCCURANCE.SMOOTHNESS  ];
	        var _typewriter_window         = _occurance_array[__SCRIBBLE_OCCURANCE.WINDOW      ];
	        var _typewriter_window_array   = _occurance_array[__SCRIBBLE_OCCURANCE.WINDOW_ARRAY];
	        var _typewriter_fade_in        = _occurance_array[__SCRIBBLE_OCCURANCE.FADE_IN     ];
	        var _typewriter_adjusted_speed = _occurance_array[__SCRIBBLE_OCCURANCE.SPEED       ]*SCRIBBLE_STEP_SIZE;
            var _skipping                  = _occurance_array[__SCRIBBLE_OCCURANCE.SKIP        ];
            
	        //Handle pausing
	        if (_occurance_array[__SCRIBBLE_OCCURANCE.PAUSED])
	        {
	            var _typewriter_speed = 0;
	        }
	        else if (_occurance_array[__SCRIBBLE_OCCURANCE.DELAY_PAUSED])
	        {
	            if (current_time > _occurance_array[__SCRIBBLE_OCCURANCE.DELAY_END])
	            {
	                //We've waited long enough, start showing more text
	                _occurance_array[@ __SCRIBBLE_OCCURANCE.DELAY_PAUSED] = false;
	                var _typewriter_speed = _typewriter_adjusted_speed;
                    
	                //Increment the window index
	                var _old_head_pos = _typewriter_window_array[@ _typewriter_window];
	                _typewriter_window = (_typewriter_window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
	                _occurance_array[@ __SCRIBBLE_OCCURANCE.WINDOW] = _typewriter_window;
	                _typewriter_window_array[@ _typewriter_window  ] = _old_head_pos;
	                _typewriter_window_array[@ _typewriter_window+1] = _old_head_pos - _typewriter_smoothness;
	            }
	            else
	            {
	                var _typewriter_speed = 0;
	            }
	        }
	        else
	        {
	            var _typewriter_speed = _typewriter_adjusted_speed;
	        }
            
            #region Scan for autotype events
            
	        if ((_typewriter_fade_in >= 0) && (_typewriter_speed > 0))
	        {
	            var _typewriter_head_pos = _typewriter_window_array[_typewriter_window];
                
	            //Find the last character we need to scan
	            switch(_typewriter_method)
	            {
	                case 1: //Per character
	                    var _scan_b = ceil(_typewriter_head_pos + _typewriter_speed);
	                    _scan_b = min(_scan_b, _page_array[__SCRIBBLE_PAGE.LAST_CHAR] + 2);
	                break;
                    
	                case 2: //Per line
	                    var _page_lines_array = _page_array[__SCRIBBLE_PAGE.LINES_ARRAY];
	                    var _line   = _page_lines_array[min(ceil(_typewriter_head_pos + _typewriter_speed), _page_array[__SCRIBBLE_PAGE.LINES]-1)];
	                    var _scan_b = _line[__SCRIBBLE_LINE.LAST_CHAR];
	                break;
	            }
                
	            var _scan_a = _occurance_array[__SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS];
                var _scan = _scan_a;
	            if (_scan_b > _scan_a)
	            {
	                var _events_char_array = _scribble_array[SCRIBBLE.EVENT_CHAR_ARRAY];
	                var _events_name_array = _scribble_array[SCRIBBLE.EVENT_NAME_ARRAY];
	                var _events_data_array = _scribble_array[SCRIBBLE.EVENT_DATA_ARRAY];
	                var _event_count       = array_length(_events_char_array);
                    
	                var _event                = _occurance_array[__SCRIBBLE_OCCURANCE.EVENT_PREVIOUS     ];
	                var _events_visited_array = _occurance_array[__SCRIBBLE_OCCURANCE.EVENT_VISITED_ARRAY];
                    
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
                                
	                            if (!_events_visited_array[_event])
	                            {
	                                _events_visited_array[@ _event] = true;
                                    _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_PREVIOUS] = _event;
                                    
	                                //Process pause and delay events
	                                if (_event_name == "pause")
	                                {
                                        if (!_skipping)
                                        {
	                                        _occurance_array[@ __SCRIBBLE_OCCURANCE.PAUSED] = true;
                                        }
	                                }
	                                else if (_event_name == "delay")
	                                {
                                        if (!_skipping)
                                        {
    	                                    if (array_length(_event_data_array) >= 1)
    	                                    {
    	                                        var _duration = real(_event_data_array[0]);
    	                                    }
    	                                    else
    	                                    {
    	                                        var _duration = SCRIBBLE_DEFAULT_DELAY_DURATION;
    	                                    }
                                            
    	                                    _occurance_array[@ __SCRIBBLE_OCCURANCE.DELAY_PAUSED] = true;
    	                                    _occurance_array[@ __SCRIBBLE_OCCURANCE.DELAY_END   ] = current_time + _duration;
                                        }
	                                }
	                                else if (_event_name == "__scribble_audio_playback__")
                                    {
                                        audio_play_sound(_event_data_array[0], 1, false);
                                    }
                                    else
	                                {
	                                    //Otherwise try to find a custom event
	                                    var _function = global.__scribble_autotype_events[? _event_name];
                                        if (is_method(_function))
                                        {
                                            _function(_scribble_array, _event_data_array, _scan);
                                        }
                                        else if (is_real(_function) && script_exists(_function))
	                                    {
	                                        script_execute(_function, _scribble_array, _event_data_array, _scan);
	                                    }
	                                }
                                    
	                                if (_occurance_array[__SCRIBBLE_OCCURANCE.PAUSED]
	                                ||  _occurance_array[__SCRIBBLE_OCCURANCE.DELAY_PAUSED])
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
                        
	                    _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS] = _scan;
	                }
	                else
	                {
	                    _occurance_array[@ __SCRIBBLE_OCCURANCE.EVENT_CHAR_PREVIOUS] = _scan_b;
	                }
	            }
                
	            switch(_typewriter_method)
	            {
	                case 1: var _typewriter_count = _page_array[__SCRIBBLE_PAGE.LAST_CHAR] + 2; break; //Per character
	                case 2: var _typewriter_count = _page_array[__SCRIBBLE_PAGE.LINES    ];     break; //Per line
	            }
                
	            _typewriter_head_pos = clamp(_typewriter_head_pos + _typewriter_speed, 0, _typewriter_count);
	            _typewriter_window_array[@ _typewriter_window] = _typewriter_head_pos;
	        }
            
            #endregion
	    }
        
        #region Move the typewriter head/tail
        
	    if (_typewriter_method != 0) //Either per line or per character fade set
	    {
	        //Figure out the limit and smoothness values
	        //If it's been around-about a frame since we called this scripts...
	        //if (_increment_timers)
	        {
	            var _i = 0;
	            repeat(__SCRIBBLE_WINDOW_COUNT)
	            {
	                _typewriter_window_array[@ _i+1] = min(_typewriter_window_array[_i+1] + _typewriter_adjusted_speed, _typewriter_window_array[_i]);
	                _i += 2;
	            }
	        }
	    }
        
        #endregion
        
	    if ((_typewriter_speed > 0) && (floor(_scan_b) > floor(_scan_a)))
	    {
            #region Play a sound effect as the text is revealed
            
	        var _sound_array = _occurance_array[__SCRIBBLE_OCCURANCE.SOUND_ARRAY];
	        if (is_array(_sound_array) && (array_length(_sound_array) > 0))
	        {
	            var _play_sound = false;
	            if (_occurance_array[__SCRIBBLE_OCCURANCE.SOUND_PER_CHAR])
	            {
	                _play_sound = true;
	            }
	            else if (current_time >= _occurance_array[@ __SCRIBBLE_OCCURANCE.SOUND_FINISH_TIME]) 
	            {
	                _play_sound = true;
	            }
                
	            if (_play_sound)
	            {
	                global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
	                var _rand = global.__scribble_lcg / 2147483648;
	                var _sound = _sound_array[floor(_rand*array_length(_sound_array))];
                
	                var _inst = audio_play_sound(_sound, 0, false);
                
	                global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
	                var _rand = global.__scribble_lcg / 2147483648;
	            	audio_sound_pitch(_inst, lerp(_occurance_array[__SCRIBBLE_OCCURANCE.SOUND_MIN_PITCH], _occurance_array[__SCRIBBLE_OCCURANCE.SOUND_MAX_PITCH], _rand));
                
	                _occurance_array[@ __SCRIBBLE_OCCURANCE.SOUND_FINISH_TIME] = current_time + 1000*audio_sound_length(_sound) - _occurance_array[__SCRIBBLE_OCCURANCE.SOUND_OVERLAP];
	            }
	        }
            
            #endregion
            
	        var _callback = _occurance_array[__SCRIBBLE_OCCURANCE.FUNCTION];
            
            if (is_method(_callback))
            {
                _callback(_scribble_array, _typewriter_window_array[_typewriter_window] - 1);
            }
            else if (is_real(_callback) && script_exists(_callback))
	        {
	            script_execute(_callback, _scribble_array, _typewriter_window_array[_typewriter_window] - 1);
	        }
	    }
        
        #endregion
        
        
        
        #region Do the drawing!
        
        if (global.scribble_state_box_align_page)
        {
            var _box_w = _page_array[__SCRIBBLE_PAGE.WIDTH ];
            var _box_h = _page_array[__SCRIBBLE_PAGE.HEIGHT];
        }
        else
        {
            var _box_w = _scribble_array[SCRIBBLE.WIDTH ];
            var _box_h = _scribble_array[SCRIBBLE.HEIGHT];
        }
        
        var _left = 0;
        var _top  = 0;
        
        //Figure out the left/top offset
        switch(global.scribble_state_box_halign)
        {
            case fa_center: _left -= _box_w div 2; break;
            case fa_right:  _left -= _box_w;       break;
        }
        
        switch(global.scribble_state_box_valign)
        {
            case fa_middle: _top -= _box_h div 2; break;
            case fa_bottom: _top -= _box_h;       break;
        }
        
        switch(_scribble_array[SCRIBBLE.VALIGN])
        {
            case fa_middle: _top -= _box_h div 2; break;
            case fa_bottom: _top -= _box_h;       break;
        }
        
	    //Build a matrix to transform the text...
	    if ((global.scribble_state_xscale == 1)
	    &&  (global.scribble_state_yscale == 1)
	    &&  (global.scribble_state_angle  == 0))
	    {
	        var _matrix = matrix_build(_left + _draw_x, _top + _draw_y, 0,   0,0,0,   1,1,1);
	    }
	    else
	    {
	        var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
	            _matrix = matrix_multiply(_matrix, matrix_build(_draw_x, _draw_y, 0,
	                                                            0, 0, global.scribble_state_angle,
	                                                            global.scribble_state_xscale, global.scribble_state_yscale, 1));
	    }
        
	    //...aaaand set the matrix
	    var _old_matrix = matrix_get(matrix_world);
	    _matrix = matrix_multiply(_matrix, _old_matrix);
	    matrix_set(matrix_world, _matrix);
        
	    //Set the shader and its uniforms
	    shader_set(shd_scribble);
	    shader_set_uniform_f(global.__scribble_uniform_time, _animation_time);
        
	    shader_set_uniform_f(global.__scribble_uniform_tw_method, _typewriter_fade_in? _typewriter_method : -_typewriter_method);
	    shader_set_uniform_f(global.__scribble_uniform_tw_smoothness, _typewriter_smoothness);
	    shader_set_uniform_f_array(global.__scribble_uniform_tw_window_array, _typewriter_window_array);
        
	    shader_set_uniform_f(global.__scribble_uniform_colour_blend, colour_get_red(  global.scribble_state_colour)/255,
	                                                                 colour_get_green(global.scribble_state_colour)/255,
	                                                                 colour_get_blue( global.scribble_state_colour)/255,
	                                                                 global.scribble_state_alpha);
        
	    shader_set_uniform_f(global.__scribble_uniform_fog, colour_get_red(  global.scribble_state_fog_colour)/255,
	                                                        colour_get_green(global.scribble_state_fog_colour)/255,
	                                                        colour_get_blue( global.scribble_state_fog_colour)/255,
	                                                        global.scribble_state_fog_alpha);
        
	    shader_set_uniform_f_array(global.__scribble_uniform_data_fields, global.scribble_state_anim_array);
        shader_set_uniform_f_array(global.__scribble_uniform_bezier_array, _scribble_array[SCRIBBLE.BEZIER_ARRAY]);
        
	    //Now iterate over the text element's vertex buffers and submit them
	    var _i = 0;
	    repeat(_count)
	    {
	        var _vbuff_data = _page_vbuffs_array[_i];
	        vertex_submit(_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
	        ++_i;
	    }
        
	    shader_reset();
        
	    //Make sure we reset the world matrix
	    matrix_set(matrix_world, _old_matrix);
        
        #endregion
	}
    
    
    
    #region Check to see if we need to free some memory from the global cache list
    
	if (SCRIBBLE_CACHE_TIMEOUT > 0)
	{
	    //Scan through the cache to see if any text elements have elapsed - though cap out at max 100 iterations
	    while(100)
	    {
	        var _size = ds_list_size(global.__scribble_global_cache_list);
	        if (_size <= 0) break;
            
	        //Move backwards through the cache list so we are always trying to check the oldest stuff
	        global.__scribble_cache_test_index = (global.__scribble_cache_test_index - 1 + _size) mod _size;
            
	        //Only flush if we want to garbage collect this text element and it hasn't been drawn for a while
	        var _cache_array = global.__scribble_global_cache_list[| global.__scribble_cache_test_index]
	        if (_cache_array[SCRIBBLE.GARBAGE_COLLECT] && (_cache_array[SCRIBBLE.DRAWN_TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time))
	        {
	            scribble_flush(_cache_array);
	        }
	        else
	        {
	            //If we haven't flushed this text element, break out of the loop
	            break;
	        }
	    }
	}
    
    #endregion
    
    
    
	return _scribble_array;
}