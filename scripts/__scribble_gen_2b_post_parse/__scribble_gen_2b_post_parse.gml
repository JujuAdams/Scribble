// Feather disable all

function __scribble_gen_2b_post_parse()
{
    static _generator_state       = __scribble_system().__generator_state;
    static _global_glyph_bidi_map = __scribble_system().__glyph_data.__bidi_map;
    
    with(_generator_state)
    {
        ///////
        // Determine the overall bidi direction
        ///////
        
        var _overall_bidi = _generator_state.__overall_bidi;
        if ((_overall_bidi != __SCRIBBLE_BIDI_L2R) && (_overall_bidi != __SCRIBBLE_BIDI_R2L))
        {
            //Searching until we find a glyph with a well-defined direction
            var _i = 0;
            repeat(__glyph_count)
            {
                var _glyph_ord = __glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH_UNICODE];
                if (_glyph_ord > 0)
                {
                    var _bidi = _global_glyph_bidi_map[? _glyph_ord] ?? __SCRIBBLE_BIDI_L2R;
                    if (_bidi == __SCRIBBLE_BIDI_L2R)
                    {
                        _overall_bidi = __SCRIBBLE_BIDI_L2R;
                        break;
                    }
                    
                    //Group R2L and R2L_ARABIC under the same overall bidi direction
                    if (_bidi >= __SCRIBBLE_BIDI_R2L)
                    {
                        _overall_bidi = __SCRIBBLE_BIDI_R2L;
                        break;
                    }
                }
                
                ++_i;
            }
            
            // We didn't find a glyph with a direction, default to L2R
            if ((_overall_bidi != __SCRIBBLE_BIDI_L2R) && (_overall_bidi != __SCRIBBLE_BIDI_R2L))
            {
                _overall_bidi = __SCRIBBLE_BIDI_L2R;
            }
            
            _generator_state.__overall_bidi = _overall_bidi;
            
            //Make sure the null terminator uses the overall bidi for the algorithm to function properly
            __glyph_grid[# __glyph_count, __SCRIBBLE_GEN_GLYPH_BIDI] = _overall_bidi;
        }
        
        
        
        ///////
        // Determine line height
        ///////
        
        //If the line height has not been manually set using `.line_height()` then we need to deduce it
        if (__line_height < 0)
        {
            //Find the first text character and use its font height
            var _line_height = undefined;
            var _i = 0;
            repeat(__glyph_count)
            {
                if (__glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH_UNICODE] > 0)
                {
                    _line_height = __glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT];
                    break;
                }
                
                ++_i;
            }
            
            //If we can't find a text character, use the first glyph
            if ((_line_height == undefined) && (__glyph_count > 0))
            {
                _line_height = __glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT];
            }
            
            //Always fall back on something valid
            __line_height = _line_height ?? 1;
        }
    }
}