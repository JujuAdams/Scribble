// Feather disable all

/// @param string

function __scribble_class_unique_element(_string) : __scribble_class_shared_element(_string) constructor
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
        
        __TypistUpdateFromDraw(other);
        __SetTypistShaderUniforms();
        
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
        if (__text != _text)
        {
            __text = _text;
            __model_cache_name_dirty = true;
        }
        
        return self;
    }
    
    static pre_update_typist = function(_typist)
    {
        __TypistMove(other, 0, false);
        return self;
    }
    
    static page = function(_page)
    {
        if (_page != __page)
        {
            var _carrySkip = __typistSkip && (not __typistDrawnSinceSkip);
            reset();
            if (_carrySkip) __typistSkip = true;
        }
        
        return __set_page(_page);
    }
    
    static reveal_type = function(_state)
    {
        if (__revealType != _state)
        {
            __revealType = _state;
            __model_cache_name_dirty = true;
        }
        
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
    __functionPerReveal  = undefined;
    __functionOnComplete = undefined;
    
    __easeMethod        = SCRIBBLE_EASE_LINEAR;
    __easeDX            = 0;
    __easeDY            = 0;
    __easeXScale        = 1;
    __easeYScale        = 1;
    __easeRotation      = 0;
    __easeAlphaDuration = 1.0;
    
    __characterDelay     = false;
    __characterDelayDict = {};
    
    __syncStarted  = false;
    __syncInstance = undefined;
    __syncPaused   = false;
    __syncPauseEnd = infinity;
    
    reset();
    
    
    
    #region Setters
    
    static reset = function()
    {
        __prevRevealIndex      = 0;
        __last_audio_character = 0;
        
        __prevTickFrame = -infinity;
        
        __windowIndex          = 0;
        __windowArray          = array_create(2*__SCRIBBLE_WINDOW_COUNT, -__typistSmoothness); __windowArray[@ 0] = 0;
        __typistManualPause    = false;
        __typistDelayPause     = false;
        __typistDelayEnd       = -1;
        __typistInlineSpeed    = 1;
        __eventStack           = [];
        __typistSkip           = false;
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
        __typistSkip           = _state;
        __typistSkipPaused     = true;
        __typistDrawnSinceSkip = false;
        __typistDelayEnd       = -infinity;
        
        return self;
    }
    
    static skip_to_pause = function(_state = true)
    {
        __typistSkip           = _state;
        __typistSkipPaused     = false;
        __typistDrawnSinceSkip = false;
        __typistDelayEnd       = -infinity;
        
        return self;
    }
    
    static set_position = function(_value)
    {
        var _delta = _value - __windowArray[@ __windowIndex];
        if (_delta > 0)
        {
            __TypistMove(other, _delta, false);
        }
        
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
        var _soundArray = _in_sound_array;
        if (!is_array(_soundArray)) _soundArray = [_soundArray];
        
        __soundArray     = _soundArray;
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
        var _soundArray = _in_sound_array;
        if (!is_array(_soundArray)) _soundArray = [_soundArray];
        
        __soundArray            = _soundArray;
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
        __functionPerReveal = _function;
        
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
        __typistManualPause = true;
        
        return self;
    }
    
    static unpause = function()
    {
        if (__typistManualPause)
        {
            var _revealPos = __windowArray[__windowIndex];
            
            //Increment the window index
            __windowIndex = (__windowIndex + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
            __windowArray[@ __windowIndex  ] = _revealPos;
            __windowArray[@ __windowIndex+1] = _revealPos - __typistSmoothness;
        }
        __typistSkip = false;
        __typistManualPause = false;
        
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
        if (not __allow_glyph_data_getter)
        {
            __scribble_trace("Warning! `.character_delay_add()` automatically calling `.allow_glyph_data_getter()`");
            allow_glyph_data_getter();
        }
        
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
        if (__prevRevealIndex == undefined) return 0.0;
        if (__typistIn == undefined) return 1.0;
        
        var _model = __get_model(true);
        if (!is_struct(_model)) return 2.0; //If there's no model then report that the element is totally faded out
        
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) <= __page) return 1.0;
        var _page_data = _pages_array[__page];
        
        var _max = _page_data.__reveal_count;
        if (_max <= 0) return 1.0;
        
        var _t = clamp((__windowArray[__windowIndex] + max(0, __windowArray[__windowIndex+1] + __typistSmoothness - _max)) / (_max + __typistSmoothness), 0, 1);
        
        if (__typistIn)
        {
            if (__typistDelayPause || (array_length(__eventStack) > 0))
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
        return __typistDelayPause;
    }
    
    static get_paused = function()
    {
        return __typistManualPause;
    }
    
    static get_position = function()
    {
        if (__typistIn == undefined) return 0;
        return __windowArray[__windowIndex];
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
        
        if (not audio_is_playing(_instance))
        {
            __scribble_error("Sound instance ", _instance, " is not playing\nCannot sync to a stopped sound instance");
        }
        
        __typistManualPause = false;
        __typistDelayPause  = false;
        
        __SyncReset();
        __syncStarted  = true;
        __syncInstance = _instance;
        
        return self;
    }
    
    static __SyncReset = function()
    {
        __syncStarted  = false;
        __syncInstance = undefined;
        __syncPaused   = false;
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
    
    static __ProcessEventStack = function(_revealCount, _functionScope)
    {
        static _system = __scribble_system();
        static _typewriter_events_map = _system.__typewriter_events_map;
        
        //This method processes events on the stack (which is filled by copying data from the target element in .__tick())
        //We return <true> if there have been no pausing behaviours called i.e. [pause] and [delay]
        //We return <false> immediately if we do run into pausing behaviours
        
        repeat(array_length(__eventStack))
        {
            //Pop the first event from the stack
            var _event_struct = __eventStack[0];
            array_delete(__eventStack, 0, 1);
            
            //Collect data from the struct
            //This data is set in __scribble_generate_model() via the .__new_event() method on the model class
            var _event_position = _event_struct.reveal_index;
            var _event_name     = _event_struct.name;
            var _event_data     = _event_struct.data;
            
            switch(_event_name)
            {
                //Simple pause
                case "pause":
                    if (!__typistSkip && !__syncStarted) || (!__typistSkipPaused)
                    {
                        if (SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK && (__prevRevealIndex >= _revealCount) && (array_length(__eventStack) <= 0))
                        {
                            __scribble_trace("Warning! Ignoring [pause] command before the end of a page");
                        }
                        else
                        {
                            __typistManualPause = true;
                            
                            return false;
                        }
                    }
                break;
                
                //Time-related delay
                case "delay":
                    if (!__typistSkip && !__ignoreDelay && !__syncStarted)
                    {
                        var _duration = (array_length(_event_data) >= 1)? real(_event_data[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __typistDelayPause = true;
                        __typistDelayEnd   = current_time + _duration;
                        
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
                    if (array_length(_event_data) >= 1) __typistInlineSpeed = real(_event_data[0]);
                break;
                
                case "/speed":
                    __typistInlineSpeed = 1;
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
                    //FIXME - We should not be passing the reveal index to external functions (should be the character index)
                    
                    //Otherwise try to find a custom event
                    var _function = _typewriter_events_map[? _event_name];
                    if (is_method(_function))
                    {
                        with(_functionScope) _function(self, _event_data, _event_position);
                    }
                    else if ((_function != undefined) && script_exists(_function))
                    {
                        with(_functionScope) script_execute(_function, self, _event_data, _event_position);
                    }
                    else
                    {
                        __scribble_trace("Warning! Event [", _event_name, "] not recognised");
                    }

                    if (__typistManualPause) return false;
                break;
            }
        }
        
        return true;
    }
    
    static __PlaySound = function(_revealPos, _character)
    {
        static _system = __scribble_system();
        
        var _soundArray = __soundArray;
        if (is_array(_soundArray) && (array_length(_soundArray) > 0))
        {
            var _playSound = false;
            if (__soundPerChar)
            {
                //Only play audio if a new character has been revealled
                if (floor(_revealPos + 0.0001) > floor(__last_audio_character))
                {
                    if (not __soundPerCharException)
                    {
                        _playSound = true;
                    }
                    else if (!variable_struct_exists(__soundPerCharExceptionDict, _character))
                    {
                        _playSound = true;
                    }
                    
                    if (_playSound && __soundPerCharInterrupt)
                    {
                        audio_stop_sound(__soundVoice);
                    }
                }
            }
            else if (current_time >= __soundFinishTime) 
            {
                _playSound = true;
            }
            
            if (_playSound)
            {
                __last_audio_character = _revealPos;
                
                __soundVoice = __scribble_play_sound(_soundArray[floor(__scribble_random()*array_length(_soundArray))], __soundGain, lerp(__soundPitchMin, __soundPitchMax, __scribble_random()));
                if (__soundVoice >= 0)
                {
                    __soundFinishTime = current_time + 1000*audio_sound_length(__soundVoice) - __soundOverlap;
                }
            }
        }
    }
    
    static __ExecuteFunctionPerReveal = function(_functionScope)
    {
        if (is_callable(__functionPerReveal))
        {
            __functionPerReveal(_functionScope, __prevRevealIndex - 1, self);
        }
    }
    
    static __ExecuteFunctionOnComplete = function(_functionScope)
    {
        if (is_callable(__functionOnComplete))
        {
            __functionOnComplete(_functionScope, self);
        }
    }
    
    static __TypistUpdateFromDraw = function(_inFunctionScope)
    {
        if (__typistSkip)
        {
            __typistDrawnSinceSkip = true;
        }
        
        //Don't move the typist if it's been less than a frame since we were last updated
        if (__scribble_state.__frames <= __prevTickFrame) return undefined;
        __prevTickFrame = __scribble_state.__frames;
        
        return __TypistMove(_inFunctionScope, __typistSpeed*__typistInlineSpeed*SCRIBBLE_TICK_SIZE, false);
    }
    
    static __TypistMove = function(_inFunctionScope, _rawDelta, _forceSkip)
    {
        var _functionScope = __functionScope ?? _inFunctionScope;
        
        //If __typistIn hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistIn == undefined) return undefined;
        
        //Ensure we unhook synchronisation if the audio instance stops playing
        if (__syncStarted)
        {
            if ((__syncInstance == undefined) || not audio_is_playing(__syncInstance))
            {
                __SyncReset();
            }
        }
        
        //Find the model from the last element
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        var _glyphDataGetter = _model.__allow_glyph_data_getter;
        var _perCharacter = (__revealType == SCRIBBLE_REVEAL_PER_CHAR);
        
        //Get page data
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) == 0) return undefined;
        var _page_data = _pages_array[__page];
        var _pageRevealCount = _page_data.__reveal_count;
        
        //Find the leading edge of our windows
        var _revealPos = __windowArray[__windowIndex];
        
        if (__typistSkip)
        {
            _rawDelta = infinity;
        }
        
        var _delta = min(_rawDelta, _pageRevealCount - _revealPos);
        
        if (not __typistIn)
        {
            ///////
            // Type out forwards
            ///////
            
            __windowArray[@ __windowIndex] = min(_pageRevealCount, _revealPos + _delta);
        }
        else if (_delta < 0)
        {
            ///////
            // Type out backwards
            ///////
            
            //TODO
        }
        else
        {
            var _canMove = true;
            var _moved   = false;
            
            ///////
            // Handle pausing
            ///////
            
            if (__typistManualPause)
            {
                _canMove = false;
            }
            else if (__typistDelayPause)
            {
                if ((current_time > __typistDelayEnd) || __ignoreDelay)
                {
                    //We've waited long enough, start showing more text
                    __typistDelayPause = false;
                    
                    //Increment the window index
                    __windowIndex = (__windowIndex + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
                    __windowArray[@ __windowIndex  ] = _revealPos;
                    __windowArray[@ __windowIndex+1] = _revealPos - __typistSmoothness;
                }
                else
                {
                    _canMove = false;
                }
            }
            else if (__syncStarted)
            {
                if (audio_is_paused(__syncInstance))
                {
                    _canMove = false;
                }
                else if (__syncPaused)
                {
                    if (audio_sound_get_track_position(__syncInstance) > __syncPauseEnd)
                    {
                        //If enough of the source audio has been played, start showing more text
                        __syncPaused = false;
                        
                        //Increment the window index
                        __windowIndex = (__windowIndex + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
                        __windowArray[@ __windowIndex  ] = _revealPos;
                        __windowArray[@ __windowIndex+1] = _revealPos - __typistSmoothness;
                    }
                    else
                    {
                        _canMove = false;
                    }
                }
            }
            
            ///////
            // Pop the event stack
            ///////
            
            if (_canMove && (array_length(__eventStack) > 0))
            {
                if (not __ProcessEventStack(_pageRevealCount, _functionScope))
                {
                    _canMove = false;
                }
            }
            
            ///////
            // Move the head and collect events / sounds
            ///////
            
            if (_canMove)
            {
                var _useCharacterDelay = (_glyphDataGetter && _perCharacter);
                
                var _remaining = min(_pageRevealCount - _revealPos, _delta);
                while(_remaining > 0)
                {
                    //Scan for events one character at a time
                    _revealPos += min(1, _remaining);
                    _remaining -= 1;
                    
                    //Only scan for new events if we've moved onto a new reveal
                    if (_revealPos >= __prevRevealIndex)
                    {
                        //Get an array of events for this reveal index
                        var _foundEventsArray = get_events(__prevRevealIndex, undefined);
                        var _foundEventsCount = array_length(_foundEventsArray);
                        
                        //Only add a per-character delay if we have glyph data to work with
                        if (_useCharacterDelay)
                        {
                            if ((not __ignoreDelay) && __characterDelay
                            &&  (__prevRevealIndex >= 1)) //Don't check character delay until we're on the first visible character (index=1)
                            {
                                //Always delay the last character if we find events to execute at the end of the page
                                if ((_foundEventsCount > 0)
                                ||  (__prevRevealIndex < (SCRIBBLE_DELAY_LAST_CHARACTER? _pageRevealCount : (_pageRevealCount-1))))
                                {
                                    var _glyph_ord = _page_data.__glyph_grid[# __prevRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                    var _delay = __characterDelayDict[$ _glyph_ord] ?? 0;
                                    
                                    if (__prevRevealIndex > 1)
                                    {
                                        _glyph_ord = (_glyph_ord << 32) | _page_data.__glyph_grid[# __prevRevealIndex-2, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                        var _double_char_delay = __characterDelayDict[$ _glyph_ord];
                                        _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                        
                                        _delay = max(_delay, _double_char_delay);
                                    }
                                    
                                    if (_delay > 0)
                                    {
                                        array_push(__eventStack, new __scribble_class_event("delay", [_delay]));
                                    }
                                }
                            }
                        }
                        
                        //Move to the next reveal
                        __prevRevealIndex++;
                        _moved = true;
                        
                        if (__prevRevealIndex > 1)
                        {
                            __ExecuteFunctionPerReveal();
                        }
                        
                        if (_foundEventsCount > 0)
                        {
                            //Copy our found array of events onto our stack
                            var _oldStackSize = array_length(__eventStack);
                            array_resize(__eventStack, _oldStackSize + _foundEventsCount);
                            array_copy(__eventStack, _oldStackSize, _foundEventsArray, 0, _foundEventsCount);
                        }
                        
                        //Process the stack
                        //If we hit a [pause] or [delay] tag then the function returns `false` and we break out of the loop
                        if (not __ProcessEventStack(_pageRevealCount, _functionScope))
                        {
                            _revealPos = __prevRevealIndex-1; //Lock our head position so we don't overstep
                            break;
                        }
                    }
                }
                
                if (_moved)
                {
                    if (__prevRevealIndex <= _pageRevealCount)
                    {
                        //Only play sound once per frame if we're going reaaaally fast
                        __PlaySound(_revealPos, _glyphDataGetter? (_page_data.__glyph_grid[# _revealPos-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE]) : 0);
                    }
                    else
                    {
                        //Execute our on-complete callback when we finish
                        __ExecuteFunctionOnComplete(_functionScope);
                    }
                }
                
                //Move the typewriter head
                __windowArray[@ __windowIndex] = _revealPos;
            }
        }
        
        ///////
        // Move the typewriter tail
        ///////
        
        if (__typistSkip)
        {
            var _i = 0;
            repeat(__SCRIBBLE_WINDOW_COUNT)
            {
                __windowArray[@ _i+1] = __windowArray[_i];
                _i += 2;
            }
        }
        else
        {
            var _i = 0;
            repeat(__SCRIBBLE_WINDOW_COUNT)
            {
                __windowArray[@ _i+1] = min(__windowArray[_i+1] + _rawDelta, __windowArray[_i]);
                _i += 2;
            }
        }
    }
    
    static __SetTypistShaderUniforms = function()
    {
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
            shader_set_uniform_i(_u_iTypewriterMethod, SCRIBBLE_EASE_NONE);
            return undefined;
        }
        
        var _method = __easeMethod;
        if (not __typistIn) _method += __SCRIBBLE_EASE_COUNT;
        
        var _reveal_max = 0;
        if (__typistBackwards)
        {
            var _model = __get_model(true);
            if (!is_struct(_model)) return undefined;
            
            var _pages_array = _model.__get_page_array();
            if (array_length(_pages_array) > __page)
            {
                var _page_data = _pages_array[__page];
                _reveal_max = _page_data.__reveal_count;
            }
            else
            {
                __scribble_trace("Warning! Typist page ", __page, " exceeds text element page count (", array_length(_pages_array), ")");
            }
        }
        
        shader_set_uniform_i(_u_iTypewriterMethod,            _method);
        shader_set_uniform_i(_u_iTypewriterCharMax,           _reveal_max);
        shader_set_uniform_f(_u_fTypewriterSmoothness,        __typistSmoothness);
        shader_set_uniform_f(_u_vTypewriterStartPos,          __easeDX, __easeDY);
        shader_set_uniform_f(_u_vTypewriterStartScale,        __easeXScale, __easeYScale);
        shader_set_uniform_f(_u_fTypewriterStartRotation,     __easeRotation);
        shader_set_uniform_f(_u_fTypewriterAlphaDuration,     __easeAlphaDuration);
        shader_set_uniform_f_array(_u_fTypewriterWindowArray, __windowArray);
    }
    
    #endregion
}