function __scribble_generator_build_words()
{
    //Unpack generator state
    //Cache globals locally for a performance boost
    var _glyph_grid      = global.__scribble_glyph_grid;
    var _word_grid       = global.__scribble_word_grid;
    var _line_grid       = global.__scribble_line_grid;
    var _control_grid    = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    var _glyph_count     = global.__scribble_generator_state.glyph_count;
    var _line_height_min = global.__scribble_generator_state.line_height_min;
    var _line_height_max = global.__scribble_generator_state.line_height_max;
    var _model_max_width = global.__scribble_generator_state.model_max_width;
    
    var _element         = global.__scribble_generator_state.element;
    var _character_wrap  = _element.wrap_per_char;
    
    var _line_count      = 0;
    var _line_word_start = 0;
    var _line_word_end   = 0;
    
    var _word_count       = 0;
    var _word_glyph_start = 0;
    var _word_glyph_end   = 0;
    var _word_width       = 0;
    
    var _word_x       = 0;
    var _space_width  = 0;
    var _state_halign = fa_left;
    
    var _control_index     = 0;
    var _control_pagebreak = false;
    //We store the next control position as there are typically many more glyphs than controls
    //This ends up being quite a lot faster than continually reading from the grid
    var _next_control_pos = _control_grid[# 0, __SCRIBBLE_PARSER_CONTROL.POSITION];
    
    var _i = 0;
    repeat(_glyph_count + 1) //Ensure we fully handle the last word by including the null terminator in this loop
    {
        //If this glyph index is the same as our control position then scan for new controls to apply
        while(_i == _next_control_pos)
        {
            //If this control is a horizontal alignment, set the halign value
            switch(_control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.TYPE])
            {
                case __SCRIBBLE_CONTROL_HALIGN:
                    _state_halign = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.DATA];
                break;
                
                case __SCRIBBLE_CONTROL_PAGEBREAK:
                    _control_pagebreak = true;
                break;
            }
            
            //Increment which control we're processing
            ++_control_index;
            _next_control_pos = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.POSITION];
            
            //Break out of this loop immediately if we've hit a pagebreak
            if (_control_pagebreak) break;
        }
        
        var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
        if ((_glyph_ord == 0x00) //Null
        ||  (_glyph_ord == 0x09) //Horizontal tab (dec = 9)
        ||  (_glyph_ord == 0x0D) //Line break (dec = 13)
        ||  (_glyph_ord == 0x20) //Space (dec = 32)
        ||   _control_pagebreak)
        {
            #region Word break
            
            _word_glyph_end = _i - 1;
            _space_width = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH];
            
            if (_word_glyph_end < _word_glyph_start)
            {
                //Empty word (usually two spaces together)
                _word_glyph_start = _word_glyph_end + 2;
                _word_x += _space_width;
            }
            else
            {
                var _last_glyph_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                
                //Word width is equal to the width of the last glyph plus its x-coordinate in the word
                _word_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X] + _last_glyph_width;
                
                //Steal the empty space for the last glyph and add it onto the space
                _space_width += _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _last_glyph_width;
                
                if ((_word_width <= _model_max_width) && !_character_wrap) //TODO - Optimise per-character wrapping
                {
                    //Word is shorter than the maximum width, wrap it down to the next time
                    
                    if (_word_x + _word_width > _model_max_width)
                    {
                        _line_word_end = _word_count - 1;
                        __SCRIBBLE_PARSER_ADD_LINE;
                        _line_word_start = _word_count;
                        
                        _word_x = 0;
                    }
                    
                    __SCRIBBLE_PARSER_ADD_WORD;
                    
                    _word_glyph_start = _word_glyph_end + 2;
                    _word_x += _space_width + _word_width;
                }
                else
                {
                    #region The word itself is longer than the maximum width
                
                    //Gotta split it up!
                
                    _word_width = 0;
                    var _prev_glyph_empty_space = 0;
                    var _last_glyph = _word_glyph_end;
                
                    var _j = _word_glyph_start;
                    repeat(1 + _word_glyph_end - _word_glyph_start)
                    {
                        var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                        if (_word_x + _word_width + _prev_glyph_empty_space + _glyph_width > _model_max_width)
                        {
                            _word_glyph_end = _j - 1;
                        
                            if (_word_glyph_end >= _word_glyph_start)
                            {
                                __SCRIBBLE_PARSER_ADD_WORD;
                            }
                        
                            _word_glyph_start = _j;
                        
                            if (_word_count > 0)
                            {
                                _line_word_end = _word_count - 1;
                                __SCRIBBLE_PARSER_ADD_LINE;
                                _line_word_start = _word_count;
                            }
                        
                            //Adjust the x-coord-in-word position of the remaining glyphs in the word
                            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _last_glyph, __SCRIBBLE_PARSER_GLYPH.X, -_glyph_grid[# _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X]);
                        
                            _word_x     = 0;
                            _word_width = _glyph_width;
                        }
                        else
                        {
                            _word_width += _prev_glyph_empty_space + _glyph_width;
                        }
                    
                        _prev_glyph_empty_space = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _glyph_width;
                    
                        ++_j;
                    }
                
                    _word_glyph_end = _i - 1;
                    __SCRIBBLE_PARSER_ADD_WORD;
                
                    _word_glyph_start = _word_glyph_end + 2;
                    _word_x += _word_width + _space_width;
                
                    #endregion
                }
            }
            
            #endregion
        }
        
        if (_glyph_ord == 0x0D)
        {
            #region Line break
            
            _line_word_end = _word_count - 1;
            __SCRIBBLE_PARSER_ADD_LINE;
            _line_word_start = _word_count;
            
            _word_x     = 0;
            _word_width = 0;
            _word_glyph_start = _i + 1;
            
            #endregion
        }
        
        if (_control_pagebreak)
        {
            _control_pagebreak = false;
            
            #region Page break
            
            if (_glyph_ord != 0x0D)
            {
                _line_word_end = _word_count - 1;
                __SCRIBBLE_PARSER_ADD_LINE;
                _line_word_start = _word_count;
            }
            
            //Add an infinitely high line (which we'll read as a page break in a later step)
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.Y         ] = 0;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START] = -1;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END  ] = -2;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH     ] = 0;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HEIGHT    ] = infinity;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN    ] = _state_halign;
            _line_count++;
            
            _word_x     = 0;
            _word_width = 0;
            _word_glyph_start = _i;
            
            #endregion
        }
        
        ++_i;
    }
    
    //Make sure we add a line for any words we have left on a trailing line
    _line_word_end = _word_count - 1;
    if (_line_word_end >= _line_word_start)
    {
        __SCRIBBLE_PARSER_ADD_LINE;
    }
    
    
    
    width = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_PARSER_LINE.WIDTH, _line_count - 1, __SCRIBBLE_PARSER_LINE.WIDTH);
    
    with(global.__scribble_generator_state)
    {
        word_count = _word_count;
        line_count = _line_count;
    }
}