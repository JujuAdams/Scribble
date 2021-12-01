#macro __SCRIBBLE_GEN_WORD_START  _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;\
                                  _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ] = _word_bidi;\
                                  _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.BIDI       ] = (_word_bidi == __SCRIBBLE_BIDI.ISOLATED)? __SCRIBBLE_BIDI.L2R : _word_bidi; //CJK isolated characters are written L2R


#macro __SCRIBBLE_GEN_WORD_END  _word_glyph_end = _i-1;\
                                ;\
                                if (_word_bidi == __SCRIBBLE_BIDI.R2L)\
                                {\
                                    ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, abs(_word_width));\
                                    ds_grid_set_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, _word_glyph_start);\
                                }\
                                ;\
                                _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_END] = _word_glyph_end;\
                                _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.WIDTH    ] = abs(_word_width);\
                                _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.HEIGHT   ] = ds_grid_get_max(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.FONT_HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.FONT_HEIGHT);\
                                ;\
                                _word_count++;


function __scribble_gen_5_build_words()
{
    //Unpack generator state
    //Cache globals locally for a performance boost
    var _glyph_grid = global.__scribble_glyph_grid;
    var _word_grid  = global.__scribble_word_grid;
    
    with(global.__scribble_generator_state)
    {
        var _element       = element;
        var _glyph_count   = glyph_count;
        var _overall_bidi  = overall_bidi;
        var _wrap_per_char = _element.wrap_per_char;
    }
    
    var _word_count            = 0;
    var _word_width            = 0;
    var _word_glyph_start      = 0;
    var _word_glyph_end        = undefined;
    var _word_bidi             = _overall_bidi;
    var _glyph_prev_whitespace = (_word_bidi == __SCRIBBLE_BIDI.WHITESPACE)
    
    if (_glyph_count > 0)
    {
        var _word_bidi = _glyph_grid[# 0, __SCRIBBLE_PARSER_GLYPH.BIDI];
        
        __SCRIBBLE_GEN_WORD_START;
        
        if (_word_bidi != __SCRIBBLE_BIDI.R2L)
        {
            _word_width += _glyph_grid[# 0, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
            _glyph_grid[# 0, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX] = 0;
        }
        else
        {
            _word_width -= _glyph_grid[# 0, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
            _glyph_grid[# 0, __SCRIBBLE_PARSER_GLYPH.X] += _word_width;
        }
        
        var _i = 1;
        repeat(_glyph_count) //Ensure we fully handle the last word by including the null terminator in this loop
        {
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
                    if (_word_bidi != __SCRIBBLE_BIDI.WHITESPACE)
                    {
                        _glyph_bidi = _word_bidi;
                    }
                    
                    // If the current word has a neutral direction, try to inherit the direction of the next L2R or R2L glyph
                    if ((_glyph_bidi == __SCRIBBLE_BIDI.L2R) || (_glyph_bidi == __SCRIBBLE_BIDI.R2L))
                    {
                        // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
                        _word_bidi = _glyph_bidi;
                        _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.BIDI_RAW] = _glyph_bidi;
                        _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.BIDI    ] = _glyph_bidi;
                    }
                break;
                
                case __SCRIBBLE_BIDI.ISOLATED:
                    _new_word = true;
                break;
            }
            
            if ((_glyph_bidi != _word_bidi) || (_i == _glyph_count)) _new_word = true;
            if ((_glyph_bidi_raw != __SCRIBBLE_BIDI.WHITESPACE) && _glyph_prev_whitespace)
            {
                _new_word = true;
                _glyph_prev_whitespace = false;
            }
            
            if ((_wrap_per_char && (_glyph_bidi_raw != __SCRIBBLE_BIDI.SYMBOL)) || (_glyph_bidi == __SCRIBBLE_BIDI.ISOLATED)) _new_word = true;
            
            // If the glyph we found is a different direction then create a new word for the glyph
            if (_new_word)
            {
                __SCRIBBLE_GEN_WORD_END;
                
                _word_width = 0;
                
                _word_glyph_start = _i;
                _word_bidi        = _glyph_bidi;
                
                __SCRIBBLE_GEN_WORD_START;
            }
            
            if (_word_bidi != __SCRIBBLE_BIDI.R2L)
            {
                _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] += _word_width;
                _word_width += _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
                _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX] = _i;
            }
            else
            {
                _word_width -= _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
                _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] += _word_width;
            }
            
            ++_i;
        }
        
        __SCRIBBLE_GEN_WORD_END;
    }
    
    _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_end;
    _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;
    _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.WIDTH      ] = 0;
    _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.HEIGHT     ] = 0;
    _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ] = _word_bidi;
    _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.BIDI       ] = _word_bidi;
    
    with(global.__scribble_generator_state)
    {
        word_count = _word_count;
    }
}