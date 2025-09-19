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
            static _system = __ScribbleSystem();
            if (__flushed) return _system.__nullModel;
            
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
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (__lastDrawn < _system.__frames)
        {
            __animationTime += __animationSpeed*_system.__tickSize;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animationTime = __animationTime mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __lastDrawn = _system.__frames;
        
        __AutoPan();
        __AutoScroll();
        
        shader_set(__shdScribble);
        __SetStandardUniforms();
        
        __TypistUpdateFromDraw(other);
        __SetTypistShaderUniforms();
        
        //...aaaand set the matrix
        var _oldMatrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__UpdateMatrix(_x, _y), _oldMatrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        __EnsureModel().__Draw(__page + __pageFraction, __scrollXArray, __scrollYArray, __clip, (__sdfOutlineThickness > 0) || (__sdfShadowAlpha > 0));
        
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
    
    
    
    static typist_start = function()
    {
        __typistRunning = true;
        
        return self;
    }
    
    static typist_start_audio_sync = function(_voice)
    {
        __typistRunning = true;
        //FIXME - Reimplement
        
        if (_voice < 400000)
        {
            __ScribbleError("Cannot synchronise to a sound asset. Please provide a sound instance (as returned by audio_play_sound())");
        }
        
        if (not audio_is_playing(_voice))
        {
            __ScribbleError("Voice ", _voice, " is not playing\nCannot sync to a stopped sound instance");
        }
        
        __TypistSyncReset();
        __typistRunning     = true;
        __typistSyncStarted = true;
        __typistSyncVoice   = _voice;
        
        return self;
    }
    
    static __TypistSyncReset = function()
    {
        __typistSyncStarted  = false;
        __typistSyncVoice    = undefined;
        __typistSyncPaused   = false;
        __typistSyncPauseEnd = infinity;
    }
    
    static typist_stop = function()
    {
        __typistRunning = false;
        
        return self;
    }
    
    static typist_finish = function()
    {
        typist_set_position(get_reveal_count());
        typist_stop();
        
        return self;
    }
    
    static typist_get_state = function()
    {
        return __typistState;
    }
    
    static typist_get_running = function()
    {
        return __typistRunning;
    }
    
    static typist_get_paused = function()
    {
        return __typistPaused;
    }
    
    static typist_get_delayed = function()
    {
        return __typistDelayed;
    }
    
    static typist_get_finished = function()
    {
        return (get_reveal() >= get_reveal_count());
    }
    
    static typist_get_length = function()
    {
        return get_reveal_count(get_page_count()-1);
    }
    
    static typist_advance = function()
    {
        if (typist_get_state() == SCRIBBLE_TYPIST_PAUSED)
        {
            __typistState = SCRIBBLE_TYPIST_RUNNING;
        }
        
        return self;
    }
    
    static typist_suspend = function(_state = true)
    {
        if (_state)
        {
            if (not __typistSuspended)
            {
                __typistSuspended = true;
                __TypistStartNewHead(__typistEventRevealIndex);
            }
        }
        else
        {
            __typistSuspend = false;
        }
        
        return self;
    }
    
    static typist_get_suspended = function()
    {
        return __typistSuspend;
    }
    
    static reveal_mode = function(_state)
    {
        if (__typistRevealMode != _state)
        {
            __typistRevealMode = _state;
            __modelDirty = true;
        }
        
        return self;
    }
    
    static get_reveal_mode = function()
    {
        return __typistRevealMode;
    }
    
    static typist_options_apply = function(_struct)
    {
        static _expectedNamesDict = {
            appear:                   true,
            speed:                    true,
            smoothness:               true,
            lineDelay:                true,
            blockScrollSpeed:         true,
            blockOverlap:             true,
            blockDelay:               true,
            pageScrollSpeed:          true,
            pageDelay:                true,
            sound:                    true,
            soundPitchMin:            true,
            soundPitchMax:            true,
            soundGain:                true,
            soundOverlap:             true,
            soundPerChar:             true,
            soundPerCharInterrupts:   true,
            soundPerCharException:    true,
            functionPerChar:          true,
            functionOnFinish:         true,
            eventScope:               true,
            dynamicPositioning:       true,
            dynamicPositioningSmooth: true,
            
            //TODO - Implement `backwards`
        };
        
        //If we're running from the IDE, scan for unsupported option names and alert the user
        if (SCRIBBLE_RUNNING_FROM_IDE)
        {
            var _namesArray = variable_struct_get_names(_struct);
            var _i = 0;
            repeat(_namesArray)
            {
                if (not variable_struct_exists(_expectedNamesDict, _namesArray[_i]))
                {
                    __ScribbleError($"Option name \"{_namesArray[_i]}\" not supported\nPlease refer to documentation");
                }
                
                ++_i;
            }
        }
        
        with(__typistOptions)
        {
            var _newAppear = _struct[$ "appear"] ?? __appear;
            if (_newAppear != __appear)
            {
                if (typist_get_state() != SCRIBBLE_TYPIST_STOPPED)
                {
                    __ScribbleTrace("Warning! Cannot change `appear` typist option whilst the typist is running");
                }
                else
                {
                    __appear = _newAppear;
                }
            }
            
            //TODO - Implement `backwards`
            
            var _oldSoundPerCharException = __soundPerCharException;
            
            __speed                    = _struct[$ "speed"                   ] ?? __speed;
            __smoothness               = _struct[$ "smoothness"              ] ?? __smoothness;
            __lineDelay                = _struct[$ "lineDelay"               ] ?? __lineDelay;
            __blockScrollSpeed         = _struct[$ "blockScrollSpeed"        ] ?? __blockScrollSpeed;
            __blockOverlap             = _struct[$ "blockOverlap"            ] ?? __blockOverlap;
            __blockDelay               = _struct[$ "blockDelay"              ] ?? __blockDelay;
            __pageScrollSpeed          = _struct[$ "pageScrollSpeed"         ] ?? __pageScrollSpeed;
            __pageDelay                = _struct[$ "pageDelay"               ] ?? __pageDelay;
            __soundArray               = _struct[$ "sound"                   ] ?? __soundArray;
            __soundPitchMin            = _struct[$ "soundPitchMin"           ] ?? __soundPitchMin;
            __soundPitchMax            = _struct[$ "soundPitchMax"           ] ?? __soundPitchMax;
            __soundGain                = _struct[$ "soundGain"               ] ?? __soundGain;
            __soundOverlap             = _struct[$ "soundOverlap"            ] ?? __soundOverlap;
            __soundPerChar             = _struct[$ "soundPerChar"            ] ?? __soundPerChar;
            __soundPerCharInterrupts   = _struct[$ "soundPerCharInterrupts"  ] ?? __soundPerCharInterrupts;
            __soundPerCharException    = _struct[$ "soundPerCharException"   ] ?? __soundPerCharException;
            __functionPerChar          = _struct[$ "functionPerChar"         ] ?? __functionPerChar;
            __functionOnFinish         = _struct[$ "functionOnFinish"        ] ?? __functionOnFinish;
            __eventScope               = _struct[$ "eventScope"              ] ?? __eventScope;
            __dynamicPositioning       = _struct[$ "dynamicPositioning"      ] ?? __dynamicPositioning;
            __dynamicPositioningSmooth = _struct[$ "dynamicPositioningSmooth"] ?? __dynamicPositioningSmooth;
            
            if (_oldSoundPerCharException != __soundPerCharException)
            {
                
            }
        }
        
        if (other.__dynamicPositioning)
        {
            allow_glyph_data_getter();
        }
        
        return self;
    }
    
    static typist_options_reset = function()
    {
        with(__typistOptions)
        {
            __appear                   = true;
            __backwards                = false; //Unused
            __speed                    = 0.4;
            __smoothness               = 0;
            __lineDelay                = 0;
            __blockScrollSpeed         = 4;
            __blockOverlap             = 0;
            __blockDelay               = infinity;
            __pageScrollSpeed          = 4;
            __pageDelay                = infinity;
            __soundArray               = undefined;
            __soundPitchMin            = 1;
            __soundPitchMax            = 1;
            __soundGain                = 1;
            __soundOverlap             = 0;
            __soundPerChar             = false;
            __soundPerCharInterrupts   = false;
            __soundPerCharException    = [];
            __functionPerChar          = undefined;
            __functionOnFinish         = undefined;
            __eventScope               = undefined;
            __typistCharDelay          = [];
            __dynamicPositioning       = false;
            __DynamicPositioningSmooth = false;
        }
        
        return self;
    }
    
    static typist_options_get = function()
    {
        return __typistOptions;
    }

    static typist_skip = function(_level = SCRIBBLE_SKIP_TO_PAUSE)
    {
        if (_level == SCRIBBLE_SKIP_TO_EVENT)
        {
            
        }
        else if (_level == SCRIBBLE_SKIP_TO_DELAY)
        {
            
        }
        else if (_level == SCRIBBLE_SKIP_TO_PAUSE)
        {
            
        }
        else if (_level == SCRIBBLE_SKIP_TO_BLOCK)
        {
            
        }
        else if (_level == SCRIBBLE_SKIP_TO_PAGE)
        {
            
        }
        else if (_level == SCRIBBLE_SKIP_TO_END)
        {
            
        }
        
        return self;
    }
    
    /// @param easeMethod
    /// @param dx
    /// @param dy
    /// @param xscale
    /// @param yscale
    /// @param rotation
    /// @param alphaDuration
    static typist_ease = function(_ease_method, _dx, _dy, _xScale, _yScale, _rotation, _alpha_duration)
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
    
    static typist_audio_gain = function()
    {
        __typistAudioGain = max(0, _value);
        return self;
    }
    
    static typist_audio_get_gain = function()
    {
        return __typistAudioGain;
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
        __typistCharDelay = true;
        __typistCharDelayDict[$ _code] = _delay;
        
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
        variable_struct_remove(__typistCharDelayDict, _code);
        
        return self;
    }
    
    static character_delay_clear = function()
    {
        __typistCharDelay = false;
        __typistCharDelayDict = {};
        
        return self;
    }
    
    static __TypistStartNewHead = function(_pos)
    {
        //Bump the middle head down
        __typistHeadArray[@      2] = __typistHeadArray[@      1];
        __typistHeadLimitArray[@ 2] = __typistHeadLimitArray[@ 1];
        
        //Copy the current position for the typist into the middle head
        __typistHeadArray[@      1] = _pos;
        __typistHeadLimitArray[@ 1] = ceil(_pos);
    }
    
    static __TypistProcessEventStack = function(_functionScope)
    {
        static _tagDict = __ScribbleSystem().__tagDict;
        
        //This method processes events on the stack (which is filled by copying data from the target element in .__tick())
        //We return `true` if there have been no pausing behaviours called i.e. [pause] and [delay]
        //We return `false` immediately if we do run into pausing behaviours
        
        repeat(array_length(__typistEventStack))
        {
            //Pop the first event from the stack
            var _eventStruct = array_shift(__typistEventStack);
            var _eventPosition = _eventStruct.revealIndex;
            var _eventName     = _eventStruct.name;
            var _eventData     = _eventStruct.data;
            
            switch(_eventName)
            {
                //Simple pause
                case __SCRIBBLE_COMMAND_TAG_PAUSE:
                    if (not __typistSyncStarted)
                    {
                        if (SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK && (__typistEventRevealIndex >= __typistHeadLimitArray[0]) && (array_length(__typistEventStack) <= 0))
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
                case __SCRIBBLE_COMMAND_TAG_DELAY:
                    if (not __typistSyncStarted)
                    {
                        if (not __typistDelayed)
                        {
                            __TypistStartNewHead(__typistEventRevealIndex);
                        }
                        
                        var _duration = (array_length(_eventData) >= 1)? real(_eventData[0]) : SCRIBBLE_DEFAULT_DELAY_DURATION;
                        __typistDelayed = true;
                        __typistDelayEnd   = current_time + _duration;
                        
                        return false;
                    }
                break;
                
                //Audio playback synchronisation
                case __SCRIBBLE_COMMAND_TAG_SYNC:
                    if (__typistSyncStarted)
                    {
                        if (not __typistDelayed)
                        {
                            __TypistStartNewHead(__typistEventRevealIndex);
                        }
                        
                        __typistSyncPaused   = true;
                        __typistSyncPauseEnd = real(_eventData[0]);
                        return false;
                    }
                break;
                
                //In-line speed setting
                case __SCRIBBLE_COMMAND_TAG_SPEED:
                    if (array_length(_eventData) >= 1)
                    {
                        __typistInlineSpeed = real(_eventData[0]);
                    }
                break;
                
                case __SCRIBBLE_COMMAND_TAG_UNSPEED:
                    __typistInlineSpeed = 1;
                break;
                
                //Native audio playback feature
                case __SCRIBBLE_COMMAND_TAG_AUDIO: //TODO - Add warning when adding a conflicting custom event
                    if (array_length(_eventData) >= 1)
                    {
                        __ScribblePlaySound(_eventData[0], __typistAudioGain, 1);
                    }
                break;
                
                case __SCRIBBLE_COMMAND_TAG_TYPIST_SOUND: //TODO - Add warning when adding a conflicting custom event
                    sound(__ScribbleParseSoundArrayString(_eventData[1]), real(_eventData[2]), real(_eventData[3]), real(_eventData[4]));
                break;
                
                case __SCRIBBLE_COMMAND_TAG_TYPIST_SOUND_PER_CHAR: //TODO - Add warning when adding a conflicting custom event
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

                    if (__typistSuspended)
                    {
                        return false;
                    }
                break;
            }
        }
        
        return true;
    }
    
    static __TypistPlaySound = function(_headPos, _character)
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
                        audio_stop_sound(__typistSoundVoice);
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
                
                __typistSoundVoice = __ScribblePlaySound(_soundArray[floor(__ScribbleRandom()*array_length(_soundArray))],
                                                         __typistOptions.__soundGain,
                                                         lerp(__typistOptions.__soundPitchMin, __typistOptions.__soundPitchMax, __ScribbleRandom()));
                if (__typistSoundVoice >= 0)
                {
                    __soundFinishTime = current_time + 1000*audio_sound_length(__typistSoundVoice) - __soundOverlap;
                }
            }
        }
    }
    
    static __TypistExecuteFunctionPerReveal = function(_functionScope)
    {
        if (is_callable(__functionPerReveal))
        {
            __functionPerReveal(_functionScope, __typistEventRevealIndex - 1, self);
        }
    }
    
    static __TypistExecuteFunctionOnComplete = function(_functionScope)
    {
        if (is_callable(__functionOnComplete))
        {
            __functionOnComplete(_functionScope, self);
        }
    }
    
    static __TypistUpdateFromDraw = function(_inFunctionScope)
    {
        //Don't move the typist if it's been less than a frame since we were last updated
        if (_system.__frames <= __prevTickFrame) return undefined;
        __prevTickFrame = _system.__frames;
        
        return __TypistMove(_inFunctionScope, __typistOptions.__speed*__typistInlineSpeed*_system.__tickSize);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    static page = function(_page)
    {
        if (__typistRunning)
        {
            __ScribbleTrace("Cannot set page, typist is running");
        }
        else
        {
            __SetPage(_page);
        }
        
        return self;
    }
    
    static reveal_mode = function(_state)
    {
        if (__typistRevealMode != _state)
        {
            __typistRevealMode = _state;
            __modelDirty = true;
        }
        
        return self;
    }
    
    static get_reveal_mode = function()
    {
        return __typistRevealMode;
    }
    
    
    
    __typistScrollTarget = 0;
    __typistSoundVoice   = -1;
    __pageTarget         = 0;
    __pageSpeed          = 1/40;
    
    __typistAudioGain = 1;
    
    __easeMethod        = SCRIBBLE_EASE_LINEAR;
    __easeDX            = 0;
    __easeDY            = 0;
    __easeXScale        = 1;
    __easeYScale        = 1;
    __easeRotation      = 0;
    __easeAlphaDuration = 1.0;
    
    __typistSyncStarted  = false;
    __typistSyncVoice    = undefined;
    __typistSyncPaused   = false;
    __typistSyncPauseEnd = infinity;
    
    __typistCharDelay     = false;
    __typistCharDelayDict = {};
    
    __soundArray                  = undefined;
    __soundOverlap                = 0;
    __soundFinishTime             = current_time;
    __soundPerReveal              = false;
    __soundPerRevealException     = false;
    __soundPerRevealExceptionDict = undefined;
    __soundPerRevealInterrupt     = false;
    
    __functionPerReveal  = undefined;
    __functionOnComplete = undefined;
    
    typist_options_reset();
    reset();
    
    
    
    #region Setters
    
    static reset = function()
    {
        __typistEventRevealIndex = -1;
        __prevAudioReveal = 0;
        
        __prevTickFrame = -infinity;
        
        __typistHeadArray      = array_create(__SCRIBBLE_HEAD_COUNT, 0);
        __typistHeadLimitArray = [__SCRIBBLE_VERY_BIG, 0, 0]; //Must match `__SCRIBBLE_HEAD_COUNT`
        
        __typistSuspended      = false;
        __typistDelayed        = false;
        __typistDelayEnd       = -1;
        __typistInlineSpeed    = 1;
        __typistEventStack     = [];
        
        return self;
    }
    
    static set_position = function(_value)
    {
        _value = max(0, _value);
        
        if (_value >= __typistHeadLimitArray[0])
        {
            //Must match `__SCRIBBLE_HEAD_COUNT`
            __typistHeadArray[@ 0] = _value + __typistOptions.__smoothness;
            __typistHeadArray[@ 1] = 0;
            __typistHeadArray[@ 2] = 0;
            
            __typistHeadLimitArray[@ 1] = 0;
            __typistHeadLimitArray[@ 2] = 0;
        }
        else
        {
            //Must match `__SCRIBBLE_HEAD_COUNT`
            __typistHeadArray[@ 0] = _value;
            __typistHeadArray[@ 1] = _value + __typistOptions.__smoothness;
            __typistHeadArray[@ 2] = 0;
            
            __typistHeadLimitArray[@ 1] = _value;
            __typistHeadLimitArray[@ 2] = 0;
        }
        
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
        
        __soundArray              = _soundArray;
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
    
    static advance = function()
    {
        if (get_paused())
        {
            unpause();
        }
        else if (get_state() == 1)
        {
            if (not on_last_page())
            {
                __pageTarget = get_page()+1;
            }
        }
        else
        {
            skip();
        }
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
    
    static newline_delay = function(_delay)
    {
        __newlineDelay = max(0, _delay);
        return self;
    }
    
    #endregion
    
    
    
    #region Getters
    
    static get_reveal_count = function()
    {
        var _pages_array = __EnsureModel().__pagesArray;
        if (array_length(_pages_array) <= __page) return 0;
        var _pageData = _pages_array[__page];
        
        return _pageData.__revealCount;
    }
    
    static get_state = function()
    {
        var _max = get_reveal_count();
        if (_max <= 0) return 2; //If we get an invalid
        
        var _t = clamp(__typistHeadArray[0] / (_max + __typistOptions.__smoothness), 0, 1);
        
        if (__typistOptions.__appear)
        {
            if (__typistDelayed || (array_length(__typistEventStack) > 0))
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
    
    #endregion
    
    
    
    #region Private Methods
    
    static __TypistMove = function(_inExecutionScope, _delta)
    {
        if (not __typistRunning) return;
        
        //Find the model from the last element
        var _model = __EnsureModel();
        
        //Get page data
        var _pages_array = _model.__pagesArray;
        if (array_length(_pages_array) == 0) return;
        var _pageData = _pages_array[__page];
        var _pageRevealCount = _pageData.__revealCount;
        
        var _functionScope = __typistOptions.__executionScope ?? _inExecutionScope;
        
        //Ensure we unhook synchronisation if the audio instance stops playing
        if (__typistSyncStarted)
        {
            if ((__typistSyncVoice == undefined) || not audio_is_playing(__typistSyncVoice))
            {
                __TypistSyncReset();
            }
        }
        
        var _glyphDataGetter = _model.__allowGlyphDataGetter;
        var _perCharacter = (__typistRevealMode == SCRIBBLE_REVEAL_PER_CHAR);
        
        __typistHeadLimitArray[@ 0] = _pageRevealCount; //TODO - Can we move this elsewhere?
        
        if (not __typistOptions.__appear)
        {
            ///////
            // Type out
            ///////
            
            __typistHeadArray[@ 0] += _delta;
        }
        else
        {
            if (_delta < 0)
            {
                ///////
                // Type in, but backwards
                ///////
                
                // N.B. Must match `__SCRIBBLE_HEAD_COUNT`
                __typistHeadArray[@ 0] += _delta;
                __typistHeadArray[@ 1] += _delta;
                __typistHeadArray[@ 2] += _delta;
            }
            else
            {
                var _canMove = true;
                var _moved = false;
                
                ///////
                // Handle pausing
                ///////
                
                if (__typistSuspended)
                {
                    _canMove = false;
                }
                else if (__typistDelayed)
                {
                    if (current_time > __typistDelayEnd)
                    {
                        //We've waited long enough, start showing more text
                        __typistDelayed = false;
                    }
                    else
                    {
                        _canMove = false;
                    }
                }
                else if (__typistSyncStarted)
                {
                    if (audio_is_paused(__typistSyncVoice))
                    {
                        _canMove = false;
                    }
                    else if (__typistSyncPaused)
                    {
                        if (audio_sound_get_track_position(__typistSyncVoice) > __typistSyncPauseEnd)
                        {
                            //If enough of the source audio has been played, start showing more text
                            __typistSyncPaused = false;
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
            
                if (_canMove && (array_length(__typistEventStack) > 0))
                {
                    if (not __TypistProcessEventStack(_functionScope))
                    {
                        _canMove = false;
                    }
                }
                
                if (_canMove)
                {
                    if (__page != __pageTarget)
                    {
                        _canMove = false;
                        __SetPage(__page + clamp(__pageTarget - __page, -__pageSpeed, __pageSpeed));
                        __typistScrollTarget = 0;
                    }
                }
                
                if (_canMove && (not is_infinity(__typistOptions.__blockScrollSpeed)) && (__scrollYArray[__page] != __typistScrollTarget))
                {
                    _canMove = false;
                    __scrollYArray[@ __page] += clamp(__typistScrollTarget - __scrollYArray[@ __page], -__typistOptions.__blockScrollSpeed, __typistOptions.__blockScrollSpeed);
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
                                
                                __TypistExecuteFunctionPerReveal();
                                
                                //Get an array of events for this reveal index
                                var _foundEventsArray = get_events(__typistEventRevealIndex, undefined);
                                var _foundEventsCount = array_length(_foundEventsArray);
                                
                                //FIXME - Abstract out to a method
                                //Only add a per-character delay if we have glyph data to work with
                                if (_useGlyphData && __typistCharDelay) //Don't check character delay until we're on the first visible character (index=1)
                                {
                                    //Always delay the last character if we find events to execute at the end of the page
                                    if ((__typistEventRevealIndex < _pageRevealCount-1) || (_foundEventsCount > 0))
                                    {
                                        var _glyphOrd = _pageData.__glyphGrid[# __typistEventRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                        var _delay = __typistCharDelayDict[$ _glyphOrd] ?? 0;
                                        
                                        if (__typistEventRevealIndex >= 2)
                                        {
                                            _glyphOrd = (_glyphOrd << 32) | _pageData.__glyphGrid[# __typistEventRevealIndex-2, __SCRIBBLE_GLYPH_LAYOUT_UNICODE];
                                            var _double_char_delay = __typistCharDelayDict[$ _glyphOrd];
                                            _double_char_delay = (_double_char_delay == undefined)? 0 : _double_char_delay;
                                            
                                            _delay = max(_delay, _double_char_delay);
                                        }
                                        
                                        if (_delay > 0)
                                        {
                                            array_push(__typistEventStack, new __ScribbleClassEvent(__SCRIBBLE_COMMAND_TAG_DELAY, [_delay]));
                                        }
                                    }
                                }
                                
                                if (_foundEventsCount > 0)
                                {
                                    //Copy our found array of events onto our stack
                                    array_copy(__typistEventStack, array_length(__typistEventStack), _foundEventsArray, 0, _foundEventsCount);
                                }
                                
                                if (is_infinity(__typistOptions.__blockDelay))
                                {
                                    if (__typistRevealMode == SCRIBBLE_REVEAL_PER_CHAR)
                                    {
                                        if (__GetGlyphBlock(__typistEventRevealIndex) < __GetGlyphBlock(__typistEventRevealIndex+1))
                                        {
                                            array_push(__typistEventStack, new __ScribbleClassEvent(__SCRIBBLE_COMMAND_TAG_PAUSE, undefined));
                                        }
                                    }
                                    else if (__typistRevealMode == SCRIBBLE_REVEAL_PER_LINE)
                                    {
                                        if (__GetLineBlock(__typistEventRevealIndex) < __GetLineBlock(__typistEventRevealIndex+1))
                                        {
                                            array_push(__typistEventStack, new __ScribbleClassEvent(__SCRIBBLE_COMMAND_TAG_PAUSE, undefined));
                                        }
                                    }
                                }
                                
                                //Process the stack
                                //If we hit a [pause] or [delay] tag then the function returns `false` and we break out of the loop
                                if (not __TypistProcessEventStack(_functionScope))
                                {
                                    _eventRevealIndex = __typistEventRevealIndex; //Lock our head position so we don't overstep
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (not _moved)
                    {
                        __typistHeadArray[@ 0] += _delta;
                    }
                    else
                    {
                        __typistHeadArray[@ 0] = _eventRevealIndex;
                        
                        if (__typistRevealMode == SCRIBBLE_REVEAL_PER_CHAR)
                        {
                            if (is_infinity(__typistOptions.__blockScrollSpeed))
                            {
                                scroll_to_glyph(_eventRevealIndex);
                            }
                            else
                            {
                                __typistScrollTarget = __GetBlockY(__GetGlyphBlock(_eventRevealIndex));
                            }
                        }
                        else if (__typistRevealMode == SCRIBBLE_REVEAL_PER_LINE)
                        {
                            if (is_infinity(__typistOptions.__blockScrollSpeed))
                            {
                                scroll_to_line(_eventRevealIndex);
                            }
                            else
                            {
                                __typistScrollTarget = __GetBlockY(__GetLineBlock(_eventRevealIndex));
                            }
                        }
                        
                        if (__typistEventRevealIndex <= _pageRevealCount)
                        {
                            //Only play sound once per frame if we're going reaaaally fast
                            __TypistPlaySound(_eventRevealIndex, _useGlyphData? (_pageData.__glyphGrid[# _eventRevealIndex-1, __SCRIBBLE_GLYPH_LAYOUT_UNICODE]) : 0);
                        }
                        else
                        {
                            //Execute our on-complete callback when we finish
                            __TypistExecuteFunctionOnComplete(_functionScope);
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
        
        if (not __typistRunning)
        {
            __SetRevealUniforms((__typistHeadArray[0] < __SCRIBBLE_VERY_BIG)? __typistHeadArray[0] : undefined);
            return;
        }
        
        var _method = __easeMethod;
        if (not __typistOptions.__appear) _method += __SCRIBBLE_EASE_COUNT;
        
        if (__typistBackwards)
        {
            //FIXME - Reimplement
        }
        
        shader_set_uniform_i(_u_iTypewriterMethod,               _method);
        shader_set_uniform_f(_u_fTypewriterSmoothness,           __typistOptions.__smoothness);
        shader_set_uniform_f(_u_vTypewriterStartPos,             __easeDX, __easeDY);
        shader_set_uniform_f(_u_vTypewriterStartScale,           __easeXScale, __easeYScale);
        shader_set_uniform_f(_u_fTypewriterStartRotation,        __easeRotation);
        shader_set_uniform_f(_u_fTypewriterAlphaDuration,        __easeAlphaDuration);
        shader_set_uniform_f_array(_u_fTypewriterHeadArray,      __typistHeadArray);
        shader_set_uniform_f_array(_u_fTypewriterHeadLimitArray, __typistHeadLimitArray);
        
        if (__typistOptions.__dynamicPositioning)
        {
            var _pages_array = __EnsureModel().__pagesArray;
            if (__page >= array_length(_pages_array))
            {
                shader_set_uniform_f(_u_vTypewriterOffsetRange, 0, 0, 0);
            }
            else
            {
                var _pageData = _pages_array[__page];
                
                var _headPos      = __typistHeadArray[0];
                var _headPosFloor = floor(_headPos);
                
                if (not (__typistOptions.__dynamicPositioningSmooth ?? (__typistOptions.__smoothness > 0)))
                {
                    _headPos = _headPosFloor;
                }
                
                if ((_headPosFloor <= 0) || (_headPosFloor >= _pageData.__revealCount))
                {
                    shader_set_uniform_f(_u_vTypewriterOffsetRange, 0, 0, 0);
                }
                else
                {
                    if (__typistRevealMode != SCRIBBLE_REVEAL_PER_CHAR)
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