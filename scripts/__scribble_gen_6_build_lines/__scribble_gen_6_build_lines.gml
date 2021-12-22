#macro __SCRIBBLE_GEN_LINE_START  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.WORD_START        ] = _line_word_start;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.HALIGN            ] = _state_halign;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.STARTS_MANUAL_PAGE] = false;\
                                  ;\
                                  ;\ //Align the left-hand side of the word to the left-hand side of the line. This corrects visually unpleasant gaps and overlaps
                                  ;\ //TODO - Implement for R2L text
                                  if (_word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.BIDI] < __SCRIBBLE_BIDI.R2L)\
                                  {\
                                      _word_glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.GLYPH_START];\
                                      _word_glyph_end   = _word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.GLYPH_END  ];\
                                      var _left_correction = _glyph_grid[# _word_glyph_start, __SCRIBBLE_GEN_GLYPH.LEFT_OFFSET];\
                                      ;\
                                      if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))\
                                      {\
                                          ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.X, _left_correction);\
                                          _word_width += _left_correction;\
                                          _word_grid[# _i, __SCRIBBLE_GEN_WORD.WIDTH] += _left_correction;\
                                      }\
                                  }\
                                  ;\
                                  _word_x = 0;


#macro __SCRIBBLE_GEN_LINE_END  var _line_height = clamp(ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_GEN_WORD.HEIGHT, _line_word_end, __SCRIBBLE_GEN_WORD.HEIGHT), _line_height_min, _line_height_max);\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.WORD_END] = _line_word_end;\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.WIDTH   ] = _word_x;\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.HEIGHT  ] = _line_height;\
                                _line_count++;\
                                if (_line_y + _line_height > _line_max_y) _line_max_y = _line_y + _line_height;\
                                _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;


