// Feather disable all
function __scribble_get_generator_state()
{
    static _struct = new __scribble_class_generator_state();
    return _struct;
}

function __scribble_class_generator_state() constructor
{
    __glyph_grid     = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH.__SIZE);
    __control_grid   = ds_grid_create(1000, __SCRIBBLE_GEN_CONTROL.__SIZE); //This grid is cleared at the bottom of __scribble_generate_model()
    __word_grid      = ds_grid_create(1000, __SCRIBBLE_GEN_WORD.__SIZE);
    __line_grid      = ds_grid_create(__SCRIBBLE_MAX_LINES, __SCRIBBLE_GEN_LINE.__SIZE);
    __stretch_grid   = ds_grid_create(1000, __SCRIBBLE_GEN_STRETCH.__SIZE);
    __temp_grid      = ds_grid_create(1000, __SCRIBBLE_GEN_WORD.__SIZE); //For some reason, changing the width of this grid causes GM to crash
    __temp2_grid     = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH.__SIZE);
    __vbuff_pos_grid = ds_grid_create(1000, __SCRIBBLE_GEN_VBUFF_POS.__SIZE);
    
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
