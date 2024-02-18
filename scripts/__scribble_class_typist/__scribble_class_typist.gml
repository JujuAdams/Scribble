/// @param perLine

function __scribble_class_typist(_per_line) : __scribble_class_typist_public_functions() constructor
{
    static __scribble_state = __scribble_get_state();
    static __external_sound_map = __scribble_state.__external_sound_map;
    
    __last_element = undefined;
    
    __speed      = 1;
    __smoothness = 0;
    __in         = undefined;
    __backwards  = false;
    
    __skip             = false;
    __skip_paused      = false;
    __drawn_since_skip = false;
    
    __sound_array                   = undefined;
    __sound_overlap                 = 0;
    __sound_pitch_min               = 1;
    __sound_pitch_max               = 1;
    __sound_gain                    = 1;
    __sound_per_char                = false;
    __sound_finish_time             = current_time;
    __sound_per_char_exception      = false;
    __sound_per_char_exception_dict = undefined;
    
    __ignore_delay = false;
    
    __function_scope       = undefined;
    __function_per_char    = undefined;
    __function_on_complete = undefined;
    
    __ease_method         = SCRIBBLE_EASE.LINEAR;
    __ease_dx             = 0;
    __ease_dy             = 0;
    __ease_xscale         = 1;
    __ease_yscale         = 1;
    __ease_rotation       = 0;
    __ease_alpha_duration = 1.0;
    
    __character_delay      = false;
    __character_delay_dict = {};
    
    __per_line = _per_line;
    
    __sync_started   = false;
    __sync_instance  = undefined;
    __sync_paused    = false;
    __sync_pause_end = infinity;
    
    reset();
    
    
    
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
        
        if (_carry_skip)
        {
            __skip             = true;
            __drawn_since_skip = false;
        }
        
        return self;
    }
    
    static __process_event_stack = function(_character_count, _target_element, _function_scope)
    {
        static _typewriter_event_dict = __scribble_state.__typewriter_events_dict;
        
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
            var _event_position = __per_line? _event_struct.line_index : _event_struct.character_index;
            var _event_name     = _event_struct.name;
            var _event_data     = _event_struct.data;
            
            switch(_event_name)
            {
                //Simple pause
                case "pause":
                    if (!__skip && !__sync_started) || (!__skip_paused)
                    {
                        if (SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK && (__last_character >= _character_count) && (array_length(__event_stack) <= 0))
                        {
                            __scribble_trace("Warning! Ignoring [pause] command before the end of a page");
                        }
                        else
                        {
                            __paused = true;
                            
                            __window_max_array[@ __window_index] = __last_character-1;
                            
                            return false;
                        }
                    }
                break;
                
                //Time-related delay
                case "delay":
                    if (!__skip && !__ignore_delay && !__sync_started)
                    {
                        var _duration = (array_length(_event_data) >= 1)? real(_event_data[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __delay_paused = true;
                        __delay_end    = current_time + _duration;
                        
                        __window_max_array[@ __window_index] = __last_character-1;
                        
                        return false;
                    }
                break;
                
                //Audio playback synchronisation
                case "sync":
                    if (!__skip && __sync_started)
                    {
                        __sync_paused    = true;
                        __sync_pause_end = real(_event_data[0]);
                        
                        __window_max_array[@ __window_index] = __last_character-1;
                        
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
                case __SCRIBBLE_AUDIO_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    if (array_length(_event_data) >= 1)
                    {
                        var _asset = _event_data[0];
                        if (is_string(_asset)) _asset = asset_get_index(_asset);
                        audio_play_sound(_asset, 1, false);
                    }
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    sound(asset_get_index(_event_data[1]), real(_event_data[2]), real(_event_data[3]), real(_event_data[4]));
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    switch(array_length(_event_data))
                    {
                        case 4: sound_per_char(asset_get_index(_event_data[1]), real(_event_data[2]), real(_event_data[3])); break;
                        case 5: sound_per_char(asset_get_index(_event_data[1]), real(_event_data[2]), real(_event_data[3]), _event_data[4]); break;
                    }
                break;
                
                //Probably a current event
                default:
                    //Otherwise try to find a custom event
                    var _function = _typewriter_event_dict[$ _event_name];
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
                    
                    if (__paused) return false;
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
                if (is_string(_audio_asset))
                {
                    _audio_asset = __external_sound_map[? _audio_asset];
                }
                
                if (_audio_asset != undefined)
                {
                    var _inst = audio_play_sound(_audio_asset, 0, false);
                    audio_sound_pitch(_inst, lerp(__sound_pitch_min, __sound_pitch_max, __scribble_random()));
                    audio_sound_gain(_inst, __sound_gain, 0);
                    __sound_finish_time = current_time + 1000*audio_sound_length(_inst) - __sound_overlap;
                }
            }
        }
    }
    
    static __execute_function_per_character = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__function_per_char))
        {
            __function_per_char(_function_scope, __last_character - 1, self);
        }
        else if (is_real(__function_per_char) && script_exists(__function_per_char))
        {
            script_execute(__function_per_char, _function_scope, __last_character - 1, self);
        }
    }
    
    static __execute_function_on_complete = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__function_on_complete))
        {
            __function_on_complete(_function_scope, self);
        }
        else if (is_real(__function_on_complete) && script_exists(__function_on_complete))
        {
            script_execute(__function_on_complete, _function_scope, self);
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
        if (__scribble_state.__frames <= __last_tick_frame) return undefined;
        __last_tick_frame = __scribble_state.__frames;
        
        //If __in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__in == undefined) return undefined;
        
        //Ensure we unhook synchronisation if the audio instance stops playing
        if (__sync_started)
        {
            if ((__sync_instance == undefined) || !audio_is_playing(__sync_instance)) __sync_reset();
        }
        
        //Calculate our speed based on our set typewriter speed, any in-line [speed] tags, and the overall tick size
        //We set inline speed in __process_event_stack()
        var _speed = __speed*__inline_speed*SCRIBBLE_TICK_SIZE;
        
        //Find the leading edge of our windows
        var _head_pos = __window_head_array[__window_index];
        
        //Find the model from the last element
        if (!weak_ref_alive(__last_element)) return undefined;
        var _element = __last_element.ref;
        
        var _model = _element.__get_model(true);
        if (!is_struct(_model)) return undefined;
        
        //Get line and page data
        var _lines_array = _model.__get_line_array();
        var _pages_array = _model.__get_page_array();
        if ((array_length(_lines_array) == 0) || (array_length(_pages_array) == 0)) return undefined;
        
        //Don't animate or process anything if we're scrolling
        if (_element.__scroll_y != _element.__scroll_target_y) return undefined;
        
        //Discover the range of lines that's on-screen
        //TODO - Use binary search instead for faster behaviour
        var _scroll_top    = _element.__scroll_y;
        var _scroll_bottom = _scroll_top + _element.__layout_height;
        
        var _min_line =  infinity;
        var _max_line = -infinity;
        var _i = 0;
        repeat(array_length(_lines_array))
        {
            var _line = _lines_array[_i];
            var _line_top    = _line.__model_y;
            var _line_bottom = _line_top + _line.__height;
            
            if ((_line_top >= _scroll_top) && (_line_bottom <= _scroll_bottom))
            {
                _min_line = min(_min_line, _i);
                _max_line = max(_max_line, _i);
            }
            
            ++_i;
        }
        
        if (is_infinity(_min_line) || is_infinity(_max_line))
        {
            //Nothing's on screen I guess
            return undefined;
        }
        
        var _min_line_data = _lines_array[_min_line];
        var _max_line_data = _lines_array[_max_line];
        
        var _min_target = _min_line_data.__glyph_start;
        var _max_target = _max_line_data.__glyph_end;
        
        if (!__in)
        {
            
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
                    var _head_pos = __window_max_array[__window_index];
                    __window_index = (__window_index + 1) mod __SCRIBBLE_WINDOW_COUNT;
                    __window_head_array[@ __window_index] = _head_pos;
                }
                else
                {
                    _paused = true;
                }
            }
            else if (__sync_started)
            {
                if (audio_is_paused(__sync_instance))
                {
                    _paused = true;
                }
                else if (__sync_paused)
                {
                    if (audio_sound_get_track_position(__sync_instance) > __sync_pause_end)
                    {
                        //If enough of the source audio has been played, start showing more text
                        __sync_paused = false;
                        
                        //Increment the window index
                        var _head_pos = __window_max_array[__window_index];
                        __window_index = (__window_index + 1) mod __SCRIBBLE_WINDOW_COUNT;
                        __window_head_array[@ __window_index] = _head_pos;
                    }
                    else
                    {
                        _paused = true;
                    }
                }
            }
            
            //If we've still got stuff on the event stack, pop those off
            if (!_paused && (array_length(__event_stack) > 0))
            {
                if (!__process_event_stack(infinity, _target_element, _function_scope)) _paused = true;
            }
            
            if (_paused)
            {
                __window_head_array[@ __window_index] = min(__window_head_array[__window_index] + _speed, __window_max_array[__window_index] + __smoothness);
            }
            else
            {
                var _play_sound = false;
                
                __window_head_array[@ __window_index] = max(__window_head_array[__window_index], _min_target);
                __window_max_array[@  __window_index] = _max_target;
                
                var _remaining = (_max_target + __smoothness) - _head_pos;
                if (not __skip) _remaining = min(_remaining, _speed);
                
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
                        var _found_events = __last_element.ref.get_events(__last_character, undefined, __per_line);
                        var _found_size = array_length(_found_events);
                        
                        //Add a per-character delay if required
                        if (SCRIBBLE_ALLOW_GLYPH_DATA_GETTER
                        &&  !__ignore_delay
                        &&  __character_delay
                        &&  (__last_character >= 1) //Don't check character delay until we're on the first character (index=1)
                        &&  ((__last_character < (SCRIBBLE_DELAY_LAST_CHARACTER? _max_target : (_max_target-1))) || (_found_size > 0)))
                        {
                            var _glyph_ord = _model.__glyph_data_grid[# __last_character-1, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                            
                            var _delay = __character_delay_dict[$ _glyph_ord];
                            _delay = (_delay == undefined)? 0 : _delay;
                            
                            if (__last_character > 1)
                            {
                                _glyph_ord = (_glyph_ord << 32) | _model.__glyph_data_grid[# __last_character-2, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                                var _double_char_delay = __character_delay_dict[$ _glyph_ord];
                                _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                
                                _delay = max(_delay, _double_char_delay);
                            }
                            
                            if (_delay > 0) array_push(__event_stack, new __scribble_class_event("delay", [_delay]));
                        }
                        
                        //Move to the next character
                        __last_character++;
                        if (__last_character > 1) __execute_function_per_character(_target_element);
                        
                        if (_found_size > 0)
                        {
                            //Copy our found array of events onto our stack
                            var _old_stack_size = array_length(__event_stack);
                            array_resize(__event_stack, _old_stack_size + _found_size);
                            array_copy(__event_stack, _old_stack_size, _found_events, 0, _found_size);
                        }
                        
                        //Process the stack
                        //If we hit a [pause] or [delay] tag then the function returns <false> and we break out of the loop
                        if (!__process_event_stack(_max_target, _target_element, _function_scope))
                        {
                            _head_pos = __last_character-1; //Lock our head position so we don't overstep
                            break;
                        }
                    }
                }
                
                if (_play_sound)
                {
                    if (__last_character <= _max_target)
                    {
                        //Only play sound once per frame if we're going reaaaally fast
                        __play_sound(_head_pos, 0);
                    }
                    else
                    {
                        //Execute our on-complete callback when we finish
                        __execute_function_on_complete(_function_scope);
                    }
                }
                
                //Set the typewriter head
                __window_head_array[@ __window_index] = _head_pos;
            }
            
            __scribble_trace(__window_head_array, " -> ", __window_max_array);
        }
    }
    
    static __set_shader_uniforms = function()
    {
        static _u_iTypistMethod        = shader_get_uniform(__shd_scribble, "u_iTypistMethod"       );
        static _u_fTypistSmoothness    = shader_get_uniform(__shd_scribble, "u_fTypistSmoothness"   );
        static _u_fTypistHeadArray     = shader_get_uniform(__shd_scribble, "u_fTypistHeadArray"    );
        static _u_fTypistMaxArray      = shader_get_uniform(__shd_scribble, "u_fTypistMaxArray"     );
        static _u_vTypistStartPos      = shader_get_uniform(__shd_scribble, "u_vTypistStartPos"     );
        static _u_vTypistStartScale    = shader_get_uniform(__shd_scribble, "u_vTypistStartScale"   );
        static _u_fTypistStartRotation = shader_get_uniform(__shd_scribble, "u_fTypistStartRotation");
        static _u_fTypistAlphaDuration = shader_get_uniform(__shd_scribble, "u_fTypistAlphaDuration");
        
        //If __in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__in == undefined)
        {
            shader_set_uniform_i(_u_iTypistMethod, SCRIBBLE_EASE.NONE);
            return undefined;
        }
        
        //Reset the "typist use lines" flag
        __scribble_state.__render_flag_value = ((__scribble_state.__render_flag_value & (~(0x40))) | (__per_line << 6));
        
        shader_set_uniform_i(_u_iTypistMethod,          __in? __ease_method : (__ease_method + SCRIBBLE_EASE.__SIZE));
        shader_set_uniform_f(_u_fTypistSmoothness,      __smoothness);
        shader_set_uniform_f(_u_vTypistStartPos,        __ease_dx, __ease_dy);
        shader_set_uniform_f(_u_vTypistStartScale,      __ease_xscale, __ease_yscale);
        shader_set_uniform_f(_u_fTypistStartRotation,   __ease_rotation);
        shader_set_uniform_f(_u_fTypistAlphaDuration,   __ease_alpha_duration);
        shader_set_uniform_f_array(_u_fTypistHeadArray, __window_head_array);
        shader_set_uniform_f_array(_u_fTypistMaxArray,  __window_max_array);
    }
}