#macro __SCRIBBLE_GEN_WORD_START  _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__GLYPH_START] = _word_glyph_start;\
                                  _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI_RAW   ] = _word_bidi;\
                                  _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI       ] = ((_word_bidi == __SCRIBBLE_BIDI.ISOLATED) || (_word_bidi == __SCRIBBLE_BIDI.ISOLATED_CJK))? __SCRIBBLE_BIDI.L2R : _word_bidi; //CJK isolated characters are written L2R


#macro __SCRIBBLE_GEN_WORD_END  _word_glyph_end = _i-1;\
                                ;\
                                if (_word_bidi == __SCRIBBLE_BIDI.R2L_ARABIC)\ //Arabic groups visually glyphs together into words
                                {\
                                    ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__X, abs(_word_width));\
                                    ds_grid_set_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _word_glyph_start);\
                                    ;\//For the purposes for further text layout, force this bidi to generic R2L
                                    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI] = __SCRIBBLE_BIDI.R2L;\
                                }\
                                else\
                                {\
                                    if (_word_bidi == __SCRIBBLE_BIDI.L2R_DEVANAGARI)\
                                    {\
                                        ds_grid_set_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _word_glyph_start);\
                                    }\
                                    ;\
                                    if (_word_bidi == __SCRIBBLE_BIDI.R2L)\ //Any R2L languages, apart from Arabic
                                    {\
                                        ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__X, abs(_word_width));\
                                    }\
                                }\
                                ;\
                                _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__GLYPH_END] = _word_glyph_end;\
                                _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__WIDTH    ] = abs(_word_width);\
                                _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__HEIGHT   ] = ds_grid_get_max(_glyph_grid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT, _word_glyph_end, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT);\
                                ;\
                                _word_count++;


#macro __SCRIBBLE_GEN_WORD_NEW  __SCRIBBLE_GEN_WORD_END;\
                                _word_width = 0;\
                                _word_glyph_start = _i;\
                                _word_bidi = _glyph_bidi;\
                                __SCRIBBLE_GEN_WORD_START;


function __scribble_gen_4_build_words()
{
    //Unpack generator state
    //Cache globals locally for a performance boost
    var _glyph_grid = global.__scribble_glyph_grid;
    var _word_grid  = global.__scribble_word_grid;
    
    with(global.__scribble_generator_state)
    {
        var _element       = __element;
        var _glyph_count   = __glyph_count;
        var _overall_bidi  = __overall_bidi;
        var _wrap_per_char = _element.__wrap_per_char; //TODO - Optimize by checking outside the loop
    }
    
    var _word_count            = 0;
    var _word_width            = 0;
    var _word_glyph_start      = 0;
    var _word_glyph_end        = undefined;
    var _word_bidi             = _overall_bidi;
    var _glyph_prev_whitespace = (_word_bidi == __SCRIBBLE_BIDI.WHITESPACE)
    
    if (_glyph_count > 0)
    {
        var _word_bidi = _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__BIDI];
        
        __SCRIBBLE_GEN_WORD_START;
        
        if (_word_bidi < __SCRIBBLE_BIDI.R2L) //Any L2R text
        {
            _word_width += _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
            _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX] = 0;
        }
        else
        {
            _word_width -= _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
            _glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__X] += _word_width;
        }
        
        var _i = 1;
        repeat(_glyph_count-1) //Ensure we fully handle the last word by including the null terminator in this loop
        {
            var _glyph_bidi = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__BIDI];
            switch(_glyph_bidi)
            {
                case __SCRIBBLE_BIDI.WHITESPACE:
                    if (_wrap_per_char || _glyph_prev_whitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                    else
                    {
                        _glyph_prev_whitespace = true;
                        
                        if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH || ((_word_bidi != _overall_bidi) && (_glyph_bidi != _word_bidi)))
                        {
                            __SCRIBBLE_GEN_WORD_NEW;
                        }
                    }
                break;
                
                case __SCRIBBLE_BIDI.SYMBOL:
                    // If we find a glyph with a neutral direction and the current word isn't whitespace, inherit the word's direction
                    if ((_word_bidi != __SCRIBBLE_BIDI.WHITESPACE) && (_word_bidi != __SCRIBBLE_BIDI.ISOLATED))
                    {
                        _glyph_bidi = _word_bidi;
                    }
                    else if (_glyph_prev_whitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                        _glyph_prev_whitespace = false;
                    }
                    else if (_glyph_bidi != _word_bidi)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                break;
                
                case __SCRIBBLE_BIDI.ISOLATED:
                    __SCRIBBLE_GEN_WORD_NEW;
                    _glyph_prev_whitespace = false;
                break;
                
                case __SCRIBBLE_BIDI.ISOLATED_CJK:
                    if (_glyph_prev_whitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                        _glyph_prev_whitespace = false;
                    }
                    else if (_word_bidi == __SCRIBBLE_BIDI.SYMBOL) // If the current word has a neutral direction, inherit the direction of the next L2R or R2L glyph
                    {
                        // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
                        _word_bidi = _glyph_bidi;
                        _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI_RAW] = _glyph_bidi;
                        _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI    ] = _glyph_bidi;
                    }
                    else
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                break;
                
                case __SCRIBBLE_BIDI.L2R:
                case __SCRIBBLE_BIDI.L2R_DEVANAGARI:
                case __SCRIBBLE_BIDI.R2L:
                case __SCRIBBLE_BIDI.R2L_ARABIC:
                    if (_glyph_prev_whitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                        
                        _glyph_prev_whitespace = false;
                    }
                    else if (_word_bidi == __SCRIBBLE_BIDI.SYMBOL) // If the current word has a neutral direction, inherit the direction of the next L2R or R2L glyph
                    {
                        // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
                        _word_bidi = _glyph_bidi;
                        _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI_RAW] = _glyph_bidi;
                        _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI    ] = _glyph_bidi;
                        
                        //Fix symbol positioning when transitioning to R2L text
                        if (_word_bidi >= __SCRIBBLE_BIDI.R2L)
                        {
                            _word_width = 0;
                            var _j = _word_glyph_start;
                            repeat(_i - _j)
                            {
                                _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__X] += _word_width;
                                _word_width -= _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
                                _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__X] += _word_width;
                                ++_j;
                            }
                        }
                    }
                    else if (_wrap_per_char || (_glyph_bidi != _word_bidi))
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                break;
            }
            
            if (_word_bidi < __SCRIBBLE_BIDI.R2L) //Any non-R2L text is laid out left-to-right
            {
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__X] += _word_width;
                _word_width += _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX] = _i;
            }
            else // __SCRIBBLE_BIDI.R2L or __SCRIBBLE_BIDI.R2L_ARABIC
            {
                _word_width -= _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__SEPARATION];
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__X] += _word_width;
                
                //Arabic groups visually glyphs together into words. Other R2L doesn't so we can assign animation indexes here
                if (_word_bidi == __SCRIBBLE_BIDI.R2L) _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX] = _i;
            }
            
            ++_i;
        }
        
        __SCRIBBLE_GEN_WORD_END;
    }
    
    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__GLYPH_START] = _word_glyph_end+1;
    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__GLYPH_END  ] = _word_glyph_end+1;
    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__WIDTH      ] = 0;
    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__HEIGHT     ] = 0;
    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI_RAW   ] = __SCRIBBLE_BIDI.SYMBOL;
    _word_grid[# _word_count, __SCRIBBLE_GEN_WORD.__BIDI       ] = __SCRIBBLE_BIDI.SYMBOL;
    
    with(global.__scribble_generator_state)
    {
        __word_count = _word_count;
    }
}
