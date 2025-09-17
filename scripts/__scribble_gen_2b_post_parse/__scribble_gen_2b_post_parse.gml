// Feather disable all

function __scribble_gen_2b_post_parse()
{
    static _generatorState       = __scribble_system().__generatorState;
    static _global_glyph_bidi_map = __scribble_system().__glyph_data.__bidi_map;
    
    with(_generatorState)
    {
        ///////
        // Determine the overall bidi direction
        ///////
        
        var _overall_bidi = _generatorState.__overallBidi;
        if ((_overall_bidi != __SCRIBBLE_BIDI_L2R) && (_overall_bidi != __SCRIBBLE_BIDI_R2L))
        {
            //Searching until we find a glyph with a well-defined direction
            var _i = 0;
            repeat(__glyphCount)
            {
                var _glyph_ord = __glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_UNICODE];
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
            
            _generatorState.__overallBidi = _overall_bidi;
            
            //Make sure the null terminator uses the overall bidi for the algorithm to function properly
            __glyphGrid[# __glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI] = _overall_bidi;
        }
        
        
        
        ///////
        // Determine line height
        ///////
        
        //If the line height has not been manually set using `.line_height()` then we need to deduce it
        if (other.__lineHeight < 0)
        {
            //Find the first text character and use its font height
            var _line_height = undefined;
            var _i = 0;
            repeat(__glyphCount)
            {
                if (__glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_UNICODE] > 0)
                {
                    _line_height = __glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT];
                    break;
                }
                
                ++_i;
            }
            
            //If we can't find a text character, use the first glyph
            if ((_line_height == undefined) && (__glyphCount > 0))
            {
                _line_height = __glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT];
            }
            
            //Always fall back on something valid
            other.__lineHeight = _line_height ?? 1;
        }
    }
}