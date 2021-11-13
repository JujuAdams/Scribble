function __scribble_generator_position_words_in_lines()
{
    var _word_grid    = global.__scribble_word_grid;
    var _stretch_grid = global.__scribble_stretch_grid;
    var _line_grid    = global.__scribble_line_grid;
    
    with(global.__scribble_generator_state)
    {
        var _line_count   = line_count;
        var _overall_bidi = overall_bidi;
    }
    
    var _i = 0;
    repeat(_line_count)
    {
        var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
        var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
        
        var _stretch_count      = 0;
        var _stretch_separation = 0;
        var _stretch_bidi       = undefined;
        
        var _j = _line_word_start;
        repeat(1 + _line_word_end - _line_word_start)
        {
            var _word_bidi = _word_grid[# _j, __SCRIBBLE_PARSER_WORD.BIDI];
            if (_word_bidi != _stretch_bidi)
            {
                if (_stretch_count > 0)
                {
                    //_stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_START]
                    _stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_END  ] = _j - 1;
                    _stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.SEPARATION] = _stretch_separation;
                    //_stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.BIDI      ]
                }
                
                _stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_START] = _j;
                //_stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_END  ]
                //_stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.SEPARATION]
                _stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.BIDI      ] = _word_bidi;
                
                _stretch_count++;
                _stretch_bidi = _word_bidi;
                _stretch_separation = 0;
            }
            
            _stretch_separation += _word_grid[# _j, __SCRIBBLE_PARSER_WORD.SEPARATION];
            
            ++_j;
        }
        
        if (_stretch_count > 0)
        {
            //_stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_START  ]
            _stretch_grid[# _stretch_count-1, __SCRIBBLE_PARSER_STRETCH.WORD_END  ] = _j - 1;
            _stretch_grid[# _stretch_count-1, __SCRIBBLE_PARSER_STRETCH.SEPARATION] = _stretch_separation;
            //_stretch_grid[# _stretch_count, __SCRIBBLE_PARSER_STRETCH.BIDI        ]
        }
        
        var _j = 0;
        repeat(_stretch_count)
        {
            if (_stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.BIDI] == __SCRIBBLE_BIDI.R2L)
            {
                var _stretch_word_start = _stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.WORD_START];
                var _stretch_word_end   = _stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.WORD_END  ];
                var _stretch_x          = _word_grid[# _stretch_word_start, __SCRIBBLE_PARSER_WORD.X];
                
                ds_grid_add_region(_word_grid, _stretch_word_start, __SCRIBBLE_PARSER_WORD.X, _stretch_word_end, __SCRIBBLE_PARSER_WORD.X, -_stretch_x);
                ds_grid_multiply_region(_word_grid, _stretch_word_start, __SCRIBBLE_PARSER_WORD.X, _stretch_word_end, __SCRIBBLE_PARSER_WORD.X, -1);
                ds_grid_add_region(_word_grid, _stretch_word_start, __SCRIBBLE_PARSER_WORD.X, _stretch_word_end, __SCRIBBLE_PARSER_WORD.X, _stretch_x + _stretch_grid[# _i, __SCRIBBLE_PARSER_STRETCH.SEPARATION]);
                
                //FIXME - This is broken in runtime 2.3.6.464 (2021-11-13)
                //ds_grid_set_grid_region(_word_grid, _word_grid, _stretch_word_start, __SCRIBBLE_PARSER_GLYPH.WIDTH, _stretch_word_end, __SCRIBBLE_PARSER_GLYPH.WIDTH, _stretch_word_start, __SCRIBBLE_PARSER_GLYPH.X);
                
                var _k = _stretch_word_start;
                repeat(1 + _stretch_word_end - _stretch_word_start)
                {
                    _word_grid[# _k, __SCRIBBLE_PARSER_WORD.X] -= _word_grid[# _k, __SCRIBBLE_PARSER_WORD.WIDTH];
                    ++_k;
                }
            }
            
            ++_j;
        }
        
        if (_overall_bidi == __SCRIBBLE_BIDI.R2L)
        {
            var _j = 0;
            repeat(_stretch_count)
            {
                
                
                
                
                
                
                
                
                ++_j;
            }
        }
        
        ++_i;
    }
}