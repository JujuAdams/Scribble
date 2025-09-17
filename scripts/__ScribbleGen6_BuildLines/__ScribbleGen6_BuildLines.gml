// Feather disable all

#macro __SCRIBBLE_LINE_PUSH  if (_trimText && (array_length(_lineArray) >= _maxLineCount))\
                             {\
                                 _breakOnTrim = true;\
                                 \
                                 if (__layoutType == SCRIBBLE_LAYOUT_TRIM_ELLIPSIS)\
                                 {\
                                     _funcTrim(_lineArray, _simulated_model_max_width);\
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
                             _lineStruct = new __ScribbleClassLine(_indent_x, _lineHeight, _line_word_start, _state_halign, _forced_break);\
                             array_push(_lineArray, _lineStruct);\
                             \
                             \ //Adjust the first word's width to account for visual tweaks
                             \ //TODO - Implement for R2L text
                             if ((SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) && (_word_grid[# _line_word_start, __SCRIBBLE_GEN_WORD_BIDI] < __SCRIBBLE_BIDI_R2L))\
                             {\
                                 var _word_glyph_start = _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD_GLYPH_START ];\
                                 var _word_glyph_end   = _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD_GLYPH_END   ];\
                                 var _left_correction  = _glyphGrid[# _word_glyph_start, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET];\
                                 \
                                 if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))\
                                 {\
                                     _word_grid[#  _line_word_start,  __SCRIBBLE_GEN_WORD_WIDTH] += _left_correction;\
                                     _word_width += _left_correction;\
                                 }\
                             }\
                             \
                             _forced_break = false;\ //Reset this value since we presume line wrapping
                             _word_x = _indent_x;


#macro __SCRIBBLE_LINE_POP  _lineStruct.wordEnd = _line_word_end;\
                            _lineStruct.width   = _word_x;

function __ScribbleGen6_BuildLines()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    static _funcTrim = function(_lineArray, _simulated_model_max_width)
    {
        static _generatorState = __ScribbleSystem().__generatorState;
        var _word_grid  = _generatorState.__word_grid;
        var _glyphGrid = _generatorState.__glyphGrid;
        var _controlArray = _generatorState.__controlArray;
        
        var _lineStruct = array_last(_lineArray);
        var _wordStart = _lineStruct.wordStart;
        var _wordEnd   = _lineStruct.wordEnd;
        
        //Find a word that we can glue ellipsis onto ...
        var _right = _lineStruct.width;
        var _word = _wordEnd;
        repeat(1 + _wordEnd - _wordStart)
        {
            var _bidiRaw = _word_grid[# _word, __SCRIBBLE_GEN_WORD_BIDI_RAW];
            if ((_word == _wordStart) || ((_bidiRaw != __SCRIBBLE_BIDI_WHITESPACE) && (_bidiRaw != __SCRIBBLE_BIDI_SYMBOL)))
            {
                //TODO - Optimise
                var _glyphEndIndex        = _word_grid[# _word, __SCRIBBLE_GEN_WORD_GLYPH_END];
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
                if (_right + _glyphEndScale*_ellpsisWidth < _simulated_model_max_width)
                {
                    break;
                }
            }
            
            _right -= _word_grid[# _word, __SCRIBBLE_GEN_WORD_WIDTH];
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
        
        _word_grid[# _newWord, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = __SCRIBBLE_BIDI_SYMBOL;
        _word_grid[# _newWord, __SCRIBBLE_GEN_WORD_BIDI       ] = __SCRIBBLE_BIDI_L2R; //FIXME - Implement for R2l
        _word_grid[# _newWord, __SCRIBBLE_GEN_WORD_GLYPH_START] = _glyphEndIndex+1;
        _word_grid[# _newWord, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _glyphEndIndex+3;
        _word_grid[# _newWord, __SCRIBBLE_GEN_WORD_WIDTH      ] = _ellpsisWidth;
        _word_grid[# _newWord, __SCRIBBLE_GEN_WORD_HEIGHT     ] = _ellpsisHeight;
    }
    
    var _wrapText       = ((__layoutType != SCRIBBLE_LAYOUT_NONE) && (__layoutType != SCRIBBLE_LAYOUT_SCALE));
    var _trimText       = ((__layoutType == SCRIBBLE_LAYOUT_TRIM) || (__layoutType == SCRIBBLE_LAYOUT_TRIM_ELLIPSIS));
    var _fitToBox       = (__layoutType == SCRIBBLE_LAYOUT_FIT);
    var _fitScale       = 1;
    var _layoutMaxScale = __layoutMaxScale;
    
    with(_generatorState)
    {
        var _glyphGrid            = __glyphGrid;
        var _word_grid             = __word_grid;
        var _controlArray          = __controlArray;
        var _temp_grid             = __temp_grid;
        var _glyphCount           = __glyphCount;
        var _word_count            = __word_count;
        var _sectionCount          = __sectionCount;
        var _modelMaxWidth         = (_wrapText? __modelMaxWidth  : infinity);
        var _modelMaxHeight        = (_wrapText? __modelMaxHeight : infinity);
        
        var _lineArray = [];
        __line_array = _lineArray;
    }
    
    var _lineHeight           = __lineHeight;
    var _line_spacing_add      = __lineSpacingAdd;
    var _line_spacing_multiply = __lineSpacingMultiply;
    
    var _line_reveal = (__revealType == SCRIBBLE_REVEAL_PER_LINE) && (_sectionCount <= 0);
    
    var _failedFit = false;
    var _forced_break = true; //Start with a forced break because it's the first line!
    var _lastIteration = false;
    var _breakOnTrim = false;
    
    var _fitIterations = 0;
    var _lower_limit = undefined;
    var _upper_limit = undefined;
    repeat(max(1, SCRIBBLE_FIT_TO_BOX_ITERATIONS))
    {
        var _lastIteration = (_fitIterations >= SCRIBBLE_FIT_TO_BOX_ITERATIONS-1);
        
        var _simulated_model_max_width  = _modelMaxWidth  / _fitScale;
        var _simulated_model_max_height = _modelMaxHeight / _fitScale;
        var _maxLineCount = floor((_simulated_model_max_height + _line_spacing_add) / (_lineHeight*_line_spacing_multiply + _line_spacing_add));
        
        if (_word_count > 0)
        {
            var _state_halign  = fa_left;
            var _control_index = 0;
            var _word_x        = 0;
            var _indent_x      = 0;
            
            //Find any horizontal alignment changes
            var _control_delta = _glyphGrid[# 0, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _control_index;
            repeat(_control_delta)
            {
                if (_controlArray[_control_index].__type == __SCRIBBLE_GEN_CONTROL_TYPE_HALIGN)
                {
                    _state_halign = _controlArray[_control_index].__hAlign;
                }
                
                _control_index++;
            }
            
            var _i = 0;
                        
            var _word_width      = 0;
            var _line_word_start = 0;
            
            var _lineStruct = undefined;
            __SCRIBBLE_LINE_PUSH;
            
            repeat(_word_count)
            {
                var _word_width       = _word_grid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ];
                var _word_start_glyph = _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START];
                
                //Find any horizontal alignment changes
                var _control_delta = _glyphGrid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _control_index;
                repeat(_control_delta)
                {
                    var _controlType = _controlArray[_control_index].__type;
                    if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_HALIGN)
                    {
                        _state_halign = _controlArray[_control_index].__hAlign;
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_START)
                    {
                        _indent_x = _word_x;
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_STOP)
                    {
                        _indent_x = 0;
                    }
                    
                    _control_index++;
                }
                
                //Analyse the alignment *after* resolving controls
                //This ensures we don't mark alignments as used if no text is rendered for that alignment
                switch(_state_halign)
                {
                    case fa_left:   _generatorState.__uses_halign_left   = true; break;
                    case fa_center: _generatorState.__uses_halign_center = true; break;
                    case fa_right:  _generatorState.__uses_halign_right  = true; break;
                }
                
                if (_word_x + _word_width > _simulated_model_max_width)
                {
                    __wrapped = true;
                    
                    if (_word_width >= _simulated_model_max_width)
                    {
                        if (_fitToBox && (not _lastIteration))
                        {
                            _failedFit = true;
                            break;
                        }
                        
                        #region Emergency! We're going to have to retroactively implement per-glyph line wrapping
                        
                        if (_word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI] >= __SCRIBBLE_BIDI_R2L)
                        {
                            //TODO - Implement R2L emergency per-glyph line wrapping
                            var _line_word_end = _i;
                            __SCRIBBLE_LINE_POP;
                            _line_word_start = _i+1;
                            __SCRIBBLE_LINE_PUSH;
                        }
                        else
                        {
                            //Back up existing word definitions=
                            var _stashed_word_count = _word_count - (_i+1);
                            ds_grid_set_grid_region(_temp_grid, _word_grid, _i+1, 0, _word_count, __SCRIBBLE_GEN_WORD_SIZE-1, 0, 0);
                            
                            var _original_word_bidi_raw    = _word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW   ];
                            var _original_word_bidi        = _word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI       ];
                            var _original_word_glyph_start = _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START];
                            var _original_word_glyph_end   = _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_END  ];
                            //var _original_word_width       = _word_grid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ]; //Unused
                            var _original_word_height      = _word_grid[# _i, __SCRIBBLE_GEN_WORD_HEIGHT     ];
                            
                            if ((SCRIBBLE_NEWLINES_PAD_LEFT_SPACE || SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) && (_word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI] < __SCRIBBLE_BIDI_R2L))
                            {
                                var _left_correction = _glyphGrid[# _original_word_glyph_start, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET];
                                if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))
                                {
                                    _word_x += _left_correction;
                                }
                            }
                            
                            var _new_word_start_x     = _word_x;
                            var _new_word_glyph_start = _original_word_glyph_start;
                            
                            var _j = _new_word_glyph_start;
                            var _glyph_width = _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                            if ((_word_x + _glyph_width >= _simulated_model_max_width) && (_i > _line_word_start))
                            {
                                var _line_word_end = _i-1;
                                __SCRIBBLE_LINE_POP;
                                _line_word_start = _i;
                                __SCRIBBLE_LINE_PUSH;
                                
                                _new_word_start_x = 0;
                            }
                            
                            _word_x += _glyph_width;
                            ++_j;
                            
                            repeat(1 + _original_word_glyph_end - _j)
                            {
                                var _glyph_width = _glyphGrid[# _j, __SCRIBBLE_GEN_GLYPH_SEPARATION];
                                if (_word_x + _glyph_width >= _simulated_model_max_width)
                                {
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = _original_word_bidi_raw;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI       ] = _original_word_bidi;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START] = _new_word_glyph_start;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _j-1;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ] = _word_x - _new_word_start_x;
                                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_HEIGHT     ] = _original_word_height;
                                    
                                    //Adjust the glyph X position in the new word
                                    ds_grid_add_region(_glyphGrid, _j, __SCRIBBLE_GEN_GLYPH_X, _original_word_glyph_end, __SCRIBBLE_GEN_GLYPH_X, -(_word_x - _new_word_start_x));
                                    
                                    var _line_word_end = _i;
                                    __SCRIBBLE_LINE_POP;
                                    _line_word_start = _i+1;
                                    __SCRIBBLE_LINE_PUSH;
                                    
                                    _new_word_start_x     = 0;
                                    _new_word_glyph_start = _j;
                                    
                                    ++_i; //We've added a new word!
                                    ++_word_count;
                                    
                                    //TODO - We can early out here if the last glyph in the word fits onto a line
                                }
                                
                                _word_x += _glyph_width;
                                ++_j;
                            }
                            
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW   ] = _original_word_bidi_raw;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI       ] = _original_word_bidi;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_START] = _new_word_glyph_start;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD_GLYPH_END  ] = _j-1;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD_WIDTH      ] = _word_x - _new_word_start_x;
                            _word_grid[# _i, __SCRIBBLE_GEN_WORD_HEIGHT     ] = _original_word_height;
                            
                            ds_grid_set_grid_region(_word_grid, _temp_grid, 0, 0, _stashed_word_count, __SCRIBBLE_GEN_WORD_SIZE-1, _i+1, 0);
                            _word_width = 0;
                        }
                        
                        #endregion
                    }
                    else if (SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH && (_word_grid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW] == __SCRIBBLE_BIDI_WHITESPACE))
                    {
                        //If the word at the end of the line is whitespace, include that on this line
                        //We trim the whitespace down to fit on the line later
                        _word_x += _word_width;
                        
                        var _line_word_end = _i;
                        __SCRIBBLE_LINE_POP;
                        _line_word_start = _i+1;
                        __SCRIBBLE_LINE_PUSH;
                        
                        //Ensure we don't carry the space's width over to the new line
                        _word_width = 0;
                    }
                    else
                    {
                        var _line_word_end = _i-1;
                        __SCRIBBLE_LINE_POP;
                        _line_word_start = _i;
                        __SCRIBBLE_LINE_PUSH;
                    }
                }
                else
                {
                    // Check for \n line break characters or nulls (manual page breaks) stored at the start of words
                    var _glyph_start_ord = _glyphGrid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH_UNICODE];
                    if (_glyph_start_ord == SCRIBBLE_UNICODE_NEWLINE) //Newline
                    {
                        //Mark the current line as not needing justification
                        _lineStruct.disableJustify = true;
                        
                        //Linebreak after this word
                        var _line_word_end = _i;
                        __SCRIBBLE_LINE_POP;
                        _line_word_start = _i+1;
                        _forced_break = true; //Gets reset to `false`
                        __SCRIBBLE_LINE_PUSH;
                    }
                    else if (_glyph_start_ord == 0x00) //Null, indicates a new page
                    {
                        //Mark the current line as not needing justification
                        _lineStruct.disableJustify = true;
                        
                        //Pagebreak after this word
                        var _line_word_end = _i;
                        __SCRIBBLE_LINE_POP;
                        _line_word_start = _i+1;
                        _forced_break = true; //Gets reset to `false`
                        __SCRIBBLE_LINE_PUSH;
                        
                        //Only mark the new line as beginning a new page if this null *isn't* the last glyph for the input string
                        if (_i < _word_count-1)
                        {
                            _lineStruct.startsManualPage = true;
                        }
                    }
                }
                
                _word_x += _word_width;
                ++_i;
            }
            
            if (not _breakOnTrim)
            {
                //Finalize the line we've already started
                //Generally speaking this should never actually execute as 0x00 NULL will terminate a line and 0x00 always appears as the final glyph
                var _line_word_end = _i-1;
                if (_line_word_end >= _line_word_start)
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
            var _lower_limit = _fitScale;
        }
        else
        {
            _failedFit = false;
            var _upper_limit = _fitScale;
        }
        
        if (_lastIteration)
        {
            if (_fitScale == _lower_limit) break;
            _fitScale = (_lower_limit == undefined)? _upper_limit : _lower_limit;
        }
        else if (_lower_limit == undefined)
        {
            _fitScale *= 0.5;
        }
        else if (_upper_limit == undefined)
        {
            _fitScale = min(_layoutMaxScale, 2*_fitScale);
        }
        else
        {
            _fitScale = _lower_limit + 0.5*(_upper_limit - _lower_limit);
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
                var _line_glyph_start = _word_grid[# __wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
                var _line_glyph_end   = _word_grid[# __wordEnd,   __SCRIBBLE_GEN_WORD_GLYPH_END  ];
                ds_grid_set_region(_glyphGrid, _line_glyph_start, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _line_glyph_end, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _i+1);
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
            
            if (_word_grid[# _lineWordStart, __SCRIBBLE_GEN_WORD_BIDI] < __SCRIBBLE_BIDI_R2L)
            {
                var _word_glyph_start = _word_grid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_GLYPH_START ];
                var _word_glyph_end   = _word_grid[#  _lineWordStart,  __SCRIBBLE_GEN_WORD_GLYPH_END   ];
                var _left_correction  = _glyphGrid[# _word_glyph_start, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET];
                
                if (((_left_correction > 0) && SCRIBBLE_NEWLINES_PAD_LEFT_SPACE) || ((_left_correction < 0) && SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE))
                {
                    ds_grid_add_region(_glyphGrid, _word_glyph_start, __SCRIBBLE_GEN_GLYPH_X, _word_glyph_end, __SCRIBBLE_GEN_GLYPH_X, _left_correction);
                    _word_grid[# _i, __SCRIBBLE_GEN_WORD_WIDTH] += _left_correction;
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
            
            if (_word_grid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_BIDI_RAW] == __SCRIBBLE_BIDI_WHITESPACE) //Only adjust whitespace words
            {
                var _line_width = _lineStruct.width;
                if (_line_width > _simulated_model_max_width) //Only adjust lines that actually exceed the maximum size
                {
                    var _delta = _simulated_model_max_width - _line_width;
                    
                    _lineStruct.width = _simulated_model_max_width;
                    _word_grid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_WIDTH] += _delta;
                    
                    var _word_start_glyph = _word_grid[# _lineWordEnd, __SCRIBBLE_GEN_WORD_GLYPH_START];
                    _glyphGrid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH_WIDTH     ] += _delta;
                    _glyphGrid[# _word_start_glyph, __SCRIBBLE_GEN_GLYPH_SEPARATION] += _delta;
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
            var _line_end_glyph      = _word_grid[# _lineArray[_i].wordEnd, __SCRIBBLE_GEN_WORD_GLYPH_END];
            var _lineEndControlCount = _glyphGrid[# _line_end_glyph, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT];
            
            array_insert(_controlArray, _lineEndControlCount+1, new __ScribbleClassControlEvent(__SCRIBBLE_DELAY_COMMAND_TAG, [__newlineDelay]));
            
            var _line_start_glyph = _word_grid[# _lineArray[_i+1].wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
            ds_grid_add_region(_glyphGrid, _line_start_glyph, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT, _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT, 1);
            
            ++_i;
        }
    }
    
    with(_generatorState)
    {
        __word_count = _word_count;
        __lineCount = array_length(_lineArray);
    }
}


