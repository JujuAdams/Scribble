function __scribble_generator_build_words()
{
    //Unpack generator state
    //Cache globals locally for a performance boost
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _control_grid = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    
    with(global.__scribble_generator_state)
    {
        var _glyph_count  = glyph_count;
        var _overall_bidi = overall_bidi;
    }
    
    var _word_index            = -1;
    var _word_glyph_start      = 0;
    var _word_glyph_end        = undefined;
    var _word_width            = undefined;
    var _word_bidi             = undefined;
    var _glyph_prev_whitespace = undefined;
    
    //var _control_index     = 0;
    //var _control_pagebreak = false;
    ////We store the next control position as there are typically many more glyphs than controls
    ////This ends up being quite a lot faster than continually reading from the grid
    //var _next_control_pos = _control_grid[# 0, __SCRIBBLE_PARSER_CONTROL.POSITION];
    
    var _i = 0;
    repeat(_glyph_count + 1) //Ensure we fully handle the last word by including the null terminator in this loop
    {
        ////If this glyph index is the same as our control position then scan for new controls to apply
        //while(_i == _next_control_pos)
        //{
        //    //If this control is a horizontal alignment, set the halign value
        //    switch(_control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.TYPE])
        //    {
        //        case __SCRIBBLE_CONTROL_PAGEBREAK:
        //            _control_pagebreak = true;
        //        break;
        //    }
        //    
        //    //Increment which control we're processing
        //    ++_control_index;
        //    _next_control_pos = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.POSITION];
        //    
        //    //Break out of this loop immediately if we've hit a pagebreak
        //    if (_control_pagebreak) break;
        //}
        //
        //if (_control_pagebreak)
        //{
        //    __scribble_error("Not yet implemented");
        //}
        
        var _glyph_bidi_raw = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.BIDI];
        var _glyph_bidi = _glyph_bidi_raw;
        
        var _new_word = false;
        switch(_glyph_bidi)
        {
            case __SCRIBBLE_BIDI.WHITESPACE:
                if ((_word_bidi == undefined) || (_word_bidi == _overall_bidi))
                {
                    _glyph_bidi = _overall_bidi;
                }
                
                _glyph_prev_whitespace = true;
            break;
            
            case __SCRIBBLE_BIDI.SYMBOL:
                // If we find a glyph with a neutral direction and the current word isn't whitespace, inherit the word's direction
                if ((_word_bidi != __SCRIBBLE_BIDI.WHITESPACE) && (_word_bidi != undefined))
                {
                    _glyph_bidi = _word_bidi;
                }
                
                // If the current word has a neutral direction, try to inherit the direction of the next L2R or R2L glyph
                if ((_glyph_bidi == __SCRIBBLE_BIDI.L2R) || (_glyph_bidi == __SCRIBBLE_BIDI.R2L))
                {
                    // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
                    _word_bidi = _glyph_bidi;
                    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW] = _glyph_bidi;
                    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI    ] = _glyph_bidi;
                }
            break;
            
            case __SCRIBBLE_BIDI.LINE_BREAK:
                _new_word = true;
            break;
        }
        
        if ((_glyph_bidi != _word_bidi) || (_i == _glyph_count)) _new_word = true;
        if ((_glyph_bidi_raw != __SCRIBBLE_BIDI.WHITESPACE) && _glyph_prev_whitespace)
        {
            _new_word = true;
            _glyph_prev_whitespace = false;
        }
        
        // If the glyph we found is a different direction then create a new word for the glyph
        if (_new_word)
        {
            if (_word_index >= 0)
            {
                _word_glyph_end = _i-1;
                
                if (_word_bidi == __SCRIBBLE_BIDI.R2L)
                {
                    ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, abs(_word_width));
                }
                
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START]
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ] = abs(_word_width);
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ] = ds_grid_get_max(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ]
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ]
                
                if (_i == _glyph_count) break;
            }
            
            _word_index++;
            
            _word_glyph_start = _i;
            _word_bidi        = _glyph_bidi;
            
            if (_word_bidi != __SCRIBBLE_BIDI.R2L)
            {
                _word_width = 0;
            }
            else
            {
                _word_width = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH];
            }
            
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ]
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ] = _word_bidi;
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ] = _word_bidi;
        }
        
        if (_word_bidi != __SCRIBBLE_BIDI.R2L)
        {
            _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] = _word_width;
            _word_width += _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
            _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX] = _i;
        }
        else
        {
            _word_width -= _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
            _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] = _word_width;
            _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX] = _word_glyph_start;
        }
        
        ++_i;
    }
    
    //Add a null word to help with bidi
    _word_index++;
    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _glyph_count;
    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _glyph_count;
    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ] = 0;
    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ] = 0;
    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ] = __SCRIBBLE_BIDI.SYMBOL;
    _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ] = __SCRIBBLE_BIDI.SYMBOL;
    
    with(global.__scribble_generator_state)
    {
        word_count = _word_index;
    }
}