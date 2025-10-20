// Feather disable all

#macro __SCRIBBLE_PARSER_POP_ALIGNMENT_OFFSET  if (_glyphCount > _stateAlignOffsetStart)\
                                               {\
                                                   if (_stateHAlignOffset != 0)\
                                                   {\
                                                       ds_grid_add_region(_glyphGrid, _stateAlignOffsetStart, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_X, _stateHAlignOffset);\
                                                   }\
                                                   if (_stateHAlignOffset != 0)\
                                                   {\
                                                       ds_grid_add_region(_glyphGrid, _stateAlignOffsetStart, __SCRIBBLE_GEN_GLYPH_Y, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, _stateVAlignOffset);\
                                                   }\
                                                   _stateAlignOffsetStart = _glyphCount;\
                                               }

#macro __SCRIBBLE_PARSER_PUSH_SCALE  if (_stateScale != 1)\
                                     {\
                                         __SCRIBBLE_PARSER_POP_ALIGNMENT_OFFSET\
                                         ds_grid_multiply_region(_glyphGrid, _stateScaleStartGlyph, __SCRIBBLE_GEN_GLYPH_X, _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE, _stateScale);\ //Covers x, y, width, height, and separation
                                     }\
                                     _stateScaleStartGlyph = _glyphCount;



#macro __SCRIBBLE_PARSER_NEXT_GLYPH  ++_glyphCount;\
                                     _glyphPrevArabicJoinNext = false;\ //Presume we're not an Arabic joining character
                                     if (SCRIBBLE_ALLOW_LIGATURES) _glyphHistory = (_glyphHistory | _glyphOrd) << 16;\
                                     _glyphPrevPrev = _glyphPrev;\
                                     _glyphPrev = _glyphWrite;



