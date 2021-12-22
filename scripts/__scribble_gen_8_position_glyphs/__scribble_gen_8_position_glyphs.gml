function __scribble_gen_8_position_glyphs()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _stretch_grid = global.__scribble_stretch_grid;
    var _line_grid    = global.__scribble_line_grid;
    var _temp_grid    = global.__scribble_temp_grid;
    
    ds_grid_clear(_temp_grid, 0); //FIXME - Works around a bug in ds_grid_add_grid_region() (runtime 2.3.7.474  2021-12-03)
    
    with(global.__scribble_generator_state)
    {
        var _element         = __element;
        var _line_count      = __line_count;
        var _overall_bidi    = __overall_bidi;
        var _model_max_width = __model_max_width;
        var _glyph_count     = __glyph_count;
        var _padding_l       = _element.__padding_l;
        var _padding_t       = _element.__padding_t;
    }
    
    //Transform the animation index into a proper packed index
    ds_grid_multiply_region(_glyph_grid, 0, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, __SCRIBBLE_MAX_LINES);
    
    var _model_min_x =  infinity;
    var _model_min_y =  infinity;
    var _model_max_x = -infinity;
    var _model_max_y = -infinity;
    
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
        
        var _page_min_x =  infinity;
        var _page_max_x = -infinity; 
        
        var _page_start_line = _page_data.__line_start;
        var _page_end_line   = _page_data.__line_end;
        
        var _j = _page_start_line;
        repeat(1 + _page_end_line - _page_start_line)
        {
            var _line_y          = _line_grid[# _j, __SCRIBBLE_GEN_LINE.Y         ];
            var _line_word_start = _line_grid[# _j, __SCRIBBLE_GEN_LINE.WORD_START];
            var _line_word_end   = _line_grid[# _j, __SCRIBBLE_GEN_LINE.WORD_END  ];
            var _line_width      = _line_grid[# _j, __SCRIBBLE_GEN_LINE.WIDTH     ];
            var _line_height     = _line_grid[# _j, __SCRIBBLE_GEN_LINE.HEIGHT    ];
            var _line_halign     = _line_grid[# _j, __SCRIBBLE_GEN_LINE.HALIGN    ];
            
            var _line_glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.GLYPH_START];
            var _line_glyph_end   = _word_grid[# _line_word_end,   __SCRIBBLE_GEN_WORD.GLYPH_END  ];
            
            
            
            ds_grid_add_region(_glyph_grid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, _line_glyph_end, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, _j - _page_start_line);
            
            
            
            #region Centre all glyphs vertically on the line
            
            var _line_glyph_count = 1 + _line_glyph_end - _line_glyph_start;
            
            // _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.Y] = _line_y + (_line_height - _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.FONT_HEIGHT]) div 2;
            ds_grid_set_grid_region(_temp_grid, _glyph_grid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.FONT_HEIGHT, _line_glyph_end, __SCRIBBLE_GEN_GLYPH.FONT_HEIGHT, 0, 0);
            ds_grid_multiply_region(_temp_grid, 0, 0, _line_glyph_count-1, 0, -0.5);
            ds_grid_add_region(_temp_grid, 0, 0, _line_glyph_count-1, 0, 0.5*_line_height + _line_y);
            ds_grid_add_grid_region(_glyph_grid, _temp_grid, 0, 0, _line_glyph_count-1, 0, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.Y);
            
            #endregion
            
            
            
            //Correct for vertical alignment
            if (_page_data.__min_y != 0) ds_grid_add_region(_glyph_grid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH.Y, _line_glyph_end, __SCRIBBLE_GEN_GLYPH.Y, _page_data.__min_y);
            
            
            
            #region Figure out what order words should come in
            
            // TODO - Do this whilst building lines
            
            var _line_stretch_count = 0;
            var _stretch_bidi       = _word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.BIDI];
            
            var _stretch_word_start = _line_word_start;
            var _w = _line_word_start;
            repeat(1 + _line_word_end - _line_word_start)
            {
                var _word_bidi = _word_grid[# _w, __SCRIBBLE_GEN_WORD.BIDI];
                if (_word_bidi != _stretch_bidi)
                {
                    _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.WORD_START] = _stretch_word_start;
                    _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.WORD_END  ] = _w - 1;
                    _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.BIDI      ] = _stretch_bidi;
                    _line_stretch_count++;
                    
                    _stretch_word_start = _w;
                    _stretch_bidi = _word_bidi;
                }
            
                ++_w;
            }
            
            if (_w > 0)
            {
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.WORD_START] = _stretch_word_start;
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.WORD_END  ] = _w - 1;
                _stretch_grid[# _line_stretch_count, __SCRIBBLE_GEN_STRETCH.BIDI      ] = _stretch_bidi;
                _line_stretch_count++;
            }
            
            #endregion
            
            
            
            // Text on the last line is never justified
            // FIXME - This should work per-page not per-model
            if ((_line_halign == __SCRIBBLE_JUSTIFY) && (_j >= _line_count - 1)) _line_halign = __SCRIBBLE_PIN_LEFT;
            
            var _justification_extra_spacing = 0;
            
            switch(_line_halign)
            {
                case fa_left:               var _glyph_x = (_overall_bidi == __SCRIBBLE_BIDI.R2L)? (_alignment_width - _line_width) : 0;     break;
                case __SCRIBBLE_PIN_LEFT:   var _glyph_x = (_overall_bidi == __SCRIBBLE_BIDI.R2L)? (_pin_alignment_width - _line_width) : 0; break;
                case fa_center:             var _glyph_x = -(_line_width div 2);                                                             break;
                case fa_right:              var _glyph_x = -_line_width;                                                                     break;
                case __SCRIBBLE_PIN_CENTRE: var _glyph_x = (_pin_alignment_width - _line_width) div 2;                                       break;
                case __SCRIBBLE_PIN_RIGHT:  var _glyph_x = _pin_alignment_width - _line_width;                                               break;
                
                case __SCRIBBLE_JUSTIFY:
                    var _glyph_x = 0;
                    
                    // Don't apply justification on the last line on a page
                    if (_j != _page_end_line)
                    {
                        var _line_word_count = 1 + _line_word_end - _line_word_start;
                        if (_line_word_count > 1) // Prevent div-by-zero
                        {
                            // Distribute spacing over the line, on which there are n-1 spaces
                            var _justification_extra_spacing = (_pin_alignment_width - _line_width) / (_line_word_count - 1);
                        }
                    }
                break;
            }
            
            
            
            // Figure out the boundaries of the page + model
            var _page_min_x  = min(_page_min_x,  _padding_l + _glyph_x              );
            var _page_max_x  = max(_page_max_x,  _padding_l + _glyph_x + _line_width);
            var _model_min_x = min(_model_min_x, _padding_l + _glyph_x              );
            var _model_max_x = max(_model_max_x, _padding_l + _glyph_x + _line_width);
            
            
            
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
                var _stretch_word_start = _stretch_grid[# _k, __SCRIBBLE_GEN_STRETCH.WORD_START];
                var _stretch_word_end   = _stretch_grid[# _k, __SCRIBBLE_GEN_STRETCH.WORD_END  ];
                var _stretch_bidi       = _stretch_grid[# _k, __SCRIBBLE_GEN_STRETCH.BIDI      ];
            
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
                    var _word_glyph_start = _word_grid[# _w, __SCRIBBLE_GEN_WORD.GLYPH_START];
                    var _word_glyph_end   = _word_grid[# _w, __SCRIBBLE_GEN_WORD.GLYPH_END  ];
                
                    ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.X, _glyph_x);
                    _glyph_x += _word_grid[# _w, __SCRIBBLE_GEN_WORD.WIDTH] + _justification_extra_spacing;
                
                    _w += _word_incr;
                }
            
                _k += _stretch_incr;
            }
            
            ++_j;
        }
        
        
        if (_page_min_x == infinity) _page_min_x = 0;
        _page_data.__min_x  = _page_min_x;
        _page_data.__max_x  = max(_page_min_x, _page_max_x);
        _page_data.__min_y += _padding_t;
        _page_data.__max_y += _padding_t;
        
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