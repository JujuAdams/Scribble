// Feather disable all

function __scribble_gen_9_build_vbuff_grids()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    with(_generatorState)
    {
        var _glyphGrid     = __glyphGrid;
        var _vbuff_pos_grid = __vbuff_pos_grid;
        var _glyphCount    = __glyphCount;
    }
    
    
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_WIDTH,   _glyphCount-1, __SCRIBBLE_GEN_GLYPH_WIDTH,   0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_HEIGHT,  _glyphCount-1, __SCRIBBLE_GEN_GLYPH_HEIGHT,  0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
    
    
    
    if (__visualBboxes)
    {
        var _model_min_x =  infinity;
        var _model_min_y =  infinity;
        var _model_max_x = -infinity;
        var _model_max_y = -infinity;
    
        var _p = 0;
        repeat(__pages)
        {
            var _pageData = __pagesArray[_p];
            with(_pageData)
            {
                var _page_glyph_start = __glyphStart;
                var _page_glyph_end   = __glyphCount-1 + _page_glyph_start;
                
                __minX = ds_grid_get_min(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
                __minY = ds_grid_get_min(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T);
                __maxX = ds_grid_get_max(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
                __maxY = ds_grid_get_max(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
                
                var _model_min_x = min(_model_min_x, __minX);
                var _model_min_y = min(_model_min_y, __minY);
                var _model_max_x = max(_model_max_x, __maxX);
                var _model_max_y = max(_model_max_y, __maxY);
            }
            
            ++_p;
        }
        
        __minX = is_infinity(_model_min_x)? 0 : _model_min_x;
        __minY = is_infinity(_model_min_y)? 0 : _model_min_y;
        __maxX = is_infinity(_model_max_x)? 0 : _model_max_x;
        __maxY = is_infinity(_model_max_y)? 0 : _model_max_y;
        
        __width  = 1 + __maxX - __minX;
        __height = 1 + __maxY - __minY;
    }
}