#macro __SCRIBBLE_PARSER_WRITE_GLYPH  \//Pull info out of the font's data structures
                                      var _dataIndex = _fontGlyphsMap[? _glyphWrite];\
                                      \//If our glyph is missing, choose the missing character glyph instead!
                                      if (_dataIndex == undefined)\
                                      {\
                                          __ScribbleTrace("Couldn't find glyph data for character code " + string(_glyphWrite) + " (" + chr(_glyphWrite) + ") in font \"" + string(_fontName) + "\"");\
                                          _glyphWrite = ord(SCRIBBLE_MISSING_CHARACTER);\
                                          _dataIndex = _fontGlyphsMap[? _glyphWrite];\
                                      }\
                                      \
                                      if (_fontDynamic)\
                                      {\
                                          var _slot = _fontGlyphDataGrid[# _dataIndex, __SCRIBBLE_GLYPH_PROPR_DYN_SLOT];\
                                          if (_slot == undefined) _slot = _fontData.__EnsureGlyph(_glyphWrite);\
                                          if (_slot != undefined) _dynamicFontUseGrid[# _slot, 0] = 1;\
                                      }\ 
                                      \
                                      \//Add this glyph to our grid by copying from the font's own glyph data grid
                                      ds_grid_set_grid_region(_glyphGrid, _fontGlyphDataGrid, _dataIndex, __SCRIBBLE_GLYPH_PROPR_UNICODE, _dataIndex, __SCRIBBLE_GLYPH_PROPR_V1, _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE);\
                                      _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;\ //FIXME - Use region function and control pop to make this more efficient
                                      \
                                      if (SCRIBBLE_USE_KERNING)\
                                      {\
                                          var _kerning = _fontKerningMap[? ((_glyphWrite & 0xFFFF) << 16) | (_glyphPrev & 0xFFFF)];\
                                          if (_kerning != undefined)\
                                          {\
                                              _glyphGrid[# _glyphCount-1, __SCRIBBLE_GEN_GLYPH_SEPARATION] += _kerning*_glyphGrid[# _glyphCount-1, __SCRIBBLE_GEN_GLYPH_SCALE];\
                                          }\
                                      }\
                                      \
                                      __SCRIBBLE_PARSER_NEXT_GLYPH

#macro __SCRIBBLE_PARSER_SET_FONT   __SCRIBBLE_PARSER_POP_ALIGNMENT_OFFSET\
                                    \
                                    var _fontData = __ScribbleGetFontData(_fontName);\
                                    _fontData.__EnsureTexelData();\
                                    if (_fontData.__superfont) _fontData.__EnsureAdditionalCharacters();\
                                    if (_fontData.__isKrutidev) __hasDevanagari = true;\
                                    if (_fontData.__dynamic)\
                                    {\
                                        var _dynamicFontUseGrid = _fontUseGridMap[? _fontName];\
                                        if (_dynamicFontUseGrid == undefined)\
                                        {\
                                            _dynamicFontUseGrid =_fontData.__CreateUseGrid();\
                                            array_push(_dynamicFontUseGridArray, {\
                                                __grid: _dynamicFontUseGrid,\
                                                __count: ds_grid_width(_dynamicFontUseGrid),\
                                                __font: _fontData,\
                                            });\
                                        }\
                                        \
                                        draw_set_font(_fontData.__dynFontAsset);\
                                    }\
                                    \
                                    var _fontDynamic           = _fontData.__dynamic;\
                                    var _fontGlyphDataGrid     = _fontData.__glyphDataGrid;\
                                    var _fontGlyphsMap         = _fontData.__glyphsMap;\
                                    var _fontKerningMap        = _fontData.__kerningMap;\
                                    var _fontHAlignOffsetArray = _fontData.__halignOffsetArray;\
                                    var _fontVAlignOffsetArray = _fontData.__valignOffsetArray;\
                                    var _fontLigatureMap       = _fontData.__ligatureMap;\
                                    \
                                    var _stateHAlignOffset = _fontHAlignOffsetArray[_stateHAlign];\
                                    var _stateVAlignOffset = _fontVAlignOffsetArray[__vAlign ?? _startingVAlign];\
                                    \
                                    var _spaceDataIndex = _fontGlyphsMap[? SCRIBBLE_UNICODE_SPACE];\
                                    if (_spaceDataIndex == undefined)\
                                    {\
                                        __ScribbleError("The space character is missing from font definition for \"", _fontName, "\"");\
                                        return false;\
                                    }\
                                    \
                                    var _fontSpaceWidth = _fontGlyphDataGrid[# _spaceDataIndex, __SCRIBBLE_GLYPH_PROPR_SEPARATION];\
                                    var _fontLineHeight = _fontData.__height;\
                                    \
                                    array_push(_controlArray, new __ScribbleClassControlFont(_fontName));\
                                    ++_controlCount;



function __ScribbleGen2_Parser()
{
    #region Hashtable to accelerate command tag lookup
    
    static _commandTagLookupAcceleratorMap = undefined;
    if (_commandTagLookupAcceleratorMap == undefined)
    {
        _commandTagLookupAcceleratorMap = ds_map_create();
        _commandTagLookupAcceleratorMap[? ""                  ] =  0;
        _commandTagLookupAcceleratorMap[? "/"                 ] =  0;
        _commandTagLookupAcceleratorMap[? "/font"             ] =  1;
        _commandTagLookupAcceleratorMap[? "/f"                ] =  1;
        _commandTagLookupAcceleratorMap[? "/colour"           ] =  2;
        _commandTagLookupAcceleratorMap[? "/color"            ] =  2;
        _commandTagLookupAcceleratorMap[? "/c"                ] =  2;
        _commandTagLookupAcceleratorMap[? "/alpha"            ] =  3;
        _commandTagLookupAcceleratorMap[? "/a"                ] =  3;
        _commandTagLookupAcceleratorMap[? "/scale"            ] =  4;
        _commandTagLookupAcceleratorMap[? "/s"                ] =  4;
        //5 is unused
        _commandTagLookupAcceleratorMap[? "/page"             ] =  6;
        _commandTagLookupAcceleratorMap[? "scale"             ] =  7;
        _commandTagLookupAcceleratorMap[? "scaleStack"        ] =  8;
        //9 is unused
        _commandTagLookupAcceleratorMap[? "alpha"             ] = 10;
        _commandTagLookupAcceleratorMap[? "fa_left"           ] = 11;
        _commandTagLookupAcceleratorMap[? "fa_center"         ] = 12;
        _commandTagLookupAcceleratorMap[? "fa_centre"         ] = 12;
        _commandTagLookupAcceleratorMap[? "fa_right"          ] = 13;
        _commandTagLookupAcceleratorMap[? "fa_top"            ] = 14;
        _commandTagLookupAcceleratorMap[? "fa_middle"         ] = 15;
        _commandTagLookupAcceleratorMap[? "fa_bottom"         ] = 16;
        _commandTagLookupAcceleratorMap[? "pin_left"          ] = 17;
        _commandTagLookupAcceleratorMap[? "pin_center"        ] = 18;
        _commandTagLookupAcceleratorMap[? "pin_centre"        ] = 18;
        _commandTagLookupAcceleratorMap[? "pin_right"         ] = 19;
        _commandTagLookupAcceleratorMap[? "fa_justify"        ] = 20;
        _commandTagLookupAcceleratorMap[? "nbsp"              ] = 21;
        _commandTagLookupAcceleratorMap[? "&nbsp"             ] = 21;
        _commandTagLookupAcceleratorMap[? "nbsp;"             ] = 21;
        _commandTagLookupAcceleratorMap[? "&nbsp;"            ] = 21;
        _commandTagLookupAcceleratorMap[? "cycle"             ] = 22;
        _commandTagLookupAcceleratorMap[? "/cycle"            ] = 23;
        _commandTagLookupAcceleratorMap[? "/rainbow"          ] = 23;
        _commandTagLookupAcceleratorMap[? "r"                 ] = 24;
        _commandTagLookupAcceleratorMap[? "/b"                ] = 24;
        _commandTagLookupAcceleratorMap[? "/i"                ] = 24;
        _commandTagLookupAcceleratorMap[? "/bi"               ] = 24;
        _commandTagLookupAcceleratorMap[? "b"                 ] = 25;
        _commandTagLookupAcceleratorMap[? "i"                 ] = 26;
        _commandTagLookupAcceleratorMap[? "bi"                ] = 27;
        _commandTagLookupAcceleratorMap[? "surface"           ] = 28;
        _commandTagLookupAcceleratorMap[? "region"            ] = 29;
        _commandTagLookupAcceleratorMap[? "/region"           ] = 30;
        _commandTagLookupAcceleratorMap[? "zwsp"              ] = 31;
        _commandTagLookupAcceleratorMap[? "typistSound"       ] = 32;
        _commandTagLookupAcceleratorMap[? "typistSoundPerChar"] = 33;
        _commandTagLookupAcceleratorMap[? "r2l"               ] = 34;
        _commandTagLookupAcceleratorMap[? "l2r"               ] = 35;
        _commandTagLookupAcceleratorMap[? "indent"            ] = 36;
        _commandTagLookupAcceleratorMap[? "/indent"           ] = 37;
        _commandTagLookupAcceleratorMap[? "offset"            ] = 38;
        _commandTagLookupAcceleratorMap[? "offsetPop"         ] = 39;
        _commandTagLookupAcceleratorMap[? "texture"           ] = 40;
        _commandTagLookupAcceleratorMap[? "rainbow"           ] = 41;
        _commandTagLookupAcceleratorMap[? "pin_top"           ] = 42;
        _commandTagLookupAcceleratorMap[? "pin_middle"        ] = 43;
        _commandTagLookupAcceleratorMap[? "pin_bottom"        ] = 44;
        _commandTagLookupAcceleratorMap[? "ul"                ] = 45;
        _commandTagLookupAcceleratorMap[? "/ul"               ] = 46;
        _commandTagLookupAcceleratorMap[? "strike"            ] = 47;
        _commandTagLookupAcceleratorMap[? "/strike"           ] = 48;
        _commandTagLookupAcceleratorMap[? "/section"          ] = 49;
    }
    
    #endregion
    
    static _system             = __ScribbleSystem();
    static _cycleDataMap       = _system.__cycleDataMap;
    static _tagDict            = _system.__tagDict;
    static _externalSpriteMap  = _system.__externalSpriteMap;
    static _externalSoundMap   = _system.__externalSoundMap;
    static _stringBuffer       = _system.__bufferA;
    static _otherStringBuffer  = _system.__bufferB;
    static _fontDataMap        = _system.__fontDataMap;
    static _generatorState     = _system.__generatorState;
    static _spriteWhitelistMap = _system.__state.__spriteWhitelistMap;
    
    with(_generatorState)
    {
        var _glyphGrid    = __glyphGrid;
        var _wordGrid     = __wordGrid;
        var _controlArray = __controlArray;
        var _vbuffPosGrid = __vbuffPosGrid;
    }
    
    static _glyphDataStruct = __ScribbleSystem().__glyphData;
    static _globalGlyphBidiMap = _glyphDataStruct.__bidiMap;
    
    static _fontUseGridMap = ds_map_create();
    ds_map_clear(_fontUseGridMap);
    var _dynamicFontUseGridArray = __dynamicFontUseGridArray;
    
    //Cache element properties locally
    var _spritesDontScale = __spritesDontScale;
    var _elementText      = __text;
    var _startingColor    = __startingColor;
    var _starting_halign  = __startingHAlign;
    var _startingVAlign   = __startingVAlign;
    var _ignoreCommands   = __ignoreCommandTags;
    var _preScale         = __preScale;
    
    var _startingFont = __startingFont;
    if (_startingFont == undefined) __ScribbleError("The default font has not been set\nCheck that you've added fonts to Scribble (scribble_font_add() / scribble_font_add_from_sprite() etc.)");
    
    _startingFont = scribble_font_get_remap(_startingFont);
    var _fontName = _startingFont;
    
    //Run the pre-processors
    var _preprocessorArray = __preprocessorArray ?? _system.__defaultPreprocessorFunc;
    if (is_array(_preprocessorArray))
    {
        var _i = 0;
        repeat(array_length(_preprocessorArray))
        {
            var _preprocessorFunc = _preprocessorArray[_i];
            if (is_callable(_preprocessorFunc))
            {
                _elementText = _preprocessorFunc(_elementText);
            }
            ++_i;
        }
    }
    else if (is_callable(_preprocessorArray))
    {
        _elementText = _preprocessorArray(_elementText);
    }
    
    //Place our input string into a buffer for quicker reading
    buffer_seek(_stringBuffer, buffer_seek_start, 0);
    buffer_write(_stringBuffer, buffer_string, _elementText);
    buffer_write(_stringBuffer, buffer_u64, 0x00); //Add some extra null characters to avoid errors where we're reading outside the buffer
    var _bufferLength = buffer_tell(_stringBuffer);
    buffer_seek(_stringBuffer, buffer_seek_start, 0);
    
    //Resize grids if we have to
    var _elementExpectedTextLength = string_length(_elementText) + 2;
    if (ds_grid_width(_glyphGrid   ) < _elementExpectedTextLength) ds_grid_resize(_glyphGrid,    _elementExpectedTextLength, __SCRIBBLE_GEN_GLYPH_SIZE);
    if (ds_grid_width(_wordGrid    ) < _elementExpectedTextLength) ds_grid_resize(_wordGrid,     _elementExpectedTextLength, __SCRIBBLE_GEN_GLYPH_SIZE);
    if (ds_grid_width(_vbuffPosGrid) < _elementExpectedTextLength) ds_grid_resize(_vbuffPosGrid, _elementExpectedTextLength, __SCRIBBLE_GEN_GLYPH_SIZE);
    
    //Start the parser!
    var _tagStart          = undefined;
    var _tagParameterCount = 0;
    var _tagParameters     = [];
    var _tagCommandName    = "";
    var _tagOpenCount      = 0;
    
    var _glyphCount                 = 0;
    var _glyphOrd                   = 0x0000;
    var _glyphHistory               = 0x0000;
    var _glyphPrev                  = 0x0000;
    var _glyphPrevPrev             = 0x0000;
    var _glyphPrevArabicJoinNext = false;
    
    var _controlCount = 0;
    var _skipWrite    = false;
    var _sectionStart = 0;
    var _sectionCount = 0;
    
    var _stateEffectFlags        = 0;
    var _stateColor              = 0xFF000000 | _startingColor; //Uses all four bytes
    var _stateHAlign             = _starting_halign;
    var _stateCommandTagFlipflop = false;
    
    var _stateScale             = _preScale;
    var _stateScaleStartGlyph = 0;
    
    var _stateHAlignOffset     = 0;
    var _stateVAlignOffset     = 0;
    var _stateAlignOffsetStart = 0;
    
    var _offsetDataArray = []; // start glyph, dX, dY
    
    array_push(_controlArray, new __ScribbleClassControlHAlign(_stateHAlign));
    ++_controlCount;
    
    array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
    ++_controlCount;
    
    __SCRIBBLE_PARSER_SET_FONT;
    
    //Keep going until we hit a null
    while(true)
    {
        // In-lined __ScribbleBufferReadUnicode() for speed
        var _glyphOrd  = buffer_read(_stringBuffer, buffer_u8); //Assume 0xxxxxxx
        
        // Break out if we hit a null terminator
        if (_glyphOrd == 0x00) break;
        
        // Only do the following tests if the first byte is large enough (the MSB is 1)
        if ((_glyphOrd & $E0) == $C0) //110xxxxx 10xxxxxx
        {
            _glyphOrd = ((_glyphOrd & $1F) << 6) | (buffer_read(_stringBuffer, buffer_u8) & $3F);
        }
        else if ((_glyphOrd & $F0) == $E0) //1110xxxx 10xxxxxx 10xxxxxx
        {
            var _glyphOrdB = buffer_read(_stringBuffer, buffer_u8);
            var _glyphOrdC = buffer_read(_stringBuffer, buffer_u8);
            _glyphOrd = ((_glyphOrd & $0F) << 12) | ((_glyphOrdB & $3F) <<  6) | (_glyphOrdC & $3F);
        }
        else if ((_glyphOrd & $F8) == $F0) //11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
        {
            var _glyphOrdB = buffer_read(_stringBuffer, buffer_u8);
            var _glyphOrdC = buffer_read(_stringBuffer, buffer_u8);
            var _glyph_ord_d = buffer_read(_stringBuffer, buffer_u8);
            _glyphOrd = ((_glyphOrd & $07) << 18) | ((_glyphOrdB & $3F) << 12) | ((_glyphOrdC & $3F) <<  6) | (_glyph_ord_d & $3F);
        }
        else if (SCRIBBLE_FIX_ESCAPED_NEWLINES)
        {
            // If we haven't needed to process 2/3/4-byte UTF8 glyphs then check for \n replacement (if enabled)
            if ((_glyphOrd == 0x5C) && (buffer_peek(_stringBuffer, buffer_tell(_stringBuffer), buffer_u8) == 0x6E)) //Backslash followed by "n"
            {
                buffer_seek(_stringBuffer, buffer_seek_relative, 1); //Skip the n
                _glyphOrd = SCRIBBLE_UNICODE_NEWLINE;
            }
        }
        
        if (_tagStart != undefined)
        {
            #region Command tag handling
            
            if (_glyphOrd == SCRIBBLE_COMMAND_TAG_CLOSE) //If we've hit a command tag close character (usually ])
            {
                _tagOpenCount--;
                
                if (_tagOpenCount <= 0)
                {
                    //Increment the parameter count and place a null byte for string reading
                    ++_tagParameterCount;
                    buffer_poke(_stringBuffer, buffer_tell(_stringBuffer)-1, buffer_u8, 0);
                    
                    //Jump back to the start of the command tag and read out strings for the command parameters
                    buffer_seek(_stringBuffer, buffer_seek_start, _tagStart);
                    repeat(_tagParameterCount)
                    {
                        array_push(_tagParameters, string_trim(buffer_read(_stringBuffer, buffer_string)));
                    }
                    
                    //Reset command tag state
                    _tagStart = undefined;
                    
                    _tagCommandName = _tagParameters[0];
                    var _newHAlign = undefined;
                    var _newVAlign = undefined;
                    
                    switch(_commandTagLookupAcceleratorMap[? _tagCommandName])
                    {
                        #region Reset formatting
                    
                        // []
                        // [/]
                        case 0:
                            //Resets:
                            //    - colour
                            //    - effect flags (inc. cycle)
                            //    - scale
                            //    - font
                            //But NOT alignment
                            
                            __SCRIBBLE_PARSER_PUSH_SCALE;
                            
                            if (_fontName != _startingFont)
                            {
                                _fontName = _startingFont; //Starting font already remapped
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                            
                            _stateEffectFlags = 0;
                            _stateScale        = _preScale;
                            _stateColor       = 0xFF000000 | _startingColor;
                            
                            array_push(_controlArray, new __ScribbleClassControlEffect(0));
                            ++_controlCount;
                            
                            array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                            ++_controlCount;
                            
                            array_push(_controlArray, new __ScribbleClassControlCycle(-1));
                            ++_controlCount;
                        break;
                    
                        // [/font]
                        // [/f]
                        case 1:
                            if (_fontName != _startingFont)
                            {
                                _fontName = _startingFont; //Starting font already remapped
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                        break;
                    
                        // [/color]
                        // [/colour]
                        // [/c]
                        case 2:
                            _stateColor = (_stateColor & 0xFF000000) | _startingColor;
                            
                            array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                            ++_controlCount;
                        break;
                    
                        // [/alpha]
                        // [/a]
                        case 3:
                            _stateColor = 0xFF000000 | _stateColor;
                            
                            array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                            ++_controlCount;
                        break;
                    
                        // [/scale]
                        // [/s]
                        case 4:
                            __SCRIBBLE_PARSER_PUSH_SCALE;
                            _stateScale = _preScale;
                        break;
                    
                        #endregion
                        
                        // [/page]
                        case 6:
                            //Add a null glyph to our grid
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = 0x00;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_ISOLATED;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                            
                            _glyphWrite = 0x0000;
                            __SCRIBBLE_PARSER_NEXT_GLYPH
                        break;
                        
                        // [ul]
                        case 45:
                            var _underlineThickness = (_tagParameterCount > 1)? real(_tagParameters[1]) : 1;
                            
                            array_push(_controlArray, new __ScribbleClassControlUnderline(_underlineThickness));
                            ++_controlCount;
                        break;
                        
                        // [/ul]
                        case 46:
                            array_push(_controlArray, new __ScribbleClassControlUnderline(0));
                            ++_controlCount;
                        break;
                        
                        // [strike]
                        case 47:
                            var _strikeThickness = (_tagParameterCount > 1)? real(_tagParameters[1]) : 1;
                            
                            array_push(_controlArray, new __ScribbleClassControlStrike(_strikeThickness));
                            ++_controlCount;
                        break;
                        
                        // [/strike]
                        case 48:
                            array_push(_controlArray, new __ScribbleClassControlStrike(0));
                            ++_controlCount;
                        break;
                        
                        #region Scale
                    
                        // [scale]
                        case 7:
                            if (_tagParameterCount <= 1)
                            {
                                __ScribbleTrace("Not enough parameters for [scale] tag!");
                            }
                            else
                            {
                                __SCRIBBLE_PARSER_PUSH_SCALE;
                                _stateScale = _preScale*real(_tagParameters[1]);
                            }
                        break;
                    
                        // [scaleStack]
                        case 8:
                            if (_tagParameterCount <= 1)
                            {
                                __ScribbleTrace("Not enough parameters for [scaleStack] tag!");
                            }
                            else
                            {
                                __SCRIBBLE_PARSER_PUSH_SCALE;
                                _stateScale *= real(_tagParameters[1]);
                            }
                        break;
                    
                        #endregion
                    
                        #region Offset
                    
                        // [offset,dX,dY]
                        case 38:
                            var _offsetDX = (_tagParameterCount > 1)? real(_tagParameters[1]) : 0;
                            var _offsetDY = (_tagParameterCount > 2)? real(_tagParameters[2]) : 0;
                        
                            array_push(_offsetDataArray, _glyphCount, _offsetDX, _offsetDY);
                        break;
                    
                        // [offsetPop]
                        case 39:
                            if ((_glyphCount > 0) && (array_length(_offsetDataArray) >= 3))
                            {
                                var _offsetDY    = array_pop(_offsetDataArray);
                                var _offsetDX    = array_pop(_offsetDataArray);
                                var _offsetStart = array_pop(_offsetDataArray);
                            
                                ds_grid_add_region(_glyphGrid, _offsetStart, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_X, _offsetDX);
                                ds_grid_add_region(_glyphGrid, _offsetStart, __SCRIBBLE_GEN_GLYPH_Y, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, _offsetDY);
                            }
                        break;
                    
                        #endregion
                    
                        // [alpha]
                        case 10:
                            _stateColor = (floor(255*clamp(real(_tagParameters[1]), 0, 1)) << 24) | (_stateColor & 0x00FFFFFF);
                            
                            array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                            ++_controlCount;
                        break;
                    
                        #region Font Alignment
                    
                        // [fa_left]
                        case 11:
                            _newHAlign = fa_left;
                        break;
                    
                        // [fa_center]
                        // [fa_centre]
                        case 12:
                            _newHAlign = fa_center;
                        break;
                    
                        // [fa_right]
                        case 13:
                            _newHAlign = fa_right;
                        break;
                        
                        // [fa_top]
                        case 14:
                            _newVAlign = fa_top;
                        break;
                         
                        // [fa_middle]   
                        case 15:
                            _newVAlign = fa_middle;
                        break;
                        
                        // [fa_bottom]    
                        case 16:
                            _newVAlign = fa_bottom;
                        break;
                        
                        // [pin_left]   
                        case 17:
                            _newHAlign = __SCRIBBLE_PIN_LEFT;
                        break;
                        
                        // [pin_center]
                        // [pin_centre]
                        case 18:
                            _newHAlign = __SCRIBBLE_PIN_CENTRE;
                        break;
                        
                        // [pin_right]
                        case 19:
                            _newHAlign = __SCRIBBLE_PIN_RIGHT;
                        break;
                        
                        // [pin_top]
                        case 42:
                            _newVAlign = __SCRIBBLE_PIN_TOP;
                        break;
                         
                        // [pin_middle]   
                        case 43:
                            _newVAlign = __SCRIBBLE_PIN_MIDDLE;
                        break;
                        
                        // [pin_bottom]    
                        case 44:
                            _newVAlign = __SCRIBBLE_PIN_BOTTOM;
                        break;
                        
                        // [fa_justify]
                        case 20:
                            _newHAlign = __SCRIBBLE_FA_JUSTIFY;
                        break;
                            
                        #endregion
                            
                        #region Non-breaking space emulation
                    
                        // [nbsp]
                        // [&nbsp]
                        // [nbsp]
                        // [&nbsp;]
                        case 21:
                            repeat((array_length(_tagParameters) == 2)? real(_tagParameters[1]) : 1)
                            {
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_NBSP;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = _fontSpaceWidth;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = _fontSpaceWidth;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                                
                                _glyphWrite = SCRIBBLE_UNICODE_NBSP;
                                __SCRIBBLE_PARSER_NEXT_GLYPH
                            }
                        break;
                    
                        #endregion
                    
                        #region Zero-width space emulation
                    
                        // [zwsp]
                        case 31:
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_ZWSP;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_WHITESPACE;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                            
                            _glyphWrite = SCRIBBLE_UNICODE_ZWSP;
                            __SCRIBBLE_PARSER_NEXT_GLYPH
                        break;
                    
                        #endregion
                    
                        // [r2l]
                        case 34:
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_R2L;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_R2L;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                            
                            _glyphWrite = SCRIBBLE_UNICODE_R2L;
                            __SCRIBBLE_PARSER_NEXT_GLYPH
                        break;
                    
                        // [l2r]
                        case 35:
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_L2R;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_L2R;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                            
                            _glyphWrite = SCRIBBLE_UNICODE_L2R;
                            __SCRIBBLE_PARSER_NEXT_GLYPH
                        break;
                    
                        #region Cycle
                    
                        
                        case 22: // [cycle]
                        case 41: // [rainbow]
                            if (_tagCommandName == "rainbow")
                            {
                                var _cycleName  = "rainbow";
                                var _cycleSpeed = (_tagParameterCount > 1)? real(_tagParameters[1]) : SCRIBBLE_DEFAULT_RAINBOW_SPEED;
                                var _cycleFreq  = (_tagParameterCount > 2)? real(_tagParameters[2]) : SCRIBBLE_DEFAULT_RAINBOW_FREQUENCY;
                            }
                            else
                            {
                                if (_tagParameterCount < 2)
                                {
                                    __ScribbleError("Must provide a cycle name");
                                }
                                
                                var _cycleName  = _tagParameters[1];
                                var _cycleSpeed = (_tagParameterCount > 2)? real(_tagParameters[2]) : SCRIBBLE_DEFAULT_CYCLE_SPEED;
                                var _cycleFreq  = (_tagParameterCount > 3)? real(_tagParameters[3]) : SCRIBBLE_DEFAULT_CYCLE_FREQUENCY;
                            }
                            
                            var _cycleData = _cycleDataMap[? _cycleName];
                            if (not is_struct(_cycleData))
                            {
                                __ScribbleError("Cycle \"", _cycleName, "\" not recognised");
                            }
                            
                            _stateEffectFlags = _stateEffectFlags | (1 << __SCRIBBLE_FLAG_CYCLE);
                            
                            array_push(_controlArray, new __ScribbleClassControlEffect(_stateEffectFlags));
                            ++_controlCount;
                            
                            var _ms = game_get_speed(gamespeed_microseconds) / 1000;
                            var _cycleIndex = clamp(_cycleData.__index, 0, 255);
                            var _cycleSpeed = clamp(255*_cycleSpeed/_ms, 1, 255);
                            var _cycleFreq  = clamp(255*_cycleFreq/_ms, 0, 255);
                            
                            array_push(_controlArray, new __ScribbleClassControlCycle(_cycleIndex | (_cycleSpeed << 8) | (_cycleFreq << 16) | 0xFF000000));
                            ++_controlCount;
                            
                            __hasAnimation = true;
                            __hasCycle = true;
                        break;
                        
                        // [/rainbow]
                        // [/cycle]
                        case 23:
                            _stateEffectFlags = ~((~_stateEffectFlags) | (1 << __SCRIBBLE_FLAG_CYCLE));
                            
                            array_push(_controlArray, new __ScribbleClassControlEffect(_stateEffectFlags));
                            ++_controlCount;
                            
                            array_push(_controlArray, new __ScribbleClassControlCycle(-1));
                            ++_controlCount;
                        break;
                            
                        #endregion
                            
                        #region Style shorthands
                    
                        // [r]
                        // [/b]
                        // [/i]
                        // [/bi]
                        case 24:
                            //Get the required font from the font family
                            var _newFont = _fontData.__styleRegular;
                            if (_newFont == undefined)
                            {
                                __ScribbleTrace("Regular style not set for font \"", _fontName, "\"");
                            }
                            else if (not ds_map_exists(_fontDataMap, _newFont))
                            {
                                __ScribbleTrace("Font \"", _fontName, "\" not found (regular style for \"", _fontName, "\")");
                            }
                            else
                            {
                                _fontName = scribble_font_get_remap(_newFont);
                                __SCRIBBLE_PARSER_SET_FONT;
                                __SCRIBBLE_PARSER_PUSH_SCALE;
                            }
                        break;
                    
                        // [b]
                        case 25:
                            //Get the required font from the font family
                            var _newFont = _fontData.__styleBold;
                            if (_newFont == undefined)
                            {
                                __ScribbleTrace("Bold style not set for font \"", _fontName, "\"");
                            }
                            else if (not ds_map_exists(_fontDataMap, _newFont))
                            {
                                __ScribbleTrace("Font \"", _fontName, "\" not found (bold style for \"", _fontName, "\")");
                            }
                            else
                            {
                                _fontName = scribble_font_get_remap(_newFont);
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                        break;
                    
                        // [i]
                        case 26:
                            //Get the required font from the font family
                            var _newFont = _fontData.__styleItalic;
                            if (_newFont == undefined)
                            {
                                __ScribbleTrace("Italic style not set for font \"", _fontName, "\"");
                            }
                            else if (not ds_map_exists(_fontDataMap, _newFont))
                            {
                                __ScribbleTrace("Font \"", _fontName, "\" not found (italic style for \"", _fontName, "\")");
                            }
                            else
                            {
                                _fontName = scribble_font_get_remap(_newFont);
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                        break;
                    
                        // [bi]
                        case 27:
                            //Get the required font from the font family
                            var _newFont = _fontData.__styleBoldItalic;
                            if (_newFont == undefined)
                            {
                                __ScribbleTrace("Bold-Italic style not set for font \"", _fontName, "\"");
                            }
                            else if (not ds_map_exists(_fontDataMap, _newFont))
                            {
                                __ScribbleTrace("Font \"", _fontName, "\" not found (bold-italic style for \"", _fontName, "\")");
                            }
                            else
                            {
                                _fontName = scribble_font_get_remap(_newFont);
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                        break;
                            
                        #endregion
                    
                        #region Surface
                    
                        // [surface]
                        case 28:
                            var _surface = handle_parse(_tagParameters[1]);
                        
                            var _surfaceW = surface_get_width(_surface);
                            var _surfaceH = surface_get_height(_surface);
                        
                            if (SCRIBBLE_SHRINK_INLINE_SURFACES)
                            {
                                var _scale = min(1, _fontLineHeight/_surfaceH);
                                _surfaceW *= _scale;
                                _surfaceH *= _scale;
                            }
                        
                            //Add this glyph to our grid
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = __SCRIBBLE_GLYPH_REPL_SURFACE;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL;
                        
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = _stateHAlignOffset;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = _stateVAlignOffset;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = _surfaceW;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _surfaceH;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _surfaceH;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = _surfaceW;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                        
                            //TODO - Add a way to force a regeneration of every text element that contains a given surface
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_MATERIAL     ] = __ScribbleSurfaceGetMaterial(_surface);
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_U0      ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_V0      ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_U1      ] = 1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_V1      ] = 1;
                        
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                            
                            if (_spritesDontScale && (_stateScale != 1))
                            {
                                ds_grid_multiply_region(_glyphGrid, _glyphCount, __SCRIBBLE_GEN_GLYPH_X, _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE, 1/_stateScale);
                            }
                            
                            _glyphWrite = 0x0000;
                            __SCRIBBLE_PARSER_NEXT_GLYPH
                        break;
                    
                        #endregion
                    
                        #region Regions
                    
                        // [region,]
                        case 29:
                            if (array_length(_tagParameters) != 2) __ScribbleError("[region] tags must contain a name e.g. [region,This is a region]");
                            
                            array_push(_controlArray, new __ScribbleClassControlRegion(_tagParameters[1]));
                            ++_controlCount;
                        break;
                    
                        // [/region]
                        case 30:
                            array_push(_controlArray, new __ScribbleClassControlRegion(undefined));
                            ++_controlCount;
                        break;
                    
                        #endregion
                    
                        #region Typist .sound() and .sound_per_char() equivalents
                    
                        case 32: // [typistSound]
                            if (array_length(_tagParameters) != 5)
                            {
                                __ScribbleError("[typistSound] tags must use the same number of arguments as .sound()");
                            }
                            else
                            {
                                array_push(_controlArray, new __ScribbleClassControlEvent(__SCRIBBLE_EVENT_TYPIST_SOUND, _tagParameters));
                                ++_controlCount;
                            }
                        break;
                    
                        case 33: // [typistSoundPerChar]
                            if ((array_length(_tagParameters) != 4) && (array_length(_tagParameters) != 5))
                            {
                                __ScribbleError("[typistSoundPerChar] tags must use the same number of arguments as .sound_per_char()");
                            }
                            else
                            {
                                array_push(_controlArray, new __ScribbleClassControlEvent(__SCRIBBLE_EVENT_TYPIST_SOUND_PER_CHAR, _tagParameters));
                                ++_controlCount;
                            }
                        break;
                    
                        #endregion
                    
                        #region Indent
                    
                        case 36: // [indent]
                            array_push(_controlArray, new __ScribbleClassControlIdentStart());
                            ++_controlCount;
                        break;
                    
                        case 37: // [/indent]
                            array_push(_controlArray, new __ScribbleClassControlIdentStop());
                            ++_controlCount;
                        break;
                    
                        #endregion
                        
                        case 40: // [texture,<index>,<x>,<y>,<w>,<h>]
                            var _texIndex = real(_tagParameters[1]);
                            var _texX     = real(_tagParameters[2]);
                            var _texY     = real(_tagParameters[3]);
                            var _texW     = real(_tagParameters[4]);
                            var _texH     = real(_tagParameters[5]);
                            
                            var _textureTexelW = texture_get_texel_width(_texIndex);
                            var _textureTexelH = texture_get_texel_height(_texIndex);
                            
                            var _u0 = _texX*_textureTexelW;
                            var _v0 = _texY*_textureTexelH;
                            var _u1 = (_texX + _texW)*_textureTexelW;
                            var _v1 = (_texY + _texH)*_textureTexelH;
                            
                            if (SCRIBBLE_SHRINK_INLINE_TEXTURES)
                            {
                                var _scale = min(1, _fontLineHeight/_texH);
                                _texW *= _scale;
                                _texH *= _scale;
                            }
                            
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = __SCRIBBLE_GLYPH_REPL_TEXTURE;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL;
                            
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = _stateHAlignOffset;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = _stateVAlignOffset;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = _texW;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _texH;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _texH;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = _texW;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                            
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_MATERIAL     ] = __ScribbleTextureGetMaterial(_texIndex);
                            //_glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_U0      ] = 0;
                            //_glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_V0      ] = 0;
                            //_glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_U1      ] = 1;
                            //_glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_V1      ] = 1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_U0      ] = _u0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_U1      ] = _u1;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_V0      ] = _v0;
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_QUAD_V1      ] = _v1;
                            
                            _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                            
                            if (_spritesDontScale && (_stateScale != 1))
                            {
                                ds_grid_multiply_region(_glyphGrid, _glyphCount, __SCRIBBLE_GEN_GLYPH_X, _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE, 1/_stateScale);
                            }
                            
                            _glyphWrite = 0x0000;
                            __SCRIBBLE_PARSER_NEXT_GLYPH
                        break;
                        
                        case 49: // [/section]
                            if (_glyphCount > 0)
                            {
                                ds_grid_set_region(_glyphGrid, _sectionStart, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _sectionCount);
                            }
                            
                            _sectionStart = _glyphCount;
                            _sectionCount++;
                        break;
                        
                        default: //TODO - Optimize
                            if (variable_struct_exists(_tagDict, _tagCommandName))
                            {
                                var _tagStruct = _tagDict[$ _tagCommandName];
                                var _tagType = _tagStruct.__type;
                                var _tagData = _tagStruct.__data;
                                
                                if (_tagType == __SCRIBBLE_TAG_COLOR)
                                {
                                    _stateColor = (_stateColor & 0xFF000000) | (_tagData & 0x00FFFFFF);
                                    
                                    array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                                    ++_controlCount;
                                }
                                else if (_tagType == __SCRIBBLE_TAG_EFFECT)
                                {
                                    _stateEffectFlags = _stateEffectFlags | (1 << _tagData);
                                    
                                    array_push(_controlArray, new __ScribbleClassControlEffect(_stateEffectFlags));
                                    ++_controlCount;
                                    
                                    __hasAnimation = true;
                                }
                                else if (_tagType == __SCRIBBLE_TAG_EFFECT_UNSET)
                                {
                                    _stateEffectFlags = ~((~_stateEffectFlags) | (1 << _tagData));
                                    
                                    array_push(_controlArray, new __ScribbleClassControlEffect(_stateEffectFlags));
                                    ++_controlCount;
                                }
                                else if (_tagType == __SCRIBBLE_TAG_EVENT)
                                {
                                    array_delete(_tagParameters, 0, 1);
                                    
                                    array_push(_controlArray, new __ScribbleClassControlEvent(_tagCommandName, _tagParameters));
                                    ++_controlCount;
                                }
                                else if (_tagType == __SCRIBBLE_TAG_MACRO)
                                {
                                    array_shift(_tagParameters);
                                    var _macro_result = string(method_call(_tagData.__function, _tagParameters));
                                    
                                    if (_tagData.__dynamic)
                                    {
                                        array_push(__dynamicMacroArray, {
                                            __function:   _tagData.__function,
                                            __parameters: _tagParameters,
                                            __result:     _macro_result,
                                        });
                                    }
                                    
                                    //Figure out how much we need to copy and if we need to resize the target buffer
                                    var _copySize = _bufferLength - buffer_tell(_stringBuffer);
                                    
                                    _bufferLength = string_byte_length(_macro_result) + _copySize;
                                    if (_bufferLength > buffer_get_size(_otherStringBuffer)) buffer_resize(_otherStringBuffer, _bufferLength);
                                    
                                    //Write the new string to the other buffer, and then copy the remainder of the data in the old buffer
                                    buffer_seek(_otherStringBuffer, buffer_seek_start, 0);
                                    buffer_write(_otherStringBuffer, buffer_text, _macro_result);
                                    buffer_copy(_stringBuffer, buffer_tell(_stringBuffer), _copySize, _otherStringBuffer, buffer_tell(_otherStringBuffer));
                                    buffer_seek(_otherStringBuffer, buffer_seek_start, 0);
                                    
                                    //Swap the two buffers over
                                    var _temp = _stringBuffer;
                                    _stringBuffer = _otherStringBuffer;
                                    _otherStringBuffer = _temp;
                                }
                            }                        
                            else if (ds_map_exists(_fontDataMap, _tagCommandName)) //Change font
                            {
                                _fontName = scribble_font_get_remap(_tagCommandName);
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                            else
                            {
                                var _spriteIndex = _externalSpriteMap[? _tagCommandName] ?? asset_get_index(_tagCommandName); 
                                if (not sprite_exists(_spriteIndex))
                                {
                                    _spriteIndex = handle_parse(_tagCommandName);
                                }
                                
                                if (sprite_exists(_spriteIndex))
                                {
                                    #region Sprite
                                    
                                    if (sprite_exists(_spriteIndex) && ((not SCRIBBLE_USE_SPRITE_WHITELIST) || (_spriteWhitelistMap[? _spriteIndex] ?? false)))
                                    {
                                        var _sprite_scale = SCRIBBLE_GLOBAL_SPRITE_SCALE;
                                        var _sprite_w = _sprite_scale*sprite_get_width( _spriteIndex);
                                        var _sprite_h = _sprite_scale*sprite_get_height(_spriteIndex);
                                
                                        if (SCRIBBLE_SHRINK_INLINE_SPRITES)
                                        {
                                            var _scale = min(1, _fontLineHeight/_sprite_h);
                                            _sprite_w *= _scale;
                                            _sprite_h *= _scale;
                                            _sprite_scale *= _scale;
                                        }
                                
                                        var _imageIndex = 0;
                                        var _imageSpeed = 0;
                                        switch(_tagParameterCount)
                                        {
                                            case 1:
                                                _imageIndex = 0;
                                                _imageSpeed = SCRIBBLE_DEFAULT_SPRITE_SPEED;
                                            break;
                                                         
                                            case 2:
                                                _imageIndex = real(_tagParameters[1]);
                                                _imageSpeed = 0;
                                            break;
                                                     
                                            default:
                                                _imageIndex = real(_tagParameters[1]);
                                                _imageSpeed = real(_tagParameters[2]);
                                            break;
                                        }
                                        
                                        if (_imageIndex < 0)
                                        {
                                            var _spriteOnce = true;
                                            _imageIndex = 0;
                                            
                                            if (_tagParameterCount == 2)
                                            {
                                                _imageSpeed = SCRIBBLE_DEFAULT_SPRITE_SPEED;
                                            }
                                        }
                                        else
                                        {
                                            var _spriteOnce = false;
                                        }
                                        
                                        //Apply IDE sprite speed
                                        _imageSpeed *= __ScribbleGetImageSpeed(_spriteIndex);
                                
                                        //Only report the model as animated if we're actually able to animate this sprite
                                        if ((_imageSpeed != 0) && (sprite_get_number(_spriteIndex) > 1)) __hasAnimation = true;
                                
                                        //Add this glyph to our grid
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = __SCRIBBLE_GLYPH_REPL_SPRITE;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL;
                                
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = _stateHAlignOffset;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = _stateVAlignOffset;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = _sprite_w;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _sprite_h;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _sprite_h;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = _sprite_w;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = _sprite_scale;
                                
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                                
                                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SPRITE_DATA] = {
                                            __spriteIndex: _spriteIndex,
                                            __imageIndex:  _imageIndex,
                                            __imageSpeed:  _imageSpeed,
                                            __spriteOnce:  _spriteOnce,
                                        };
                                        
                                        if (_spritesDontScale && (_stateScale != 1))
                                        {
                                            ds_grid_multiply_region(_glyphGrid, _glyphCount, __SCRIBBLE_GEN_GLYPH_X, _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE, 1/_stateScale);
                                        }
                                        
                                        _glyphWrite = 0x0000;
                                        __SCRIBBLE_PARSER_NEXT_GLYPH
                                    }
                            
                                    #endregion
                                }
                                else if (asset_get_type(_tagCommandName) == asset_sound)
                                {
                                    array_push(_controlArray, new __ScribbleClassControlEvent(__SCRIBBLE_EVENT_AUDIO, _tagParameters));
                                    ++_controlCount;
                                }
                                else if (ds_map_exists(_externalSoundMap, _tagCommandName))
                                {
                                    //External audio added via scribble_external_sound_add()
                                    
                                    array_push(_controlArray, new __ScribbleClassControlEvent(__SCRIBBLE_EVENT_AUDIO, [_externalSoundMap[? _tagCommandName]]));
                                    ++_controlCount;
                                }
                                else
                                {
                                    var _firstChar = string_copy(_tagCommandName, 1, 1);
                                    if ((string_length(_tagCommandName) <= 7) && ((_firstChar == "$") || (_firstChar == "#")))
                                    {
                                        //Hex colour decoding
                                        //Crafty trick to quickly convert a hex string into a number
                                        try
                                        {
                                            var _decodedColor = real("0x" + string_delete(_tagCommandName, 1, 1));
                                            _decodedColor = __ScribbleRGBToBGR(_decodedColor);
                                        }
                                        catch(_error)
                                        {
                                            __ScribbleTrace(_error);
                                            __ScribbleTrace("Error! \"", string_delete(_tagCommandName, 1, 2), "\" could not be converted into a hexcode");
                                            _decodedColor = _startingColor;
                                        }
                                
                                        _stateColor = (_stateColor & 0xFF000000) | (_decodedColor & 0x00FFFFFF);
                                        
                                        array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                                        ++_controlCount;
                                    }
                                    else
                                    {
                                        var _secondChar = string_copy(_tagCommandName, 2, 1);
                                        if (((_firstChar  == "d") || (_firstChar  == "D"))
                                        &&  ((_secondChar == "$") || (_secondChar == "#")))
                                        {
                                            #region Decimal colour decoding
                                    
                                            try
                                            {
                                                var _decodedColor = real(string_delete(_tagCommandName, 1, 2));
                                            }
                                            catch(_error)
                                            {
                                                __ScribbleTrace(_error);
                                                __ScribbleTrace("Error! \"", string_delete(_tagCommandName, 1, 2), "\" could not be converted into a decimal");
                                                _decodedColor = _startingColor;
                                            }
                                    
                                            _stateColor = (_stateColor & 0xFF000000) | (_decodedColor & 0x00FFFFFF);
                                            
                                            array_push(_controlArray, new __ScribbleClassControlColor(_stateColor));
                                            ++_controlCount;
                                            
                                            #endregion
                                        }
                                        else
                                        {
                                            var _commandString = string(_tagCommandName);
                                            var _j = 1;
                                            repeat(_tagParameterCount-1) _commandString += "," + string(_tagParameters[_j++]);
                                            __ScribbleTrace("Warning! Unrecognised command tag [" + _commandString + "]" );
                                        }
                                    }
                                }
                            }
                        break;
                    }
                
                    //If this command set a new horizontal alignment, and this alignment is different to what we had before, store it as a command
                    if ((_newHAlign != undefined) && (_newHAlign != _stateHAlign))
                    {
                        _stateHAlign = _newHAlign;
                        _newHAlign = undefined;
                        _stateHAlignOffset = _fontHAlignOffsetArray[_stateHAlign];
                    
                        array_push(_controlArray, new __ScribbleClassControlHAlign(_stateHAlign));
                        ++_controlCount;
                    
                        if (_glyphCount > 0)
                        {
                            //Add a newline character if the previous character wasn't also a newline
                            if ((_glyphPrev != 0x00) && (_glyphPrev != SCRIBBLE_UNICODE_NEWLINE))
                            {
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_NEWLINE;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_ISOLATED;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                                
                                _glyphWrite = SCRIBBLE_UNICODE_NEWLINE;
                                __SCRIBBLE_PARSER_NEXT_GLYPH
                            }
                            else
                            {
                                _glyphGrid[# _glyphCount-1, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT]++;
                            }
                        }
                    }
                        
                    //Handle vertical alignment changes
                    if (_newVAlign != undefined)
                    {
                        if (__vAlign == undefined)
                        {
                            __vAlign = _newVAlign;
                        }
                        else if (__vAlign != _newVAlign)
                        {
                            __ScribbleError("In-line vertical alignment cannot be set more than once");
                        }
                    
                        _newVAlign = undefined;
                        _stateVAlignOffset = _fontVAlignOffsetArray[__vAlign];
                    }
                }
            }
            else if (_glyphOrd == SCRIBBLE_COMMAND_TAG_ARGUMENT) //If we've hit a command tag argument delimiter character (usually ,)
            {
                if (_tagOpenCount == 1)
                {
                    //Increment the parameter count and place a null byte for string reading later
                    ++_tagParameterCount;
                    buffer_poke(_stringBuffer, buffer_tell(_stringBuffer)-1, buffer_u8, 0);
                }
            }
            else if (_glyphOrd == SCRIBBLE_COMMAND_TAG_OPEN)
            {
                _tagOpenCount++;
            }
            
            #endregion
        }
        else
        {
            if ((_glyphOrd == SCRIBBLE_COMMAND_TAG_OPEN) && (not _ignoreCommands) && (_stateCommandTagFlipflop || (__ScribbleBufferPeekUnicode(_stringBuffer, buffer_tell(_stringBuffer)) != SCRIBBLE_COMMAND_TAG_OPEN)))
            {
                if (_stateCommandTagFlipflop)
                {
                    _stateCommandTagFlipflop = false;
                }
                else
                {
                    //Begin a command tag
                    _tagStart          = buffer_tell(_stringBuffer);
                    _tagOpenCount      = 1;
                    _tagParameterCount = 0;
                    _tagParameters     = [];
                }
            }
            else if ((_glyphOrd == SCRIBBLE_UNICODE_NEWLINE) //If we've hit a newline (\n)
                 || (SCRIBBLE_HASH_NEWLINE && (_glyphOrd == 0x23))) //If we've hit a hash, and hash newlines are on
            {
                //TODO - Prepare boilerplate version of this glyph in the font for faster copy-pasting
                
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_NEWLINE; //ASCII line break (dec = 10)
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_ISOLATED;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                
                _glyphWrite = SCRIBBLE_UNICODE_NEWLINE;
                __SCRIBBLE_PARSER_NEXT_GLYPH
            }
            else if (_glyphOrd == SCRIBBLE_UNICODE_TAB) //ASCII horizontal tab
            {
                #region Add a tab glyph to our grid
                
                //TODO - Prepare boilerplate version of this glyph in the font for faster copy-pasting
                
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_TAB;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_WHITESPACE;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = SCRIBBLE_TAB_WIDTH*_fontSpaceWidth;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = SCRIBBLE_TAB_WIDTH*_fontSpaceWidth;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                
                _glyphWrite = SCRIBBLE_UNICODE_TAB;
                __SCRIBBLE_PARSER_NEXT_GLYPH
                
                #endregion
            }
            else if (_glyphOrd == SCRIBBLE_UNICODE_SPACE) //ASCII space
            {
                #region Add a space glyph to our grid
                
                //TODO - Prepare boilerplate version of this glyph in the font for faster copy-pasting
                
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_SPACE;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_WHITESPACE;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = _fontSpaceWidth;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = _fontSpaceWidth;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                
                _glyphWrite = SCRIBBLE_UNICODE_SPACE;
                __SCRIBBLE_PARSER_NEXT_GLYPH
                
                #endregion
            }
            else if (_glyphOrd == SCRIBBLE_UNICODE_NBSP)
            {
                #region Add a non-breaking space glyph to our grid
                
                //TODO - Prepare boilerplate version of this glyph in the font for faster copy-pasting
                
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_NBSP;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = _fontSpaceWidth;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = _fontSpaceWidth;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                
                _glyphWrite = SCRIBBLE_UNICODE_NBSP;
                __SCRIBBLE_PARSER_NEXT_GLYPH
                
                #endregion
            }
            else if ((_glyphOrd == SCRIBBLE_UNICODE_ZWSP) || (SCRIBBLE_THAI_GRAVE_ACCENTS_ARE_ZWSP && __hasThai && (_glyphOrd == 0x60))) //Zero-width space, or a Thai grave accent
            {
                #region Add a zero-width space glyph to our grid
                
                //TODO - Prepare boilerplate version of this glyph in the font for faster copy-pasting
                
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = SCRIBBLE_UNICODE_ZWSP;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_WHITESPACE;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = _fontLineHeight;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
                _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                
                _glyphWrite = SCRIBBLE_UNICODE_ZWSP;
                __SCRIBBLE_PARSER_NEXT_GLYPH
                
                #endregion
            }
            else if (SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS && (_glyphOrd == SCRIBBLE_UNICODE_ELLIPSIS))
            {
                //Figure out how much we need to copy and if we need to resize the target buffer
                var _copySize = _bufferLength - buffer_tell(_stringBuffer);
                
                _bufferLength = 3 + _copySize;
                if (_bufferLength > buffer_get_size(_otherStringBuffer)) buffer_resize(_otherStringBuffer, _bufferLength);
                
                //Write the new string to the other buffer, and then copy the remainder of the data in the old buffer
                buffer_seek(_otherStringBuffer, buffer_seek_start, 0);
                buffer_write(_otherStringBuffer, buffer_text, "...");
                buffer_copy(_stringBuffer, buffer_tell(_stringBuffer), _copySize, _otherStringBuffer, 3);
                buffer_seek(_otherStringBuffer, buffer_seek_start, 0);
                
                //Swap the two buffers over
                var _temp = _stringBuffer;
                _stringBuffer = _otherStringBuffer;
                _otherStringBuffer = _temp;
            }
            else if (_glyphOrd > SCRIBBLE_UNICODE_SPACE) //Only write glyphs that aren't system control characters
            {
                if (SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS)
                { 
                    if ((_glyphOrd == SCRIBBLE_UNICODE_EN_DASH)
                    ||  (_glyphOrd == SCRIBBLE_UNICODE_EM_DASH)
                    ||  (_glyphOrd == SCRIBBLE_UNICODE_BAR)) //Horizontal bar ―
                    {
                        //Replace with hyphen -
                        _glyphOrd = SCRIBBLE_UNICODE_HYPHEN;
                    }
                    else if ((_glyphOrd == SCRIBBLE_UNICODE_QUOTE_ST)  //Start single quote ‘
                         ||  (_glyphOrd == SCRIBBLE_UNICODE_QUOTE_END)) //End single quote ’
                    {
                        //Replace with single quote '
                        _glyphOrd = SCRIBBLE_UNICODE_APOSTROPHE;
                    }
                    else if ((_glyphOrd == SCRIBBLE_UNICODE_DQUOTE_ST)
                         ||  (_glyphOrd == SCRIBBLE_UNICODE_DQUOTE_END)
                         ||  (_glyphOrd == SCRIBBLE_UNICODE_DQUOTE_LOW)
                         ||  (_glyphOrd == SCRIBBLE_UNICODE_DQUOTE_HI))
                    {
                        //Replace with double quote "
                        _glyphOrd = SCRIBBLE_UNICODE_DQUOTE;
                    }
                    else if (_glyphOrd == SCRIBBLE_UNICODE_GREEK_QMARK) //Greek question mark ;
                    {
                        //Replace with semicolon
                        _glyphOrd = SCRIBBLE_UNICODE_SEMICOLON;
                    }
                }
                
                #region Add a standard glyph
                
                var _glyphWrite  = _glyphOrd;
                var _glyph_joiner = _glyphOrd;
                
                if (SCRIBBLE_ALLOW_ARABIC && (_glyphWrite >= 0x0600) && (_glyphWrite <= 0x06FF)) // Arabic Unicode block
                {
                    #region Arabic handling
                    
                    //Arabic look-up tables
                    static _arabicJoinNextMap = _glyphDataStruct.__arabicJoinNextMap;
                    static _arabicJoinPrevMap = _glyphDataStruct.__arabicJoinPrevMap;
                    static _arabicIsolatedMap = _glyphDataStruct.__arabicIsolatedMap;
                    static _arabicInitialMap  = _glyphDataStruct.__arabicInitialMap;
                    static _arabicMedialMap   = _glyphDataStruct.__arabicMedialMap;
                    static _arabicFinalMap    = _glyphDataStruct.__arabicFinalMap;
                    
                    __hasArabic = true;
                    
                    var _bufferOffset = buffer_tell(_stringBuffer);
                    var _glyphNext = __ScribbleBufferPeekUnicode(_stringBuffer, _bufferOffset);
                    
                    // Lam with Alef ligatures
                    if (_glyphWrite == 0x0644)
                    {
                        var _glyphReplacement = undefined;
                        switch(_glyphNext)
                        {
                            case 0x0622: var _glyphReplacement = 0xFEF5; break; //Lam with Alef with madda above
                            case 0x0623: var _glyphReplacement = 0xFEF7; break; //Lam with Alef with hamza above
                            case 0x0625: var _glyphReplacement = 0xFEF9; break; //Lam with Alef with madda below
                            case 0x0627: var _glyphReplacement = 0xFEFB; break; //Lam with Alef with hamza below
                        }
                        
                        if (_glyphReplacement != undefined)
                        {
                            _glyphWrite  = _glyphReplacement;
                            _glyph_joiner = _glyphReplacement;
                            
                            // Skip over the next glyph entirely
                            // The size of an Alef, no matter what form, is only 2 bytes
                            buffer_seek(_stringBuffer, buffer_seek_relative, 2);
                            
                            _glyphNext = __ScribbleBufferPeekUnicode(_stringBuffer, _bufferOffset);
                        }
                    }
                    
                    // If the next glyph is tashkil, ignore it for the purposes of determining join state
                    while((_glyphNext >= 0x064B) && (_glyphNext <= 0x0652)) // Tashkil range
                    {
                        _bufferOffset += 2;
                        _glyphNext = __ScribbleBufferPeekUnicode(_stringBuffer, _bufferOffset);
                    }
                    
                    // Figure out what to replace this glyph with, depending on what glyphs around it join in which directions
                    var _newGlyph = undefined;
                    if (_glyphPrevArabicJoinNext) // Does the previous glyph allow joining to us?
                    {
                        if (_arabicJoinPrevMap[? _glyphNext]) // Does the next glyph allow joining to us?
                        {
                            var _newGlyph = _arabicMedialMap[? _glyphWrite];
                        }
                        else
                        {
                            var _newGlyph = _arabicFinalMap[? _glyphWrite];
                        }
                    }
                    else
                    {
                        if (_arabicJoinPrevMap[? _glyphNext]) // Does the next glyph allow joining to us?
                        {
                            var _newGlyph = _arabicInitialMap[? _glyphWrite];
                        }
                        else
                        {
                            var _newGlyph = _arabicIsolatedMap[? _glyphWrite];
                        }
                    }
                    
                    // Update the glyph we're trying to write if we found a replacement
                    if (_newGlyph != undefined) _glyphWrite = _newGlyph;
                    
                    #endregion
                    
                    __SCRIBBLE_PARSER_WRITE_GLYPH
                    
                    //If the glyph in the original source string wasn't tashkil then try to find if we can join to the next character
                    if ((_glyphPrev < 0x064B) || (_glyphPrev > 0x0652))
                    {
                        _glyphPrevArabicJoinNext = _arabicJoinNextMap[? _glyph_joiner] ?? false;
                    }
                    
                    //Adjust height of shadda after lam
                    if ((_glyphPrev == 0x0651)
                    &&  ((_glyphPrevPrev == 0x0644)
                      || (_glyphPrevPrev == 0xFEDD)
                      || (_glyphPrevPrev == 0xFEDE)
                      || (_glyphPrevPrev == 0xFEE0)
                      || (_glyphPrevPrev == 0xFEDF)))
                    {
                        _glyphGrid[# _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y] -= 0.17*_glyphGrid[# _glyphCount-1, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT];
                    }
                }
                else
                {
                    if (SCRIBBLE_ALLOW_DEVANAGARI && (_glyphWrite >= 0x0900) && (_glyphWrite <= 0x097F))
                    {
                        //Devanagari is so complex it gets its own function
                        __hasDevanagari = true;
                        
                        //Create a placeholder glyph entry
                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = _glyphWrite;
                        _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount;
                        
                        __SCRIBBLE_PARSER_NEXT_GLYPH
                    }
                    else
                    {
                        if (SCRIBBLE_ALLOW_THAI && (_glyphWrite >= 0x0E00) && (_glyphWrite <= 0x0E7F))
                        {
                            #region C90 Thai handling
                            
                            //Thai look-up tables
                            static _thaiBaseMap          = _glyphDataStruct.__thaiBaseMap;
                            static _thaiBaseDescenderMap = _glyphDataStruct.__thaiBaseDescenderMap;
                            static _thaiBaseAscenderMap  = _glyphDataStruct.__thaiBaseAscenderMap;
                            static _thaiTopMap           = _glyphDataStruct.__thaiTopMap;
                            static _thaiLowerMap         = _glyphDataStruct.__thaiLowerMap;
                            static _thaiUpperMap         = _glyphDataStruct.__thaiUpperMap;
                            
                            __hasThai = true;
                        
                            if (_thaiTopMap[? _glyphWrite] && (_glyphCount >= 1))
                            {
                                var _base = _glyphPrev;
                                if (_thaiLowerMap[? _base] && (_glyphCount >= 2)) _base = _glyphPrevPrev;
                            
                                if (_thaiBaseMap[? _base])
                                {
                                    _glyphNext = __ScribbleBufferPeekUnicode(_stringBuffer, buffer_tell(_stringBuffer));
                                
                                    var _followingNikhahit = ((_glyphNext == 0x0e33) || (_glyphNext == 0x0e4d));
                                    if (_thaiBaseAscenderMap[? _base])
                                    {
                                        if (_followingNikhahit)
                                        {
                                            _glyphWrite += 0xf713 - 0x0e48;
                                            __SCRIBBLE_PARSER_WRITE_GLYPH;
                                        
                                            _glyphWrite = 0xf711;
                                        
                                            if (_glyphNext == 0x0e33)
                                            {
                                                __SCRIBBLE_PARSER_WRITE_GLYPH;
                                                _glyphWrite = 0x0e32;
                                            }
                                        
                                            //Skip over the next glyph
                                            buffer_seek(_stringBuffer, buffer_seek_relative, 2);
                                        
                                            //Fall through remaining code
                                            _skipWrite = true;
                                        }
                                        else
                                        {
                                            _glyphWrite += 0xf705 - 0x0e48;
                                        
                                            if ((_glyphCount >= 2) && _thaiUpperMap[? _glyphPrev] && _thaiBaseAscenderMap[? _glyphPrev])
                                            {
                                                _glyphWrite += 0xf713 - 0x0e48;
                                            }
                                        }
                                    }
                                    else if (not _followingNikhahit)
                                    {
                                        _glyphWrite += 0xf70a - 0x0e48;
                                    
                                        if ((_glyphCount >= 2) && _thaiUpperMap[? _glyphPrev] && _thaiBaseAscenderMap[? _glyphPrev])
                                        {
                                            _glyphWrite += 0xf713 - 0x0e48;
                                        }
                                    }
                                }
                            }
                            else if (_thaiUpperMap[? _glyphWrite] && (_glyphCount > 0) && _thaiBaseAscenderMap[? _glyphPrev])
                            {
                                switch(_glyphWrite)
                                {
                                    case 0x0e31: _glyphWrite = 0xf710; break;
                                    case 0x0e34: _glyphWrite = 0xf701; break;
                                    case 0x0e35: _glyphWrite = 0xf702; break;
                                    case 0x0e36: _glyphWrite = 0xf703; break;
                                    case 0x0e37: _glyphWrite = 0xf704; break;
                                    case 0x0e4d: _glyphWrite = 0xf711; break;
                                    case 0x0e47: _glyphWrite = 0xf712; break;
                                }
                            }
                            else if (_thaiLowerMap[? _glyphWrite] && (_glyphCount > 0) && _thaiBaseDescenderMap[? _glyphPrev])
                            {
                                _glyphWrite += 0xf718 - 0x0e38;
                            }
                            else
                            {
                                _glyphNext = __ScribbleBufferPeekUnicode(_stringBuffer, buffer_tell(_stringBuffer));
                            
                                if ((_glyphWrite == 0x0e0d) && _thaiLowerMap[? _glyphNext])
                                {
                                    _glyphWrite = 0xf70f;
                                }
                                else if ((_glyphWrite == 0x0e10) && _thaiLowerMap[? _glyphNext])
                                {
                                    _glyphWrite = 0xf700;
                                }
                            }
                        
                            #endregion
                        }
                        else if (SCRIBBLE_ALLOW_HEBREW && (_glyphWrite >= 0x0590) && (_glyphWrite <= 0x05FF))
                        {
                            //Hebrew handling is, mercifully, straight-forward beyond R2L directionality
                            __hasHebrew = true;
                        }
                        
                        if (SCRIBBLE_ALLOW_LIGATURES)
                        {
                            var _ligature = _fontLigatureMap[? (_glyphHistory & 0xFFFF_FFFF_0000) | _glyphWrite];
                            if (_ligature != undefined)
                            {
                                _glyphCount -= ds_map_exists(_fontLigatureMap, (_glyphHistory & 0xFFFF_FFFF_0000) >> 16)? 1 : 2;
                                _glyphWrite = _ligature;
                            }
                            else
                            {
                                var _ligature = _fontLigatureMap[? (_glyphHistory & 0xFFFF_0000) | _glyphWrite];
                                if (_ligature != undefined)
                                {
                                    --_glyphCount;
                                    _glyphWrite = _ligature;
                                }
                            }
                        }
                        
                        __SCRIBBLE_PARSER_WRITE_GLYPH
                    }
                }
                
                if (_glyphOrd == SCRIBBLE_COMMAND_TAG_OPEN) _stateCommandTagFlipflop = true;
                
                #endregion
            }
        }
    }
    
    //Resolve hanging offsets
    if (_glyphCount > 0)
    {
        while(array_length(_offsetDataArray) >= 3)
        {
            var _offsetDY    = array_pop(_offsetDataArray);
            var _offsetDX    = array_pop(_offsetDataArray);
            var _offsetStart = array_pop(_offsetDataArray);
            
            ds_grid_add_region(_glyphGrid, _offsetStart, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_X, _offsetDX);
            ds_grid_add_region(_glyphGrid, _offsetStart, __SCRIBBLE_GEN_GLYPH_Y, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, _offsetDY);
        }
    }
    
    __SCRIBBLE_PARSER_PUSH_SCALE; //Also pops alignment offset
    
    //Resolve sections
    if ((_sectionCount > 0) && (_glyphCount > _sectionCount))
    {
        ds_grid_set_region(_glyphGrid, _sectionStart, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, _sectionCount);
    }
    
    if (__hasArabic || __hasHebrew) __hasR2L = true;
    
    //Set our vertical alignment if it hasn't been overrided
    if (__vAlign == undefined) __vAlign = _startingVAlign;
    
    var _i = 0;
    repeat(array_length(_dynamicFontUseGridArray))
    {
        with(_dynamicFontUseGridArray[_i])
        {
            ds_grid_add_grid_region(__font.__dynSlotDataGrid, __grid,   0, 0, __count-1, 0,   0, __SCRIBBLE_DYN_SLOT_DATA_USED_COUNT);
            __font.__EnsureDynamicSurface();
        }
        
        ++_i;
    }
    
    ///////
    // Tidy up loose ends
    ///////
    
    //Create a null terminator so we correctly handle the last character in the string
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_UNICODE      ] = 0x00;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_BIDI         ] = __SCRIBBLE_BIDI_SYMBOL; //Replaced in the next generator phase
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_X            ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_Y            ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_WIDTH        ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_HEIGHT       ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT  ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SEPARATION   ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET  ] = 0;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_SCALE        ] = 1;
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] = _controlCount; //Make sure we collect controls at the end of a string
    _glyphGrid[# _glyphCount, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX ] = _sectionCount;
    
    with(_generatorState)
    {
        __glyphCount   = _glyphCount+1;
        __sectionCount  = _sectionCount;
    }
}
