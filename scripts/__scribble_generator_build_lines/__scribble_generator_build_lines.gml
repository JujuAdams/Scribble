function __scribble_generator_build_lines()
{
    var _word_grid = global.__scribble_word_grid;
    var _line_grid = global.__scribble_line_grid;
    
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
        var _state_halign = fa_left;
        var _control_index = 0;
        
        var _line_y          = 0;
        var _line_count      = 0;
        var _line_word_start = 0;
        var _word_x          = 0;
        
        var _simulated_model_max_width  = _model_max_width  / fit_scale;
        var _simulated_model_max_height = _model_max_height / fit_scale;
        
        var _i = 0;
        repeat(_word_count)
        {
            var _word_width = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.WIDTH];
            if (_word_x + _word_width < _simulated_model_max_width)
            {
                _word_x += _word_grid[# _i, __SCRIBBLE_PARSER_WORD.WIDTH];
            }
            else
            {
                //TODO - Check if word is too big to fit on one line
                
                var _line_word_end = _i - 1;
                var _line_height = clamp(ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.HEIGHT, _line_word_end, __SCRIBBLE_PARSER_WORD.HEIGHT), _line_height_min, _line_height_max);
                
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.Y          ]  // Set in __scribble_generator_build_pages()
                _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START ] = _line_word_start;
                _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END   ] = _line_word_end;
                _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH      ] = _word_x + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];
                _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HEIGHT     ] = _line_height;
                _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN     ] = _state_halign;
                _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.CONTROL_END] = _control_index - 1;
            
                _line_count++;
                _line_y += _line_height;
                
                _line_word_start = _i;
                _word_x = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.WIDTH];
            }
        
            ++_i;
        }
    
        if ((_line_word_start != _i - 1) || _word_grid[# _line_word_start, __SCRIBBLE_PARSER_WORD.PRINTABLE])
        {
            var _line_word_end = _i - 1;
            var _line_height = clamp(ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.HEIGHT, _line_word_end, __SCRIBBLE_PARSER_WORD.HEIGHT), _line_height_min, _line_height_max);
            
            //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.Y          ]  // Set in __scribble_generator_build_pages()
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START ] = _line_word_start;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END   ] = _line_word_end;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH      ] = _word_x + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HEIGHT     ] = clamp(ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.HEIGHT, _line_word_end, __SCRIBBLE_PARSER_WORD.HEIGHT), _line_height_min, _line_height_max);
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN     ] = _state_halign;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.CONTROL_END] = _control_index - 1;
        
            _line_count++;
            _line_y += _line_height;
        }
        
        //If we're not running .fit_to_box() behaviour then escape now!
        if (!_wrap_no_pages) break;
        
        
        
        
        _fit_to_box_iterations++;
        
        if (_line_y < _simulated_model_max_height)
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
    
    width = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_PARSER_LINE.WIDTH, _line_count - 1, __SCRIBBLE_PARSER_LINE.WIDTH);
    
    with(global.__scribble_generator_state)
    {
        word_count = _word_count;
        line_count = _line_count;
    }
}