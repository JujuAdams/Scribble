// Feather disable all
#macro __SCRIBBLE_GEN_LINE_START  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__X                 ] = _indent_x;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__WORD_START        ] = _line_word_start;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__HALIGN            ] = _state_halign;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__STARTS_MANUAL_PAGE] = false;\
                                  ;\ //Adjust the first word's width to account for visual tweaks
                                  ;\ //TODO - Implement for R2L text
                                  if ((SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) && (_word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.__BIDI] < __SCRIBBLE_BIDI.R2L))\
                                  {\
                                      var _word_glyph_start = _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD.__GLYPH_START ];\
                                      var _word_glyph_end   = _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD.__GLYPH_END   ];\
                                      var _left_correction  = _glyph_grid[# _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET];\
                                      ;\
                                      if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))\
                                      {\
                                          _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD.__WIDTH] += _left_correction;\
                                          _word_width += _left_correction;\
                                      }\
                                  }\
                                  _word_x = _indent_x;


#macro __SCRIBBLE_GEN_LINE_END  var _found_line_height = ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_GEN_WORD.__HEIGHT, _line_word_end, __SCRIBBLE_GEN_WORD.__HEIGHT);\
                                if (_found_line_height < _line_height_min)\ //Found line height is narrower than we want
                                {\
                                    if (((_found_line_height/2) == (_found_line_height div 2)) == ((_line_height_min/2) == (_line_height_min div 2)))\
                                    {\
                                        var _line_height = _line_height_min;\ //Evenness matches - set the line height to the minimum
                                    }\
                                    else\
                                    {\
                                        var _line_height = _line_height_min+1;\ //Evenness doesn't match - make the line height slightly wider than the minimum to avoid janky y-offsets
                                    }\
                                }\
                                else if (_found_line_height > _line_height_max)\ //Found line height is wider than we want
                                {\
                                    if (((_found_line_height/2) == (_found_line_height div 2)) == ((_line_height_max/2) == (_line_height_max div 2)))\
                                    {\
                                        var _line_height = _line_height_max;\ //Evenness matches - set the line height to the maximum
                                    }\
                                    else\
                                    {\
                                        var _line_height = _line_height_max-1;\ //Evenness doesn't match - make the line height slightly narrower than the minimum to avoid janky y-offsets
                                    }\
                                }\
                                else\
                                {\
                                    var _line_height = _found_line_height;\ //Line height is fine, don't fiddle with anything
                                }\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__WORD_END] = _line_word_end;\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__WIDTH   ] = _word_x;\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__HEIGHT  ] = _line_height;\
                                _line_count++;\
                                if (_line_y + _line_height > _line_max_y) _line_max_y = _line_y + _line_height;\
                                _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;


