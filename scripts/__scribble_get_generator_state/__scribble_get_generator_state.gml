function __scribble_get_generator_state()
{
    static _struct = new __scribble_class_generator_state();
    return _struct;
}

function __scribble_class_generator_state() constructor
{
    __Reset();
    
    static __Reset = function()
    {
        //Model class
        __element          = undefined;
        __glyph_count      = 0;
        __control_count    = 0;
        __word_count       = 0;
        __line_count       = 0;
        __line_height_min  = 0;
        __line_height_max  = 0;
        __model_max_width  = 0;
        __model_max_height = 0;
        __overall_bidi     = undefined;
        
        __uses_halign_left   = false;
        __uses_halign_center = false;
        __uses_halign_right  = false;
        
        __bezier_lengths_array = undefined;
        
        __model_max_width       = 0;
        __model_max_height      = 0;
        __line_height_min       = 0;
        __line_height_max       = 0;
        __line_spacing_add      = 0;
        __line_spacing_multiply = 0;
        
        __overall_bidi  = __SCRIBBLE_BIDI.L2R;
        __glyph_count   = 0;
        __control_count = 0;
    }
}