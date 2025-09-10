// Feather disable all

/// @param string

function __scribble_class_unique_element(_string) : __scribble_class_element_parent(_string) constructor
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
            __animation_time += __animation_speed*_system.__tickSize;
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
    
    
    
    __typistAnim       = SCRIBBLE_TYPIST_ANIM_NONE;
    __typistSpeed      = 1;
    __typistSmoothness = 0;
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
    __soundPerReveal              = false;
    __soundPerRevealException     = false;
    __soundPerRevealExceptionDict = undefined;
    __soundPerRevealInterrupt     = false;
    
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
        __typistEventRevealIndex = -1;
        __prevAudioReveal = 0;
        
        __prevTickFrame = -infinity;
        
        __typistHeadArray      = array_create(__SCRIBBLE_HEAD_COUNT, 0);
        __typistHeadLimitArray = [__SCRIBBLE_VERY_BIG, 0, 0]; //Must match `__SCRIBBLE_HEAD_COUNT`
        
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
        var _oldAnim = __typistAnim;
        
        __typistAnim       = SCRIBBLE_TYPIST_ANIM_APPEAR;
        __typistBackwards  = false;
        __typistSpeed      = _speed;
        __typistSmoothness = _smoothness;
        __typistSkip       = false;
        
        if (_oldAnim != SCRIBBLE_TYPIST_ANIM_APPEAR)
        {
            reset();
        }
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards=false]
    static out = function(_speed, _smoothness, _backwards = false)
    {
        var _oldAnim = __typistAnim;
        
        __typistAnim       = SCRIBBLE_TYPIST_ANIM_DISAPPEAR;
        __typistBackwards  = _backwards;
        __typistSpeed      = _speed;
        __typistSmoothness = _smoothness;
        __typistSkip       = false;
        
        if (_oldAnim != SCRIBBLE_TYPIST_ANIM_DISAPPEAR)
        {
            reset();
        }
        
        return self;
    }
    
    static stop = function()
    {
        __typistAnim = SCRIBBLE_TYPIST_ANIM_NONE;
        
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
        if (_value >= __typistHeadLimitArray[0])
        {
            //Must match `__SCRIBBLE_HEAD_COUNT`
            __typistHeadArray[@ 0] = _value + __typistSmoothness;
            __typistHeadArray[@ 1] = 0;
            __typistHeadArray[@ 2] = 0;
            
            __typistHeadLimitArray[@ 1] = 0;
            __typistHeadLimitArray[@ 2] = 0;
        }
        else
        {
            //Must match `__SCRIBBLE_HEAD_COUNT`
            __typistHeadArray[@ 0] = _value - __typistSmoothness;
            __typistHeadArray[@ 1] = _value;
            __typistHeadArray[@ 2] = 0;
            
            __typistHeadLimitArray[@ 1] = _value;
            __typistHeadLimitArray[@ 2] = 0;
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
        __soundPitchMin  = _pitch_min;
        __soundPitchMax  = _pitch_max;
        __soundGain      = _gain;
        __soundPerReveal = false;
        
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
        __soundPerReveal          = true;
        __soundPerRevealInterrupt = _interrupt;
        
        if (is_string(_exception_string))
        {
            __soundPerRevealException = true;
            __soundPerRevealExceptionDict = {};
            
            var _i = 1;
            repeat(string_length(_exception_string))
            {
                __soundPerRevealExceptionDict[$ ord(string_char_at(_exception_string, _i))] = true;
                ++_i;
            }
        }
        else
        {
            __soundPerRevealException = false;
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
        if (not __typistManualPause)
        {
            __typistManualPause = true;
            __StartNewHead(__typistEventRevealIndex);
        }
        
        return self;
    }
    
    static unpause = function()
    {
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
        if (__typistEventRevealIndex == undefined) return 0.0;
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_NONE) return 1.0;
        
        var _model = __get_model(true);
        if (not is_struct(_model)) return 2.0; //If there's no model then report that the element is totally faded out
        
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) <= __page) return 1.0;
        var _pageData = _pages_array[__page];
        
        var _max = _pageData.__reveal_count;
        if (_max <= 0) return 1.0;
        
        var _t = clamp(__typistHeadArray[0] / (_max + __typistSmoothness), 0, 1);
        
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_APPEAR)
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
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_NONE) return 0;
        return __typistHeadArray[0];
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
    
    static __StartNewHead = function(_pos)
    {
        //Bump the middle head down
        __typistHeadArray[@      2] = __typistHeadArray[@      1];
        __typistHeadLimitArray[@ 2] = __typistHeadLimitArray[@ 1];
        
        //Copy the current position for the typist into the middle head
        __typistHeadArray[@      1] = _pos;
        __typistHeadLimitArray[@ 1] = ceil(_pos);
    }
    
    static __ProcessEventStack = function(_functionScope)
    {
        static _tagDict = __scribble_system().__tagDict;
        
        //This method processes events on the stack (which is filled by copying data from the target element in .__tick())
        //We return <true> if there have been no pausing behaviours called i.e. [pause] and [delay]
        //We return <false> immediately if we do run into pausing behaviours
        
        repeat(array_length(__eventStack))
        {
            //Pop the first event from the stack
            var _eventStruct = array_shift(__eventStack);
            var _eventPosition = _eventStruct.reveal_index;
            var _eventName     = _eventStruct.name;
            var _eventData     = _eventStruct.data;
            
            switch(_eventName)
            {
                //Simple pause
                case __SCRIBBLE_PAUSE_COMMAND_TAG:
                    if (((not __typistSkip) && (not __syncStarted)) || (not __typistSkipPaused))
                    {
                        if (SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK && (__typistEventRevealIndex >= __typistHeadLimitArray[0]) && (array_length(__eventStack) <= 0))
                        {
                            __scribble_trace("Warning! Ignoring [pause] command before the end of a page");
                        }
                        else
                        {
                            pause();
                            return false;
                        }
                    }
                break;
                
                //Time-related delay
                case __SCRIBBLE_DELAY_COMMAND_TAG:
                    if ((not __typistSkip) && (not __ignoreDelay) && (not __syncStarted))
                    {
                        if (not __typistDelayPause)
                        {
                            __StartNewHead(__typistEventRevealIndex);
                        }
                        
                        var _duration = (array_length(_eventData) >= 1)? real(_eventData[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __typistDelayPause = true;
                        __typistDelayEnd   = current_time + _duration;
                        
                        return false;
                    }
                break;
                
                //Audio playback synchronisation
                case __SCRIBBLE_SYNC_COMMAND_TAG:
                    if ((not __typistSkip) && __syncStarted)
                    {
                        if (not __typistDelayPause)
                        {
                            __StartNewHead(__typistEventRevealIndex);
                        }
                        
                        __syncPaused   = true;
                        __syncPauseEnd = real(_eventData[0]);
                        return false;
                    }
                break;
                
                //In-line speed setting
                case __SCRIBBLE_SPEED_COMMAND_TAG:
                    if (array_length(_eventData) >= 1)
                    {
                        __typistInlineSpeed = real(_eventData[0]);
                    }
                break;
                
                case __SCRIBBLE_UNSPEED_COMMAND_TAG:
                    __typistInlineSpeed = 1;
                break;
                
                //Native audio playback feature
                case __SCRIBBLE_AUDIO_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    if ((not __typistSkip) && (array_length(_eventData) >= 1))
                    {
                        __scribble_play_sound(_eventData[0], __soundTagGain, 1);
                    }
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    sound(__scribble_parse_sound_array_string(_eventData[1]), real(_eventData[2]), real(_eventData[3]), real(_eventData[4]));
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    switch(array_length(_eventData))
                    {
                        case 4: sound_per_char(__scribble_parse_sound_array_string(_eventData[1]), real(_eventData[2]), real(_eventData[3])); break;
                        case 5: sound_per_char(__scribble_parse_sound_array_string(_eventData[1]), real(_eventData[2]), real(_eventData[3]), _eventData[4]); break;
                    }
                break;
                
                //Probably a current event
                default:
                    //FIXME - We should not be passing the reveal index to external functions (should be the character index)
                    
                    //Otherwise try to find a custom event
                    var _tagStruct = _tagDict[$ _eventName];
                    if (is_struct(_tagStruct) && (_tagStruct.__type == __SCRIBBLE_TAG_EVENT))
                    {
                        var _function = _tagStruct.__data.__function;
                        if (is_callable(_function))
                        {
                            with(_functionScope) _function(self, _eventData, _eventPosition);
                        }
                        else
                        {
                            __scribble_trace("Warning! Event [", _eventName, "] does not have a callable function attached");
                        }
                    }
                    else
                    {
                        __scribble_trace("Warning! Event [", _eventName, "] not recognised");
                    }

                    if (__typistManualPause)
                    {
                        return false;
                    }
                break;
            }
        }
        
        return true;
    }
    
    static __PlaySound = function(_headPos, _character)
    {
        var _soundArray = __soundArray;
        if (is_array(_soundArray) && (array_length(_soundArray) > 0))
        {
            var _playSound = false;
            if (__soundPerReveal)
            {
                //Only play audio if a new character has been revealled
                if (floor(_headPos + 0.0001) > floor(__prevAudioReveal))
                {
                    if (not __soundPerRevealException)
                    {
                        _playSound = true;
                    }
                    else if (not variable_struct_exists(__soundPerRevealExceptionDict, _character))
                    {
                        _playSound = true;
                    }
                    
                    if (_playSound && __soundPerRevealInterrupt)
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
                __prevAudioReveal = _headPos;
                
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
            __functionPerReveal(_functionScope, __typistEventRevealIndex - 1, self);
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
        
        return __TypistMove(_inFunctionScope, __typistSpeed*__typistInlineSpeed*_system.__tickSize);
    }
    
    static __TypistMove = function(_inFunctionScope, _delta)
    {
        //If __typistAnim hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_NONE) return;
        
        //Find the model from the last element
        var _model = __get_model(true);
        if (not is_struct(_model)) return;
        
        //Get page data
        var _pages_array = _model.__get_page_array();
        if (array_length(_pages_array) == 0) return;
        var _pageData = _pages_array[__page];
        var _pageRevealCount = _pageData.__reveal_count;
        
        var _functionScope = __functionScope ?? _inFunctionScope;
        
        if (__typistSkip)
        {
            _delta = (_delta < 0)? (-__SCRIBBLE_VERY_BIG) : __SCRIBBLE_VERY_BIG; //Do not use `infinity` here
        }
        
        //Ensure we unhook synchronisation if the audio instance stops playing
        if (__syncStarted)
        {
            if ((__syncInstance == undefined) || not audio_is_playing(__syncInstance))
            {
                __SyncReset();
            }
        }
        
        var _glyphDataGetter = _model.__allow_glyph_data_getter;
        var _perCharacter = (__revealType == SCRIBBLE_REVEAL_PER_CHAR);
        
        __typistHeadLimitArray[@ 0] = _pageRevealCount; //TODO - Can we move this elsewhere?
        
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_DISAPPEAR)
        {
            ///////
            // Type out
            ///////
            
            if (__typistSkip)
            {
                __typistHeadArray[@ 0] = _pageRevealCount + __typistSmoothness;
            }
            else
            {
                __typistHeadArray[@ 0] += _delta;
            }
        }
        else
        {
            if (_delta < 0)
            {
                ///////
                // Type in, but backwards
                ///////
                
                if (__typistSkip)
                {
                    // N.B. Must match `__SCRIBBLE_HEAD_COUNT`
                    __typistHeadArray[@ 0] = 0;
                    __typistHeadArray[@ 1] = 0;
                    __typistHeadArray[@ 2] = 0;
                }
                else
                {
                    // N.B. Must match `__SCRIBBLE_HEAD_COUNT`
                    __typistHeadArray[@ 0] += _delta;
                    __typistHeadArray[@ 1] += _delta;
                    __typistHeadArray[@ 2] += _delta;
                }
            }
            else
            {
                var _canMove = true;
                var _moved = false;
                
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
                    if (not __ProcessEventStack(_functionScope))
                    {
                        _canMove = false;
                    }
                }
            
                ///////
                // Move the head and collect events / sounds
                ///////
            
                if (_canMove && (_delta > 0))
                {
                    var _useGlyphData = _glyphDataGetter && _perCharacter;
                    
                    var _eventRevealIndex = __typistHeadArray[0];
                    var _remaining = min(_pageRevealCount - _eventRevealIndex, _delta);
                    
                    if (_remaining > 0)
                    {
                        repeat(ceil(_remaining))
                        {
                            //Scan for events one character at a time
                            _eventRevealIndex += min(1, _remaining);
                            _remaining -= 1;
                            
                            // CatDog
                            // Reveal index is 0-indexed. If C is partially visible, the reveal index is greater than 0
                            // 
                            // Cat[event]Dog
                            // Index 3. We expect [event] to execute immediately before D is animated
                            // 
                            // CatDog[event]
                            // Index 6. We expect [event] to execute immediately before an imaginery null character, placed after g, is animated
                            // 
                            // [event]Cat
                            // Stored at index 0. We expected [event] to execute immediately upon drawing the text
                            //
                            // Cat. Dog
                            // We expect the delay to be applied before the space at reveal index 4
                            // 
                            // Cat Dog.
                            // We do not expect a delay because the . is the last character
                            // 
                            // Cat.[/page]
                            // We do not expect a delay because the . is the last character
                            // 
                            // Cat Dog.[event]
                            // We expect the delay to be applied before the space at reveal index 8 because there is a subsequent event
                            // 
                            // Cat.[event]Dog.
                            // We expect the event to execute after the character delay and before D appears
                            // 
                            // Cat.[pause][/page]
                            // FIXME - figure out what's meant to happen here
                            
                            if (floor(_eventRevealIndex) > __typistEventRevealIndex)
                            {
                                ++__typistEventRevealIndex;
                                _moved = true;
                                
                                __ExecuteFunctionPerReveal();
                                
                                //Get an array of events for this reveal index
                                var _foundEventsArray = get_events(__typistEventRevealIndex, undefined);
                                var _foundEventsCount = array_length(_foundEventsArray);
                                
                                //FIXME - Abstract out to a method
                                //Only add a per-character delay if we have glyph data to work with
                                if (_useGlyphData && (not __ignoreDelay) && __characterDelay) //Don't check character delay until we're on the first visible character (index=1)
                                {
                                    //Always delay the last character if we find events to execute at the end of the page
                                    if ((__typistEventRevealIndex < _pageRevealCount-1) || (_foundEventsCount > 0))
                                    {
                                        var _glyph_ord = _pageData.__glyph_grid[# __typistEventRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                        var _delay = __characterDelayDict[$ _glyph_ord] ?? 0;
                                        
                                        if (__typistEventRevealIndex >= 2)
                                        {
                                            _glyph_ord = (_glyph_ord << 32) | _pageData.__glyph_grid[# __typistEventRevealIndex-2, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                            var _double_char_delay = __characterDelayDict[$ _glyph_ord];
                                            _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                            
                                            _delay = max(_delay, _double_char_delay);
                                        }
                                        
                                        if (_delay > 0)
                                        {
                                            array_push(__eventStack, new __scribble_class_event(__SCRIBBLE_DELAY_COMMAND_TAG, [_delay]));
                                        }
                                    }
                                }
                                
                                if (_foundEventsCount > 0)
                                {
                                    //Copy our found array of events onto our stack
                                    array_copy(__eventStack, array_length(__eventStack), _foundEventsArray, 0, _foundEventsCount);
                                }
                                
                                //Process the stack
                                //If we hit a [pause] or [delay] tag then the function returns `false` and we break out of the loop
                                if (not __ProcessEventStack(_functionScope))
                                {
                                    _eventRevealIndex = __typistEventRevealIndex; //Lock our head position so we don't overstep
                                    break;
                                }
                            }
                        }
                        
                        if (__typistSkip)
                        {
                            _eventRevealIndex += __typistSmoothness;
                        }
                    }
                    
                    if (not _moved)
                    {
                        __typistHeadArray[@ 0] += _delta;
                    }
                    else
                    {
                        __typistHeadArray[@ 0] = _eventRevealIndex;
                    
                        if (__typistEventRevealIndex <= _pageRevealCount)
                        {
                            if (not __typistSkip)
                            {
                                //Only play sound once per frame if we're going reaaaally fast
                                __PlaySound(_eventRevealIndex, _useGlyphData? (_pageData.__glyph_grid[# _eventRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE]) : 0);
                            }
                        }
                        else
                        {
                            //Execute our on-complete callback when we finish
                            __ExecuteFunctionOnComplete(_functionScope);
                        }
                    }
                }
            }
            
            ///////
            // Move the typewriter heads
            ///////
            
            // N.B. Must match `__SCRIBBLE_HEAD_COUNT`
            __typistHeadArray[@ 1] += _delta;
            __typistHeadArray[@ 2] += _delta;
        }
        
        __typistSkip = false;
    }
    
    static __SetTypistShaderUniforms = function()
    {
        static _u_iTypewriterMethod         = shader_get_uniform(__shd_scribble, "u_iTypewriterMethod"        );
        static _u_fTypewriterHeadArray      = shader_get_uniform(__shd_scribble, "u_fTypewriterHeadArray"     );
        static _u_fTypewriterHeadLimitArray = shader_get_uniform(__shd_scribble, "u_fTypewriterHeadLimitArray");
        static _u_fTypewriterSmoothness     = shader_get_uniform(__shd_scribble, "u_fTypewriterSmoothness"    );
        static _u_vTypewriterStartPos       = shader_get_uniform(__shd_scribble, "u_vTypewriterStartPos"      );
        static _u_vTypewriterStartScale     = shader_get_uniform(__shd_scribble, "u_vTypewriterStartScale"    );
        static _u_fTypewriterStartRotation  = shader_get_uniform(__shd_scribble, "u_fTypewriterStartRotation" );
        static _u_fTypewriterAlphaDuration  = shader_get_uniform(__shd_scribble, "u_fTypewriterAlphaDuration" );
        
        //If __typistAnim hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_NONE)
        {
            shader_set_uniform_i(_u_iTypewriterMethod, SCRIBBLE_EASE_NONE);
            return;
        }
        
        var _method = __easeMethod;
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_DISAPPEAR) _method += __SCRIBBLE_EASE_COUNT;
        
        var _reveal_max = 0;
        if (__typistBackwards)
        {
            var _model = __get_model(true);
            if (not is_struct(_model)) return;
            
            var _pages_array = _model.__get_page_array();
            if (array_length(_pages_array) > __page)
            {
                var _pageData = _pages_array[__page];
                _reveal_max = _pageData.__reveal_count;
            }
            else
            {
                __scribble_trace("Warning! Typist page ", __page, " exceeds text element page count (", array_length(_pages_array), ")");
            }
        }
        
        shader_set_uniform_i(_u_iTypewriterMethod,               _method);
        shader_set_uniform_f(_u_fTypewriterSmoothness,           __typistSmoothness);
        shader_set_uniform_f(_u_vTypewriterStartPos,             __easeDX, __easeDY);
        shader_set_uniform_f(_u_vTypewriterStartScale,           __easeXScale, __easeYScale);
        shader_set_uniform_f(_u_fTypewriterStartRotation,        __easeRotation);
        shader_set_uniform_f(_u_fTypewriterAlphaDuration,        __easeAlphaDuration);
        shader_set_uniform_f_array(_u_fTypewriterHeadArray,      __typistHeadArray);
        shader_set_uniform_f_array(_u_fTypewriterHeadLimitArray, __typistHeadLimitArray);
    }
    
    #endregion
}