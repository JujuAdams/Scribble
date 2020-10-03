/// @param string
/// @param [uniqueID]

function scribble()
{
    var _string    = argument[0];
    var _unique_id = (argument_count > 1)? argument[1] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;
    
    return new __scribble_text_element(_string);
}

function __scribble_text_element(_string) constructor
{
    text = _string;
    
    #region Setters
    
    blend = function(_colour, _alpha)
    {
        blend_colour = _colour;
        blend_alpha  = _alpha;
        return self;
    }
    
    transform = function(_xscale, _yscale, _angle)
    {
        xscale = _xscale;
        yscale = _yscale;
        angle  = _angle;
        return self;
    }
    
    origin = function(_x, _y)
    {
        origin_x = _x;
        origin_y = _y;
        return self;
    }
    
    wrap = function(_max_width, _max_height, _character_wrap)
    {
        max_width      = _max_width;
        max_height     = _max_height;
        character_wrap = _character_wrap;
        return self;
    }
    
    line_height = function(_min, _max)
    {
        line_height_min = _min;
        line_height_max = _max;
        return self;
    }
    
    template = function(_template)
    {
        if (is_array(_template))
        {
            var _i = 0;
            repeat(array_length(_template))
            {
                _template[_i]();
                ++_i;
            }
        }
        else
        {
            _template();
        }
        
        return self;
    }
    
    page = function(_page)
    {
        __page = _page;
        return self;
    }
    
    animation = function(_property, _value)
    {
        __scribble_trace("animation() not implemented");
        return self;
    }
    
    #endregion
    
    #region Typewriter Setters
    
    typewriter_in = function(_speed, _smoothness)
    {
        tw_in         = true;
        tw_speed      = _speed;
        tw_smoothness = _smoothness;
        return self;
    }
    
    typewriter_out = function(_speed, _smoothness)
    {
        tw_in         = false;
        tw_speed      = _speed;
        tw_smoothness = _smoothness;
        return self;
    }
    
    typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max)
    {
        tw_sound_array     = _sound_array;
        tw_sound_overlap   = _overlap;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = false;
        return self;
    }
    
    typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max)
    {
        tw_sound_array     = _sound_array;
        tw_sound_pitch_min = _pitch_min;
        tw_sound_pitch_max = _pitch_max;
        tw_sound_per_char  = true;
        return self;
    }
    
    typewriter_function = function(_function)
    {
        tw_function = _function;
        return self;
    }
    
    typewriter_character_delay = function(_character, _delay)
    {
        __scribble_trace("typewriter_character_delay() not implemented");
        return self;
    }
    
    set_typewriter_paused = function(_state)
    {
        tw_paused = _state;
        return self;
    }
    
    #endregion
    
    #region Getters
    
    get_bbox = function()
    {
        __scribble_trace("b() not implemented");
        return undefined;
    }
    
    get_width = function()
    {
        __scribble_trace("get_width() not implemented");
        return undefined;
    }
    
    get_height = function()
    {
        __scribble_trace("get_height() not implemented");
        return undefined;
    }
    
    get_page = function()
    {
        return __page;
    }
    
    get_pages = function()
    {
        __scribble_trace("get_pages() not implemented");
        return undefined;
    }
    
    get_typewriter_state = function()
    {
        __scribble_trace("get_typewriter_state() not implemented");
        return undefined;
    }
    
    get_typewriter_paused = function()
    {
        return tw_paused;
    }
    
    #endregion
    
    draw = function(_x, _y)
    {
        
    }
    
    flush_now = function()
    {
        return undefined;
    }
    
    //Apply the default template
    template(scribble_default_template);
}