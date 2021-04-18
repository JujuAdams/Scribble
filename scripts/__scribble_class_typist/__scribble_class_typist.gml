function __scribble_class_typist() constructor
{
    __last_element = undefined;
    
    __window       = 0;
    __window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, 0.0);
    __in           = true;
    __skip         = false;
    __backwards    = false;
    __function     = undefined;
    __paused       = false;
    __delay_paused = false;
    __delay_end    = -1;
    
    __event_previous       = -1;
    __event_char_previous  = -1;
    __event_visited_struct = {};
    
    __sound_array       = undefined;
    __sound_overlap     = 0;
    __sound_pitch_min   = 1;
    __sound_pitch_max   = 1;
    __sound_per_char    = false;
    __sound_finish_time = current_time;
    
    __speed      = 1;
    __smoothness = 0;
    
    __inline_speed        = 1;
    __anim_ease_method    = SCRIBBLE_EASE.LINEAR;
    __anim_dx             = 0;
    __anim_dy             = 0;
    __anim_xscale         = 1;
    __anim_yscale         = 1;
    __anim_rotation       = 0;
    __anim_alpha_duration = 1.0;
    
    
    
    static reset = function()
    {
        __window_array = array_create(2*__SCRIBBLE_WINDOW_COUNT, -__smoothness);
        __window_array[@ 0] = 0;
        
        __skip = false;
        
        if (__in)
        {
            __event_previous       = -1;
            __event_char_previous  = -1;
            __event_visited_struct = {};
        }
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    static in = function(_speed, _smoothness)
    {
        __in         = true;
        __backwards  = false;
        __speed      = _speed;
        __smoothness = _smoothness;
        
        if (!__in) reset();
        
        return self;
    }
    
    /// @param speed
    /// @param smoothness
    /// @param [backwards]
    static out = function()
    {
        var _speed      = argument[0];
        var _smoothness = argument[1];
        var _backwards  = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;
        
        __in         = false;
        __backwards  = _backwards;
        __speed      = _speed;
        __smoothness = _smoothness;
        
        if (__in) reset();
        
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
            var _old_head_pos = __window_array[@ __window];
            
            //Increment the window index
            __window = (__window + 2) mod (2*__SCRIBBLE_WINDOW_COUNT);
            
            __window_array[@ __window  ] = _old_head_pos;
            __window_array[@ __window+1] = _old_head_pos - __smoothness;
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
        __anim_ease_method    = _ease_method;
        __anim_dx             = _dx;
        __anim_dy             = _dy;
        __anim_xscale         = _xscale;
        __anim_yscale         = _yscale;
        __anim_rotation       = _rotation;
        __anim_alpha_duration = _alpha_duration;
        
        return self;
    }
}