function __scribble_class_typist() constructor
{
    __last_element         = undefined;
    __last_page            = 0;
    __last_character       = 0;
    __last_audio_character = 0;
    
    __last_tick_time = -infinity;
    
    __window_index = 0;
    __window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, 0.0);
    __skip         = false;
    __paused       = false;
    __delay_paused = false;
    __delay_end    = -1;
    __inline_speed = 1;
    __event_stack  = [];
    
    __speed      = 1;
    __smoothness = 0;
    __in         = undefined;
    __backwards  = false;
    
    __sound_array       = undefined;
    __sound_overlap     = 0;
    __sound_pitch_min   = 1;
    __sound_pitch_max   = 1;
    __sound_per_char    = false;
    __sound_finish_time = current_time;
    __function          = undefined;
    
    __ease_method         = SCRIBBLE_EASE.LINEAR;
    __ease_dx             = 0;
    __ease_dy             = 0;
    __ease_xscale         = 1;
    __ease_yscale         = 1;
    __ease_rotation       = 0;
    __ease_alpha_duration = 1.0;
    
    
    
    #region Setters
    
    /// @param speed
    /// @param smoothness
    static in = function(_speed, _smoothness)
    {
        var _old_in = __in;
        
        __in         = true;
        __backwards  = false;
        __speed      = _speed;
        __smoothness = _smoothness;
        __skip       = false;
        
        if ((_old_in == undefined) || !_old_in) __reset();
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards=false]
    static out = function(_speed, _smoothness, _backwards = false)
    {
        var _old_in = __in;
        
        __in         = false;
        __backwards  = _backwards;
        __speed      = _speed;
        __smoothness = _smoothness;
        __skip       = false;
        
        if ((_old_in == undefined) || _old_in) __reset();
        
        return self;
    }
    
    static skip = function()
    {
        __skip = true;
        
        return self;
    }
    
    /// @param soundArray
    /// @param overlap
    /// @param pitchMin
    /// @param pitchMax
    static sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __sound_array     = _sound_array;
        __sound_overlap   = _overlap;
        __sound_pitch_min = _pitch_min;
        __sound_pitch_max = _pitch_max;
        __sound_per_char  = false;
        
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    static sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __sound_array     = _sound_array;
        __sound_pitch_min = _pitch_min;
        __sound_pitch_max = _pitch_max;
        __sound_per_char  = true;
        
        return self;
    }
    
    static function_per_char = function(_function)
    {
        __function = _function;
        
        return self;
    }
    
    static pause = function()
    {
        __paused = true;
        
        return self;
    }
    
    static unpause = function()
    {
        if (__paused)
        {
            var _head_pos = __window_array[__window_index];
            
            //Increment the window index
            __window_index = (__window_index + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
            __window_array[@ __window_index  ] = _head_pos;
            __window_array[@ __window_index+1] = _head_pos - __smoothness;
        }
        
        __paused = false;
        
        return self;
    }
    
    /// @param easeMethod
    /// @param dx
    /// @param dy
    /// @param xscale
    /// @param yscale
    /// @param rotation
    /// @param alphaDuration
    static ease = function(_ease_method, _dx, _dy, _xscale, _yscale, _rotation, _alpha_duration)
    {
        __ease_method    = _ease_method;
        __ease_dx             = _dx;
        __ease_dy             = _dy;
        __ease_xscale         = _xscale;
        __ease_yscale         = _yscale;
        __ease_rotation       = _rotation;
        __ease_alpha_duration = _alpha_duration;
        
        return self;
    }
    
    #endregion
    
    
    
    #region Getters
    
    static get_skip = function()
    {
        return __skip;
    }
    
    static get_state = function()
    {
        if ((__last_element == undefined) || (__last_page == undefined) || (__last_character == undefined)) return 0.0;
        if (__in == undefined) return 1.0;
        
        var _model = __last_element.ref.__get_model(true);
        if (!is_struct(_model)) return 2.0; //If there's no model then report that the element is totally faded out
        
        var _pages_array = _model.get_page_array();
        if (array_length(_pages_array) <= __last_page) return 1.0;
        var _page_data = _pages_array[__last_page];
        var _min = 0;
        var _max = _page_data.__character_count;
        
        if (_max <= _min) return 1.0;
        
        var _t = clamp((get_position() - _min) / (_max - _min), 0, 1);
        return __in? _t : (_t + 1);
    }
    
    static get_paused = function()
    {
        return __paused;
    }
    
    static get_position = function()
    {
        if (__in == undefined) return 0;
        return __window_array[__window_index];
    }
    
    static get_text_element = function()
    {
        return __last_element;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __reset = function()
    {
        __last_page            = 0;
        __last_character       = 0;
        __last_audio_character = 0;
        
        __last_tick_time = -infinity;
        
        __window_index = 0;
        __window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, -__smoothness); __window_array[@ 0] = 0;
        __skip         = false;
        __paused       = false;
        __delay_paused = false;
        __delay_end    = -1;
        __inline_speed = 1;
        __event_stack  = [];
        
        return self;
    }
    
    static __associate = function(_text_element)
    {
        if ((__last_element == undefined) || (__last_element.ref != _text_element)) //We didn't have an element defined, or we swapped to a different element
        {
            __reset();
            __last_element = weak_ref_create(_text_element);
        }
        else if (!weak_ref_alive(__last_element)) //Our associated element got GC'd for some reason and we didn't
        {
            __scribble_trace("Warning! Typist's target text element has been garbage collected");
            __reset();
            __last_element = weak_ref_create(_text_element);
        }
        else if (__last_element.ref.__page != __last_page) //Page change
        {
            __reset();
        }
        
        __last_page = __last_element.ref.__page;
        
        return self;
    }
    
    static __process_event_stack = function(_target_element, _function_scope)
    {
        //This method processes events on the stack (which is filled by copying data from the target element in .__tick())
        //We return <true> if there have been no pausing behaviours called i.e. [pause] and [delay]
        //We return <false> immediately if we do run into pausing behaviours
        
        repeat(array_length(__event_stack))
        {
            //Pop the first event from the stack
            var _event_struct = __event_stack[0];
            array_delete(__event_stack, 0, 1);
            
            //Collect data from the struct
            //This data is set in __scribble_generate_model() via the .__new_event() method on the model class
            var _event_position = _event_struct.position;
            var _event_name     = _event_struct.name;
            var _event_data     = _event_struct.data;
            
            switch(_event_name)
            {
                //Simple pause
                case "pause":
                    if (!__skip)
                    {
                        __paused = true;
                        
                        return false;
                    }
                break;
                
                //Time-related delay
                case "delay":
                    if (!__skip)
                    {
                        var _duration = (array_length(_event_data) >= 1)? real(_event_data[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __delay_paused = true;
                        __delay_end    = current_time + _duration;
                        
                        return false;
                    }
                break;
                
                //In-line speed setting
                case "speed":
                    if (array_length(_event_data) >= 1) __inline_speed = real(_event_data[0]);
                break;
                
                case "/speed":
                    __inline_speed = 1;
                break;
                
                //Native audio playback feature
                case __SCRIBBLE_AUDIO_COMMAND_TAG: //TODO - Rename and add warning when adding a conflicting custom event
                    if (array_length(_event_data) >= 1)
                    {
                        var _asset = asset_get_index(_event_data[0]);
                        __scribble_trace(_asset);
                        audio_play_sound(_asset, 1, false);
                    }
                break;
                
                //Porbably a current event
                default:
                    //Otherwise try to find a custom event
                    var _function = global.__scribble_typewriter_events[? _event_name];
                    if (is_method(_function))
                    {
                        with(_function_scope) _function(_target_element, _event_data, _event_position);
                    }
                    else if (is_real(_function) && script_exists(_function))
                    {
                        with(_function_scope) script_execute(_function, _target_element, _event_data, _event_position);
                    }
                    else
                    {
                        __scribble_trace("Warning! Event [", _event_name, "] not recognised");
                    }
                break;
            }
        }
        
        return true;
    }
    
    static __play_sound = function(_head_pos)
    {
        var _sound_array = __sound_array;
        if (is_array(_sound_array) && (array_length(_sound_array) > 0))
        {
            var _play_sound = false;
            if (__sound_per_char)
            {
                //Only play audio if a new character has been revealled
                if (floor(_head_pos) > floor(__last_audio_character))
                {
                    _play_sound = true;
                }
            }
            else if (current_time >= __sound_finish_time) 
            {
                _play_sound = true;
            }
            
            if (_play_sound)
            {
                __last_audio_character = _head_pos;
                
                var _inst = audio_play_sound(_sound_array[floor(__scribble_random()*array_length(_sound_array))], 0, false);
                audio_sound_pitch(_inst, lerp(__sound_pitch_min, __sound_pitch_max, __scribble_random()));
                __sound_finish_time = current_time + 1000*audio_sound_length(_inst) - __sound_overlap;
            }
        }
    }
    
    static __execute_function_per_character = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__function))
        {
            __function(_function_scope, __last_character - 1, self);
        }
        else if (is_real(__function) && script_exists(__function))
        {
            script_execute(__function, _function_scope, __last_character - 1, self);
        }
    }
    
    static __tick = function(_target_element, _function_scope)
    {
        //Associate the typist with the target element so that we're pulling data from the correct place
        //This saves the user from doing it themselves
        __associate(_target_element);
        
        //Don't tick if it's been less than a frame since we were last updated
        if (current_time - __last_tick_time < __SCRIBBLE_EXPECTED_FRAME_TIME) return undefined;
        __last_tick_time = current_time;
        
        //If __in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__in == undefined) return undefined;
        
        //Calculate our speed based on our set typewriter speed, any in-line [speed] tags, and the overall tick size
        //We set inline speed in __process_event_stack()
        var _speed = __speed*__inline_speed*SCRIBBLE_TICK_SIZE;
        
        //Find the leading edge of our windows
        var _head_pos = __window_array[__window_index];
        
        if (!__in)
        {
            //Find the model from the last element
            var _model = __last_element.ref.__get_model(true);
            if (!is_struct(_model)) return undefined;
            
            //Get page data
            //We use this to set the maximum limit for the typewriter feature
            var _pages_array = _model.get_page_array();
            if (array_length(_pages_array) <= __last_page) return undefined;
            var _page_data = _pages_array[__last_page];
            
            if (__skip)
            {
                __window_array[@ __window_index] = _page_data.__character_count;
            }
            else
            {
                __window_array[@ __window_index] = min(_page_data.__character_count, _head_pos + _speed);
            }
        }
        else
        {
            //Handle pausing
            var _paused = false;
            if (__paused)
            {
                _paused = true;
            }
            else if (__delay_paused)
            {
                if (current_time > __delay_end)
                {
                    //We've waited long enough, start showing more text
                    __delay_paused = false;
                
                    //Increment the window index
                    __window_index = (__window_index + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
                    __window_array[@ __window_index  ] = _head_pos;
                    __window_array[@ __window_index+1] = _head_pos - __smoothness;
                }
                else
                {
                    _paused = true;
                }
            }
            
            //If we've still got stuff on the event stack, pop those off
            if (!_paused && (array_length(__event_stack) > 0))
            {
                if (!__process_event_stack(_target_element, _function_scope)) _paused = true;
            }
            
            if (!_paused)
            {
                //Find the model from the last element
                var _model = __last_element.ref.__get_model(true);
                if (!is_struct(_model)) return undefined;
                
                //Get page data
                //We use this to set the maximum limit for the typewriter feature
                var _pages_array = _model.get_page_array();
                if (array_length(_pages_array) == 0) return undefined;
                var _page_data = _pages_array[__last_page];
                
                var _play_sound = false;
                
                if (__skip)
                {
                    var _remaining = _page_data.__character_count - _head_pos;
                }
                else
                {
                    var _remaining = min(_page_data.__character_count - _head_pos, _speed);
                }
                
                while(_remaining > 0)
                {
                    //Scan for events one character at a time
                    _head_pos += min(1, _remaining);
                    _remaining -= 1;
                    
                    //Only scan for new events if we've moved onto a new character
                    if (_head_pos >= __last_character)
                    {
                        _play_sound = true;
                        
                        //Get an array of events for this character from the text element
                        var _found_events = __last_element.ref.events_get(__last_character);
                        __last_character++;
                        
                        if (__last_character > 1) __execute_function_per_character(_target_element);
                        
                        var _found_size = array_length(_found_events);
                        if (_found_size > 0)
                        {
                            //Copy our found array of events onto our stack
                            var _old_stack_size = array_length(__event_stack);
                            array_resize(__event_stack, _old_stack_size + _found_size);
                            array_copy(__event_stack, _old_stack_size, _found_events, 0, _found_size);
                            
                            //Process the stack
                            //If we hit a [pause] or [delay] tag then the function returns <false> and we break out of the loop
                            if (!__process_event_stack(_target_element, _function_scope))
                            {
                                _head_pos = __last_character - 1; //Lock our head position so we don't overstep
                                break;
                            }
                        }
                    }
                }
                
                //Only play sound once per frame if we're going reaaaally fast
                if (_play_sound) __play_sound(_head_pos);
                
                //Set the typewriter head
                __window_array[@ __window_index] = _head_pos;
            }
        }
        
        //Move the typewriter tail
        if (__skip)
        {
            var _i = 0;
            repeat(__SCRIBBLE_WINDOW_COUNT)
            {
                __window_array[@ _i+1] = __window_array[_i];
                _i += 2;
            }
        }
        else
        {
            var _i = 0;
            repeat(__SCRIBBLE_WINDOW_COUNT)
            {
                __window_array[@ _i+1] = min(__window_array[_i+1] + _speed, __window_array[_i]);
                _i += 2;
            }
        }
    }
    
    static __set_shader_uniforms = function()
    {
        //If __in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__in == undefined)
        {
            shader_set_uniform_i(global.__scribble_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
            return undefined;
        }
        
        var _method = __ease_method;
        if (!__in) _method += SCRIBBLE_EASE.__SIZE;
        
        var _char_max = 0;
        if (__backwards)
        {
            var _model = __last_element.ref.__get_model(true);
            if (!is_struct(_model)) return undefined;
            
            var _pages_array = _model.get_page_array();
            if (array_length(_pages_array) > __last_page)
            {
                var _page_data = _pages_array[__last_page];
                _char_max = _page_data.__character_count;
            }
            else
            {
                __scribble_trace("Warning! Typist page (", __last_page, ") exceeds text element page count (", array_length(_pages_array), ")");
            }
        }
        
        shader_set_uniform_i(global.__scribble_u_iTypewriterMethod,            _method);
        shader_set_uniform_i(global.__scribble_u_iTypewriterCharMax,           _char_max);
        shader_set_uniform_f(global.__scribble_u_fTypewriterSmoothness,        __smoothness);
        shader_set_uniform_f(global.__scribble_u_vTypewriterStartPos,          __ease_dx, __ease_dy);
        shader_set_uniform_f(global.__scribble_u_vTypewriterStartScale,        __ease_xscale, __ease_yscale);
        shader_set_uniform_f(global.__scribble_u_fTypewriterStartRotation,     __ease_rotation);
        shader_set_uniform_f(global.__scribble_u_fTypewriterAlphaDuration,     __ease_alpha_duration);
        shader_set_uniform_f_array(global.__scribble_u_fTypewriterWindowArray, __window_array);
    }
    
    static __set_msdf_shader_uniforms = function()
    {
        //If __in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__in == undefined)
        {
            shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
            return undefined;
        }
        
        var _method = __ease_method;
        if (!__in) _method += SCRIBBLE_EASE.__SIZE;
        
        var _char_max = 0;
        if (__backwards)
        {
            var _model = __last_element.ref.__get_model(true);
            if (!is_struct(_model)) return undefined;
            
            var _pages_array = _model.get_page_array();
            if (array_length(_pages_array) > __last_page)
            {
                var _page_data = _pages_array[__last_page];
                _char_max = _page_data.__character_count;
            }
            else
            {
                __scribble_trace("Warning! Typist page (", __last_page, ") exceeds text element page count (", array_length(_pages_array), ")");
            }
        }
        
        shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod,            _method);
        shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterCharMax,           _char_max);
        shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterSmoothness,        __smoothness);
        shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartPos,          __ease_dx, __ease_dy);
        shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartScale,        __ease_xscale, __ease_yscale);
        shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterStartRotation,     __ease_rotation);
        shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterAlphaDuration,     __ease_alpha_duration);
        shader_set_uniform_f_array(global.__scribble_msdf_u_fTypewriterWindowArray, __window_array);
    }
    
    #endregion
}