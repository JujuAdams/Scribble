function __scribble_generator_build_words()
{
    //Unpack generator state
    //Cache globals locally for a performance boost
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _control_grid = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    
    var _glyph_bidi_map      = global.__scribble_glyph_data.bidi_map;
    var _glyph_printable_map = global.__scribble_glyph_data.printable_map;
    
    with(global.__scribble_generator_state)
    {
        var _glyph_count = glyph_count;
    }
    
    var _word_index       = -1;
    var _word_glyph_start = 0;
    var _word_glyph_end   = undefined;
    var _word_separation  = undefined;
    var _word_bidi        = undefined;
    var _word_printable   = undefined;
    
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
        
        if (_control_pagebreak)
        {
            __scribble_error("Not yet implemented");
        }
        
        var _glyph_ord       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
        var _glyph_bidi      = _glyph_bidi_map[?      _glyph_ord];
        var _glyph_printable = _glyph_printable_map[? _glyph_ord];
        
        if (_glyph_bidi      == undefined) _glyph_bidi      = __SCRIBBLE_BIDI.L2R;
        if (_glyph_printable == undefined) _glyph_printable = true;
        
        if ((_glyph_ord == 0x0000) || (_glyph_bidi != _word_bidi) || (_glyph_printable != _word_printable))
        {
            if (_word_index >= 0)
            {
                _word_glyph_end = _i-1;
                
                var _word_width = _word_separation - _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.SEPARATION] + _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START]
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ] = _word_width;
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ] = ds_grid_get_max(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.X          ]
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.Y          ]
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.SEPARATION ] = _word_separation;
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ]
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ]
                //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.PRINTABLE  ]
                
                //TODO - Word positioning on lines
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.X   ] = 0;
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.Y   ] = 0;
                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI] = __SCRIBBLE_BIDI.L2R;
                
                if (_glyph_ord == 0x0000) break;
            }
            
            _word_index++;
            
            _word_glyph_start = _i;
            _word_bidi        = _glyph_bidi;
            _word_printable   = _glyph_printable;
            _word_separation  = 0;
            
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.X          ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.Y          ]
            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.SEPARATION ]
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ] = _word_bidi;
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ] = (_word_bidi == __SCRIBBLE_BIDI.NEUTRAL)? undefined : _word_bidi;
            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.PRINTABLE  ] = _word_printable;
        }
        
        _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] = _word_separation;
        _word_separation += _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
        
        ++_i;
    }
    
    with(global.__scribble_generator_state)
    {
        word_count = _word_index + 1;
    }
}