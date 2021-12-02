#macro __SCRIBBLE_GEN_LINE_START  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.WORD_START        ] = _line_word_start;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.HALIGN            ] = _state_halign;\
                                  _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.STARTS_MANUAL_PAGE] = false;


#macro __SCRIBBLE_GEN_LINE_END  var _line_height = clamp(ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_GEN_WORD.HEIGHT, _line_word_end, __SCRIBBLE_GEN_WORD.HEIGHT), _line_height_min, _line_height_max);\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.WORD_END] = _line_word_end;\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.WIDTH   ] = _word_x;\
                                _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.HEIGHT  ] = _line_height;\
                                _line_count++;\
                                _word_width = 0;


function __scribble_gen_7_build_lines()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _line_grid    = global.__scribble_line_grid;
    var _control_grid = global.__scribble_control_grid;
    
    with(global.__scribble_generator_state)
    {
        var _element          = element;
        var _word_count       = word_count;
        var _line_height_min  = line_height_min;
        var _line_height_max  = line_height_max;
        var _model_max_width  = model_max_width;
        var _model_max_height = model_max_height;
        var _wrap_no_pages    = _element.wrap_no_pages;
        var _wrap_max_scale   = _element.wrap_max_scale;
    }
    
    var _fit_to_box_iterations = 0;
    var _lower_limit = undefined;
    var _upper_limit = undefined;
    repeat(SCRIBBLE_FIT_TO_BOX_ITERATIONS)
    {
        var _line_max_y                 = 0;
        var _simulated_model_max_width  = _model_max_width  / fit_scale;
        var _simulated_model_max_height = _model_max_height / fit_scale;
        
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
            
            var _line_word_start = 0;
            __SCRIBBLE_GEN_LINE_START;
            
            var _i = 0;
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
                
                if (_word_x + _word_width >= _simulated_model_max_width)
                {
                    //TODO - Check if word is too big to fit on one line
                    
                    var _line_word_end = _i-1;
                    __SCRIBBLE_GEN_LINE_END;
                    
                    _line_y += _line_height;
                    if (_line_y > _line_max_y) _line_max_y = _line_y;
                    
                    _line_word_start = _i;
                    __SCRIBBLE_GEN_LINE_START;
                }
                else
                {
                    // Check for \n line break characters or nulls (manual page breaks) stored at the start of words
                    var _glyph_start_ord = _glyph_grid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH.ORD];
                    if (_glyph_start_ord == 0x0A) //Newline
                    {
                        //Linebreak after this word
                        
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
                        
                        _line_y += _line_height;
                        if (_line_y > _line_max_y) _line_max_y = _line_y;
                        
                        _line_word_start = _i+1;
                        __SCRIBBLE_GEN_LINE_START;
                        
                        _word_x = 0;
                    }
                    else if (_glyph_start_ord == 0x00) //Null, indicates a new page
                    {
                        //Pagebreak after this word
                        
                        var _line_word_end = _i;
                        __SCRIBBLE_GEN_LINE_END;
                        
                        _line_y = 0;
                        
                        _line_word_start = _i+1;
                        __SCRIBBLE_GEN_LINE_START;
                        _line_grid[# _line_count, __SCRIBBLE_GEN_LINE.STARTS_MANUAL_PAGE] = true;
                        
                        _word_x = 0;
                    }
                }
                
                _word_x += _word_width;
                ++_i;
            }
            
            //Finalize the line we've already started
            var _line_word_end = _i-1;
            __SCRIBBLE_GEN_LINE_END;
            
            _line_y += _line_height;
            if (_line_y > _line_max_y) _line_max_y = _line_y;
        }
        
        //If we're not running .fit_to_box() behaviour then escape now!
        if (!_wrap_no_pages || (SCRIBBLE_FIT_TO_BOX_ITERATIONS <= 1)) break;
        
        
        
        
        _fit_to_box_iterations++;
        
        if (_line_max_y < _simulated_model_max_height)
        {
            //The text is already small enough to fit!
            if (fit_scale >= _wrap_max_scale) break;
            var _lower_limit = fit_scale;
        }
        else
        {
            var _upper_limit = fit_scale;
        }
        
        if (_fit_to_box_iterations >= SCRIBBLE_FIT_TO_BOX_ITERATIONS-1)
        {
            if (fit_scale == _lower_limit) break;
            fit_scale = _lower_limit;
        }
        else if (_lower_limit == undefined)
        {
            fit_scale *= 0.5;
        }
        else if (_upper_limit == undefined)
        {
            fit_scale = min(_wrap_max_scale, 2*fit_scale);
        }
        else
        {
            fit_scale = _lower_limit + 0.5*(_upper_limit - _lower_limit);
        }
    }
    
    width = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_GEN_LINE.WIDTH, _line_count - 1, __SCRIBBLE_GEN_LINE.WIDTH);
    
    with(global.__scribble_generator_state)
    {
        word_count = _word_count;
        line_count = _line_count;
    }
}