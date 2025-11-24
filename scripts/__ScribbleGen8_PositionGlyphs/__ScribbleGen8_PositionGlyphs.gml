// Feather disable all

function __ScribbleGen8_PositionGlyphs()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    static _stretchArray = array_create_ext(1000, function()
    {
        return {
            __wordStart: undefined,
            __wordEnd:   undefined,
            __bidi:      undefined,
        };
    });
    
    with(_generatorState)
    {
        var _glyphGrid     = __glyphGrid;
        var _wordGrid      = __wordGrid;
        var _lineArray     = __lineArray;
        var _tempGrid      = __tempGrid;
        var _overallBidi   = __overallBidi;
        var _modelMaxWidth = __modelMaxWidth;
    }
    
    var _squashText = (__layoutType == SCRIBBLE_LAYOUT_SQUASH);
    var _squashMin  = __layoutSquashMin;
    var _squashMax  = __layoutSquashMax;
    var _usingPath  = (__path != undefined);
    
    var _lineHeight = __lineHeight;
    
    ds_grid_clear(_tempGrid, 0); //FIXME - Works around a bug in ds_grid_add_grid_region() (runtime 2.3.7.474  2021-12-03)
    
    var _modelMinX =  infinity;
    var _modelMinY =  infinity;
    var _modelMaxX = -infinity;
    var _modelMaxY = -infinity;
    
    //Now handle each page in turn
    var _i = 0;
    repeat(__pages)
    {
        var _pageData = __pagesArray[_i];
        
        if (SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE)
        {
            var _alignmentWidth    = _pageData.__width;
            var _pinAlignmentWidth = _pageData.__width;
        }
        else
        {
            // If we were given no maximum alignment width, align to the actual width of the model
            var _alignmentWidth    = (_modelMaxWidth == infinity)? __width : _modelMaxWidth;
            var _pinAlignmentWidth = (_modelMaxWidth == infinity)? __width : _modelMaxWidth;
        }
            
        _alignmentWidth    /= __fitScale;
        _pinAlignmentWidth /= __fitScale;
        
        var _pageMinX =  infinity;
        var _pageMaxX = -infinity; 
        
        var _pageStartLine = _pageData.__lineStart;
        var _pageEndLine   = _pageData.__lineEnd;
        
        var _j = _pageStartLine;
        repeat(1 + _pageEndLine - _pageStartLine)
        {
            with(_lineArray[_j])
            {
                var _lineX              = x;
                var _lineY              = y;
                var _lineWordStart      = wordStart;
                var _lineWordEnd        = wordEnd;
                var _lineWidth          = width;
                var _lineHAlign         = hAlign;
                var _lineDisableJustify = disableJustify;
                
                var _lineGlyphStart = _wordGrid[# _lineWordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
                var _lineGlyphEnd   = _wordGrid[# _lineWordEnd,   __SCRIBBLE_GEN_WORD_GLYPH_END  ];
                var _lineGlyphCount = 1 + _lineGlyphEnd - _lineGlyphStart;
                
                ///////
                // Squash text horizontally
                ///////
                
                if (_squashText && (_lineGlyphCount > 2))
                {
                    var _extraSpace = _alignmentWidth - _lineWidth;
                    
                    var _separationIncr = clamp(_extraSpace / (_lineGlyphCount - 2), _squashMin, _squashMax);
                    if (_separationIncr != 0)
                    {
                        ds_grid_add_region(_glyphGrid, _lineGlyphStart, __SCRIBBLE_GEN_GLYPH_SEPARATION, _lineGlyphEnd, __SCRIBBLE_GEN_GLYPH_SEPARATION, _separationIncr);
                        
                        var _separation = _separationIncr;
                        var _glyph = _lineGlyphStart + 1;
                        
                        repeat(_lineGlyphCount - 2)
                        {
                            _glyphGrid[# _glyph, __SCRIBBLE_GEN_GLYPH_X] += _separation;
                            
                            _separation += _separationIncr;
                            ++_glyph;
                        }
                        
                        _lineWidth += _separation;
                        width = _lineWidth;
                    }
                }
            }
            
            ///////
            // Vertically centre glyphs on the line
            ///////
            
            // _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_Y] = _lineY + (_lineHeight - _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT]) div 2;
            ds_grid_set_grid_region(_tempGrid, _glyphGrid, _lineGlyphStart, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT, _lineGlyphEnd, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT, 0, 0);
            ds_grid_multiply_region(_tempGrid, 0, 0, _lineGlyphCount-1, 0, -0.5);
            ds_grid_add_region(_tempGrid, 0, 0, _lineGlyphCount-1, 0, 0.5*_lineHeight + _lineY);
            ds_grid_add_grid_region(_glyphGrid, _tempGrid, 0, 0, _lineGlyphCount-1, 0, _lineGlyphStart, __SCRIBBLE_GEN_GLYPH_Y);
            
            ///////
            // Figure out what order words should come in
            ///////
            
            // FIXME - Do we need to pre-build stretches? Can't we handle this later?
            var _lineStretchCount = 0;
            var _stretchBidi = _wordGrid[# _lineWordStart, __SCRIBBLE_GEN_WORD_BIDI];
            
            var _stretchWordStart = _lineWordStart;
            var _w = _lineWordStart;
            repeat(1 + _lineWordEnd - _lineWordStart)
            {
                var _wordBidi = _wordGrid[# _w, __SCRIBBLE_GEN_WORD_BIDI];
                if (_wordBidi != _stretchBidi)
                {
                    var _stretchStruct = _stretchArray[_lineStretchCount];
                    _stretchStruct.__wordStart = _stretchWordStart;
                    _stretchStruct.__wordEnd   = _w - 1;
                    _stretchStruct.__bidi      = _stretchBidi;
                    
                    _lineStretchCount++;
                    
                    _stretchWordStart = _w;
                    _stretchBidi = _wordBidi;
                }
            
                ++_w;
            }
            
            if (_w > 0)
            {
                var _stretchStruct = _stretchArray[_lineStretchCount];
                _stretchStruct.__wordStart = _stretchWordStart;
                _stretchStruct.__wordEnd   = _w - 1;
                _stretchStruct.__bidi      = _stretchBidi;
                
                _lineStretchCount++;
            }
            
            ///////
            // Calculate the line x-offset
            ///////
            
            //Force pin alignment when using paths
            if (_usingPath)
            {
                if (_lineHAlign == fa_left)
                {
                    _lineHAlign = __SCRIBBLE_PIN_LEFT;
                }
                else if (_lineHAlign == fa_center)
                {
                    _lineHAlign = __SCRIBBLE_PIN_CENTRE;
                }
                else if (_lineHAlign == fa_right)
                {
                    _lineHAlign = __SCRIBBLE_PIN_RIGHT;
                }
            }
            
            //Text on the last line is never justified
            if ((_lineHAlign == __SCRIBBLE_FA_JUSTIFY) && _lineDisableJustify)
            {
                _lineHAlign = __SCRIBBLE_PIN_LEFT;
            }
            
            //Adjust the size of the last glyph on a line provided it is whitespace
            var _lineAdjustedWidth = _lineWidth;
            if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && (_lineHAlign != fa_left) && (_lineHAlign != __SCRIBBLE_PIN_LEFT))
            {
                if ((_lineWordEnd >= 1)
                && (_wordGrid[# _lineWordEnd,   __SCRIBBLE_GEN_WORD_BIDI_RAW] == __SCRIBBLE_BIDI_WHITESPACE)
                && (_wordGrid[# _lineWordEnd-1, __SCRIBBLE_GEN_WORD_BIDI_RAW] != __SCRIBBLE_BIDI_WHITESPACE))
                {
                    _lineAdjustedWidth -= _wordGrid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_WIDTH];
                    
                    _wordGrid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_WIDTH] = 0;
                    var _wordGlyph = _wordGrid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_GLYPH_START]; //Assume that whitespace words only have one glyph
                    _glyphGrid[# _wordGlyph, __SCRIBBLE_GEN_GLYPH_WIDTH     ] = 0;
                    _glyphGrid[# _wordGlyph, __SCRIBBLE_GEN_GLYPH_SEPARATION] = 0;
                }
            }
            
            var _glyphX = (_overallBidi == __SCRIBBLE_BIDI_R2L)? -_lineX : _lineX;
            var _justificationExtraSpacing = 0;
            
            switch(_lineHAlign)
            {
                case fa_left:   _glyphX += (_overallBidi == __SCRIBBLE_BIDI_R2L)? (_alignmentWidth - _lineAdjustedWidth) : 0; break;
                case fa_center: _glyphX += -(_lineAdjustedWidth div 2);                                                       break;
                case fa_right:  _glyphX += -_lineAdjustedWidth;                                                               break;

                case __SCRIBBLE_PIN_LEFT:   _glyphX += (_overallBidi == __SCRIBBLE_BIDI_R2L)? (_pinAlignmentWidth - _lineAdjustedWidth) : 0; break;
                case __SCRIBBLE_PIN_CENTRE: _glyphX += (_pinAlignmentWidth - _lineAdjustedWidth) div 2;                                      break;
                case __SCRIBBLE_PIN_RIGHT:  _glyphX += _pinAlignmentWidth - _lineAdjustedWidth;                                              break;
                
                case __SCRIBBLE_FA_JUSTIFY:
                    //TODO - Do we need this? We're already determining justification via `_lineDisableJustify`
                    
                    // Don't apply justification on the last line on a page
                    if (_j != _pageEndLine)
                    {
                        var _lineWordCount = 1 + _lineWordEnd - _lineWordStart;
                        if (_lineWordCount > 1) // Prevent div-by-zero
                        {
                            // Distribute spacing over the line, on which there are n-1 spaces
                            var _justificationExtraSpacing = (_pinAlignmentWidth - _lineAdjustedWidth) / (_lineWordCount - 1);
                        }
                    }
                break;
            }
            
            // Figure out the boundaries of the page + model
            var _pageMinX  = min(_pageMinX,  _glyphX                     );
            var _pageMaxX  = max(_pageMaxX,  _glyphX + _lineAdjustedWidth);
            var _modelMinX = min(_modelMinX, _glyphX                     );
            var _modelMaxX = max(_modelMaxX, _glyphX + _lineAdjustedWidth);
            
            if (_overallBidi < __SCRIBBLE_BIDI_R2L)
            {
                // "Normal" L2R text, no stretch reordering required
                var _k = 0;
                var _stretchIncr = 1;
            }
            else
            {
                // R2L text, stretches need to be reversed
                var _k = _lineStretchCount-1;
                var _stretchIncr = -1;
            }
            
            repeat(_lineStretchCount)
            {
                var _stretchStruct = _stretchArray[_k];
                var _stretchWordStart = _stretchStruct.__wordStart;
                var _stretchWordEnd   = _stretchStruct.__wordEnd;
                var _stretchBidi      = _stretchStruct.__bidi;
            
                if (_stretchBidi < __SCRIBBLE_BIDI_R2L)
                {
                    // "Normal" L2R text, no word reordering required
                    var _w = _stretchWordStart;
                    var _wordIncr = 1;
                }
                else
                {
                    // R2L text, words need to be reversed
                    var _w = _stretchWordEnd;
                    var _wordIncr = -1;
                }
                
                repeat(1 + _stretchWordEnd - _stretchWordStart)
                {
                    var _wordGlyphStart = _wordGrid[# _w, __SCRIBBLE_GEN_WORD_GLYPH_START];
                    var _wordGlyphEnd   = _wordGrid[# _w, __SCRIBBLE_GEN_WORD_GLYPH_END  ];
                
                    ds_grid_add_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_X, _wordGlyphEnd, __SCRIBBLE_GEN_GLYPH_X, _glyphX);
                    _glyphX += _wordGrid[# _w, __SCRIBBLE_GEN_WORD_WIDTH] + _justificationExtraSpacing;
                
                    _w += _wordIncr;
                }
            
                _k += _stretchIncr;
            }
            
            ++_j;
        }
        
        
        if (_pageMinX == infinity) _pageMinX = 0;
        _pageData.__minX = _pageMinX;
        _pageData.__maxX = max(_pageMinX, _pageMaxX);
        
        _modelMinY = min(_modelMinY, _pageData.__minY);
        _modelMaxY = max(_modelMaxY, _pageData.__maxY);
        
        ++_i;
    }
    
    if (_modelMinX == infinity) _modelMinX = 0;
    
   __minX = _modelMinX;
   __minY = _modelMinY;
   __maxX = max(_modelMinX, _modelMaxX);
   __maxY = _modelMaxY;
    
    __width  = 1 + __maxX - __minX;
    __height = 1 + __maxY - __minY;
}
