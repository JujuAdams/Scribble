// Feather disable all
#macro __SCRIBBLE_GEN_WORD_START  _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_GLYPH_START] = _wordGlyphStart;\
                                  _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = _wordBidi;\
                                  _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI       ] = ((_wordBidi == __SCRIBBLE_BIDI_ISOLATED) || (_wordBidi == __SCRIBBLE_BIDI_ISOLATED_CJK))? __SCRIBBLE_BIDI_L2R : _wordBidi; //CJK isolated characters are written L2R


#macro __SCRIBBLE_GEN_WORD_END  _wordGlyphEnd = _i-1;\
                                \
                                if (_wordBidi == __SCRIBBLE_BIDI_R2L_ARABIC)\ //Arabic visually groups glyphs together into words
                                {\
                                    ds_grid_add_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_X, _wordGlyphEnd, __SCRIBBLE_GEN_GLYPH_X, abs(_wordWidth));\
                                    ds_grid_set_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX, _wordGlyphEnd, _gridRegionWriteMax, _wordGlyphStart);\
                                    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI] = __SCRIBBLE_BIDI_R2L;\ //For the purposes for further text layout, force this bidi to generic R2L
                                }\
                                else if (_wordBidi == __SCRIBBLE_BIDI_L2R_DEVANAGARI)\ //Devanagari also visually groups glyphs together into words
                                {\
                                    ds_grid_set_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX, _wordGlyphEnd, _gridRegionWriteMax, _wordGlyphStart);\
                                }\
                                else\
                                {\
                                    if (_wordReveal)\
                                    {\
                                        ds_grid_set_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _wordGlyphEnd, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _wordGlyphStart);\
                                    }\
                                    \
                                    if (_wordBidi == __SCRIBBLE_BIDI_R2L)\ //Any R2L languages, apart from Arabic
                                    {\
                                        ds_grid_add_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_X, _wordGlyphEnd, __SCRIBBLE_GEN_GLYPH_X, abs(_wordWidth));\
                                    }\
                                }\
                                \
                                _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_GLYPH_END   ] = _wordGlyphEnd;\
                                _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_WIDTH       ] = abs(_wordWidth);\
                                _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_HEIGHT      ] = ds_grid_get_max(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT, _wordGlyphEnd, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT);\
                                \
                                _wordCount++;


#macro __SCRIBBLE_GEN_WORD_NEW  __SCRIBBLE_GEN_WORD_END;\
                                _wordWidth = 0;\
                                _wordGlyphStart = _i;\
                                _wordBidi = _glyphBidi;\
                                __SCRIBBLE_GEN_WORD_START;


