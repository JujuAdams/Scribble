// Feather disable all

function __scribble_gen_9_build_vbuff_grids()
{
    static _generator_state = __scribble_system().__generator_state;
    
    with(_generator_state)
    {
        var _glyph_grid     = __glyph_grid;
        var _vbuff_pos_grid = __vbuff_pos_grid;
        var _glyph_count    = __glyph_count;
        var _element        = __element;
    }
    
    
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_WIDTH,   _glyph_count-1, __SCRIBBLE_GEN_GLYPH_WIDTH,   0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_HEIGHT,  _glyph_count-1, __SCRIBBLE_GEN_GLYPH_HEIGHT,  0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
    
    
    
    if (_element.__visual_bboxes)
    {
        var _model_min_x =  infinity;
        var _model_min_y =  infinity;
        var _model_max_x = -infinity;
        var _model_max_y = -infinity;
    
        var _p = 0;
        repeat(__pages)
        {
            var _page_data = __pages_array[_p];
            with(_page_data)
            {
                var _page_glyph_start = __glyph_start;
                var _page_glyph_end   = __glyph_count-1 + _page_glyph_start;
                
                __min_x = ds_grid_get_min(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
                __min_y = ds_grid_get_min(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T);
                __max_x = ds_grid_get_max(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
                __max_y = ds_grid_get_max(_vbuff_pos_grid, _page_glyph_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B, _page_glyph_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
                
                var _model_min_x = min(_model_min_x, __min_x);
                var _model_min_y = min(_model_min_y, __min_y);
                var _model_max_x = max(_model_max_x, __max_x);
                var _model_max_y = max(_model_max_y, __max_y);
            }
            
            ++_p;
        }
        
        __min_x = is_infinity(_model_min_x)? 0 : _model_min_x;
        __min_y = is_infinity(_model_min_y)? 0 : _model_min_y;
        __max_x = is_infinity(_model_max_x)? 0 : _model_max_x;
        __max_y = is_infinity(_model_max_y)? 0 : _model_max_y;
        
        __width  = 1 + __max_x - __min_x;
        __height = 1 + __max_y - __min_y;
    }
}