function __scribble_gen_6_build_lines()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _line_grid    = global.__scribble_line_grid;
    var _control_grid = global.__scribble_control_grid;
    var _temp_grid    = global.__scribble_temp_grid;
    
    with(global.__scribble_generator_state)
    {
        var _element               = __element;
        var _word_count            = __word_count;
        var _line_height_min       = __line_height_min;
        var _line_height_max       = __line_height_max;
        var _line_spacing_add      = __line_spacing_add;
        var _line_spacing_multiply = __line_spacing_multiply;
        var _model_max_width       = __model_max_width;
        var _model_max_height      = __model_max_height;
        var _wrap_no_pages         = _element.__wrap_no_pages;
        var _wrap_max_scale        = _element.__wrap_max_scale;
    }
    
    var _fit_to_box_iterations = 0;
    var _lower_limit = undefined;
    var _upper_limit = undefined;
    repeat(SCRIBBLE_FIT_TO_BOX_ITERATIONS)
    {
        var _line_max_y                 = 0;
        var _simulated_model_max_width  = _model_max_width  / __fit_scale;
        var _simulated_model_max_height = _model_max_height / __fit_scale;
        
        var _line_count = 0;
        
        if (_word_count > 0)
        {
            var _state_halign  = fa_left;
            var _control_index = 0;
            var _word_x        = 0;
            var _line_y        = 0;
            
            //Find any horizontal alignment changes
            var _control_delta = _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.CONTROL_COUNT] - _control_index;
            repeat(_control_delta)
            {
                if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE.HALIGN)
                {
                    _state_halign = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.DATA];
                }
                
                _control_index++;
            }
            
            var _i = 0;
                        
            var _word_width      = 0;
            var _line_word_start = 0;
            __SCRIBBLE_GEN_LINE_START;
            
            repeat(_word_count)
            {
                var _word_width       = _word_grid[# _i, __SCRIBBLE_GEN_WORD.WIDTH      ];
                var _word_start_glyph = _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_START];
                
                //Find any horizontal alignment changes
                var _control_delta = _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.CONTROL_COUNT] - _control_index;
                repeat(_control_delta)
                {
                    if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE.HALIGN)
                    {
                        _state_halign = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.DATA];
                    }
                    
                    _control_index++;
                }
                
                if (_word_x + _word_width > _simulated_model_max_width)
                {
                    __wrapped = true;
                    
                    if (_word_width >= _simulated_model_max_width)
                    {
                        #region Emergency! We're going to have to retroactively implement per-glyph line wrapping
                        
                        if (_word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI] >= __SCRIBBLE_BIDI.R2L)
                        {
                            //TODO - Implement R2L emergency per-glyph line wrapping
                            var _line_word_end = _i;
                            __SCRIBBLE_GEN_LINE_END;
                            _line_y += _line_height;
                            _line_word_start = _i+1;
                            __SCRIBBLE_GEN_LINE_START;
                        }
                        else
                        {
                            //Back up existing word definitions=
                            var _stashed_word_count = _word_count - (_i+1);
                            ds_grid_set_grid_region(_temp_grid, _word_grid, _i+1, 0, _word_count, __SCRIBBLE_GEN_WORD.__SIZE-1, 0, 0);
                            
                            var _original_word_bidi_raw    = _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI_RAW   ];
                            var _original_word_bidi        = _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI       ];
                            var _original_word_glyph_start = _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_START];
                            var _original_word_glyph_end   = _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_END  ];
                            //var _original_word_width       = _word_grid[# _i, __SCRIBBLE_GEN_WORD.WIDTH      ]; //Unused
                            var _original_word_height      = _word_grid[# _i, __SCRIBBLE_GEN_WORD.HEIGHT     ];
                            
                            var _new_word_start_x     = _word_x;
                            var _new_word_glyph_start = _original_word_glyph_start;
                            
                            var _j = _new_word_glyph_start;
                            var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.SEPARATION];
                            if ((_word_x + _glyph_width >= _simulated_model_max_width) && (_i > _line_word_start))
                            {
                                var _line_word_end = _i-1;
                                __SCRIBBLE_GEN_LINE_END;
                                _line_y += _line_height;
                                _line_word_start = _i;
                                __SCRIBBLE_GEN_LINE_START;
                                
                                _new_word_start_x = 0;
                            }
                            
                            _word_x += _glyph_width;
                            ++_j;
                            
                            repeat(1 + _original_word_glyph_end - _j)
                            {
                                var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.SEPARATION];
                                if (_word_x + _glyph_width >= _simulated_model_max_width)
                                {
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI_RAW   ] = _original_word_bidi_raw;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI       ] = _original_word_bidi;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_START] = _new_word_glyph_start;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_END  ] = _j-1;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.WIDTH      ] = _word_x - _new_word_start_x;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.HEIGHT     ] = _original_word_height;
                                    
                                    //Adjust the glyph X position in the new word
                                    ds_grid_add_region(_glyph_grid, _j, __SCRIBBLE_GEN_GLYPH.X, _original_word_glyph_end, __SCRIBBLE_GEN_GLYPH.X, -(_word_x - _new_word_start_x));
                                    
                                    var _line_word_end = _i;
                                    __SCRIBBLE_GEN_LINE_END;
                                    _line_y += _line_height;
                                    _line_word_start = _i+1;
                                    __SCRIBBLE_GEN_LINE_START;
                                    
                                    _new_word_start_x     = 0;
                                    _new_word_glyph_start = _j;
                                    
                                    ++_i; //We've added a new word!
                                    ++_word_count;
                                    
                                    //TODO - We can early out here if the last glyph in the word fits onto a line
                                }
                                
                                _word_x += _glyph_width;
                                ++_j;
                            }
                            
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI_RAW   ] = _original_word_bidi_raw;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI       ] = _original_word_bidi;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_START] = _new_word_glyph_start;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.GLYPH_END  ] = _j-1;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.WIDTH      ] = _word_x - _new_word_start_x;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.HEIGHT     ] = _original_word_height;
                            
                            ds_grid_set_grid_region(_word_grid, _temp_grid, 0, 0, _stashed_word_count, __SCRIBBLE_GEN_WORD.__SIZE-1, _i+1, 0);
                            _word_width = 0;
                        }
                        
                        #endregion
                    }
                    else if (!SCRIBBLE_FIXED_WHITESPACE_WIDTH && _word_grid[# _i, __SCRIBBLE_GEN_WORD.BIDI_RAW] == __SCRIBBLE_BIDI.WHITESPACE)
                    {
                        _word_grid[# _i, __SCRIBBLE_GEN_WORD.WIDTH] = _simulated_model_max_width - _word_x;
                        
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
                        _line_y += _line_height;
                        _line_word_start = _i+1;
                        __SCRIBBLE_GEN_LINE_START;
                    }
                    else
                    {
                        var _line_word_end = _i-1;
                        __SCRIBBLE_GEN_LINE_END;
                        _line_y += _line_height;
                        _line_word_start = _i;
                        __SCRIBBLE_GEN_LINE_START;
                    }
                }
                else
                {
                    // Check for \n line break characters or nulls (manual page breaks) stored at the start of words
                    var _glyph_start_ord = _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.UNICODE];
                    if (_glyph_start_ord == 0x0A) //Newline
                    {
                        //Linebreak after this word
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
                        _line_y += _line_height;
                        _line_word_start = _i+1;
                        __SCRIBBLE_GEN_LINE_START;
                    }
                    else if (_glyph_start_ord == 0x00) //Null, indicates a new page
                    {
                        //Pagebreak after this word
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
                        _line_y = 0;
                        _line_word_start = _i+1;
                        __SCRIBBLE_GEN_LINE_START;
                        
                        //Only mark the new line as beginning a new page if this null *isn't* the last glyph for the input string
                        if (_i < _word_count - 1) _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.STARTS_MANUAL_PAGE] = true;
                    }
                }
                
                _word_x += _word_width;
                ++_i;
            }
            
            //Finalize the line we've already started
            var _line_word_end = _i-1;
            __SCRIBBLE_GEN_LINE_END;
            _line_y += _line_height;
        }
        
        //If we're not running .fit_to_box() behaviour then escape now!
        if (!_wrap_no_pages || (SCRIBBLE_FIT_TO_BOX_ITERATIONS <= 1)) break;
        
        
        
        _fit_to_box_iterations++;
        
        if (_line_max_y < _simulated_model_max_height)
        {
            //The text is already small enough to fit!
            if (__fit_scale >= _wrap_max_scale) break;
            var _lower_limit = __fit_scale;
        }
        else
        {
            var _upper_limit = __fit_scale;
        }
        
        if (_fit_to_box_iterations >= SCRIBBLE_FIT_TO_BOX_ITERATIONS-1)
        {
            if (__fit_scale == _lower_limit) break;
            __fit_scale = (_lower_limit == undefined)? _upper_limit : _lower_limit;
        }
        else if (_lower_limit == undefined)
        {
            __fit_scale *= 0.5;
        }
        else if (_upper_limit == undefined)
        {
            __fit_scale = min(_wrap_max_scale, 2*__fit_scale);
        }
        else
        {
            __fit_scale = _lower_limit + 0.5*(_upper_limit - _lower_limit);
        }
    }
    
    __width = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_GEN_LINE.WIDTH, _line_count - 1, __SCRIBBLE_GEN_LINE.WIDTH);
    
    with(global.__scribble_generator_state)
    {
        __word_count = _word_count;
        __line_count = _line_count;
    }
}