function __ScribbleGen4_BuildWords()
{
    //Unpack generator state
    static _generatorState = __ScribbleSystem().__generatorState;
    with(_generatorState)
    {
        var _glyphGrid    = __glyphGrid;
        var _wordGrid     = __wordGrid;
        var _glyphCount   = __glyphCount;
        var _sectionCount = __sectionCount;
        var _overallBidi = __overallBidi;
    }
    
    var _charReveal  = (__typistRevealMode == SCRIBBLE_REVEAL_PER_CHAR) && (_sectionCount <= 0);
    var _wordReveal  = (__typistRevealMode == SCRIBBLE_REVEAL_PER_WORD) && (_sectionCount <= 0);
    var _wrapPerChar = __layoutForcePerChar; //TODO - Optimize by checking outside the loop
    
    var _gridRegionWriteMax = _charReveal? __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX : __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX;
    
    var _wordCount        = 0;
    var _wordWidth        = 0;
    var _wordGlyphStart  = 0;
    var _wordGlyphEnd    = undefined;
    var _wordBidi         = _overallBidi;
    
    var _glyphPrevWhitespace = (_wordBidi == __SCRIBBLE_BIDI_WHITESPACE)
    
    if (_glyphCount > 0)
    {
        var _wordBidi = _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_BIDI];
        
        __SCRIBBLE_GEN_WORD_START;
        
        if (_wordBidi < __SCRIBBLE_BIDI_R2L) //Any L2R text
        {
            _wordWidth += _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_SEPARATION];
            _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX] = 0;
            
            if (_charReveal || _wordReveal)
            {
                _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX] = 0;
            }
        }
        else
        {
            _wordWidth -= _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_SEPARATION];
            _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_X] += _wordWidth;
        }
        
        var _i = 1;
        repeat(_glyphCount-1) //Ensure we fully handle the last word by including the null terminator in this loop
        {
            var _glyphBidi = _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_BIDI];
            switch(_glyphBidi)
            {
                case __SCRIBBLE_BIDI_WHITESPACE:
                    if (_wrapPerChar || _glyphPrevWhitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                    else
                    {
                        _glyphPrevWhitespace = true;
                        
                        if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH || ((_wordBidi != _overallBidi) && (_glyphBidi != _wordBidi)))
                        {
                            __SCRIBBLE_GEN_WORD_NEW;
                        }
                    }
                break;
                
                case __SCRIBBLE_BIDI_SYMBOL:
                    // If we find a glyph with a neutral direction and the current word isn't whitespace, inherit the word's direction
                    if ((_wordBidi != __SCRIBBLE_BIDI_WHITESPACE) && (_wordBidi != __SCRIBBLE_BIDI_ISOLATED))
                    {
                        _glyphBidi = _wordBidi;
                    }
                    else if (_glyphPrevWhitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                        _glyphPrevWhitespace = false;
                    }
                    else if (_glyphBidi != _wordBidi)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                break;
                
                case __SCRIBBLE_BIDI_ISOLATED:
                    __SCRIBBLE_GEN_WORD_NEW;
                    _glyphPrevWhitespace = false;
                break;
                
                case __SCRIBBLE_BIDI_ISOLATED_CJK:
                    if (_glyphPrevWhitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                        _glyphPrevWhitespace = false;
                    }
                    else if (_wordBidi == __SCRIBBLE_BIDI_SYMBOL) // If the current word has a neutral direction, inherit the direction of the next L2R or R2L glyph
                    {
                        // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
                        _wordBidi = _glyphBidi;
                        _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI_RAW] = _glyphBidi;
                        _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI    ] = _glyphBidi;
                    }
                    else
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                break;
                
                case __SCRIBBLE_BIDI_L2R:
                case __SCRIBBLE_BIDI_L2R_DEVANAGARI:
                case __SCRIBBLE_BIDI_R2L:
                case __SCRIBBLE_BIDI_R2L_ARABIC:
                    if (_glyphPrevWhitespace)
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                        
                        _glyphPrevWhitespace = false;
                    }
                    else if (_wordBidi == __SCRIBBLE_BIDI_SYMBOL) // If the current word has a neutral direction, inherit the direction of the next L2R or R2L glyph
                    {
                        // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
                        _wordBidi = _glyphBidi;
                        _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI_RAW] = _glyphBidi;
                        _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI    ] = _glyphBidi;
                        
                        //Fix symbol positioning when transitioning to R2L text
                        if (_wordBidi >= __SCRIBBLE_BIDI_R2L)
                        {
                            _wordWidth = 0;
                            var _j = _wordGlyphStart;
                            repeat(_i - _j)
                            {
                                _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_X] += _wordWidth;
                                _wordWidth -= _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                                _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_X] += _wordWidth;
                                ++_j;
                            }
                        }
                    }
                    else if (_wrapPerChar || (_glyphBidi != _wordBidi))
                    {
                        __SCRIBBLE_GEN_WORD_NEW;
                    }
                break;
            }
            
            if (_wordBidi < __SCRIBBLE_BIDI_R2L) //Any non-R2L text is laid out left-to-right
            {
                _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_X] += _wordWidth;
                _wordWidth += _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                ds_grid_set_region(_glyphGrid, _i, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX, _i, _gridRegionWriteMax, _i);
            }
            else // __SCRIBBLE_BIDI_R2L or __SCRIBBLE_BIDI_R2L_ARABIC
            {
                _wordWidth -= _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_X] += _wordWidth;
                
                //Only Arabic groups visually glyphs together into words. Other R2L (e.g. Hebrew) doesn't so we can assign animation indexes here
                if (_wordBidi == __SCRIBBLE_BIDI_R2L)
                {
                    ds_grid_set_region(_glyphGrid, _i, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX, _i, _gridRegionWriteMax, _i);
                }
            }
            
            ++_i;
        }
        
        __SCRIBBLE_GEN_WORD_END;
    }
    
    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_GLYPH_START] = _wordGlyphEnd+1;
    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _wordGlyphEnd+1;
    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_WIDTH      ] = 0;
    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_HEIGHT     ] = 0;
    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = __SCRIBBLE_BIDI_SYMBOL;
    _wordGrid[# _wordCount, __SCRIBBLE_GEN_WORD_BIDI       ] = __SCRIBBLE_BIDI_SYMBOL;
    
    with(_generatorState)
    {
        __wordCount = _wordCount;
    }
}
