// Feather disable all

function __ScribbleClassGeneratorState() constructor
{
    __glyphGrid     = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH_SIZE);
    __controlArray   = [];
    __wordGrid      = ds_grid_create(1000, __SCRIBBLE_GEN_WORD_SIZE);
    __lineArray     = [];
    __tempGrid      = ds_grid_create(1000, __SCRIBBLE_GEN_WORD_SIZE); //For some reason, changing the width of this grid causes GM to crash
    __tempGrid2     = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH_SIZE);
    __vbuffPosGrid = ds_grid_create(1000, __SCRIBBLE_GEN_VBUFF_POS_SIZE);
    
    __Reset();
    
    static __Reset = function()
    {
        array_resize(__lineArray, 0);
        array_resize(__controlArray, 0);
        
        //Model class
        __glyphCount    = 0;
        __sectionCount   = 0; // [/section] tags. Optional feature
        __wordCount     = 0;
        __lineCount     = 0;
        __modelMaxWidth  = 0;
        __modelMaxHeight = 0;
        __overallBidi   = undefined;
        
        __usesHAlignLeft   = false;
        __usesHAlignCenter = false;
        __usesHAlignRight  = false;
        
        __bezierLengthsArray = undefined;
        
        __modelMaxWidth  = 0;
        __modelMaxHeight = 0;
    }
}
