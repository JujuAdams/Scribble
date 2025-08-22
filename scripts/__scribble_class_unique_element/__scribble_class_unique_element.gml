// Feather disable all

/// @param string
/// @param [perLine=false]

function __scribble_class_unique_element(_string, _perLine = false) : __scribble_class_shared_element(_string) constructor
{
    /// @param x
    /// @param y
    /// @param [typist_UNUSED]
    static draw = function(_x, _y, _typist_UNUSED = undefined)
    {
        if (_typist_UNUSED != undefined)
        {
            __scribble_error("Typists have been removed in favour of `scribble_unique()`. Please refer to documentation");
        }
        
        if (SCRIBBLE_FLOOR_DRAW_COORDINATES)
        {
            _x = floor(_x);
            _y = floor(_y);
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
        
        shader_set(__shd_scribble);
        __set_standard_uniforms();
        __typist_tick(other);
        __set_typist_shader_uniforms();
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__update_matrix(_model, _x, _y), _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__submit(__page, (__sdf_outline_thickness > 0) || (__sdf_shadow_alpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
        shader_reset();
        
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
    
    static flush = function()
    {
        __flushed = true;
    }
    
    /// @param string
    /// @param [uniqueID_UNUSED]
    static overwrite = function(_text, _unique_id_UNUSED)
    {
        __text = _text;
        __model_cache_name_dirty = true;
        
        return self;
    }
    
    static pre_update_typist = function(_typist)
    {
        __typist_tick(other);
        return self;
    }
    
    

    __typistSpeed      = 1;
    __typistSmoothness = 0;
    __typistIn         = undefined;
    __typistBackwards  = false;
    
    __typistSkip           = false;
    __typistSkipPaused     = false;
    __typistDrawnSinceSkip = false;
    
    __soundTagGain = 1;
    
    __soundArray                = undefined;
    __soundVoice                = -1;
    __soundOverlap              = 0;
    __soundPitchMin             = 1;
    __soundPitchMax             = 1;
    __soundGain                 = 1;
    __soundFinishTime           = current_time;
    __soundPerChar              = false;
    __soundPerCharException     = false;
    __soundPerCharExceptionDict = undefined;
    __soundPerCharInterrupt     = false;
    
    __ignoreDelay = false;
    
    __functionScope      = undefined;
    __functionPerChar    = undefined;
    __functionOnComplete = undefined;
    
    __easeMethod        = SCRIBBLE_EASE.LINEAR;
    __easeDX            = 0;
    __easeDY            = 0;
    __easeXScale        = 1;
    __easeYScale        = 1;
    __easeRotation      = 0;
    __easeAlphaDuration = 1.0;
    
    __characterDelay     = false;
    __characterDelayDict = {};
    
    __perLine = _perLine;
    
    __syncStarted  = false;
    __syncInstance = undefined;
    __syncPaused   = false;
    __syncPauseEnd = infinity;
    
    reset();
    
    
    
    #region Setters
    
    static reset = function()
    {
        __last_page            = 0;
        __last_character       = 0;
        __last_audio_character = 0;
        
        __last_tick_frame = -infinity;
        
        __window_index     = 0;
        __window_array     = array_create(2*__SCRIBBLE_WINDOW_COUNT, -__typistSmoothness); __window_array[@ 0] = 0;
        __paused           = false;
        __delay_paused     = false;
        __delay_end        = -1;
        __inline_speed     = 1;
        __event_stack      = [];
        __typistSkip             = false;
        __typistDrawnSinceSkip = false;
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    static in = function(_speed, _smoothness)
    {
        var _old_in = __typistIn;
        
        __typistIn         = true;
        __typistBackwards  = false;
        __typistSpeed      = _speed;
        __typistSmoothness = _smoothness;
        __typistSkip       = false;
        
        if ((_old_in == undefined) || !_old_in) reset();
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards=false]
    static out = function(_speed, _smoothness, _backwards = false)
    {
        var _old_in = __typistIn;
        
        __typistIn         = false;
        __typistBackwards  = _backwards;
        __typistSpeed      = _speed;
        __typistSmoothness = _smoothness;
        __typistSkip       = false;
        
        if ((_old_in == undefined) || _old_in) reset();
        
        return self;
    }
    
    static skip = function(_state = true)
    {
        __typistSkip = _state;
        __typistSkipPaused = true;
        __typistDrawnSinceSkip = false;
        __delay_end = -infinity;
        
        return self;
    }
    
    static skip_to_pause = function(_state = true)
    {
        __typistSkip = _state;
        __typistSkipPaused = false;
        __typistDrawnSinceSkip = false;
        __delay_end = -infinity;
        
        return self;
    }
    
    static ignore_delay = function(_state = true)
    {
        __ignoreDelay = _state;
        
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
        
        __soundArray     = _sound_array;
        __soundOverlap   = _overlap;
        __soundPitchMin = _pitch_min;
        __soundPitchMax = _pitch_max;
        __soundGain      = _gain;
        __soundPerChar  = false;
        
        return self;
    }
    
    /// @param soundArray
    /// @param pitchMin
    /// @param pitchMax
    /// @param [exceptionString]
    /// @param [gain=1]
    /// @param [interrupt=false]
    static sound_per_char = function(_in_sound_array, _pitch_min, _pitch_max, _exception_string, _gain = 1, _interrupt = false)
    {
        var _sound_array = _in_sound_array;
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __soundArray            = _sound_array;
        __soundPitchMin         = _pitch_min;
        __soundPitchMax         = _pitch_max;
        __soundGain             = _gain;
        __soundPerChar          = true;
        __soundPerCharInterrupt = _interrupt;
        
        if (is_string(_exception_string))
        {
            __soundPerCharException = true;
            __soundPerCharExceptionDict = {};
            
            var _i = 1;
            repeat(string_length(_exception_string))
            {
                __soundPerCharExceptionDict[$ ord(string_char_at(_exception_string, _i))] = true;
                ++_i;
            }
        }
        else
        {
            __soundPerCharException = false;
        }
        
        return self;
    }
    
    static function_per_char = function(_function)
    {
        __functionPerChar = _function;
        
        return self;
    }
    
    static function_on_complete = function(_function)
    {
        __functionOnComplete = _function;
        
        return self;
    }
    
    static execution_scope = function(_scope)
    {
        __functionScope = _scope;
        
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
            __window_array[@ __window_index+1] = _head_pos - __typistSmoothness;
        }
        __typistSkip = false;
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
        __easeMethod         = _ease_method;
        __easeDX             = _dx;
        __easeDY             = _dy;
        __easeXScale         = _xscale;
        __easeYScale         = _yscale;
        __easeRotation       = _rotation;
        __easeAlphaDuration = _alpha_duration;
        
        return self;
    }
    
    static character_delay_add = function(_character, _delay)
    {
        var _char_1 = _character;
        var _char_2 = 0;
        
        if (is_string(_character))
        {
            _char_1 = ord(string_char_at(_character, 1));
            if (string_length(_character) >= 2) _char_2 = ord(string_char_at(_character, 2));
        }
        
        var _code = _char_1 | (_char_2 << 32);
        __characterDelay = true;
        __characterDelayDict[$ _code] = _delay;
        
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
        variable_struct_remove(__characterDelayDict, _code);
        
        return self;
    }
    
    static character_delay_clear = function()
    {
        __characterDelay = false;
        __characterDelayDict = {};
        
        return self;
    }
    
    #endregion
    
    
    
    #region Getters
    
    static get_skip = function()
    {
        return __typistSkip;
    }
    
    static get_ignore_delay = function()
    {
        return __ignoreDelay;
    }
    
    static get_state = function()
    {
        if ((__last_page == undefined) || (__last_character == undefined)) return 0.0;
        if (__typistIn == undefined) return 1.0;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 2.0; //If there's no model then report that the element is totally faded out
        
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) <= __last_page) return 1.0;
        var _page_data = _pages_array[__last_page];
        
        var _max = __perLine? _page_data.__line_count : _page_data.__character_count;
        if (_max <= 0) return 1.0;
        
        var _t = clamp((__window_array[__window_index] + max(0, __window_array[__window_index+1] + __typistSmoothness - _max)) / (_max + __typistSmoothness), 0, 1);
        
        if (__typistIn)
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
    
    static get_delay_paused = function()
    {
        return __delay_paused;
    }
    
    static get_paused = function()
    {
        return __paused;
    }
    
    static get_position = function()
    {
        if (__typistIn == undefined) return 0;
        return __window_array[__window_index];
    }
    
    static get_execution_scope = function()
    {
        return __functionScope;
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
        
        __paused       = false;
        __delay_paused = false;
        
        __sync_reset();
        __syncStarted  = true;
        __syncInstance = _instance;
        
        return self;
    }
    
    static __sync_reset = function()
    {
        __syncStarted   = false;
        __syncInstance  = undefined;
        __syncPaused    = false;
        __syncPauseEnd = infinity;
    }
    
    #endregion
    
    
    
    #region Gain
    
    static set_sound_tag_gain = function(_gain)
    {
        __soundTagGain = _gain;
        return self;
    }
    
    static get_sound_tag_gain = function()
    {
        return __soundTagGain;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __process_event_stack = function(_character_count, _function_scope)
    {
        static _system = __scribble_system();
        static _typewriter_events_map = _system.__typewriter_events_map;
        
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
            var _event_position = __perLine? _event_struct.line_index : _event_struct.character_index;
            var _event_name     = _event_struct.name;
            var _event_data     = _event_struct.data;
            
            switch(_event_name)
            {
                //Simple pause
                case "pause":
                    if (!__typistSkip && !__syncStarted) || (!__typistSkipPaused)
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
                    if (!__typistSkip && !__ignoreDelay && !__syncStarted)
                    {
                        var _duration = (array_length(_event_data) >= 1)? real(_event_data[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __delay_paused = true;
                        __delay_end    = current_time + _duration;
                        
                        return false;
                    }
                break;
                
                //Audio playback synchronisation
                case "sync":
                    if (!__typistSkip && __syncStarted)
                    {
                        __syncPaused    = true;
                        __syncPauseEnd = real(_event_data[0]);
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
                        __scribble_play_sound(_event_data[0], __soundTagGain, 1);
                    }
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    sound(__scribble_parse_sound_array_string(_event_data[1]), real(_event_data[2]), real(_event_data[3]), real(_event_data[4]));
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    switch(array_length(_event_data))
                    {
                        case 4: sound_per_char(__scribble_parse_sound_array_string(_event_data[1]), real(_event_data[2]), real(_event_data[3])); break;
                        case 5: sound_per_char(__scribble_parse_sound_array_string(_event_data[1]), real(_event_data[2]), real(_event_data[3]), _event_data[4]); break;
                    }
                break;
                
                //Probably a current event
                default:
                    //Otherwise try to find a custom event
                    var _function = _typewriter_events_map[? _event_name];
                    if (is_method(_function))
                    {
                        with(_function_scope) _function(self, _event_data, _event_position);
                    }
                    else if ((_function != undefined) && script_exists(_function))
                    {
                        with(_function_scope) script_execute(_function, self, _event_data, _event_position);
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
        static _system = __scribble_system();
        
        var _sound_array = __soundArray;
        if (is_array(_sound_array) && (array_length(_sound_array) > 0))
        {
            var _play_sound = false;
            if (__soundPerChar)
            {
                //Only play audio if a new character has been revealled
                if (floor(_head_pos + 0.0001) > floor(__last_audio_character))
                {
                    if (not __soundPerCharException)
                    {
                        _play_sound = true;
                    }
                    else if (!variable_struct_exists(__soundPerCharExceptionDict, _character))
                    {
                        _play_sound = true;
                    }
                    
                    if (_play_sound && __soundPerCharInterrupt)
                    {
                        audio_stop_sound(__soundVoice);
                    }
                }
            }
            else if (current_time >= __soundFinishTime) 
            {
                _play_sound = true;
            }
            
            if (_play_sound)
            {
                __last_audio_character = _head_pos;
                
                __soundVoice = __scribble_play_sound(_sound_array[floor(__scribble_random()*array_length(_sound_array))], __soundGain, lerp(__soundPitchMin, __soundPitchMax, __scribble_random()));
                if (__soundVoice >= 0)
                {
                    __soundFinishTime = current_time + 1000*audio_sound_length(__soundVoice) - __soundOverlap;
                }
            }
        }
    }
    
    static __execute_function_per_character = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__functionPerChar))
        {
            __functionPerChar(_function_scope, __last_character - 1, self);
        }
        else if ((__functionPerChar != undefined) && script_exists(__functionPerChar))
        {
            script_execute(__functionPerChar, _function_scope, __last_character - 1, self);
        }
    }
    
    static __execute_function_on_complete = function(_function_scope)
    {
        //Execute function per character
        if (is_method(__functionOnComplete))
        {
            __functionOnComplete(_function_scope, self);
        }
        else if ((__functionOnComplete != undefined) && script_exists(__functionOnComplete))
        {
            script_execute(__functionOnComplete, _function_scope, self);
        }
    }
    
    static __typist_tick = function(_in_function_scope)
    {
        var _function_scope = (__functionScope != undefined)? __functionScope : _in_function_scope;
        
        if (__page != __last_page) //Page change
        {
            __last_page = __page;
            
            var _carry_skip = __typistSkip && (not __typistDrawnSinceSkip);
            reset();
            if (_carry_skip) __typistSkip = true;
        }
        
        if (__typistSkip) __typistDrawnSinceSkip = true;
        
        //Don't tick if it's been less than a frame since we were last updated
        if (__scribble_state.__frames <= __last_tick_frame) return undefined;
        __last_tick_frame = __scribble_state.__frames;
        
        //If __typistIn hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistIn == undefined) return undefined;
        
        //Ensure we unhook synchronisation if the audio instance stops playing
        if (__syncStarted)
        {
            if ((__syncInstance == undefined) || !audio_is_playing(__syncInstance)) __sync_reset();
        }
        
        //Calculate our speed based on our set typewriter speed, any in-line [speed] tags, and the overall tick size
        //We set inline speed in __process_event_stack()
        var _speed = __typistSpeed*__inline_speed*SCRIBBLE_TICK_SIZE;
        
        //Find the leading edge of our windows
        var _head_pos = __window_array[__window_index];
        
        //Find the model from the last element
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        var _glyph_data_getter = _model.__allow_glyph_data_getter;
        
        //Get page data
        //We use this to set the maximum limit for the typewriter feature
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) == 0) return undefined;
        var _page_data = _pages_array[__last_page];
        var _page_character_count = __perLine? _page_data.__line_count : _page_data.__character_count;
        
        if (!__typistIn)
        {
            if (__typistSkip)
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
                if ((current_time > __delay_end) || __ignoreDelay)
                {
                    //We've waited long enough, start showing more text
                    __delay_paused = false;
                    
                    //Increment the window index
                    __window_index = (__window_index + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
                    __window_array[@ __window_index  ] = _head_pos;
                    __window_array[@ __window_index+1] = _head_pos - __typistSmoothness;
                }
                else
                {
                    _paused = true;
                }
            }
            else if (__syncStarted)
            {
                if (audio_is_paused(__syncInstance))
                {
                    _paused = true;
                }
                else if (__syncPaused)
                {
                    if (audio_sound_get_track_position(__syncInstance) > __syncPauseEnd)
                    {
                        //If enough of the source audio has been played, start showing more text
                        __syncPaused = false;
                        
                        //Increment the window index
                        __window_index = (__window_index + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
                        __window_array[@ __window_index  ] = _head_pos;
                        __window_array[@ __window_index+1] = _head_pos - __typistSmoothness;
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
                if (!__process_event_stack(_page_character_count, _function_scope)) _paused = true;
            }
            
            if (!_paused)
            {
                var _play_sound = false;
                
                if (__typistSkip)
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
                        var _found_events = get_events(__last_character, undefined, __perLine);
                        var _found_size = array_length(_found_events);
                        
                        //Add a per-character delay if required
                        if (_glyph_data_getter
                        &&  !__ignoreDelay
                        &&  __characterDelay
                        &&  (__last_character >= 1) //Don't check character delay until we're on the first character (index=1)
                        &&  ((__last_character < (SCRIBBLE_DELAY_LAST_CHARACTER? _page_character_count : (_page_character_count-1))) || (_found_size > 0)))
                        {
                            var _glyph_ord = _page_data.__glyph_grid[# __last_character-1, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                            
                            var _delay = __characterDelayDict[$ _glyph_ord];
                            _delay = (_delay == undefined)? 0 : _delay;
                            
                            if (__last_character > 1)
                            {
                                _glyph_ord = (_glyph_ord << 32) | _page_data.__glyph_grid[# __last_character-2, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE];
                                var _double_char_delay = __characterDelayDict[$ _glyph_ord];
                                _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                
                                _delay = max(_delay, _double_char_delay);
                            }
                            
                            if (_delay > 0) array_push(__event_stack, new __scribble_class_event("delay", [_delay]));
                        }
                        
                        //Move to the next character
                        __last_character++;
                        if (__last_character > 1) __execute_function_per_character();
                        
                        if (_found_size > 0)
                        {
                            //Copy our found array of events onto our stack
                            var _old_stack_size = array_length(__event_stack);
                            array_resize(__event_stack, _old_stack_size + _found_size);
                            array_copy(__event_stack, _old_stack_size, _found_events, 0, _found_size);
                        }
                        
                        //Process the stack
                        //If we hit a [pause] or [delay] tag then the function returns <false> and we break out of the loop
                        if (!__process_event_stack(_page_character_count, _function_scope))
                        {
                            _head_pos = __last_character-1; //Lock our head position so we don't overstep
                            break;
                        }
                    }
                }
                
                if (_play_sound)
                {
                    if (__last_character <= _page_character_count)
                    {
                        //Only play sound once per frame if we're going reaaaally fast
                        __play_sound(_head_pos, _glyph_data_getter? (_page_data.__glyph_grid[# _head_pos-1, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE]) : 0);
                    }
                    else
                    {
                        //Execute our on-complete callback when we finish
                        __execute_function_on_complete(_function_scope);
                    }
                }
                
                //Set the typewriter head
                __window_array[@ __window_index] = _head_pos;
            }
        }
        
        //Move the typewriter tail
        if (__typistSkip)
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
    
    static __set_typist_shader_uniforms = function()
    {
        static _u_iTypewriterUseLines      = shader_get_uniform(__shd_scribble, "u_iTypewriterUseLines"     );
        static _u_iTypewriterMethod        = shader_get_uniform(__shd_scribble, "u_iTypewriterMethod"       );
        static _u_iTypewriterCharMax       = shader_get_uniform(__shd_scribble, "u_iTypewriterCharMax"      );
        static _u_fTypewriterWindowArray   = shader_get_uniform(__shd_scribble, "u_fTypewriterWindowArray"  );
        static _u_fTypewriterSmoothness    = shader_get_uniform(__shd_scribble, "u_fTypewriterSmoothness"   );
        static _u_vTypewriterStartPos      = shader_get_uniform(__shd_scribble, "u_vTypewriterStartPos"     );
        static _u_vTypewriterStartScale    = shader_get_uniform(__shd_scribble, "u_vTypewriterStartScale"   );
        static _u_fTypewriterStartRotation = shader_get_uniform(__shd_scribble, "u_fTypewriterStartRotation");
        static _u_fTypewriterAlphaDuration = shader_get_uniform(__shd_scribble, "u_fTypewriterAlphaDuration");
        
        //If __typistIn hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistIn == undefined)
        {
            shader_set_uniform_i(_u_iTypewriterMethod, SCRIBBLE_EASE.NONE);
            return undefined;
        }
        
        var _method = __easeMethod;
        if (!__typistIn) _method += SCRIBBLE_EASE.__SIZE;
        
        var _char_max = 0;
        if (__typistBackwards)
        {
            var _model = __get_model(true);
            if (!is_struct(_model)) return undefined;
            
            var _pages_array = _model.__get_page_array();
            if (array_length(_pages_array) > __last_page)
            {
                var _page_data = _pages_array[__last_page];
                _char_max = __perLine? _page_data.__line_count : _page_data.__character_count;
            }
            else
            {
                __scribble_trace("Warning! Typist page (", __last_page, ") exceeds text element page count (", array_length(_pages_array), ")");
            }
        }
        
        shader_set_uniform_i(_u_iTypewriterUseLines,          __perLine);
        shader_set_uniform_i(_u_iTypewriterMethod,            _method);
        shader_set_uniform_i(_u_iTypewriterCharMax,           _char_max);
        shader_set_uniform_f(_u_fTypewriterSmoothness,        __typistSmoothness);
        shader_set_uniform_f(_u_vTypewriterStartPos,          __easeDX, __easeDY);
        shader_set_uniform_f(_u_vTypewriterStartScale,        __easeXScale, __easeYScale);
        shader_set_uniform_f(_u_fTypewriterStartRotation,     __easeRotation);
        shader_set_uniform_f(_u_fTypewriterAlphaDuration,     __easeAlphaDuration);
        shader_set_uniform_f_array(_u_fTypewriterWindowArray, __window_array);
    }
    
    #endregion
}