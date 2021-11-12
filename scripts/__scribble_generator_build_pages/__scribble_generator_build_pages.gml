function __scribble_generator_build_pages()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _line_grid    = global.__scribble_line_grid;
    var _control_grid = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    
    var _model_max_width  = global.__scribble_generator_state.model_max_width;
    var _model_max_height = global.__scribble_generator_state.model_max_height;
    var _line_count       = global.__scribble_generator_state.line_count;
    var _control_count    = global.__scribble_generator_state.control_count;
    
    var _page_data = __new_page();
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
    
    if (_model_max_width != infinity)
    {
        var _alignment_width = _model_max_width;
    }
    else
    {
        var _alignment_width = width;
    }
    
    var _line_y = 0;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height     = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HEIGHT    ];
        var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
        var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
        
        ////Manual page break
        //if (_line_height == infinity)
        //{
        //    _page_data.__glyph_end = _word_grid[# _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.WORD_END], __SCRIBBLE_PARSER_WORD.GLYPH_END];
        //    
        //    var _page_char_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
        //    ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, -_page_char_start);
        //    _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
        //    
        //    _page_data = __new_page();
        //    _page_data.__glyph_start = _word_grid[# _line_grid[# _i+1, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
        //    
        //    _line_y = 0;
        //    _line_height = 0;
        //}
        
        //Create a new page if we've run off the end of the current one
        if (is_infinity(_line_height) || ((_line_y + _line_height > _model_max_height) && (_line_y > 0)))
        {
            _page_data.__glyph_end = _word_grid[# _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.WORD_END], __SCRIBBLE_PARSER_WORD.GLYPH_END];
            
            var _page_char_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
            ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, -_page_char_start);
            _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
            
            _line_y = 0;
            
            if (is_infinity(_line_height))
            {
                _page_data = __new_page();
                _page_data.__glyph_start = _word_grid[# _line_grid[# _i+1, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
                
                //Set our line height to 0!
                _line_height = 0;
            }
            else
            {
                _page_data = __new_page();
                _page_data.__glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_PARSER_WORD.GLYPH_START];
                
                //We also need to increment the page counter for our controls
                ds_grid_add_region(_control_grid, _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.CONTROL_END], __SCRIBBLE_PARSER_CONTROL.PAGE, _control_count - 1, __SCRIBBLE_PARSER_CONTROL.PAGE, 1);
            }
        }
        
        _line_grid[# _i, __SCRIBBLE_PARSER_LINE.Y] = _line_y;
        
        //Only adjust word positions if we actually have words on this line
        if (_line_word_end - _line_word_start >= 0)
        {
            var _line_width  = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH ];
            var _line_halign = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HALIGN];
            
            if (SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) 
            {
                var _line_x_offset = 0;
                
                //Search over all glyphs for the line looking for a valid glyph
                //We use that's glyph's x-offset to adjust the position / width of the line
                //We have to search over the entire line because events and alignment changes are stored as glyphs
                var _line_glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_PARSER_WORD.GLYPH_START];
                var _line_glyph_end   = _word_grid[# _line_word_end,   __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
                
                var _j = _line_glyph_start;
                repeat(1 + _line_glyph_end - _line_glyph_start)
                {
                    var _glyph_data = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA];
                    if (is_array(_glyph_data))
                    {
                        _line_x_offset = _glyph_data[SCRIBBLE_GLYPH.X_OFFSET];
                        break;
                    }
                    
                    ++_j;
                }
                
                if (_line_x_offset > 0)
                {
                    ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.X, _line_word_end, __SCRIBBLE_PARSER_WORD.X, -_line_x_offset);
                    
                    _line_width -= _line_x_offset;
                    _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH] = _line_width;
                }
            }
            
            //Move words vertically onto the line
            if (_line_y != 0)
            {
                ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.Y, _line_word_end, __SCRIBBLE_PARSER_WORD.Y, _line_y);
            }
            
            if ((_line_halign != fa_left) && (_line_halign != __SCRIBBLE_PIN_LEFT)) //fa_left and pin_left do nothing
            {
                #region Other (simpler!) types of alignment
                
                var _xoffset = 0;
                switch(_line_halign)
                {
                    case fa_center:             _xoffset = -(_line_width div 2);                   break;
                    case fa_right:              _xoffset = -_line_width;                           break;
                    case __SCRIBBLE_PIN_CENTRE: _xoffset = (_alignment_width - _line_width) div 2; break;
                    case __SCRIBBLE_PIN_RIGHT:  _xoffset = _alignment_width - _line_width;         break;
                }
                
                if (_xoffset != 0)
                {
                    ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.X, _line_word_end, __SCRIBBLE_PARSER_WORD.X, _xoffset);
                }
                
                _line_grid[# _i, __SCRIBBLE_PARSER_LINE.X      ] = _xoffset;
                _line_grid[# _i, __SCRIBBLE_PARSER_LINE.X_RIGHT] = _xoffset + _line_width;
                
                #endregion
            }
            else
            {
                //Either aligned left or justified
                _line_grid[# _i, __SCRIBBLE_PARSER_LINE.X_RIGHT] = _line_width;
                
                if ((_line_halign == __SCRIBBLE_JUSTIFY) && (_i < _line_count - 1)) //Don't try to justify text on the last line
                {
                    #region Justify
                    
                    var _line_word_count = 1 + _line_word_end - _line_word_start;
                    if (_line_word_count > 1) //Prevent div-by-zero
                    {
                        //Distribute spacing over the line, on which there are n-1 spaces
                        var _spacing_incr = (_alignment_width - _line_width) / (_line_word_count - 1);
                        var _spacing = _spacing_incr;
                        
                        var _j = _line_word_start + 1; //Skip the first word
                        repeat(_line_word_count - 1)
                        {
                            _word_grid[# _j, __SCRIBBLE_PARSER_WORD.X] = floor(_word_grid[# _j, __SCRIBBLE_PARSER_WORD.X] + _spacing);
                            _spacing += _spacing_incr;
                            ++_j;
                        }
                    }
                    
                    #endregion
                }
            }
        }
        
        //Vertically centre words
        var _j = _line_word_start;
        repeat(1 + _line_word_end - _line_word_start)
        {
            _word_grid[# _j, __SCRIBBLE_PARSER_WORD.Y] += (_line_height - _word_grid[# _j, __SCRIBBLE_PARSER_WORD.HEIGHT]) div 2;
            ++_j;
        }
        
        _line_y += _line_height;
        
        ++_i;
    }
    
    _page_data.__glyph_end = _word_grid[# _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.WORD_END], __SCRIBBLE_PARSER_WORD.GLYPH_END];
    
    var _page_char_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
    ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, -_page_char_start);
    _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
    
    height = _line_y;
    
    min_x = ds_grid_get_min(_line_grid, 0, __SCRIBBLE_PARSER_LINE.X,       _line_count - 1, __SCRIBBLE_PARSER_LINE.X      );
    max_x = ds_grid_get_min(_line_grid, 0, __SCRIBBLE_PARSER_LINE.X_RIGHT, _line_count - 1, __SCRIBBLE_PARSER_LINE.X_RIGHT);
}