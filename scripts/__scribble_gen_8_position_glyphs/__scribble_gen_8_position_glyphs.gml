function __scribble_gen_8_position_glyphs()
{
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        var _glyph_grid      = __glyph_grid;
        var _word_grid       = __word_grid;
        var _stretch_grid    = __stretch_grid;
        var _line_grid       = __line_grid;
        var _temp_grid       = __temp_grid;
        var _line_count      = __line_count;
        var _overall_bidi    = __overall_bidi;
        var _model_max_width = __model_max_width;
        var _glyph_count     = __glyph_count;
    }
    
    ds_grid_clear(_temp_grid, 0); //FIXME - Works around a bug in ds_grid_add_grid_region() (runtime 2.3.7.474  2021-12-03)
    
    //Transform the animation index into a proper packed index
    ds_grid_multiply_region(_glyph_grid, 0, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, __SCRIBBLE_MAX_LINES);
    
    var _model_min_x =  infinity;
    var _model_min_y =  infinity;
    var _model_max_x = -infinity;
    var _model_max_y = -infinity;
    
    //Now handle each page in turn
    var _i = 0;
    repeat(__pages)
    {
        var _page_data = __pages_array[_i];
        
        if (SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE)
        {
            var _alignment_width     = _page_data.__width;
            var _pin_alignment_width = _page_data.__width;
        }
        else
        {
            // If we were given no maximum alignment width, align to the actual width of the model
            var _alignment_width     = (_model_max_width == infinity)? __width : _model_max_width;
            var _pin_alignment_width = (_model_max_width == infinity)? __width : _model_max_width;
        }
            
        _alignment_width     /= __fit_scale;
        _pin_alignment_width /= __fit_scale;
        
        var _page_min_x =  infinity;
        var _page_max_x = -infinity; 
        
        var _page_start_line = _page_data.__line_start;
        var _page_end_line   = _page_data.__line_end;
        
        var _j = _page_start_line;
        repeat(1 + _page_end_line - _page_start_line)
        {
            var _line_x          = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__X         ];
            var _line_y          = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__Y         ];
            var _line_word_start = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__WORD_START];
            var _line_word_end   = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__WORD_END  ];
            var _line_width      = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__WIDTH     ];
            var _line_height     = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__HEIGHT    ];
            var _line_halign     = _line_grid[# _j, __SCRIBBLE_GEN_LINE.__HALIGN    ];
            
            var _line_glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.__GLYPH_START];
            var _line_glyph_end   = _word_grid[# _line_word_end,   __SCRIBBLE_GEN_WORD.__GLYPH_END  ];
            
            
            
            ds_grid_add_region(_glyph_grid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _line_glyph_end, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _j - _page_start_line);
            
            
            
            #region Centre all glyphs vertically on the line
            
            var _line_glyph_count = 1 + _line_glyph_end - _line_glyph_start;
            
            // _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__Y] = _line_y + (_line_height - _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT]) div 2;
            ds_grid_set_grid_region(_temp_grid, _glyph_grid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT, _line_glyph_end, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT, 0, 0);
            ds_grid_multiply_region(_temp_grid, 0, 0, _line_glyph_count-1, 0, -0.5);
            ds_grid_add_region(_temp_grid, 0, 0, _line_glyph_count-1, 0, 0.5*_line_height + _line_y);
            ds_grid_add_grid_region(_glyph_grid, _temp_grid, 0, 0, _line_glyph_count-1, 0, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.__Y);
            
            #endregion
            
            
            
            //Correct for vertical alignment
            if (_page_data.__min_y != 0) ds_grid_add_region(_glyph_grid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.__Y, _line_glyph_end, __SCRIBBLE_GEN_GLYPH.__Y, _page_data.__min_y);
            
            
            
            #region Figure out what order words should come in
            
            // TODO - Do this whilst building lines
            
            var _line_stretch_count = 0;
            var _stretch_bidi       = _word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.__BIDI];
            
            var _stretch_word_start = _line_word_start;
            var _w = _line_word_start;
            repeat(1 + _line_word_end - _line_word_start)
            {
                var _word_bidi = _word_grid[# _w, __SCRIBBLE_GEN_WORD.__BIDI];
                if (_word_bidi != _stretch_bidi)
                {
                    _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.__WORD_START] = _stretch_word_start;
                    _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.__WORD_END  ] = _w - 1;
                    _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.__BIDI      ] = _stretch_bidi;
                    _line_stretch_count++;
                    
                    _stretch_word_start = _w;
                    _stretch_bidi = _word_bidi;
                }
            
                ++_w;
            }
            
            if (_w > 0)
            {
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.__WORD_START] = _stretch_word_start;
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.__WORD_END  ] = _w - 1;
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.__BIDI      ] = _stretch_bidi;
                _line_stretch_count++;
            }
            
            #endregion
            
            
            
            // Text on the last line is never justified
            // FIXME - This should work per-page not per-model
            if ((_line_halign == __SCRIBBLE_FA_JUSTIFY) && (_j >= _line_count - 1)) _line_halign = __SCRIBBLE_PIN_LEFT;
            
            var _justification_extra_spacing = 0;
            
            var _line_adjusted_width = _line_width;
            if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && (_line_halign != fa_left) && (_line_halign != __SCRIBBLE_PIN_LEFT))
            {
                if ((_line_word_end >= 1)
                && (_word_grid[# _line_word_end, __SCRIBBLE_GEN_WORD.__BIDI_RAW] == __SCRIBBLE_BIDI.WHITESPACE)
                && (_word_grid[# _line_word_end-1, __SCRIBBLE_GEN_WORD.__BIDI_RAW] != __SCRIBBLE_BIDI.WHITESPACE))
                {
                    _line_adjusted_width -= _word_grid[# _line_word_end, __SCRIBBLE_GEN_WORD.__WIDTH];
                    
                    _word_grid[# _line_word_end, __SCRIBBLE_GEN_WORD.__WIDTH] = 0;
                    var _word_glyph = _word_grid[# _line_word_end, __SCRIBBLE_GEN_WORD.__GLYPH_START]; //Assume that whitespace words only have one glyph
                    _glyph_grid[# _word_glyph, __SCRIBBLE_GEN_GLYPH.__WIDTH     ] = 0;
                    _glyph_grid[# _word_glyph, __SCRIBBLE_GEN_GLYPH.__SEPARATION] = 0;
                }
            }
            
            var _glyph_x = (_overall_bidi == __SCRIBBLE_BIDI.R2L)? -_line_x : _line_x;
            
            switch(_line_halign)
            {
                case fa_left:               _glyph_x += (_overall_bidi == __SCRIBBLE_BIDI.R2L)? (_alignment_width - _line_adjusted_width) : 0;     break;
                case __SCRIBBLE_PIN_LEFT:   _glyph_x += (_overall_bidi == __SCRIBBLE_BIDI.R2L)? (_pin_alignment_width - _line_adjusted_width) : 0; break;
                case fa_center:             _glyph_x += -(_line_adjusted_width div 2);                                                             break;
                case fa_right:              _glyph_x += -_line_adjusted_width;                                                                     break;
                case __SCRIBBLE_PIN_CENTRE: _glyph_x += (_pin_alignment_width - _line_adjusted_width) div 2;                                       break;
                case __SCRIBBLE_PIN_RIGHT:  _glyph_x += _pin_alignment_width - _line_adjusted_width;                                               break;
                
                case __SCRIBBLE_FA_JUSTIFY:
                    // Don't apply justification on the last line on a page
                    if (_j != _page_end_line)
                    {
                        var _line_word_count = 1 + _line_word_end - _line_word_start;
                        if (_line_word_count > 1) // Prevent div-by-zero
                        {
                            // Distribute spacing over the line, on which there are n-1 spaces
                            var _justification_extra_spacing = (_pin_alignment_width - _line_adjusted_width) / (_line_word_count - 1);
                        }
                    }
                break;
            }
            
            // Figure out the boundaries of the page + model
            var _page_min_x  = min(_page_min_x,  _glyph_x                       );
            var _page_max_x  = max(_page_max_x,  _glyph_x + _line_adjusted_width);
            var _model_min_x = min(_model_min_x, _glyph_x                       );
            var _model_max_x = max(_model_max_x, _glyph_x + _line_adjusted_width);
            
            
            
            if (_overall_bidi < __SCRIBBLE_BIDI.R2L)
            {
                // "Normal" L2R text, no stretch reordering required
                var _k = 0;
                var _stretch_incr = 1;
            }
            else
            {
                // R2L text, stretches need to be reversed
                var _k = _line_stretch_count-1;
                var _stretch_incr = -1;
            }
        
            repeat(_line_stretch_count)
            {
                var _stretch_word_start = _stretch_grid[# _k, __SCRIBBLE_GEN_STRETCH.__WORD_START];
                var _stretch_word_end   = _stretch_grid[# _k, __SCRIBBLE_GEN_STRETCH.__WORD_END  ];
                var _stretch_bidi       = _stretch_grid[# _k, __SCRIBBLE_GEN_STRETCH.__BIDI      ];
            
                if (_stretch_bidi < __SCRIBBLE_BIDI.R2L)
                {
                    // "Normal" L2R text, no word reordering required
                    var _w = _stretch_word_start;
                    var _word_incr = 1;
                }
                else
                {
                    // R2L text, words need to be reversed
                    var _w = _stretch_word_end;
                    var _word_incr = -1;
                }
                
                repeat(1 + _stretch_word_end - _stretch_word_start)
                {
                    var _word_glyph_start = _word_grid[# _w, __SCRIBBLE_GEN_WORD.__GLYPH_START];
                    var _word_glyph_end   = _word_grid[# _w, __SCRIBBLE_GEN_WORD.__GLYPH_END  ];
                
                    ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__X, _glyph_x);
                    _glyph_x += _word_grid[# _w, __SCRIBBLE_GEN_WORD.__WIDTH] + _justification_extra_spacing;
                
                    _w += _word_incr;
                }
            
                _k += _stretch_incr;
            }
            
            ++_j;
        }
        
        
        if (_page_min_x == infinity) _page_min_x = 0;
        _page_data.__min_x  = _page_min_x;
        _page_data.__max_x  = max(_page_min_x, _page_max_x);
        
        _model_min_y = min(_model_min_y, _page_data.__min_y);
        _model_max_y = max(_model_max_y, _page_data.__max_y);
        
        ++_i;
    }
    
    if (_model_min_x == infinity) _model_min_x = 0;
    
   __min_x = _model_min_x;
   __min_y = _model_min_y;
   __max_x = max(_model_min_x, _model_max_x);
   __max_y = _model_max_y;
    
    __width  = 1 + __max_x - __min_x;
    __height = 1 + __max_y - __min_y;
}