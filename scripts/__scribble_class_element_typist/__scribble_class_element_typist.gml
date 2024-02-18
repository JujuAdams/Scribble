/// @param string
/// @param [uniqueID=""]

function __scribble_class_element_typist(_string, _unique_id) : __scribble_class_element(_string, _unique_id) constructor
{
    static __scribble_state = __scribble_get_state();
    static __external_sound_map = __scribble_state.__external_sound_map;
    
    __isTypist = true;
    
    __typ_last_element = undefined;
    
    __typ_speed      = 1;
    __typ_smoothness = 0;
    __typ_in         = undefined;
    __typ_backwards  = false;
    
    __typ_skip             = false;
    __typ_skip_paused      = false;
    __typ_drawn_since_skip = false;
    
    __typ_sound_array                   = undefined;
    __typ_sound_overlap                 = 0;
    __typ_sound_pitch_min               = 1;
    __typ_sound_pitch_max               = 1;
    __typ_sound_gain                    = 1;
    __typ_sound_per_char                = false;
    __typ_sound_finish_time             = current_time;
    __typ_sound_per_char_exception      = false;
    __typ_sound_per_char_exception_dict = undefined;
    
    __typ_ignore_delay = false;
    
    __typ_function_scope       = undefined;
    __typ_function_per_char    = undefined;
    __typ_function_on_complete = undefined;
    
    __typ_ease_method         = SCRIBBLE_EASE.LINEAR;
    __typ_ease_dx             = 0;
    __typ_ease_dy             = 0;
    __typ_ease_xscale         = 1;
    __typ_ease_yscale         = 1;
    __typ_ease_rotation       = 0;
    __typ_ease_alpha_duration = 1.0;
    
    __typ_character_delay      = false;
    __typ_character_delay_dict = {};
    
    __typ_per_line = _per_line;
    
    __typ_sync_started   = false;
    __typ_sync_instance  = undefined;
    __typ_sync_paused    = false;
    __typ_sync_pause_end = infinity;
    
    reset();
    
    
    
    #region Setters
    
    static reset = function()
    {
        __typ_last_page            = 0;
        __typ_last_character       = 0;
        __typ_last_audio_character = 0;
        
        __typ_last_tick_frame = -infinity;
        
        __typ_window_index       = 0;
        __typ_window_head_array  = array_create(__SCRIBBLE_WINDOW_COUNT, 0);
        __typ_window_max_array   = array_create(__SCRIBBLE_WINDOW_COUNT, 0);
        __typ_paused             = false;
        __typ_delay_paused       = false;
        __typ_delay_end          = -1;
        __typ_inline_speed       = 1;
        __typ_event_stack        = [];
        __typ_skip               = false;
        __typ_drawn_since_skip   = false;
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    static in = function(_speed, _smoothness)
    {
        var _old_in = __typ_in;
        
        __typ_in         = true;
        __typ_backwards  = false;
        __typ_speed      = _speed;
        __typ_smoothness = _smoothness;
        __typ_skip       = false;
        
        if ((_old_in == undefined) || !_old_in) reset();
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards=false]
    static out = function(_speed, _smoothness, _backwards = false)
    {
        var _old_in = __typ_in;
        
        __typ_in         = false;
        __typ_backwards  = _backwards;
        __typ_speed      = _speed;
        __typ_smoothness = _smoothness;
        __typ_skip       = false;
        
        if ((_old_in == undefined) || _old_in) reset();
        
        return self;
    }
    
    static skip = function(_state = true)
    {
        __typ_skip             = _state;
        __typ_skip_paused      = true;
        __typ_drawn_since_skip = false;
        
        return self;
    }
    
    static skip_to_pause = function(_state = true)
    {
        __typ_skip             = _state;
        __typ_skip_paused      = false;
        __typ_drawn_since_skip = false;
        
        return self;
    }
    
    static ignore_delay = function(_state = true)
    {
        __typ_ignore_delay = _state;
        
        return self;
    }
    
    /// @param soundArray
    /// @param overlap
    /// @param pitchMin
    /// @param pitchMax
    /// @param [gain=1]
    static sound = function(_in_sound_array, _overlap, _pitch_min, _pitch_max, _gain = 1)
    {
        var _sound_array = _in_sound_array;
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __typ_sound_array     = _sound_array;
        __typ_sound_overlap   = _overlap;
        __typ_sound_pitch_min = _pitch_min;
        __typ_sound_pitch_max = _pitch_max;
        __typ_sound_gain      = _gain;
        __typ_sound_per_char  = false;
        
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    /// @param [exceptionString]
    /// @param [gain=1]
    static sound_per_char = function(_in_sound_array, _pitch_min, _pitch_max, _exception_string, _gain = 1)
    {
        var _sound_array = _in_sound_array;
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __typ_sound_array     = _sound_array;
        __typ_sound_pitch_min = _pitch_min;
        __typ_sound_pitch_max = _pitch_max;
        __typ_sound_gain      = _gain;
        __typ_sound_per_char  = true;
        
        if (is_string(_exception_string))
        {
            if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("SCRIBBLE_ALLOW_GLYPH_DATA_GETTER must be set to <true> to use sound-per-character exceptions");
            
            __typ_sound_per_char_exception = true;
            __typ_sound_per_char_exception_dict = {};
            
            var _i = 1;
            repeat(string_length(_exception_string))
            {
                __typ_sound_per_char_exception_dict[$ ord(string_char_at(_exception_string, _i))] = true;
                ++_i;
            }
        }
        else
        {
            __typ_sound_per_char_exception = false;
        }
        
        return self;
    }
    
    static function_per_char = function(_function)
    {
        __typ_function_per_char = _function;
        
        return self;
    }
    
    static function_on_complete = function(_function)
    {
        __typ_function_on_complete = _function;
        
        return self;
    }
    
    static execution_scope = function(_scope)
    {
        __typ_function_scope = _scope;
        
        return self;
    }
    
    static pause = function()
    {
        __typ_paused = true;
        
        return self;
    }
    
    static unpause = function()
    {
        if (__typ_paused)
        {
            var _head_pos = __typ_window_max_array[__typ_window_index];
            
            //Increment the window index
            __typ_window_index = (__typ_window_index + 1) mod __SCRIBBLE_WINDOW_COUNT;
            __typ_window_head_array[@ __typ_window_index] = _head_pos;
        }
        
        __typ_skip   = false;
        __typ_paused = false;
        
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
        __typ_ease_method         = _ease_method;
        __typ_ease_dx             = _dx;
        __typ_ease_dy             = _dy;
        __typ_ease_xscale         = _xscale;
        __typ_ease_yscale         = _yscale;
        __typ_ease_rotation       = _rotation;
        __typ_ease_alpha_duration = _alpha_duration;
        
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
        __typ_character_delay = true;
        __typ_character_delay_dict[$ _code] = _delay;
        
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
        variable_struct_remove(__typ_character_delay_dict, _code);
        
        return self;
    }
    
    static character_delay_clear = function()
    {
        __typ_character_delay = false;
        __typ_character_delay_dict = {};
        
        return self;
    }
    
    #endregion
    
    
    
    #region Getters
    
    static get_skip = function()
    {
        return __typ_skip;
    }
    
    static get_ignore_delay = function()
    {
        return __typ_ignore_delay;
    }
    
    static get_state = function()
    {
        if ((__typ_last_element == undefined) || (__typ_last_page == undefined) || (__typ_last_character == undefined)) return 0.0;
        if (__typ_in == undefined) return 1.0;
        
        if (!weak_ref_alive(__typ_last_element)) return 2.0; //If there's no element then report that the element is totally faded out
        
        var _model = __typ_last_element.ref.__get_model(true);
        if (!is_struct(_model)) return 2.0; //If there's no model then report that the element is totally faded out
        
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) <= __typ_last_page) return 1.0;
        var _page_data = _pages_array[__typ_last_page];
        
        var _max = __typ_per_line? _page_data.__line_count : _page_data.__character_count;
        if (_max <= 0) return 1.0;
        
        var _t = clamp((__typ_window_head_array[__typ_window_index] + max(0, __typ_window_max_array[__typ_window_index] + __typ_smoothness - _max)) / (_max + __typ_smoothness), 0, 1);
        
        if (__typ_in)
        {
            if (__typ_delay_paused || (array_length(__typ_event_stack) > 0))
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
        return __typ_paused;
    }
    
    static get_position = function()
    {
        if (__typ_in == undefined) return 0;
        return __typ_window_head_array[__typ_window_index];
    }
    
    static get_text_element = function()
    {
        return weak_ref_alive(__typ_last_element)? __typ_last_element.ref : undefined;
    }
    
    static get_execution_scope = function()
    {
        return __typ_function_scope;
    }
    
    #endregion
    
    
    
    #region Sync
    
    static sync_to_sound = function(_instance)
    {
        if (_instance < 400000)
        {
            __scribble_error("Cannot synchronise to a sound asset. Please provide a sound instance (as returned by audio_play_sound())");
        }
        
        if (!audio_is_playing(_instance))
        {
            __scribble_error("Sound instance ", _instance, " is not playing\nCannot sync to a stopped sound instance");
        }
        
        __typ_paused       = false;
        __typ_delay_paused = false;
        
        __sync_reset();
        __typ_sync_started  = true;
        __typ_sync_instance = _instance;
        
        return self;
    }
    
    static __sync_reset = function()
    {
        __typ_sync_started   = false;
        __typ_sync_instance  = undefined;
        __typ_sync_paused    = false;
        __typ_sync_pause_end = infinity;
    }
    
    #endregion
    
    
    
    static __associate = function(_text_element)
    {
        var _carry_skip = __typ_skip && ((__typ_last_element == undefined) || !__typ_drawn_since_skip);
        
        if ((__typ_last_element == undefined) || !weak_ref_alive(__typ_last_element) || (__typ_last_element.ref != _text_element)) //We didn't have an element defined, or we swapped to a different element
        {
            reset();
            __typ_last_element = weak_ref_create(_text_element);
        }
        else if (!weak_ref_alive(__typ_last_element)) //Our associated element got GC'd for some reason and we didn't
        {
            __scribble_trace("Warning! Typist's target text element has been garbage collected");
            reset();
            __typ_last_element = weak_ref_create(_text_element);
        }
        
        if (_carry_skip)
        {
            __typ_skip             = true;
            __typ_drawn_since_skip = false;
        }
        
        return self;
    }
    
    static __process_event_stack = function(_character_count, _target_element, _function_scope)
    {
        static _typewriter_event_dict = __scribble_state.__typewriter_events_dict;
        
        //This method processes events on the stack (which is filled by copying data from the target element in .__TypistTick())
        //We return <true> if there have been no pausing behaviours called i.e. [pause] and [delay]
        //We return <false> immediately if we do run into pausing behaviours
        
        repeat(array_length(__typ_event_stack))
        {
            //Pop the first event from the stack
            var _event_struct = __typ_event_stack[0];
            array_delete(__typ_event_stack, 0, 1);
            
            //Collect data from the struct
            //This data is set in __scribble_generate_model() via the .__new_event() method on the model class
            var _event_position = __typ_per_line? _event_struct.line_index : _event_struct.character_index;
            var _event_name     = _event_struct.name;
            var _event_data     = _event_struct.data;
            
            switch(_event_name)
            {
                //Simple pause
                case "pause":
                    if (!__typ_skip && !__typ_sync_started) || (!__typ_skip_paused)
                    {
                        if (SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK && (__typ_last_character >= _character_count) && (array_length(__typ_event_stack) <= 0))
                        {
                            __scribble_trace("Warning! Ignoring [pause] command before the end of a page");
                        }
                        else
                        {
                            __typ_paused = true;
                            
                            __typ_window_max_array[@ __typ_window_index] = __typ_last_character-1;
                            
                            return false;
                        }
                    }
                break;
                
                //Time-related delay
                case "delay":
                    if (!__typ_skip && !__typ_ignore_delay && !__typ_sync_started)
                    {
                        var _duration = (array_length(_event_data) >= 1)? real(_event_data[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __typ_delay_paused = true;
                        __typ_delay_end    = current_time + _duration;
                        
                        __typ_window_max_array[@ __typ_window_index] = __typ_last_character-1;
                        
                        return false;
                    }
                break;
                
                //Audio playback synchronisation
                case "sync":
                    if (!__typ_skip && __typ_sync_started)
                    {
                        __typ_sync_paused    = true;
                        __typ_sync_pause_end = real(_event_data[0]);
                        
                        __typ_window_max_array[@ __typ_window_index] = __typ_last_character-1;
                        
                        return false;
                    }
                break;
                
                //In-line speed setting
                case "speed":
                    if (array_length(_event_data) >= 1) __typ_inline_speed = real(_event_data[0]);
                break;
                
                case "/speed":
                    __typ_inline_speed = 1;
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
                    
                    if (__typ_paused) return false;
                break;
            }
        }
        
        return true;
    }
    
    static __play_sound = function(_head_pos, _character)
    {
        var _sound_array = __typ_sound_array;
        if (is_array(_sound_array) && (array_length(_sound_array) > 0))
        {
            var _play_sound = false;
            if (__typ_sound_per_char)
            {
                //Only play audio if a new character has been revealled
                if (floor(_head_pos + 0.0001) > floor(__typ_last_audio_character))
                {
                    if (!__typ_sound_per_char_exception)
                    {
                        _play_sound = true;
                    }
                    else if (!variable_struct_exists(__typ_sound_per_char_exception_dict, _character))
                    {
                        _play_sound = true;
                    }
                }
            }
            else if (current_time >= __typ_sound_finish_time) 
            {
                _play_sound = true;
            }
            
            if (_play_sound)
            {
                __typ_last_audio_character = _head_pos;
                
                var _audio_asset = _sound_array[floor(__scribble_random()*array_length(_sound_array))];
                if (is_string(_audio_asset))
                {
                    _audio_asset = __external_sound_map[? _audio_asset];
                }
                
                if (_audio_asset != undefined)
                {
                    var _inst = audio_play_sound(_audio_asset, 0, false);
                    audio_sound_pitch(_inst, lerp(__typ_sound_pitch_min, __typ_sound_pitch_max, __scribble_random()));
                    audio_sound_gain(_inst, __typ_sound_gain, 0);
                    __typ_sound_finish_time = current_time + 1000*audio_sound_length(_inst) - __typ_sound_overlap;
                }
            }
        }
    }
    
    static __execute_function_per_character = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__typ_function_per_char))
        {
            __typ_function_per_char(_function_scope, __typ_last_character - 1, self);
        }
        else if (is_real(__typ_function_per_char) && script_exists(__typ_function_per_char))
        {
            script_execute(__typ_function_per_char, _function_scope, __typ_last_character - 1, self);
        }
    }
    
    static __execute_function_on_complete = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__typ_function_on_complete))
        {
            __typ_function_on_complete(_function_scope, self);
        }
        else if (is_real(__typ_function_on_complete) && script_exists(__typ_function_on_complete))
        {
            script_execute(__typ_function_on_complete, _function_scope, self);
        }
    }
    
    static __TypistTick = function(_target_element, _in_function_scope)
    {
        var _function_scope = (__typ_function_scope != undefined)? __typ_function_scope : _in_function_scope;
        
        //Associate the typist with the target element so that we're pulling data from the correct place
        //This saves the user from doing it themselves
        __associate(_target_element);
        
        if (__typ_skip) __typ_drawn_since_skip = true;
        
        //Don't tick if it's been less than a frame since we were last updated
        if (__scribble_state.__frames <= __typ_last_tick_frame) return undefined;
        __typ_last_tick_frame = __scribble_state.__frames;
        
        //If __typ_in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typ_in == undefined) return undefined;
        
        //Ensure we unhook synchronisation if the audio instance stops playing
        if (__typ_sync_started)
        {
            if ((__typ_sync_instance == undefined) || !audio_is_playing(__typ_sync_instance)) __sync_reset();
        }
        
        //Calculate our speed based on our set typewriter speed, any in-line [speed] tags, and the overall tick size
        //We set inline speed in __process_event_stack()
        var _speed = __typ_speed*__typ_inline_speed*SCRIBBLE_TICK_SIZE;
        
        //Find the leading edge of our windows
        var _head_pos = __typ_window_head_array[__typ_window_index];
        
        //Find the model from the last element
        if (!weak_ref_alive(__typ_last_element)) return undefined;
        var _element = __typ_last_element.ref;
        
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
        
        if (!__typ_in)
        {
            
        }
        else
        {
            //Handle pausing
            var _paused = false;
            
            if (__typ_paused)
            {
                _paused = true;
            }
            else if (__typ_delay_paused)
            {
                if ((current_time > __typ_delay_end) || __typ_ignore_delay)
                {
                    //We've waited long enough, start showing more text
                    __typ_delay_paused = false;
                    
                    //Increment the window index
                    var _head_pos = __typ_window_max_array[__typ_window_index];
                    __typ_window_index = (__typ_window_index + 1) mod __SCRIBBLE_WINDOW_COUNT;
                    __typ_window_head_array[@ __typ_window_index] = _head_pos;
                }
                else
                {
                    _paused = true;
                }
            }
            else if (__typ_sync_started)
            {
                if (audio_is_paused(__typ_sync_instance))
                {
                    _paused = true;
                }
                else if (__typ_sync_paused)
                {
                    if (audio_sound_get_track_position(__typ_sync_instance) > __typ_sync_pause_end)
                    {
                        //If enough of the source audio has been played, start showing more text
                        __typ_sync_paused = false;
                        
                        //Increment the window index
                        var _head_pos = __typ_window_max_array[__typ_window_index];
                        __typ_window_index = (__typ_window_index + 1) mod __SCRIBBLE_WINDOW_COUNT;
                        __typ_window_head_array[@ __typ_window_index] = _head_pos;
                    }
                    else
                    {
                        _paused = true;
                    }
                }
            }
            
            //If we've still got stuff on the event stack, pop those off
            if (!_paused && (array_length(__typ_event_stack) > 0))
            {
                if (!__process_event_stack(infinity, _target_element, _function_scope)) _paused = true;
            }
            
            if (_paused)
            {
                __typ_window_head_array[@ __typ_window_index] = min(__typ_window_head_array[__typ_window_index] + _speed, __typ_window_max_array[__typ_window_index] + __typ_smoothness);
            }
            else
            {
                var _play_sound = false;
                
                __typ_window_head_array[@ __typ_window_index] = max(__typ_window_head_array[__typ_window_index], _min_target);
                __typ_window_max_array[@  __typ_window_index] = _max_target;
                
                var _remaining = (_max_target + __typ_smoothness) - _head_pos;
                if (not __typ_skip) _remaining = min(_remaining, _speed);
                
                while(_remaining > 0)
                {
                    //Scan for events one character at a time
                    _head_pos += min(1, _remaining);
                    _remaining -= 1;
                    
                    //Only scan for new events if we've moved onto a new character
                    if (_head_pos >= __typ_last_character)
                    {
                        _play_sound = true;
                        
                        //Get an array of events for this character from the text element
                        var _found_events = __typ_last_element.ref.get_events(__typ_last_character, undefined, __typ_per_line);
                        var _found_size = array_length(_found_events);
                        
                        //Add a per-character delay if required
                        if (SCRIBBLE_ALLOW_GLYPH_DATA_GETTER
                        &&  !__typ_ignore_delay
                        &&  __typ_character_delay
                        &&  (__typ_last_character >= 1) //Don't check character delay until we're on the first character (index=1)
                        &&  ((__typ_last_character < (SCRIBBLE_DELAY_LAST_CHARACTER? _max_target : (_max_target-1))) || (_found_size > 0)))
                        {
                            var _glyph_ord = _model.__glyph_data_grid[# __typ_last_character-1, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                            
                            var _delay = __typ_character_delay_dict[$ _glyph_ord];
                            _delay = (_delay == undefined)? 0 : _delay;
                            
                            if (__typ_last_character > 1)
                            {
                                _glyph_ord = (_glyph_ord << 32) | _model.__glyph_data_grid[# __typ_last_character-2, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                                var _double_char_delay = __typ_character_delay_dict[$ _glyph_ord];
                                _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                
                                _delay = max(_delay, _double_char_delay);
                            }
                            
                            if (_delay > 0) array_push(__typ_event_stack, new __scribble_class_event("delay", [_delay]));
                        }
                        
                        //Move to the next character
                        __typ_last_character++;
                        if (__typ_last_character > 1) __execute_function_per_character(_target_element);
                        
                        if (_found_size > 0)
                        {
                            //Copy our found array of events onto our stack
                            var _old_stack_size = array_length(__typ_event_stack);
                            array_resize(__typ_event_stack, _old_stack_size + _found_size);
                            array_copy(__typ_event_stack, _old_stack_size, _found_events, 0, _found_size);
                        }
                        
                        //Process the stack
                        //If we hit a [pause] or [delay] tag then the function returns <false> and we break out of the loop
                        if (!__process_event_stack(_max_target, _target_element, _function_scope))
                        {
                            _head_pos = __typ_last_character-1; //Lock our head position so we don't overstep
                            break;
                        }
                    }
                }
                
                if (_play_sound)
                {
                    if (__typ_last_character <= _max_target)
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
                __typ_window_head_array[@ __typ_window_index] = _head_pos;
            }
            
            __scribble_trace(__typ_window_head_array, " -> ", __typ_window_max_array);
        }
    }
    
    static __TypistSetShaderUniforms = function()
    {
        static _u_iTypistMethod        = shader_get_uniform(__shd_scribble, "u_iTypistMethod"       );
        static _u_fTypistSmoothness    = shader_get_uniform(__shd_scribble, "u_fTypistSmoothness"   );
        static _u_fTypistHeadArray     = shader_get_uniform(__shd_scribble, "u_fTypistHeadArray"    );
        static _u_fTypistMaxArray      = shader_get_uniform(__shd_scribble, "u_fTypistMaxArray"     );
        static _u_vTypistStartPos      = shader_get_uniform(__shd_scribble, "u_vTypistStartPos"     );
        static _u_vTypistStartScale    = shader_get_uniform(__shd_scribble, "u_vTypistStartScale"   );
        static _u_fTypistStartRotation = shader_get_uniform(__shd_scribble, "u_fTypistStartRotation");
        static _u_fTypistAlphaDuration = shader_get_uniform(__shd_scribble, "u_fTypistAlphaDuration");
        
        //If __typ_in hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typ_in == undefined)
        {
            shader_set_uniform_i(_u_iTypistMethod, SCRIBBLE_EASE.NONE);
            return undefined;
        }
        
        //Reset the "typist use lines" flag
        __scribble_state.__render_flag_value = ((__scribble_state.__render_flag_value & (~(0x40))) | (__typ_per_line << 6));
        
        shader_set_uniform_i(_u_iTypistMethod,          __typ_in? __typ_ease_method : (__typ_ease_method + SCRIBBLE_EASE.__SIZE));
        shader_set_uniform_f(_u_fTypistSmoothness,      __typ_smoothness);
        shader_set_uniform_f(_u_vTypistStartPos,        __typ_ease_dx, __typ_ease_dy);
        shader_set_uniform_f(_u_vTypistStartScale,      __typ_ease_xscale, __typ_ease_yscale);
        shader_set_uniform_f(_u_fTypistStartRotation,   __typ_ease_rotation);
        shader_set_uniform_f(_u_fTypistAlphaDuration,   __typ_ease_alpha_duration);
        shader_set_uniform_f_array(_u_fTypistHeadArray, __typ_window_head_array);
        shader_set_uniform_f_array(_u_fTypistMaxArray,  __typ_window_max_array);
    }
}