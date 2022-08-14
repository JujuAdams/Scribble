function __scribble_class_typist() constructor
{
    __last_element = undefined;
    
    __speed      = 1;
    __smoothness = 0;
    __in         = undefined;
    __backwards  = false;
    
    __skip = false;
    __drawn_since_skip = false;
    
    __sound_array                   = undefined;
    __sound_overlap                 = 0;
    __sound_pitch_min               = 1;
    __sound_pitch_max               = 1;
    __sound_per_char                = false;
    __sound_finish_time             = current_time;
    __sound_per_char_exception      = false;
    __sound_per_char_exception_dict = undefined;
    
    __ignore_delay = false;
    
    __function       = undefined;
    __function_scope = undefined;
    
    __ease_method         = SCRIBBLE_EASE.LINEAR;
    __ease_dx             = 0;
    __ease_dy             = 0;
    __ease_xscale         = 1;
    __ease_yscale         = 1;
    __ease_rotation       = 0;
    __ease_alpha_duration = 1.0;
    
    __character_delay      = false;
    __character_delay_dict = {};
    
    reset();
    
    
    
    #region Setters
    
    static reset = function()
    {
        __last_page            = 0;
        __last_character       = 0;
        __last_audio_character = 0;
        
        __last_tick_time = -infinity;
        
        __window_index     = 0;
        __window_array     = array_create(2*__SCRIBBLE_WINDOW_COUNT, -__smoothness); __window_array[@ 0] = 0;
        __paused           = false;
        __delay_paused     = false;
        __delay_end        = -1;
        __inline_speed     = 1;
        __event_stack      = [];
        __skip             = false;
        __drawn_since_skip = false;
        
        return self;
    }
    
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
        
        if ((_old_in == undefined) || !_old_in) reset();
        
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
        
        if ((_old_in == undefined) || _old_in) reset();
        
        return self;
    }
    
    static skip = function(_state = true)
    {
        __skip = _state;
        __drawn_since_skip = false;
        
        return self;
    }
    
    static ignore_delay = function(_state = true)
    {
        __ignore_delay = _state;
        
        return self;
    }
    
    /// @param soundArray
    /// @param overlap
    /// @param pitchMin
    /// @param pitchMax
    static sound = function(_in_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        var _sound_array = _in_sound_array;
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
    /// @param [exceptionString]
    static sound_per_char = function(_in_sound_array, _pitch_min, _pitch_max, _exception_string)
    {
        var _sound_array = _in_sound_array;
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __sound_array     = _sound_array;
        __sound_pitch_min = _pitch_min;
        __sound_pitch_max = _pitch_max;
        __sound_per_char  = true;
        
        if (is_string(_exception_string))
        {
            if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("SCRIBBLE_ALLOW_GLYPH_DATA_GETTER must be set to <true> to use sound-per-character exceptions");
            
            __sound_per_char_exception = true;
            __sound_per_char_exception_dict = {};
            
            var _i = 1;
            repeat(string_length(_exception_string))
            {
                __sound_per_char_exception_dict[$ ord(string_char_at(_exception_string, _i))] = true;
                ++_i;
            }
        }
        else
        {
            __sound_per_char_exception = false;
        }
        
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
        __ease_method         = _ease_method;
        __ease_dx             = _dx;
        __ease_dy             = _dy;
        __ease_xscale         = _xscale;
        __ease_yscale         = _yscale;
        __ease_rotation       = _rotation;
        __ease_alpha_duration = _alpha_duration;
        
        return self;
    }
    
    static execution_scope = function(_scope)
    {
        __function_scope = _scope;
        
        return self;
    }
    
    static character_delay_add = function(_character, _delay)
    {
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("SCRIBBLE_ALLOW_GLYPH_DATA_GETTER must be set to <true> to use per-character delay");
        
        var _char_1 = _character;
        var _char_2 = 0;
        
        if (is_string(_character))
        {
            _char_1 = ord(string_char_at(_character, 1));
            if (string_length(_character) >= 2) _char_2 = ord(string_char_at(_character, 2));
        }
        
        var _code = _char_1 | (_char_2 << 32);
        __character_delay = true;
        __character_delay_dict[$ _code] = _delay;
        
        return self;
    }
    
    static character_delay_remove = function(_character)
    {
        var _char_1 = _character;
        var _char_2 = 0;
        
        if (is_string(_character))
        {
            _char_1 = ord(string_char_at(_character, 1));
            if (string_length(_character) >= 2) _char_2 = ord(string_char_at(_character, 2));
        }
        
        var _code = _char_1 | (_char_2 << 32);
        variable_struct_remove(__character_delay_dict, _code);
        
        return self;
    }
    
    static character_delay_clear = function()
    {
        __character_delay = false;
        __character_delay_dict = {};
        
        return self;
    }
    
    #endregion
    
    
    
    #region Getters
    
    static get_skip = function()
    {
        return __skip;
    }
    
    static get_ignore_delay = function()
    {
        return __ignore_delay;
    }
    
    static get_state = function()
    {
        if ((__last_element == undefined) || (__last_page == undefined) || (__last_character == undefined)) return 0.0;
        if (__in == undefined) return 1.0;
        
        if (!weak_ref_alive(__last_element)) return 2.0; //If there's no element then report that the element is totally faded out
        
        var _model = __last_element.ref.__get_model(true);
        if (!is_struct(_model)) return 2.0; //If there's no model then report that the element is totally faded out
        
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) <= __last_page) return 1.0;
        var _page_data = _pages_array[__last_page];
        
        var _max = _page_data.__character_count;
        if (_max <= 0) return 1.0;
        
        var _t = clamp((__window_array[__window_index] + max(0, __window_array[__window_index+1] + __smoothness - _max)) / (_max + __smoothness), 0, 1);
        
        if (__in)
        {
            if (__delay_paused || (array_length(__event_stack) > 0))
            {
                //If we're waiting for a delay or there's something in our delay stack we need to process, limit our return value to just less than 1.0
                return min(1 - 2*math_get_epsilon(), _t);
            }
            else
            {
                return _t;
            }
        }
        else
        {
            return _t + 1;
        }
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
    
    static get_execution_scope = function()
    {
        return __function_scope;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __associate = function(_text_element)
    {
        var _carry_skip = __skip && ((__last_element == undefined) || !__drawn_since_skip);
        
        if ((__last_element == undefined) || !weak_ref_alive(__last_element) || (__last_element.ref != _text_element)) //We didn't have an element defined, or we swapped to a different element
        {
            reset();
            __last_element = weak_ref_create(_text_element);
        }
        else if (!weak_ref_alive(__last_element)) //Our associated element got GC'd for some reason and we didn't
        {
            __scribble_trace("Warning! Typist's target text element has been garbage collected");
            reset();
            __last_element = weak_ref_create(_text_element);
        }
        else if (__last_element.ref.__page != __last_page) //Page change
        {
            reset();
        }
        
        __last_page = __last_element.ref.__page;
        
        if (_carry_skip)
        {
            __skip = true;
            __drawn_since_skip = false;
        }
        
        return self;
    }
    
    static __process_event_stack = function(_character_count, _target_element, _function_scope)
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
                        if (SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK && (__last_character >= _character_count) && (array_length(__event_stack) <= 0))
                        {
                            __scribble_trace("Warning! Ignoring [pause] command before the end of a page");
                        }
                        else
                        {
                            __paused = true;
                            
                            return false;
                        }
                    }
                break;
                
                //Time-related delay
                case "delay":
                    if (!__skip && !__ignore_delay)
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
                        var _asset = _event_data[0];
                        if (is_string(_asset)) _asset = asset_get_index(_asset);
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
    
    static __play_sound = function(_head_pos, _character)
    {
        var _sound_array = __sound_array;
        if (is_array(_sound_array) && (array_length(_sound_array) > 0))
        {
            var _play_sound = false;
            if (__sound_per_char)
            {
                //Only play audio if a new character has been revealled
                if (floor(_head_pos + 0.0001) > floor(__last_audio_character))
                {
                    if (!__sound_per_char_exception)
                    {
                        _play_sound = true;
                    }
                    else if (!variable_struct_exists(__sound_per_char_exception_dict, _character))
                    {
                        _play_sound = true;
                    }
                }
            }
            else if (current_time >= __sound_finish_time) 
            {
                _play_sound = true;
            }
            
            if (_play_sound)
            {
                __last_audio_character = _head_pos;
                
                var _audio_asset = _sound_array[floor(__scribble_random()*array_length(_sound_array))];
                if (is_string(_audio_asset)) _audio_asset = global.__scribble_external_sound_map[? _audio_asset];
                
                if (_audio_asset != undefined)
                {
                    var _inst = audio_play_sound(_audio_asset, 0, false);
                    audio_sound_pitch(_inst, lerp(__sound_pitch_min, __sound_pitch_max, __scribble_random()));
                    __sound_finish_time = current_time + 1000*audio_sound_length(_inst) - __sound_overlap;
                }
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
    
    static __tick = function(_target_element, _in_function_scope)
    {
        var _function_scope = (__function_scope != undefined)? __function_scope : _in_function_scope;
        
        //Associate the typist with the target element so that we're pulling data from the correct place
        //This saves the user from doing it themselves
        __associate(_target_element);
        
        if (__skip) __drawn_since_skip = true;
        
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
        
        //Find the model from the last element
        var _model = __last_element.ref.__get_model(true);
        if (!is_struct(_model)) return undefined;
        
        //Get page data
        //We use this to set the maximum limit for the typewriter feature
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) == 0) return undefined;
        var _page_data = _pages_array[__last_page];
        var _page_character_count = _page_data.__character_count;
        
        if (!__in)
        {
            if (__skip)
            {
                __window_array[@ __window_index] = _page_character_count;
            }
            else
            {
                __window_array[@ __window_index] = min(_page_character_count, _head_pos + _speed);
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
                if ((current_time > __delay_end) || __ignore_delay)
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
                if (!__process_event_stack(_page_character_count, _target_element, _function_scope)) _paused = true;
            }
            
            if (!_paused)
            {
                var _play_sound = false;
                
                if (__skip)
                {
                    var _remaining = _page_character_count - _head_pos;
                }
                else
                {
                    var _remaining = min(_page_character_count - _head_pos, _speed);
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
                        var _found_events = __last_element.ref.get_events(__last_character);
                        
                        //Add a per-character delay if required
                        if (SCRIBBLE_ALLOW_GLYPH_DATA_GETTER && !__ignore_delay && __character_delay && (__last_character > 0))
                        {
                            var _glyph_ord = _page_data.__glyph_grid[# __last_character-1, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                            var _delay = __character_delay_dict[$ _glyph_ord];
                            _delay = (_delay == undefined)? 0 : _delay;
                            
                            if (__last_character > 1)
                            {
                                _glyph_ord = (_glyph_ord << 32) | _page_data.__glyph_grid[# __last_character-2, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                                var _double_char_delay = __character_delay_dict[$ _glyph_ord];
                                _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                
                                _delay = max(_delay, _double_char_delay);
                            }
                            
                            if (_delay > 0) array_push(_found_events, new __scribble_class_event("delay", [_delay]));
                        }
                        
                        //Move to the next character
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
                            if (!__process_event_stack(_page_character_count, _target_element, _function_scope))
                            {
                                _head_pos = __last_character - 1; //Lock our head position so we don't overstep
                                break;
                            }
                        }
                    }
                }
                
                //Only play sound once per frame if we're going reaaaally fast
                if (_play_sound && (__last_character <= _page_character_count))
                {
                    __play_sound(_head_pos, SCRIBBLE_ALLOW_GLYPH_DATA_GETTER? (_page_data.__glyph_grid[# _head_pos-1, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE]) : 0);
                }
                
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
            
            var _pages_array = _model.__get_page_array();
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
            
            var _pages_array = _model.__get_page_array();
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