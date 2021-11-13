function __scribble_generator_position_glyphs()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _stretch_grid = global.__scribble_stretch_grid;
    var _line_grid    = global.__scribble_line_grid;
    
    with(global.__scribble_generator_state)
    {
        var _line_count      = line_count;
        var _overall_bidi    = overall_bidi;
        var _model_max_width = model_max_width;
    }
    
    // If we were given no maximum alignment width, align to the actual width of the model
    var _alignment_width = (_model_max_width == infinity)? width : _model_max_width;
    
    var _i = 0;
    repeat(_line_count)
    {
        var _line_y          = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.Y         ];
        var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
        var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
        var _line_width      = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH     ];
        var _line_height     = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HEIGHT    ];
        var _line_halign     = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HALIGN    ];
        
        // Figure out what order words should come in
        var _line_stretch_count = 0;
        var _stretch_bidi  = undefined;
        
        var _j = _line_word_start;
        repeat(1 + _line_word_end - _line_word_start)
        {
            var _word_bidi = _word_grid[# _j, __SCRIBBLE_PARSER_WORD.BIDI];
            if (_word_bidi != _stretch_bidi)
            {
                if (_line_stretch_count > 0)
                {
                    //_stretch_grid[# _line_stretch_count-1, __SCRIBBLE_PARSER_STRETCH.WORD_START]
                    _stretch_grid[# _line_stretch_count-1, __SCRIBBLE_PARSER_STRETCH.WORD_END  ] = _j - 1;
                    //_stretch_grid[# _line_stretch_count-1, __SCRIBBLE_PARSER_STRETCH.BIDI      ]
                }
                
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_START] = _j;
                //_stretch_grid[# _line_stretch_count, __SCRIBBLE_PARSER_STRETCH.WORD_END  ]
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_PARSER_STRETCH.BIDI      ] = _word_bidi;
                
                _line_stretch_count++;
                _stretch_bidi = _word_bidi;
            }
            
            ++_j;
        }
        
        if (_line_stretch_count > 0)
        {
            //_stretch_grid[# _line_stretch_count-1, __SCRIBBLE_PARSER_STRETCH.WORD_START  ]
            _stretch_grid[# _line_stretch_count-1, __SCRIBBLE_PARSER_STRETCH.WORD_END  ] = _j - 1;
            //_stretch_grid[# _line_stretch_count-1, __SCRIBBLE_PARSER_STRETCH.BIDI        ]
        }
        
        
        
        if (SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) 
        {
            __scribble_error("SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE not implemented yet"); 
        }
        
        // Text on the last line is never justified
        // FIXME - This should work per-page not per-model
        if (_i >= _line_count - 1) _line_halign = fa_left;
        
        if (_overall_bidi == __SCRIBBLE_BIDI.R2L)
        {
            // Automatically pin left-aligned text to the right when rendering R2L text
            if ((_line_halign == fa_left) || (_line_halign == __SCRIBBLE_PIN_LEFT)) _line_halign = __SCRIBBLE_PIN_RIGHT;
        }
        
        switch(_line_halign)
        {
            case fa_left:               var _glyph_x = 0;                                      break;
            case fa_center:             var _glyph_x = -(_line_width div 2);                   break;
            case fa_right:              var _glyph_x = -_line_width;                           break;
            case __SCRIBBLE_PIN_LEFT:   var _glyph_x = 0;                                      break;
            case __SCRIBBLE_PIN_CENTRE: var _glyph_x = (_alignment_width - _line_width) div 2; break;
            case __SCRIBBLE_PIN_RIGHT:  var _glyph_x = _alignment_width - _line_width;         break;
            case __SCRIBBLE_JUSTIFY:
                var _glyph_x = 0;
            break;
        }
        
        var _justification_extra_spacing = 0;
        
        if (_line_halign == __SCRIBBLE_JUSTIFY)
        {
            var _line_word_count = 1 + _line_word_end - _line_word_start;
            if (_line_word_count > 1) //Prevent div-by-zero
            {
                //Distribute spacing over the line, on which there are n-1 spaces
                var _justification_extra_spacing = (_alignment_width - _line_width) / (_line_word_count - 1);
            }
        }
        
        if (_overall_bidi != __SCRIBBLE_BIDI.R2L)
        {
            // "Normal" L2R text, no stretch reordering required
            var _j = 0;
            var _stretch_incr = 1;
        }
        else
        {
            // R2L text, stretches need to be reversed
            var _j = _line_stretch_count-1;
            var _stretch_incr = -1;
        }
        
        repeat(_line_stretch_count)
        {
            var _stretch_word_start = _stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.WORD_START];
            var _stretch_word_end   = _stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.WORD_END  ];
            
            if (_stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.BIDI] != __SCRIBBLE_BIDI.R2L)
            {
                // "Normal" L2R text, no word reordering required
                var _k = _stretch_word_start;
                var _word_incr = 1;
            }
            else
            {
                // R2L text, words need to be reversed
                var _k = _stretch_word_end;
                var _word_incr = -1;
            }
            
            repeat(1 + _stretch_word_end - _stretch_word_start)
            {
                var _word_glyph_start = _word_grid[# _k, __SCRIBBLE_PARSER_WORD.GLYPH_START];
                var _word_glyph_end   = _word_grid[# _k, __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
                
                if (_word_grid[# _k, __SCRIBBLE_PARSER_WORD.BIDI] != __SCRIBBLE_BIDI.R2L)
                {
                    // "Normal" L2R text, no word reordering required
                    var _l = _word_glyph_start;
                    var _glyph_incr = 1;
                }
                else
                {
                    // R2L text, words need to be reversed
                    var _l = _word_glyph_end;
                    var _glyph_incr = -1;
                }
                
                repeat(1 + _word_glyph_end - _word_glyph_start)
                {
                    _glyph_grid[# _l, __SCRIBBLE_PARSER_GLYPH.X] = _glyph_x;
                    _glyph_grid[# _l, __SCRIBBLE_PARSER_GLYPH.Y] = _line_y + (_line_height - _glyph_grid[# _l, __SCRIBBLE_PARSER_GLYPH.HEIGHT]) div 2;
                    _glyph_x += _glyph_grid[# _l, __SCRIBBLE_PARSER_GLYPH.SEPARATION] + _justification_extra_spacing;
                    
                    _l += _glyph_incr;
                }
                
                _k += _word_incr;
            }
            
            _j += _stretch_incr;
        }
        
        ++_i;
    }
}