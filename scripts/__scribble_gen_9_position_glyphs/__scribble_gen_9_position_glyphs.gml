function __scribble_gen_9_position_glyphs()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _stretch_grid = global.__scribble_stretch_grid;
    var _line_grid    = global.__scribble_line_grid;
    var _temp_grid    = global.__scribble_temp_grid;
    
    with(global.__scribble_generator_state)
    {
        var _line_count      = line_count;
        var _overall_bidi    = overall_bidi;
        var _model_max_width = model_max_width;
        var _glyph_count     = glyph_count;
    }
    
    // If we were given no maximum alignment width, align to the actual width of the model
    var _alignment_width = (_model_max_width == infinity)? width : _model_max_width;
    
    var _model_min_x       =  infinity;
    var _model_max_x       = -infinity;
    var _model_glyph_count = 0;
    
    var _i = 0;
    repeat(_line_count)
    {
        var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
        var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
        
        if (_line_word_end < _line_word_start)
        {
            ++_i;
            continue;
        }
        
        var _line_y      = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.Y     ];
        var _line_width  = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH ];
        var _line_height = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HEIGHT];
        var _line_halign = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HALIGN];
        
        
        // Centre all glyphs vertically on the line
        var _line_glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_PARSER_WORD.GLYPH_START];
        var _line_glyph_end   = _word_grid[# _line_word_end,   __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
        var _line_glyph_count = 1 + _line_glyph_end - _line_glyph_start;
        
        // _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y] = _line_y + (_line_height - _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.HEIGHT]) div 2;
        ds_grid_set_grid_region(_temp_grid, _glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT, 0, 0);
        ds_grid_multiply_region(_temp_grid, 0, 0, _line_glyph_count-1, 0, -0.5);
        ds_grid_add_region(_temp_grid, 0, 0, _line_glyph_count-1, 0, 0.5*_line_height + _line_y);
        ds_grid_add_grid_region(_glyph_grid, _temp_grid, 0, 0, _line_glyph_count-1, 0, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y);
        
        
        
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
        if ((_line_halign == __SCRIBBLE_JUSTIFY) && (_i >= _line_count - 1)) _line_halign = __SCRIBBLE_PIN_LEFT;
        
        // FIXME - This doesn't match the typewriter or the events system!
        var _glyph_index = 0;
        
        switch(_line_halign)
        {
            case fa_left:
                if (_overall_bidi != __SCRIBBLE_BIDI.R2L)
                {
                    var _glyph_x = 0;
                }
                else
                {
                    var _glyph_x = width - _line_width;
                }
            break;
            
            case __SCRIBBLE_PIN_LEFT:
                if (_overall_bidi != __SCRIBBLE_BIDI.R2L)
                {
                    var _glyph_x = 0; // FIXME - This should align to the minimum left-hand edge
                }
                else
                {
                    var _glyph_x = _alignment_width - _line_width;
                }
            break;
            
            case fa_center:             var _glyph_x = -(_line_width div 2);                   break;
            case fa_right:              var _glyph_x = -_line_width;                           break;
            case __SCRIBBLE_PIN_CENTRE: var _glyph_x = (_alignment_width - _line_width) div 2; break;
            case __SCRIBBLE_PIN_RIGHT:  var _glyph_x = _alignment_width - _line_width;         break;
            case __SCRIBBLE_JUSTIFY:    var _glyph_x = 0;                                      break;
        }
        
        var _justification_extra_spacing = 0;
        
        if (_line_halign == __SCRIBBLE_JUSTIFY)
        {
            // TODO - Apply justification spacing to glyphs
            
            var _line_word_count = 1 + _line_word_end - _line_word_start;
            if (_line_word_count > 1) //Prevent div-by-zero
            {
                //Distribute spacing over the line, on which there are n-1 spaces
                var _justification_extra_spacing = (_alignment_width - _line_width) / (_line_word_count - 1);
            }
        }
        
        var _model_min_x = min(_model_min_x, _glyph_x);
        var _model_max_x = max(_model_max_x, _glyph_x + _line_width);
        
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
            var _stretch_bidi       = _stretch_grid[# _j, __SCRIBBLE_PARSER_STRETCH.BIDI      ];
            
            if (_stretch_bidi != __SCRIBBLE_BIDI.R2L)
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
                
                ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _glyph_x);
                _glyph_x += _word_grid[# _k, __SCRIBBLE_PARSER_WORD.WIDTH];
                
                _k += _word_incr;
            }
            
            _j += _stretch_incr;
        }
        
        _model_glyph_count += _glyph_index;
        
        ++_i;
    }
    
    if (_model_min_x ==  infinity) _model_min_x = 0;
    
    characters = _model_glyph_count;
    
    //TODO - Set this per page too
    min_x = _model_min_x;
    max_x = max(_model_min_x, _model_max_x);
    width = 1 + max_x - min_x;
    var _vbuff_pos_grid = global.__scribble_vbuff_pos_grid;
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_PARSER_GLYPH.X, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.Y, 0, __SCRIBBLE_VBUFF_POS.QUAD_L);
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_PARSER_GLYPH.X, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.Y, 0, __SCRIBBLE_VBUFF_POS.QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_PARSER_GLYPH.WIDTH,   _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.WIDTH,   0, __SCRIBBLE_VBUFF_POS.QUAD_R);
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_PARSER_GLYPH.HEIGHT,  _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.HEIGHT,  0, __SCRIBBLE_VBUFF_POS.QUAD_B);
    
    //Transform the animation index into a proper packed index
    ds_grid_multiply_region(_glyph_grid, 0, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, __SCRIBBLE_MAX_LINES);
    ds_grid_add_region(_glyph_grid, 0, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, 1); //TODO - Put line indexes into the packed index
}