function __scribble_generator_position_glyphs_in_words()
{
    var _glyph_grid = global.__scribble_glyph_grid;
    var _word_grid  = global.__scribble_word_grid;
    
    var _word_count = global.__scribble_generator_state.word_count;
    
    var _i = 0;
    repeat(_word_count)
    {
        var _word_glyph_start = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_START];
        var _word_glyph_end   = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
        
        if (_word_glyph_end - _word_glyph_start >= 0)
        {
            if (_word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI] != __SCRIBBLE_BIDI.R2L)
            {
                // If this word isn't R2L, position glyphs simply
                ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _word_grid[# _i, __SCRIBBLE_PARSER_WORD.X]);
            }
            else
            {
                // R2L words require some special treatment
                
                ds_grid_multiply_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, -1);
                ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _word_grid[# _i, __SCRIBBLE_PARSER_WORD.X] + _word_grid[# _i, __SCRIBBLE_PARSER_WORD.WIDTH]);
                
                //FIXME - This is broken in runtime 2.3.6.464 (2021-11-13)
                //ds_grid_set_grid_region(_glyph_grid, _glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.WIDTH, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X);
                
                var _j = _word_glyph_start;
                repeat(1 + _word_glyph_end - _word_glyph_start)
                {
                    _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.X] -= _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                    ++_j;
                }
            }
            
            // Next we do the y-axis
            // Basically, we want the glyph's top y-coordinate = word.y + (word.height - glyph.height)/2
            // Doing this in bulk using grid functions requires us to do this in four steps:
            //   1) glyph.y  = glyph.height
            //   2) glyph.y -= word.height + 2*word.y
            //   3) glyph.y *= -0.5
            // We have to do some funny stuff with the signs because it's not possible to subtract a region, only to add a region
            // Fortunately we can reverse some signs and get away with it!
            
            //FIXME - This is broken in runtime 23.1.1.385 (2021-09-26)
            //ds_grid_set_grid_region(_glyph_grid, _glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y);
            
            //FIXME - Workaround for the above. This is slower than using the ds_grid functions
            var _j = _word_glyph_start;
            repeat(1 + _word_glyph_end - _word_glyph_start)
            {
                _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.Y] = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.HEIGHT];
                ++_j;
            }
            
            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, -_word_grid[# _i, __SCRIBBLE_PARSER_WORD.HEIGHT] - 2*_word_grid[# _i, __SCRIBBLE_PARSER_WORD.Y]);
            ds_grid_multiply_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, -0.5);
        }
        
        ++_i;
    }
}