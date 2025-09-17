// Feather disable all

function __ScribbleClassGeneratorState() constructor
{
    __glyphGrid     = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH_SIZE);
    __controlArray   = [];
    __word_grid      = ds_grid_create(1000, __SCRIBBLE_GEN_WORD_SIZE);
    __line_array     = [];
    __temp_grid      = ds_grid_create(1000, __SCRIBBLE_GEN_WORD_SIZE); //For some reason, changing the width of this grid causes GM to crash
    __temp2_grid     = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH_SIZE);
    __vbuff_pos_grid = ds_grid_create(1000, __SCRIBBLE_GEN_VBUFF_POS_SIZE);
    
    __Reset();
    
    static __Reset = function()
    {
        array_resize(__line_array, 0);
        array_resize(__controlArray, 0);
        
        //Model class
        __glyphCount    = 0;
        __sectionCount   = 0; // [/section] tags. Optional feature
        __word_count     = 0;
        __lineCount     = 0;
        __modelMaxWidth  = 0;
        __modelMaxHeight = 0;
        __overallBidi   = undefined;
        
        __uses_halign_left   = false;
        __uses_halign_center = false;
        __uses_halign_right  = false;
        
        __bezier_lengths_array = undefined;
        
        __modelMaxWidth  = 0;
        __modelMaxHeight = 0;
    }
}
