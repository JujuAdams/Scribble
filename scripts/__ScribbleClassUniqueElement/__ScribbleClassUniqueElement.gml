// Feather disable all

/// @param string

function __ScribbleClassUniqueElement(_string) : __ScribbleClassElementParent(_string) constructor
{
    __weakRef = weak_ref_create(self);
    with(__weakRef)
    {
        __flushed = false;
        __model   = undefined;
        
        
        
        __Flush = function()
        {
            if (__flushed) return;
            
            if (__SCRIBBLE_DEBUG) __ScribbleTrace("Flushing element \"" + string(__cacheName) + "\"");
            
            //Get rid of our model
            if (is_struct(__model))
            {
                __model.__Flush();
                __model = undefined;
            }
            
            //Set as flushed
            __flushed = true;
            
            time_source_stop(__gcTimeSource);
            time_source_destroy(__gcTimeSource);
        }
        
        __Refresh = function()
        {
            if (__flushed) return undefined;
            
            //Get rid of the existing model
            if (is_struct(__model))
            {
                __model.__Flush();
            }
            
            __model = new __ScribbleClassModel(ref);
            return __model;
        }
        
        
        
        array_push(__ScribbleSystem().__elementWeakArray, self);
        
        __gcTimeSource = time_source_create(time_source_global, __ScribbleRandomRange(__SCRIBBLE_ELEMENT_SELFCHECK_MIN, __SCRIBBLE_ELEMENT_SELFCHECK_MAX), time_source_units_seconds,
                                            function()
                                            {
                                                if (not weak_ref_alive(self))
                                                {
                                                    __Flush();
                                                }
                                            }, [], -1);
        time_source_start(__gcTimeSource);
    }
    
    
    
    /// @param x
    /// @param y
    static draw = function(_x, _y)
    {
        if (SCRIBBLE_FLOOR_DRAW_COORDINATES)
        {
            _x = floor(_x);
            _y = floor(_y);
        }
        
        //Get our model, and create one if needed
        var _model = __EnsureModel();
        if (not is_struct(_model)) return undefined;
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (__lastDrawn < _system.__frames)
        {
            __animationTime += __animationSpeed*_system.__tickSize;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animationTime = __animationTime mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __lastDrawn = _system.__frames;
        
        __AutoScroll();
        
        shader_set(__shdScribble);
        __SetStandardUniforms();
        
        __TypistUpdateFromDraw(other);
        __SetTypistShaderUniforms();
        
        //...aaaand set the matrix
        var _oldMatrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__UpdateMatrix(_model, _x, _y), _oldMatrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__Draw(__page, __scrollX, __scrollY, __serial, __serialY, __clip, (__sdfOutlineThickness > 0) || (__sdfShadowAlpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _oldMatrix);
        shader_reset();
        
        if (SCRIBBLE_SHOW_WRAP_BOUNDARY) debug_draw_bbox(_x, _y);
    }
    
    flush = __weakRef.__Flush;
    
    /// @param string
    static overwrite = function(_text)
    {
        if (__text != _text)
        {
            __text = _text;
            __modelDirty = true;
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
        
        //FIXME - Set typist head here
        
        return __SetPage(_page);
    }
    
    static reveal_type = function(_state)
    {
        if (__revealType != _state)
        {
            __revealType = _state;
            __modelDirty = true;
        }
        
        return self;
    }
    
    
    
    __typistAnim       = SCRIBBLE_TYPIST_ANIM_NONE;
    __typistSpeed      = 1;
    __typistSmoothness = 0;
    __typistBackwards  = false;
    
    __typistSkip               = false;
    __typistSkipPaused         = false;
    __typistDrawnSinceSkip     = false;
    __typistDynamicPositioning = false;
    __typistDynamicPositioningSmooth = false;
    
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
    /// @param [smoothness=0]
    static in = function(_speed, _smoothness = 0)
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
    /// @param [smoothness=0]
    /// @param [backwards=false]
    static out = function(_speed, _smoothness = 0, _backwards = false)
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
        _value = max(0, _value);
        
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
            __typistHeadArray[@ 0] = _value;
            __typistHeadArray[@ 1] = _value + __typistSmoothness;
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
        if (not is_array(_soundArray)) _soundArray = [_soundArray];
        
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
        if (not is_array(_soundArray)) _soundArray = [_soundArray];
        
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
    static ease = function(_ease_method, _dx, _dy, _xScale, _yScale, _rotation, _alpha_duration)
    {
        __easeMethod         = _ease_method;
        __easeDX             = _dx;
        __easeDY             = _dy;
        __easeXScale         = _xScale;
        __easeYScale         = _yScale;
        __easeRotation       = _rotation;
        __easeAlphaDuration = _alpha_duration;
        
        return self;
    }
    
    static character_delay_add = function(_character, _delay)
    {
        if (not __allowGlyphDataGetter)
        {
            __ScribbleTrace("Warning! `.character_delay_add()` automatically calling `.allow_glyph_data_getter()`");
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
    
    static newline_delay = function(_delay)
    {
        __newlineDelay = max(0, _delay);
        return self;
    }
    
    static dynamic_positioning = function(_smooth = undefined)
    {
        __typistDynamicPositioning       = true;
        __typistDynamicPositioningSmooth = _smooth;
        
        allow_glyph_data_getter();
        
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
    
    static get_reveal_count = function()
    {
        var _model = __EnsureModel();
        if (not is_struct(_model)) return 0;
        
        var _pages_array = _model.__pagesArray;
        if (array_length(_pages_array) <= __page) return 0;
        var _pageData = _pages_array[__page];
        
        return _pageData.__revealCount;
    }
    
    static get_state = function()
    {
        var _max = get_reveal_count();
        if (_max <= 0) return 2; //If we get an invalid
        
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
        return __typistHeadArray[0];
    }
    
    static get_execution_scope = function()
    {
        return __functionScope;
    }
    
    static get_newline_delay = function()
    {
        return __newlineDelay;
    }
    
    #endregion
    
    
    
    #region Sync
    
    static sync_to_sound = function(_instance)
    {
        if (_instance < 400000)
        {
            __ScribbleError("Cannot synchronise to a sound asset. Please provide a sound instance (as returned by audio_play_sound())");
        }
        
        if (not audio_is_playing(_instance))
        {
            __ScribbleError("Sound instance ", _instance, " is not playing\nCannot sync to a stopped sound instance");
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
        static _tagDict = __ScribbleSystem().__tagDict;
        
        //This method processes events on the stack (which is filled by copying data from the target element in .__tick())
        //We return <true> if there have been no pausing behaviours called i.e. [pause] and [delay]
        //We return <false> immediately if we do run into pausing behaviours
        
        repeat(array_length(__eventStack))
        {
            //Pop the first event from the stack
            var _eventStruct = array_shift(__eventStack);
            var _eventPosition = _eventStruct.revealIndex;
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
                            __ScribbleTrace("Warning! Ignoring [pause] command before the end of a page");
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
                        __ScribblePlaySound(_eventData[0], __soundTagGain, 1);
                    }
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    sound(__ScribbleParseSoundArrayString(_eventData[1]), real(_eventData[2]), real(_eventData[3]), real(_eventData[4]));
                break;
                
                case __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG: //TODO - Add warning when adding a conflicting custom event
                    switch(array_length(_eventData))
                    {
                        case 4: sound_per_char(__ScribbleParseSoundArrayString(_eventData[1]), real(_eventData[2]), real(_eventData[3])); break;
                        case 5: sound_per_char(__ScribbleParseSoundArrayString(_eventData[1]), real(_eventData[2]), real(_eventData[3]), _eventData[4]); break;
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
                            __ScribbleTrace("Warning! Event [", _eventName, "] does not have a callable function attached");
                        }
                    }
                    else
                    {
                        __ScribbleTrace("Warning! Event [", _eventName, "] not recognised");
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
                
                __soundVoice = __ScribblePlaySound(_soundArray[floor(__ScribbleRandom()*array_length(_soundArray))], __soundGain, lerp(__soundPitchMin, __soundPitchMax, __ScribbleRandom()));
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
        if (_system.__frames <= __prevTickFrame) return undefined;
        __prevTickFrame = _system.__frames;
        
        return __TypistMove(_inFunctionScope, __typistSpeed*__typistInlineSpeed*_system.__tickSize);
    }
    
    static __TypistMove = function(_inFunctionScope, _delta)
    {
        //If __typistAnim hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_NONE) return;
        
        //Find the model from the last element
        var _model = __EnsureModel();
        if (not is_struct(_model)) return;
        
        //Get page data
        var _pages_array = _model.__pagesArray;
        if (array_length(_pages_array) == 0) return;
        var _pageData = _pages_array[__page];
        var _pageRevealCount = _pageData.__revealCount;
        
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
        
        var _glyphDataGetter = _model.__allowGlyphDataGetter;
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
                                        var _glyphOrd = _pageData.__glyphGrid[# __typistEventRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                        var _delay = __characterDelayDict[$ _glyphOrd] ?? 0;
                                        
                                        if (__typistEventRevealIndex >= 2)
                                        {
                                            _glyphOrd = (_glyphOrd << 32) | _pageData.__glyphGrid[# __typistEventRevealIndex-2, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                            var _double_char_delay = __characterDelayDict[$ _glyphOrd];
                                            _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                            
                                            _delay = max(_delay, _double_char_delay);
                                        }
                                        
                                        if (_delay > 0)
                                        {
                                            array_push(__eventStack, new __ScribbleClassEvent(__SCRIBBLE_DELAY_COMMAND_TAG, [_delay]));
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
                        
                        if (__revealType == SCRIBBLE_REVEAL_PER_CHAR)
                        {
                            scroll_to_glyph_y(_eventRevealIndex);
                        }
                        else if (__revealType == SCRIBBLE_REVEAL_PER_LINE)
                        {
                            scroll_to_line(_eventRevealIndex);
                        }
                        
                        if (__typistEventRevealIndex <= _pageRevealCount)
                        {
                            if (not __typistSkip)
                            {
                                //Only play sound once per frame if we're going reaaaally fast
                                __PlaySound(_eventRevealIndex, _useGlyphData? (_pageData.__glyphGrid[# _eventRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE]) : 0);
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
        static _u_iTypewriterMethod         = shader_get_uniform(__shdScribble, "u_iTypewriterMethod"        );
        static _u_fTypewriterHeadArray      = shader_get_uniform(__shdScribble, "u_fTypewriterHeadArray"     );
        static _u_fTypewriterHeadLimitArray = shader_get_uniform(__shdScribble, "u_fTypewriterHeadLimitArray");
        static _u_fTypewriterSmoothness     = shader_get_uniform(__shdScribble, "u_fTypewriterSmoothness"    );
        static _u_vTypewriterStartPos       = shader_get_uniform(__shdScribble, "u_vTypewriterStartPos"      );
        static _u_vTypewriterStartScale     = shader_get_uniform(__shdScribble, "u_vTypewriterStartScale"    );
        static _u_fTypewriterStartRotation  = shader_get_uniform(__shdScribble, "u_fTypewriterStartRotation" );
        static _u_fTypewriterAlphaDuration  = shader_get_uniform(__shdScribble, "u_fTypewriterAlphaDuration" );
        static _u_vTypewriterOffsetRange    = shader_get_uniform(__shdScribble, "u_vTypewriterOffsetRange"   );
        
        //If __typistAnim hasn't been set yet (.in() / .out() haven't been set) then just nope out
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_NONE)
        {
            __SetRevealUniforms((__typistHeadArray[0] < __SCRIBBLE_VERY_BIG)? __typistHeadArray[0] : undefined);
            return;
        }
        
        var _method = __easeMethod;
        if (__typistAnim == SCRIBBLE_TYPIST_ANIM_DISAPPEAR) _method += __SCRIBBLE_EASE_COUNT;
        
        if (__typistBackwards)
        {
            //FIXME - Reimplement
        }
        
        shader_set_uniform_i(_u_iTypewriterMethod,               _method);
        shader_set_uniform_f(_u_fTypewriterSmoothness,           __typistSmoothness);
        shader_set_uniform_f(_u_vTypewriterStartPos,             __easeDX, __easeDY);
        shader_set_uniform_f(_u_vTypewriterStartScale,           __easeXScale, __easeYScale);
        shader_set_uniform_f(_u_fTypewriterStartRotation,        __easeRotation);
        shader_set_uniform_f(_u_fTypewriterAlphaDuration,        __easeAlphaDuration);
        shader_set_uniform_f_array(_u_fTypewriterHeadArray,      __typistHeadArray);
        shader_set_uniform_f_array(_u_fTypewriterHeadLimitArray, __typistHeadLimitArray);
        
        if (__typistDynamicPositioning)
        {
            var _model = __EnsureModel();
            if (not is_struct(_model)) return;
            
            var _pages_array = _model.__pagesArray;
            if (__page >= array_length(_pages_array))
            {
                shader_set_uniform_f(_u_vTypewriterOffsetRange, 0, 0, 0);
            }
            else
            {
                var _pageData = _pages_array[__page];
                
                var _headPos      = __typistHeadArray[0];
                var _headPosFloor = floor(_headPos);
                
                if (not (__typistDynamicPositioningSmooth ?? (__typistSmoothness > 0)))
                {
                    _headPos = _headPosFloor;
                }
                
                if ((_headPosFloor <= 0) || (_headPosFloor >= _pageData.__revealCount))
                {
                    shader_set_uniform_f(_u_vTypewriterOffsetRange, 0, 0, 0);
                }
                else
                {
                    if (__revealType != SCRIBBLE_REVEAL_PER_CHAR)
                    {
                        __ScribbleError("Must use `SCRIBBLE_REVEAL_PER_CHAR` with dynamic positioning");
                    }
                    
                    var _lineDataArray = _pageData.__lineDataArray;
                    var _i = 0;
                    repeat(array_length(_lineDataArray))
                    {
                        var _lineData = _lineDataArray[_i];
                        if (_lineData.glyphEnd >= _headPosFloor)
                        {
                            break;
                        }
                        
                        ++_i;
                    }
                    
                    var _hAlign = _lineData.hAlign;
                    
                    if ((_hAlign == fa_left) || (_hAlign == __SCRIBBLE_FA_JUSTIFY) || (_hAlign == __SCRIBBLE_PIN_LEFT))
                    {
                        shader_set_uniform_f(_u_vTypewriterOffsetRange, 0, 0, 0);
                    }
                    else
                    {
                        if ((_hAlign == fa_center) || (_hAlign == __SCRIBBLE_PIN_CENTRE))
                        {
                            var _glyphDataStart = get_glyph_data(_lineData.glyphStart);
                            var _glyphDataA     = get_glyph_data(_headPosFloor-1);
                            var _glyphDataB     = get_glyph_data(min(_lineData.glyph_end, _headPosFloor+1)-1);
                            var _offsetA = -0.5*(_glyphDataStart.left + _glyphDataA.right);
                            var _offsetB = -0.5*(_glyphDataStart.left + _glyphDataB.right);
                            var _offset = lerp(_offsetA, _offsetB, frac(_headPos));
                            
                            if (_hAlign == __SCRIBBLE_PIN_CENTRE)
                            {
                                _offset += 0.5*get_width();
                            }
                        }
                        else if ((_hAlign == fa_right) || (_hAlign == __SCRIBBLE_PIN_RIGHT))
                        {
                            var _glyphDataA = get_glyph_data(_headPosFloor-1);
                            var _glyphDataB = get_glyph_data(min(_lineData.glyph_end, _headPosFloor+1)-1);
                            var _offset = -lerp(_glyphDataA.right, _glyphDataB.right, frac(_headPos));
                            
                            if (_hAlign == __SCRIBBLE_PIN_RIGHT)
                            {
                                _offset += get_width();
                            }
                        }
                        else
                        {
                            var _offset = 0;
                        }
                        
                        shader_set_uniform_f(_u_vTypewriterOffsetRange, _offset, _lineData.glyphStart, _headPosFloor);
                    }
                }
            }
        }
        else
        {
            shader_set_uniform_f(_u_vTypewriterOffsetRange, 0, 0, 0);
        }
    }
    
    #endregion
}