function __scribble_gen_6_build_lines()
{
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        var _glyph_grid            = __glyph_grid;
        var _word_grid             = __word_grid;
        var _line_grid             = __line_grid;
        var _control_grid          = __control_grid;
        var _temp_grid             = __temp_grid;
        var _element               = __element;
        var _word_count            = __word_count;
        var _line_height_min       = __line_height_min;
        var _line_height_max       = __line_height_max;
        var _line_spacing_add      = __line_spacing_add;
        var _line_spacing_multiply = __line_spacing_multiply;
        var _wrap_no_pages         = _element.__wrap_no_pages;
        var _wrap_max_scale        = _element.__wrap_max_scale;
        var _wrap_apply            = _element.__wrap_apply;
        var _model_max_width       = (_wrap_apply? __model_max_width  : infinity);
        var _model_max_height      = (_wrap_apply? __model_max_height : infinity);
    }
    
    var _fit_to_box_iterations = 0;
    var _lower_limit = undefined;
    var _upper_limit = undefined;
    repeat(max(1, SCRIBBLE_FIT_TO_BOX_ITERATIONS))
    {
        var _line_max_y                 = 0;
        var _simulated_model_max_width  = _model_max_width  / __fit_scale;
        var _simulated_model_max_height = _model_max_height / __fit_scale;
        
        var _line_count = 0;
        var _word_broken = false;
        
        if (_word_count > 0)
        {
            var _state_halign  = fa_left;
            var _control_index = 0;
            var _word_x        = 0;
            var _line_y        = 0;
            var _indent_x      = 0;
            
            //Find any horizontal alignment changes
            var _control_delta = _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] - _control_index;
            repeat(_control_delta)
            {
                if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE.__HALIGN)
                {
                    _state_halign = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                }
                
                _control_index++;
            }
            
            var _i = 0;
                        
            var _word_width      = 0;
            var _line_word_start = 0;
            __SCRIBBLE_GEN_LINE_START;
            
            repeat(_word_count)
            {
                var _word_width       = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__WIDTH      ];
                var _word_start_glyph = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_START];
                
                //Find any horizontal alignment changes
                var _control_delta = _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] - _control_index;
                repeat(_control_delta)
                {
                    switch(_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__TYPE])
                    {
                        case __SCRIBBLE_GEN_CONTROL_TYPE.__HALIGN:
                            _state_halign = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE.__INDENT_START:
                            _indent_x = _word_x;
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE.__INDENT_STOP:
                            _indent_x = 0;
                        break;
                    }
                    
                    _control_index++;
                }
                
                //Analyse the alignment *after* resolving controls
                //This ensures we don't mark alignments as used if no text is rendered for that alignment
                switch(_state_halign)
                {
                    case fa_left:   _generator_state.__uses_halign_left   = true; break;
                    case fa_center: _generator_state.__uses_halign_center = true; break;
                    case fa_right:  _generator_state.__uses_halign_right  = true; break;
                }
                
                if (_word_x + _word_width > _simulated_model_max_width)
                {
                    __wrapped = true;
                    
                    if (_word_width >= _simulated_model_max_width)
                    {
                        _word_broken = true;
                        if (_wrap_no_pages)
                        {
                            var _line_word_end = _i;
                            __SCRIBBLE_GEN_LINE_END;
                            _line_y += _line_height;
                            break;
                        }
                        
                        #region Emergency! We're going to have to retroactively implement per-glyph line wrapping
                        
                        if (_word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI] >= __SCRIBBLE_BIDI.R2L)
                        {
                            //TODO - Implement R2L emergency per-glyph line wrapping
                            var _line_word_end = _i;
                            __SCRIBBLE_GEN_LINE_END;
                            _line_word_start = _i+1;
                            __SCRIBBLE_GEN_LINE_START;
                        }
                        else
                        {
                            //Back up existing word definitions=
                            var _stashed_word_count = _word_count - (_i+1);
                            ds_grid_set_grid_region(_temp_grid, _word_grid, _i+1, 0, _word_count, __SCRIBBLE_GEN_WORD.__SIZE-1, 0, 0);
                            
                            var _original_word_bidi_raw    = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI_RAW   ];
                            var _original_word_bidi        = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI       ];
                            var _original_word_glyph_start = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_START];
                            var _original_word_glyph_end   = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_END  ];
                            //var _original_word_width       = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__WIDTH      ]; //Unused
                            var _original_word_height      = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__HEIGHT     ];
                            
                            if ((SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) && (_word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI] < __SCRIBBLE_BIDI.R2L))
                            {
                                var _left_correction = _glyph_grid[# _original_word_glyph_start, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET];
                                if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))
                                {
                                    _word_x += _left_correction;
                                }
                            }
                            
                            var _new_word_start_x     = _word_x;
                            var _new_word_glyph_start = _original_word_glyph_start;
                            
                            var _j = _new_word_glyph_start;
                            var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
                            if ((_word_x + _glyph_width >= _simulated_model_max_width) && (_i > _line_word_start))
                            {
                                var _line_word_end = _i-1;
                                __SCRIBBLE_GEN_LINE_END;
                                _line_word_start = _i;
                                __SCRIBBLE_GEN_LINE_START;
                                
                                _new_word_start_x = 0;
                            }
                            
                            _word_x += _glyph_width;
                            ++_j;
                            
                            repeat(1 + _original_word_glyph_end - _j)
                            {
                                var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
                                if (_word_x + _glyph_width >= _simulated_model_max_width)
                                {
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI_RAW   ] = _original_word_bidi_raw;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI       ] = _original_word_bidi;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_START] = _new_word_glyph_start;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_END  ] = _j-1;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__WIDTH      ] = _word_x - _new_word_start_x;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__HEIGHT     ] = _original_word_height;
                                    
                                    //Adjust the glyph X position in the new word
                                    ds_grid_add_region(_glyph_grid, _j, __SCRIBBLE_GEN_GLYPH.__X, _original_word_glyph_end, __SCRIBBLE_GEN_GLYPH.__X, -(_word_x - _new_word_start_x));
                                    
                                    var _line_word_end = _i;
                                    __SCRIBBLE_GEN_LINE_END;
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
                            
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI_RAW   ] = _original_word_bidi_raw;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI       ] = _original_word_bidi;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_START] = _new_word_glyph_start;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__GLYPH_END  ] = _j-1;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__WIDTH      ] = _word_x - _new_word_start_x;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__HEIGHT     ] = _original_word_height;
                            
                            ds_grid_set_grid_region(_word_grid, _temp_grid, 0, 0, _stashed_word_count, __SCRIBBLE_GEN_WORD.__SIZE-1, _i+1, 0);
                            _word_width = 0;
                        }
                        
                        #endregion
                    }
                    else if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && (_word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI_RAW] == __SCRIBBLE_BIDI.WHITESPACE))
                    {
                        //If the word at the end of the line is whitespace, include that on this line
                        //We trim the whitespace down to fit on the line later
                        _word_x += _word_width;
                        
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
                        _line_word_start = _i+1;
                        __SCRIBBLE_GEN_LINE_START;
                        
                        //Ensure we don't carry the space's width over to the new line
                        _word_width = 0;
                    }
                    else
                    {
                        var _line_word_end = _i-1;
                        __SCRIBBLE_GEN_LINE_END;
                        _line_word_start = _i;
                        __SCRIBBLE_GEN_LINE_START;
                    }
                }
                else
                {
                    // Check for \n line break characters or nulls (manual page breaks) stored at the start of words
                    var _glyph_start_ord = _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.__UNICODE];
                    if (_glyph_start_ord == 0x0A) //Newline
                    {
                        //Linebreak after this word
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
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
                        if (_i < _word_count - 1) _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.__STARTS_MANUAL_PAGE] = true;
                    }
                }
                
                _word_x += _word_width;
                ++_i;
            }
            
            //Finalize the line we've already started
            //Generally speaking this should never actually execute as 0x00 NULL will terminate a line and 0x00 always appears as the final glyph
            var _line_word_end = _i-1;
            if (_line_word_end >= _line_word_start) //Only generate a new line if we actually have glyphs on the final line
            {
                __SCRIBBLE_GEN_LINE_END;
                _line_y += _line_height;
            }
        }
        
        //If we're not running .fit_to_box() behaviour then escape now!
        if (!_wrap_no_pages || (SCRIBBLE_FIT_TO_BOX_ITERATIONS <= 1)) break;
        
        
        
        _fit_to_box_iterations++;
        
        if ((_line_max_y < _simulated_model_max_height) && !_word_broken)
        {
            //The text is already small enough to fit (and none of the words have been split in the middle)
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
    
    //Align the left-hand side of the word to the left-hand side of the line. This corrects visually unpleasant gaps and overlaps
    //TODO - Implement for R2L text
    if (SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE)
    {
        var _line = 0;
        repeat(_line_count)
        {
            var _line_word_start = _line_grid[# _line, __SCRIBBLE_GEN_LINE.__WORD_START];
            if (_word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD.__BIDI] < __SCRIBBLE_BIDI.R2L)
            {
                var _word_glyph_start = _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD.__GLYPH_START ];
                var _word_glyph_end   = _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD.__GLYPH_END   ];
                var _left_correction  = _glyph_grid[# _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET];
                
                if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))
                {
                    ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__X, _left_correction);
                    _word_grid[# _i, __SCRIBBLE_GEN_WORD.__WIDTH] += _left_correction;
                }
            }
            
            ++_line;
        }
    }
    
    //Trim the whitespace at the end of lines to fit into the desired width
    //This helps the glyph position getter return more visually pleasing results by ensuring the RHS of the glyph doesn't exceed the wrapping width
    if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && _wrap_apply)
    {
        var _line = 0;
        repeat(_line_count)
        {
            var _line_end_word = _line_grid[# _line, __SCRIBBLE_GEN_LINE.__WORD_END];
            if (_word_grid[# _line_end_word, __SCRIBBLE_GEN_WORD.__BIDI_RAW] == __SCRIBBLE_BIDI.WHITESPACE) //Only adjust whitespace words
            {
                var _line_width = _line_grid[# _line, __SCRIBBLE_GEN_LINE.__WIDTH];
                if (_line_width > _simulated_model_max_width) //Only adjust lines that actually exceed the maximum size
                {
                    var _delta = _simulated_model_max_width - _line_width;
                    
                    _line_grid[# _line, __SCRIBBLE_GEN_LINE.__WIDTH] = _simulated_model_max_width;
                    
                    _word_grid[# _line_end_word, __SCRIBBLE_GEN_WORD.__WIDTH] += _delta;
                    
                    var _word_start_glyph = _word_grid[# _line_end_word, __SCRIBBLE_GEN_WORD.__GLYPH_START];
                    _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.__WIDTH     ] += _delta;
                    _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.__SEPARATION] += _delta;
                }
            }
            
            ++_line;
        }
    }
    
    __width = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_GEN_LINE.__WIDTH, _line_count - 1, __SCRIBBLE_GEN_LINE.__WIDTH);
    
    with(_generator_state)
    {
        __word_count = _word_count;
        __line_count = _line_count;
    }
}


