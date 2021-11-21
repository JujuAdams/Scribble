function __scribble_gen_4_determine_overall_bidi()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _glyph_count  = global.__scribble_generator_state.glyph_count;
    var _overall_bidi = global.__scribble_generator_state.overall_bidi;
    
    if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L))
    {
        // Presume that the first glyph in the string implies the overall text direction
        var _overall_bidi = _glyph_grid[# 0, __SCRIBBLE_PARSER_GLYPH.BIDI];
        if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L))
        {
            // If the first glyph has a neutral direction then keep searching until we find a
            // glyph with a well-defined direction
            var _i = 0;
            repeat(_glyph_count)
            {
                var _bidi = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.BIDI];
                if ((_bidi != __SCRIBBLE_BIDI.SYMBOL) && (_bidi != __SCRIBBLE_BIDI.WHITESPACE))
                {
                    _overall_bidi = _bidi;
                    break;
                }
                
                ++_i;
            }
            
            // We didn't find a glyph with a direction, default to L2R
            if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L))
            {
                _overall_bidi = __SCRIBBLE_BIDI.L2R;
            }
        }
    }
    
    global.__scribble_generator_state.overall_bidi = _overall_bidi;
}