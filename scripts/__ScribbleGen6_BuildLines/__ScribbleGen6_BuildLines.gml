// Feather disable all

#macro __SCRIBBLE_LINE_PUSH  if (_trimText && (array_length(_lineArray) >= _maxLineCount))\
                             {\
                                 _breakOnTrim = true;\
                                 \
                                 if (__layoutType == SCRIBBLE_LAYOUT_TRIM_ELLIPSIS)\
                                 {\
                                     _funcTrim(_lineArray, _simulatedModelMaxWidth);\
                                 }\
                                 \
                                 break;\
                             }\
                             \
                             if (_fitToBox && (not _lastIteration) && (array_length(_lineArray) >= _maxLineCount))\
                             {\
                                 _failedFit = true;\
                                 break;\
                             }\
                             \
                             _lineStruct = new __ScribbleClassLine(_indentX, _lineHeight, _lineWordStart, _stateHAlign, _forcedBreak);\
                             array_push(_lineArray, _lineStruct);\
                             \
                             \ //Adjust the first word's width to account for visual tweaks
                             \ //TODO - Implement for R2L text
                             if ((SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) && (_wordGrid[# _lineWordStart, __SCRIBBLE_GEN_WORD_BIDI] < __SCRIBBLE_BIDI_R2L))\
                             {\
                                 var _wordGlyphStart = _wordGrid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_GLYPH_START ];\
                                 var _wordGlyphEnd   = _wordGrid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_GLYPH_END   ];\
                                 var _leftCorrection  = _glyphGrid[# _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET];\
                                 \
                                 if (((_leftCorrection > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_leftCorrection < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))\
                                 {\
                                     _wordGrid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_WIDTH] += _leftCorrection;\
                                     _wordWidth += _leftCorrection;\
                                 }\
                             }\
                             \
                             _forcedBreak = false;\ //Reset this value since we presume line wrapping
                             _wordX = _indentX;


#macro __SCRIBBLE_LINE_POP  _lineStruct.wordEnd = _lineWordEnd;\
                            _lineStruct.width   = _wordX;

function __ScribbleGen6_BuildLines()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    static _funcTrim = function(_lineArray, _simulatedModelMaxWidth)
    {
        static _generatorState = __ScribbleSystem().__generatorState;
        var _wordGrid     = _generatorState.__wordGrid;
        var _glyphGrid    = _generatorState.__glyphGrid;
        var _controlArray = _generatorState.__controlArray;
        
        var _lineStruct = array_last(_lineArray);
        var _wordStart = _lineStruct.wordStart;
        var _wordEnd   = _lineStruct.wordEnd;
        
        //Find a word that we can glue ellipsis onto ...
        var _right = _lineStruct.width;
        var _word = _wordEnd;
        repeat(1 + _wordEnd - _wordStart)
        {
            var _bidiRaw = _wordGrid[# _word, __SCRIBBLE_GEN_WORD_BIDI_RAW];
            if ((_word == _wordStart) || ((_bidiRaw != __SCRIBBLE_BIDI_WHITESPACE) && (_bidiRaw != __SCRIBBLE_BIDI_SYMBOL)))
            {
                //TODO - Optimise
                var _glyphEndIndex        = _wordGrid[# _word, __SCRIBBLE_GEN_WORD_GLYPH_END];
                var _glyphEndScale        = _glyphGrid[# _glyphEndIndex, __SCRIBBLE_GEN_GLYPH_SCALE];
                var _glyphEndControlCount = _glyphGrid[# _glyphEndIndex, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT];
                
                var _fontName = undefined;
                var _controlIndex = _glyphEndControlCount-1;
                repeat(_glyphEndControlCount)
                {
                    if (_controlArray[_controlIndex].__type == __SCRIBBLE_GEN_CONTROL_TYPE_FONT)
                    {
                        _fontName = _controlArray[_controlIndex].__fontName;
                        break;
                    }
                    
                    --_controlIndex;
                }
                
                if (_fontName == undefined)
                {
                    __ScribbleError("Could not find font during trim backtracking");
                }
                
                var _fontData          = __ScribbleGetFontData(_fontName);
                var _fontGlyphDataGrid = _fontData.__glyphDataGrid;
                var _fontGlyphsMap     = _fontData.__glyphsMap;
                
                var _dataIndex = _fontGlyphsMap[? ord(".")];
                if (_dataIndex == undefined)
                {
                    __ScribbleTrace("Couldn't find glyph data for character code ", ord("."), " (.) in font \"", _fontName, "\"");
                    return;
                }
                
                var _ellpsisWidth = _glyphEndScale*(2*_fontGlyphDataGrid[# _dataIndex, __SCRIBBLE_GLYPH_PROPR_SEPARATION] + _fontGlyphDataGrid[# _dataIndex, __SCRIBBLE_GLYPH_PROPR_WIDTH]);
                if (_right + _glyphEndScale*_ellpsisWidth < _simulatedModelMaxWidth)
                {
                    break;
                }
            }
            
            _right -= _wordGrid[# _word, __SCRIBBLE_GEN_WORD_WIDTH];
            --_word;
        }
        
        var _glyphIndex = _glyphEndIndex + 1;
        var _glyphRevealIndex = _glyphGrid[# _glyphEndIndex, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX] + 1;
        
        var _x = 0;
        repeat(3)
        {
            ds_grid_set_grid_region(_glyphGrid, _fontGlyphDataGrid, _dataIndex, __SCRIBBLE_GLYPH_PROPR_UNICODE, _dataIndex, __SCRIBBLE_GLYPH_PROPR_V1, _glyphIndex, __SCRIBBLE_GEN_GLYPH_UNICODE);
            
            //Ensure the correct scale
            ds_grid_multiply_region(_glyphGrid, _dataIndex, __SCRIBBLE_GEN_GLYPH_X, _dataIndex, __SCRIBBLE_GEN_GLYPH_SCALE, _glyphEndScale);
            
            //Set the position of the glyph
            _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_X] += _x;
            _x += _fontGlyphDataGrid[# _dataIndex, __SCRIBBLE_GLYPH_PROPR_SEPARATION];
            
            //Make sure we have a sensible control count
            _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _glyphEndControlCount;
            
            //Set our reveal
            _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX] = _glyphRevealIndex;
            ++_glyphRevealIndex; //FIXME - Only works with per-char reveal
            
            ++_glyphIndex;
        }
        
        //Ensure we still have a sensible null terminator
        //FIXME - Do we need to update the final word too? Probably
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = 0x00;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL; //Replaced in the next generator phase
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _glyphEndControlCount; //Make sure we collect controls at the end of a string
        _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX ] = _glyphRevealIndex;
        
        //Create a new word for the ellipsis
        var _ellpsisHeight = _glyphEndScale*(_fontGlyphDataGrid[# _dataIndex, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT]);
        
        var _newWord = _word + 1;
        _lineStruct.wordEnd = _newWord;
        
        _wordGrid[# _newWord, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = __SCRIBBLE_BIDI_SYMBOL;
        _wordGrid[# _newWord, __SCRIBBLE_GEN_WORD_BIDI       ] = __SCRIBBLE_BIDI_L2R; //FIXME - Implement for R2l
        _wordGrid[# _newWord, __SCRIBBLE_GEN_WORD_GLYPH_START] = _glyphEndIndex+1;
        _wordGrid[# _newWord, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _glyphEndIndex+3;
        _wordGrid[# _newWord, __SCRIBBLE_GEN_WORD_WIDTH      ] = _ellpsisWidth;
        _wordGrid[# _newWord, __SCRIBBLE_GEN_WORD_HEIGHT     ] = _ellpsisHeight;
    }
    
    var _wrapText       = ((__layoutType != SCRIBBLE_LAYOUT_NONE) && (__layoutType != SCRIBBLE_LAYOUT_SCALE));
    var _trimText       = ((__layoutType == SCRIBBLE_LAYOUT_TRIM) || (__layoutType == SCRIBBLE_LAYOUT_TRIM_ELLIPSIS));
    var _fitToBox       = (__layoutType == SCRIBBLE_LAYOUT_FIT);
    var _fitScale       = 1;
    var _layoutMaxScale = __layoutMaxScale;
    
    with(_generatorState)
    {
        var _glyphGrid      = __glyphGrid;
        var _wordGrid       = __wordGrid;
        var _controlArray   = __controlArray;
        var _tempGrid       = __tempGrid;
        var _glyphCount     = __glyphCount;
        var _wordCount      = __wordCount;
        var _sectionCount   = __sectionCount;
        var _modelMaxWidth  = (_wrapText? __modelMaxWidth  : infinity);
        var _modelMaxHeight = (_wrapText? __modelMaxHeight : infinity);
        
        var _lineArray = [];
        __lineArray = _lineArray;
    }
    
    var _lineHeight          = __lineHeight;
    var _lineSpacingAdd      = __lineSpacingAdd;
    var _lineSpacingMultiply = __lineSpacingMultiply;
    
    var _line_reveal = (__revealType == SCRIBBLE_REVEAL_PER_LINE) && (_sectionCount <= 0);
    
    var _failedFit = false;
    var _forcedBreak = true; //Start with a forced break because it's the first line!
    var _lastIteration = false;
    var _breakOnTrim = false;
    
    var _fitIterations = 0;
    var _lowerLimit = undefined;
    var _upperLimit = undefined;
    repeat(max(1, SCRIBBLE_FIT_TO_BOX_ITERATIONS))
    {
        var _lastIteration = (_fitIterations >= SCRIBBLE_FIT_TO_BOX_ITERATIONS-1);
        
        var _simulatedModelMaxWidth  = _modelMaxWidth  / _fitScale;
        var _simulatedModelMaxHeight = _modelMaxHeight / _fitScale;
        var _maxLineCount = floor((_simulatedModelMaxHeight + _lineSpacingAdd) / (_lineHeight*_lineSpacingMultiply + _lineSpacingAdd));
        
        if (_wordCount > 0)
        {
            var _stateHAlign  = fa_left;
            var _controlIndex = 0;
            var _wordX       = 0;
            var _indentX     = 0;
            
            //Find any horizontal alignment changes
            var _controlDelta = _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _controlIndex;
            repeat(_controlDelta)
            {
                if (_controlArray[_controlIndex].__type == __SCRIBBLE_GEN_CONTROL_TYPE_HALIGN)
                {
                    _stateHAlign = _controlArray[_controlIndex].__hAlign;
                }
                
                _controlIndex++;
            }
            
            var _i = 0;
                        
            var _wordWidth     = 0;
            var _lineWordStart = 0;
            
            var _lineStruct = undefined;
            __SCRIBBLE_LINE_PUSH;
            
            repeat(_wordCount)
            {
                var _wordWidth      = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ];
                var _wordStartGlyph = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START];
                
                //Find any horizontal alignment changes
                var _controlDelta = _glyphGrid[# _wordStartGlyph, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _controlIndex;
                repeat(_controlDelta)
                {
                    var _controlType = _controlArray[_controlIndex].__type;
                    if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_HALIGN)
                    {
                        _stateHAlign = _controlArray[_controlIndex].__hAlign;
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_START)
                    {
                        _indentX = _wordX;
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_STOP)
                    {
                        _indentX = 0;
                    }
                    
                    _controlIndex++;
                }
                
                //Analyse the alignment *after* resolving controls
                //This ensures we don't mark alignments as used if no text is rendered for that alignment
                switch(_stateHAlign)
                {
                    case fa_left:   _generatorState.__usesHAlignLeft   = true; break;
                    case fa_center: _generatorState.__usesHAlignCenter = true; break;
                    case fa_right:  _generatorState.__usesHAlignRight  = true; break;
                }
                
                if (_wordX + _wordWidth > _simulatedModelMaxWidth)
                {
                    __wrapped = true;
                    
                    if (_wordWidth >= _simulatedModelMaxWidth)
                    {
                        if (_fitToBox && (not _lastIteration))
                        {
                            _failedFit = true;
                            break;
                        }
                        
                        #region Emergency! We're going to have to retroactively implement per-glyph line wrapping
                        
                        if (_wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI] >= __SCRIBBLE_BIDI_R2L)
                        {
                            //TODO - Implement R2L emergency per-glyph line wrapping
                            var _lineWordEnd = _i;
                            __SCRIBBLE_LINE_POP;
                            _lineWordStart = _i+1;
                            __SCRIBBLE_LINE_PUSH;
                        }
                        else
                        {
                            //Back up existing word definitions=
                            var _stashedWordCount = _wordCount - (_i+1);
                            ds_grid_set_grid_region(_tempGrid, _wordGrid, _i+1, 0, _wordCount, __SCRIBBLE_GEN_WORD_SIZE-1, 0, 0);
                            
                            var _originalWordBidiRaw    = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW   ];
                            var _originalWordBidi       = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI       ];
                            var _originalWordGlyphStart = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START];
                            var _originalWordGlyphEnd   = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_END  ];
                            //var _originalWordWidth      = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ]; //Unused
                            var _originalWordHeight     = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_HEIGHT     ];
                            
                            if ((SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) && (_wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI] < __SCRIBBLE_BIDI_R2L))
                            {
                                var _leftCorrection = _glyphGrid[# _originalWordGlyphStart, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET];
                                if (((_leftCorrection > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_leftCorrection < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))
                                {
                                    _wordX += _leftCorrection;
                                }
                            }
                            
                            var _newWordStartX     = _wordX;
                            var _newWordGlyphStart = _originalWordGlyphStart;
                            
                            var _j = _newWordGlyphStart;
                            var _glyphWidth = _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                            if ((_wordX + _glyphWidth >= _simulatedModelMaxWidth) && (_i > _lineWordStart))
                            {
                                var _lineWordEnd = _i-1;
                                __SCRIBBLE_LINE_POP;
                                _lineWordStart = _i;
                                __SCRIBBLE_LINE_PUSH;
                                
                                _newWordStartX = 0;
                            }
                            
                            _wordX += _glyphWidth;
                            ++_j;
                            
                            repeat(1 + _originalWordGlyphEnd - _j)
                            {
                                var _glyphWidth = _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                                if (_wordX + _glyphWidth >= _simulatedModelMaxWidth)
                                {
                                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = _originalWordBidiRaw;
                                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI       ] = _originalWordBidi;
                                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START] = _newWordGlyphStart;
                                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _j-1;
                                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ] = _wordX - _newWordStartX;
                                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_HEIGHT     ] = _originalWordHeight;
                                    
                                    //Adjust the glyph X position in the new word
                                    ds_grid_add_region(_glyphGrid, _j, __SCRIBBLE_GEN_GLYPH_X, _originalWordGlyphEnd, __SCRIBBLE_GEN_GLYPH_X, -(_wordX - _newWordStartX));
                                    
                                    var _lineWordEnd = _i;
                                    __SCRIBBLE_LINE_POP;
                                    _lineWordStart = _i+1;
                                    __SCRIBBLE_LINE_PUSH;
                                    
                                    _newWordStartX     = 0;
                                    _newWordGlyphStart = _j;
                                    
                                    ++_i; //We've added a new word!
                                    ++_wordCount;
                                    
                                    //TODO - We can early out here if the last glyph in the word fits onto a line
                                }
                                
                                _wordX += _glyphWidth;
                                ++_j;
                            }
                            
                            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = _originalWordBidiRaw;
                            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI       ] = _originalWordBidi;
                            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START] = _newWordGlyphStart;
                            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _j-1;
                            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ] = _wordX - _newWordStartX;
                            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_HEIGHT     ] = _originalWordHeight;
                            
                            ds_grid_set_grid_region(_wordGrid, _tempGrid, 0, 0, _stashedWordCount, __SCRIBBLE_GEN_WORD_SIZE-1, _i+1, 0);
                            _wordWidth = 0;
                        }
                        
                        #endregion
                    }
                    else if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && (_wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW] == __SCRIBBLE_BIDI_WHITESPACE))
                    {
                        //If the word at the end of the line is whitespace, include that on this line
                        //We trim the whitespace down to fit on the line later
                        _wordX += _wordWidth;
                        
                        var _lineWordEnd = _i;
                        __SCRIBBLE_LINE_POP;
                        _lineWordStart = _i+1;
                        __SCRIBBLE_LINE_PUSH;
                        
                        //Ensure we don't carry the space's width over to the new line
                        _wordWidth = 0;
                    }
                    else
                    {
                        var _lineWordEnd = _i-1;
                        __SCRIBBLE_LINE_POP;
                        _lineWordStart = _i;
                        __SCRIBBLE_LINE_PUSH;
                    }
                }
                else
                {
                    // Check for \n line break characters or nulls (manual page breaks) stored at the start of words
                    var _glyph_start_ord = _glyphGrid[# _wordStartGlyph, __SCRIBBLE_GEN_GLYPH_UNICODE];
                    if (_glyph_start_ord == SCRIBBLE_UNICODE_NEWLINE) //Newline
                    {
                        //Mark the current line as not needing justification
                        _lineStruct.disableJustify = true;
                        
                        //Linebreak after this word
                        var _lineWordEnd = _i;
                        __SCRIBBLE_LINE_POP;
                        _lineWordStart = _i+1;
                        _forcedBreak = true; //Gets reset to `false`
                        __SCRIBBLE_LINE_PUSH;
                    }
                    else if (_glyph_start_ord == 0x00) //Null, indicates a new page
                    {
                        //Mark the current line as not needing justification
                        _lineStruct.disableJustify = true;
                        
                        //Pagebreak after this word
                        var _lineWordEnd = _i;
                        __SCRIBBLE_LINE_POP;
                        _lineWordStart = _i+1;
                        _forcedBreak = true; //Gets reset to `false`
                        __SCRIBBLE_LINE_PUSH;
                        
                        //Only mark the new line as beginning a new page if this null *isn't* the last glyph for the input string
                        if (_i < _wordCount-1)
                        {
                            _lineStruct.startsManualPage = true;
                        }
                    }
                }
                
                _wordX += _wordWidth;
                ++_i;
            }
            
            if (not _breakOnTrim)
            {
                //Finalize the line we've already started
                //Generally speaking this should never actually execute as 0x00 NULL will terminate a line and 0x00 always appears as the final glyph
                var _lineWordEnd = _i-1;
                if (_lineWordEnd >= _lineWordStart)
                {
                    //Only keep the last line if we actually have glyphs
                    __SCRIBBLE_LINE_POP;
                }
                else
                {
                    //Otherwise forget this line ever happened
                    array_pop(_lineArray);
                }
            }
        }
        
        //If we're not running .fit_to_box() behaviour then escape now!
        if ((not _fitToBox) || _breakOnTrim || (SCRIBBLE_FIT_TO_BOX_ITERATIONS <= 1)) break;
        
        
        
        _fitIterations++;
        
        if (not _failedFit)
        {
            //The text is already small enough to fit (and none of the words have been split in the middle)
            if (_fitScale >= _layoutMaxScale) break;
            var _lowerLimit = _fitScale;
        }
        else
        {
            _failedFit = false;
            var _upperLimit = _fitScale;
        }
        
        if (_lastIteration)
        {
            if (_fitScale == _lowerLimit) break;
            _fitScale = (_lowerLimit == undefined)? _upperLimit : _lowerLimit;
        }
        else if (_lowerLimit == undefined)
        {
            _fitScale *= 0.5;
        }
        else if (_upperLimit == undefined)
        {
            _fitScale = min(_layoutMaxScale, 2*_fitScale);
        }
        else
        {
            _fitScale = _lowerLimit + 0.5*(_upperLimit - _lowerLimit);
        }
    }
    
    __fitScale = _fitScale;
    
    //Mark the final line as not needing justification
    if (array_length(_lineArray) > 0)
    {
        array_last(_lineArray).__disableJustify = true;
    }
    
    if (_line_reveal)
    {
        var _i = 0;
        repeat(array_length(_lineArray))
        {
            with(_lineArray[_i])
            {
                var _lineGlyphStart = _wordGrid[# __wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
                var _lineGlyphEnd   = _wordGrid[# __wordEnd,   __SCRIBBLE_GEN_WORD_GLYPH_END  ];
                ds_grid_set_region(_glyphGrid, _lineGlyphStart, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _lineGlyphEnd, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _i+1);
            }
            
            ++_i;
        }
    }
    
    //Align the left-hand side of the word to the left-hand side of the line. This corrects visually unpleasant gaps and overlaps
    //TODO - Implement for R2L text
    if (SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE)
    {
        var _i = 0;
        repeat(array_length(_lineArray))
        {
            var _lineStruct = _lineArray[_i];
            var _lineWordStart = _lineStruct.wordStart;
            
            if (_wordGrid[# _lineWordStart, __SCRIBBLE_GEN_WORD_BIDI] < __SCRIBBLE_BIDI_R2L)
            {
                var _wordGlyphStart = _wordGrid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_GLYPH_START ];
                var _wordGlyphEnd   = _wordGrid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_GLYPH_END   ];
                var _leftCorrection = _glyphGrid[# _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET];
                
                if (((_leftCorrection > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_leftCorrection < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))
                {
                    ds_grid_add_region(_glyphGrid, _wordGlyphStart, __SCRIBBLE_GEN_GLYPH_X, _wordGlyphEnd, __SCRIBBLE_GEN_GLYPH_X, _leftCorrection);
                    _wordGrid[# _i, __SCRIBBLE_GEN_WORD_WIDTH] += _leftCorrection;
                }
            }
            
            ++_i;
        }
    }
    
    //Trim the whitespace at the end of lines to fit into the desired width
    //This helps the glyph position getter return more visually pleasing results by ensuring the RHS of the glyph doesn't exceed the wrapping width
    if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && _wrapText)
    {
        var _i = 0;
        repeat(array_length(_lineArray))
        {
            var _lineStruct = _lineArray[_i];
            var _lineWordEnd = _lineStruct.wordEnd;
            
            if (_wordGrid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_BIDI_RAW] == __SCRIBBLE_BIDI_WHITESPACE) //Only adjust whitespace words
            {
                var _lineWidth = _lineStruct.width;
                if (_lineWidth > _simulatedModelMaxWidth) //Only adjust lines that actually exceed the maximum size
                {
                    var _delta = _simulatedModelMaxWidth - _lineWidth;
                    
                    _lineStruct.width = _simulatedModelMaxWidth;
                    _wordGrid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_WIDTH] += _delta;
                    
                    var _wordStartGlyph = _wordGrid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_GLYPH_START];
                    _glyphGrid[# _wordStartGlyph, __SCRIBBLE_GEN_GLYPH_WIDTH     ] += _delta;
                    _glyphGrid[# _wordStartGlyph, __SCRIBBLE_GEN_GLYPH_SEPARATION] += _delta;
                }
            }
            
            ++_i;
        }
    }
    
    if (__newlineDelay > 0)
    {
        var _i = 0;
        repeat(array_length(_lineArray)-1)
        {
            var _lineGlyphEnd        = _wordGrid[# _lineArray[_i].wordEnd, __SCRIBBLE_GEN_WORD_GLYPH_END];
            var _lineEndControlCount = _glyphGrid[# _lineGlyphEnd, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT];
            
            array_insert(_controlArray, _lineEndControlCount+1, new __ScribbleClassControlEvent(__SCRIBBLE_DELAY_COMMAND_TAG, [__newlineDelay]));
            
            var _lineGlyphStart = _wordGrid[# _lineArray[_i+1].wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
            ds_grid_add_region(_glyphGrid, _lineGlyphStart, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT, _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT, 1);
            
            ++_i;
        }
    }
    
    with(_generatorState)
    {
        __wordCount = _wordCount;
        __lineCount = array_length(_lineArray);
    }
}


