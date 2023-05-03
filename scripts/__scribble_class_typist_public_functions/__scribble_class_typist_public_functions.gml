/// @param perLine

function __scribble_class_typist_public_functions() constructor
{
    #region Setters
    
    static reset = function()
    {
        __last_page            = 0;
        __last_character       = 0;
        __last_audio_character = 0;
        
        __last_tick_frame = -infinity;
        
        __window_index       = 0;
        __window_head_array  = array_create(__SCRIBBLE_WINDOW_COUNT, 0);
        __window_max_array   = array_create(__SCRIBBLE_WINDOW_COUNT, 0);
        __paused             = false;
        __delay_paused       = false;
        __delay_end          = -1;
        __inline_speed       = 1;
        __event_stack        = [];
        __skip               = false;
        __drawn_since_skip   = false;
        
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
        __skip             = _state;
        __skip_paused      = true;
        __drawn_since_skip = false;
        
        return self;
    }
    
    static skip_to_pause = function(_state = true)
    {
        __skip             = _state;
        __skip_paused      = false;
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
    /// @param [gain=1]
    static sound = function(_in_sound_array, _overlap, _pitch_min, _pitch_max, _gain = 1)
    {
        var _sound_array = _in_sound_array;
        if (!is_array(_sound_array)) _sound_array = [_sound_array];
        
        __sound_array     = _sound_array;
        __sound_overlap   = _overlap;
        __sound_pitch_min = _pitch_min;
        __sound_pitch_max = _pitch_max;
        __sound_gain      = _gain;
        __sound_per_char  = false;
        
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
        
        __sound_array     = _sound_array;
        __sound_pitch_min = _pitch_min;
        __sound_pitch_max = _pitch_max;
        __sound_gain      = _gain;
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
        __function_per_char = _function;
        
        return self;
    }
    
    static function_on_complete = function(_function)
    {
        __function_on_complete = _function;
        
        return self;
    }
    
    static execution_scope = function(_scope)
    {
        __function_scope = _scope;
        
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
            var _head_pos = __window_max_array[__window_index];
            
            //Increment the window index
            __window_index = (__window_index + 1) mod __SCRIBBLE_WINDOW_COUNT;
            __window_head_array[@ __window_index] = _head_pos;
        }
        
        __skip   = false;
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
        
        var _max = __per_line? _page_data.__line_count : _page_data.__character_count;
        if (_max <= 0) return 1.0;
        
        var _t = clamp((__window_head_array[__window_index] + max(0, __window_max_array[__window_index] + __smoothness - _max)) / (_max + __smoothness), 0, 1);
        
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
        return __window_head_array[__window_index];
    }
    
    static get_text_element = function()
    {
        return weak_ref_alive(__last_element)? __last_element.ref : undefined;
    }
    
    static get_execution_scope = function()
    {
        return __function_scope;
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
        __sync_started  = true;
        __sync_instance = _instance;
        
        return self;
    }
    
    static __sync_reset = function()
    {
        __sync_started   = false;
        __sync_instance  = undefined;
        __sync_paused    = false;
        __sync_pause_end = infinity;
    }
    
    #endregion
}