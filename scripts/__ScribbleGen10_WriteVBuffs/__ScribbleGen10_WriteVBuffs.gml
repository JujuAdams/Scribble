// Feather disable all
#macro __SCRIBBLE_VBUFF_READ_GLYPH  var _quadL = _vbuffPosGrid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];\
                                    var _quadT = _vbuffPosGrid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T];\
                                    var _quadR = _vbuffPosGrid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R];\
                                    var _quadB = _vbuffPosGrid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B];\
                                    \
                                    var _material = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_MATERIAL];\
                                    var _quadU0  = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_U0];\
                                    var _quadV0  = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_V0];\
                                    var _quadU1  = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_U1];\
                                    var _quadV1  = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_V1];\
                                    \
                                    var _halfW = 0.5*_glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_WIDTH ];\
                                    var _halfH = 0.5*_glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_HEIGHT];



#macro __SCRIBBLE_VBUFF_WRITE_GLYPH  if (_material != _materialPrev)\ //Swap vertex buffer if the material has changed
                                     {\
                                         _materialPrev = _material;\
                                         _vbuff = _pageData.__GetVertexBuffer(_material);\
                                     }\
                                     if (_bezierDo)\
                                     {\
                                         var _quadCX = _quadL + _halfW;\
                                         var _quadCY = _quadT + _halfH;\
                                         if (_quadCY > _bezierPrevCY)\ //If we've snapped back to the LHS then reset our Bezier curve 
                                         {\ //TODO - Maybe use a line number check instead? This could get slow
                                             _bezierSearchIndex = 0;\
                                             _bezierSearchD0 = 0;\
                                             _bezierSearchD1 = _bezierLengths[1];\
                                         }\
                                         _bezierPrevCY = _quadCY;\
                                         while (true)\ //Iterate forwards until we find a Bezier segment we can fit into
                                         {\
                                             if (_quadCX <= _bezierSearchD1)\ //If this glyph is on this line segment...
                                             {\
                                                 var _bezierParam = _bezierParamIncrement*((_quadCX - _bezierSearchD0)/ (_bezierSearchD1 - _bezierSearchD0) + _bezierSearchIndex);\ //...then parameterise this glyph
                                                 break;\
                                             }\
                                             _bezierSearchIndex++;\
                                             if (_bezierSearchIndex >= SCRIBBLE_BEZIER_ACCURACY-1)\
                                             {\
                                                 var _bezierParam = 1.0;\ //We've hit the end of the Bezier curve, force all the remaining glyphs to stack up at the end of the line
                                                 break;\
                                             }\
                                             _bezierSearchD0 = _bezierSearchD1;\ //Advance to the next line segment
                                             _bezierSearchD1 = _bezierLengths[_bezierSearchIndex+1];\
                                         }\
                                         _quadL = _bezierParam;\
                                         _quadR = _bezierParam;\
                                         _quadT = _quadCY;\
                                         _quadB = _quadCY;\
                                     }\
                                     \
                                     vertex_position_3d(_vbuff, _quadL, _quadT, _animationIndex); vertex_normal(_vbuff, _revealIndex, _glyphSpriteData, _glyphEffectFlags); vertex_argb(_vbuff, _writeColor); vertex_float4(_vbuff, _quadU0, _quadV0,  _halfW,  _halfH);\
                                     vertex_position_3d(_vbuff, _quadR, _quadB, _animationIndex); vertex_normal(_vbuff, _revealIndex, _glyphSpriteData, _glyphEffectFlags); vertex_argb(_vbuff, _writeColor); vertex_float4(_vbuff, _quadU1, _quadV1, -_halfW, -_halfH);\
                                     vertex_position_3d(_vbuff, _quadL, _quadB, _animationIndex); vertex_normal(_vbuff, _revealIndex, _glyphSpriteData, _glyphEffectFlags); vertex_argb(_vbuff, _writeColor); vertex_float4(_vbuff, _quadU0, _quadV1,  _halfW, -_halfH);\
                                     vertex_position_3d(_vbuff, _quadR, _quadB, _animationIndex); vertex_normal(_vbuff, _revealIndex, _glyphSpriteData, _glyphEffectFlags); vertex_argb(_vbuff, _writeColor); vertex_float4(_vbuff, _quadU1, _quadV1, -_halfW, -_halfH);\
                                     vertex_position_3d(_vbuff, _quadL, _quadT, _animationIndex); vertex_normal(_vbuff, _revealIndex, _glyphSpriteData, _glyphEffectFlags); vertex_argb(_vbuff, _writeColor); vertex_float4(_vbuff, _quadU0, _quadV0,  _halfW,  _halfH);\
                                     vertex_position_3d(_vbuff, _quadR, _quadT, _animationIndex); vertex_normal(_vbuff, _revealIndex, _glyphSpriteData, _glyphEffectFlags); vertex_argb(_vbuff, _writeColor); vertex_float4(_vbuff, _quadU1, _quadV0, -_halfW,  _halfH);



function __ScribbleGen10_WriteVBuffs()
{
    static _stringBuffer   = __ScribbleSystem().__bufferA;
    static _generatorState = __ScribbleSystem().__generatorState;
    static _tagDict        = __ScribbleSystem().__tagDict;
    
    static _scribbleDotUVs = sprite_get_uvs(sprScribbleFallbackDot, 0);
    static _scribbleDotMaterial = __ScribbleSpriteGetMaterial(sprScribbleFallbackDot, 0);
    
    with(_generatorState)
    {
        var _vbuffPosGrid = __vbuffPosGrid;
        var _controlArray = __controlArray;
        var _glyphGrid    = __glyphGrid;
        var _wordGrid     = __wordGrid;
        var _lineArray    = __lineArray;
        var _glyphCount   = __glyphCount;
    }
    
    var _textGetter       = __allowTextGetter;
    var _glyph_data_getter = __allowGlyphDataGetter;
    
    
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
    ds_grid_set_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_WIDTH,   _glyphCount-1, __SCRIBBLE_GEN_GLYPH_WIDTH,   0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    ds_grid_add_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_HEIGHT,  _glyphCount-1, __SCRIBBLE_GEN_GLYPH_HEIGHT,  0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
    
    
    
    if (is_array(_generatorState.__bezierLengthsArray))
    {
        //Prep for Bezier curve shenanigans if necessary
        var _bezierDo             = true;
        var _bezierLengths        = _generatorState.__bezierLengthsArray;
        var _bezierSearchIndex    = 0;
        var _bezierSearchD0       = 0;
        var _bezierSearchD1       = _bezierLengths[1];
        var _bezierPrevCY         = -infinity;
        var _bezierParamIncrement = 1 / (SCRIBBLE_BEZIER_ACCURACY-1);
    }
    else
    {
        _bezierDo = false;
    }
    
    var _glyphColor       = 0xFFFFFFFF;
    var _glyphCycle       = 0x00000000;
    var _glyphEffectFlags = 0;
    var _glyphSpriteData  = 0;
    var _writeColor       = 0xFFFFFFFF;
    
    var _controlIndex = 0;
    var _regionName   = undefined;
    var _regionStart  = undefined;
    
    var _underline = 0;
    var _strike    = 0;
    
    var _fontUnderlineY = 0;
    var _fontStrikeY    = 0;
    
    var _funcRegionPop = function(_pageData, _regionName, _regionStart, _regionEnd)
    {
        static _generatorState = __ScribbleSystem().__generatorState;
        
        if (_regionStart > _regionEnd) return;
        
        var _region_bbox_array = [];
        
        var _vbuffPosGrid = _generatorState.__vbuffPosGrid;
        var _lineArray    = _generatorState.__lineArray;
        var _wordGrid     = _generatorState.__wordGrid;
        
        var _line = 0;
        var _regionBboxStart = _regionStart;
        var _regionBboxEnd   = _regionStart-1;
        
        while(_regionEnd >= _regionBboxStart)
        {
            _regionBboxEnd = min(_regionEnd, _wordGrid[# _lineArray[_line].wordEnd, __SCRIBBLE_GEN_WORD_GLYPH_END]);
            
            if (_regionBboxStart <= _regionBboxEnd)
            {
                //Push a bounding box to the region
                //N.B. This array is exposed to the end-user via .region_get_bboxes()
                array_push(_region_bbox_array, {
                    x1 : ds_grid_get_min(_vbuffPosGrid, _regionBboxStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L, _regionBboxEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L),
                    y1 : ds_grid_get_min(_vbuffPosGrid, _regionBboxStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T, _regionBboxEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T),
                    x2 : ds_grid_get_max(_vbuffPosGrid, _regionBboxStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R, _regionBboxEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R),
                    y2 : ds_grid_get_max(_vbuffPosGrid, _regionBboxStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B, _regionBboxEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B),
                });
                
                _regionBboxStart = _regionBboxEnd + 1;
            }
            
            ++_line;
        }
        
        //N.B. This array is exposed to the end-user via .region_get_bboxes()
        array_push(_pageData.__regionArray, {
            name:       _regionName,
            bboxArray:  _region_bbox_array,
            startGlyph: _regionStart - _pageData.__glyphStart,
            endGlyph:   _regionEnd - _pageData.__glyphStart,
        });
    }
    
    var _pageIndex = 0;
    repeat(__pages)
    {
        var _pageData       = __pagesArray[_pageIndex];
        var _pageEventsDict = _pageData.__eventsDict;
        var _vbuff          = undefined;
        var _materialPrev   = undefined;
        var _animationIndex = 0;
        var _revealIndex    = 0;
        
        if (_glyph_data_getter)
        {
            with(_pageData)
            {
                __EnsureGlyphGrid();
                ds_grid_set_grid_region(__glyphGrid, _glyphGrid, __glyphStart, __SCRIBBLE_GEN_GLYPH_UNICODE, __glyphEnd, __SCRIBBLE_GEN_GLYPH_UNICODE, 0, __SCRIBBLE_GLYPH_LAYOUT_UNICODE);
                ds_grid_set_grid_region(__glyphGrid, _glyphGrid, __glyphStart, __SCRIBBLE_GEN_GLYPH_Y, __glyphEnd, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET);
                ds_grid_set_grid_region(__glyphGrid, _vbuffPosGrid, __glyphStart, 0, __glyphEnd, __SCRIBBLE_GEN_VBUFF_POS_SIZE-1, 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT);
            }
        }
        
        if (_textGetter)
        {
            buffer_seek(_stringBuffer, buffer_seek_start, 0);
        }
        
        var _lineIndex = _pageData.__lineStart;
        repeat(_pageData.__lineCount)
        {
            var _lineStruct = _lineArray[_lineIndex];
            var _lineY = _lineStruct.y;
            
            var _glyphStart = _wordGrid[# _lineStruct.wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START];
            var _glyphEnd   = _wordGrid[# _lineStruct.wordEnd,   __SCRIBBLE_GEN_WORD_GLYPH_END  ];
            
            var _glyphIndex = _glyphStart;
            repeat(1 + _glyphEnd - _glyphStart)
            {
                var _animationIndex = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX];
                var _revealIndex    = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX   ];
                
                #region Read controls
                
                var _controlDelta = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _controlIndex;
                repeat(_controlDelta)
                {
                    var _controlStruct = _controlArray[_controlIndex];
                    var _controlType = _controlStruct.__type;
                    if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_COLOUR)
                    {
                        _glyphColor = _controlStruct.__color;
                        var _writeColor = (__SCRIBBLE_FIX_ARGB? __ScribbleRGBToBGR(_glyphColor) : _glyphColor); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_EFFECT)
                    {
                        _glyphEffectFlags = _controlStruct.__bitflags;
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_CYCLE)
                    {
                        _glyphCycle = _controlStruct.__value;
                        
                        if (_glyphCycle == -1)
                        {
                            _writeColor = (__SCRIBBLE_FIX_ARGB? __ScribbleRGBToBGR(_glyphColor) : _glyphColor); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                        }
                        else
                        {
                            _writeColor = (__SCRIBBLE_FIX_ARGB? __ScribbleRGBToBGR(_glyphCycle) : _glyphCycle); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                        }
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_EVENT)
                    {
                        //FIXME - Add character index (and line index if possible)
                        var _event = _controlStruct.__event;
                        _event.revealIndex = _revealIndex;
                        
                        var _eventArray = _pageEventsDict[$ _revealIndex]; //Find the correct event array in the dictionary, creating a new one if needed
                        
                        if (not is_array(_eventArray))
                        {
                            var _eventArray = [];
                            _pageEventsDict[$ _revealIndex] = _eventArray;
                        }
                        
                        array_push(_eventArray, _event);
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_REGION)
                    {
                        if (_regionName != undefined)
                        {
                            _funcRegionPop(_pageData, _regionName, _regionStart, _glyphIndex-1);
                        }
                        
                        // [/region] just sets the .DATA field to undefined
                        _regionName  = _controlStruct.__name;
                        _regionStart = _glyphIndex;
                    }
                    else if (_controlType == __SCRIBBLE_GEN_CONTROL_TYPE_FONT)
                    {
                        var _fontData = __ScribbleGetFontData(_controlStruct.__fontName);
                        var _fontUnderlineY = floor(_fontData.__underlineY);
                        var _fontStrikeY    = floor(_fontData.__strikeY);
                    }
                    else if ( _controlType == __SCRIBBLE_GEN_CONTROL_TYPE_UNDERLINE)
                    {
                        _underline = _controlStruct.__thickness;
                    }
                    else if ( _controlType == __SCRIBBLE_GEN_CONTROL_TYPE_STRIKE)
                    {
                        _strike = _controlStruct.__thickness;
                    }
                    
                    _controlIndex++;
                }
                
                #endregion
                
                var _glyphOrd = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_UNICODE];
                if (_glyphOrd >= 0)
                {
                    if (_textGetter)
                    {
                        __ScribbleBufferWriteUnicode(_stringBuffer, _glyphOrd);
                    }
                    
                    if ((_glyphOrd > SCRIBBLE_UNICODE_SPACE) && (_glyphOrd != SCRIBBLE_UNICODE_NBSP) && (_glyphOrd != SCRIBBLE_UNICODE_ZWSP))
                    {
                        __SCRIBBLE_VBUFF_READ_GLYPH;
                        __SCRIBBLE_VBUFF_WRITE_GLYPH;
                    }
                }
                else if (_glyphOrd == __SCRIBBLE_GLYPH_REPL_SPRITE)
                {
                    #region Write sprite
                    
                    if (_textGetter)
                    {
                        buffer_write(_stringBuffer, buffer_u8, SCRIBBLE_UNICODE_SUB);
                    }
                    
                    var _glyphX      = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_X          ];
                    var _glyphY      = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_Y          ];
                    var _glyphWidth  = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_WIDTH      ];
                    var _glyphHeight = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_HEIGHT     ];
                    var _spriteData  = _glyphGrid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_SPRITE_DATA];
                    
                    var _spriteIndex = _spriteData.__spriteIndex;
                    var _imageIndex  = _spriteData.__imageIndex;
                    var _imageSpeed  = _spriteData.__imageSpeed;
                    var _spriteOnce  = _spriteData.__spriteOnce;
                    
                    var _glyphXScale = sprite_get_width( _spriteIndex) / _glyphWidth;
                    var _glyphYScale = sprite_get_height(_spriteIndex) / _glyphHeight;
                    
                    if (SCRIBBLE_ADD_SPRITE_ORIGINS)
                    {
                        _glyphX += (_glyphWidth  div 2) - _glyphXScale*sprite_get_xoffset(_spriteIndex);
                        _glyphY += (_glyphHeight div 2) - _glyphYScale*sprite_get_yoffset(_spriteIndex);
                    }
                    
                    var _oldGlyphEffectFlags = _glyphEffectFlags;
                    
                    if (not SCRIBBLE_COLORIZE_SPRITES)
                    {
                        var _oldWriteColor = _writeColor;
                        _writeColor = _glyphColor | 0xFFFFFF; //Make sure we use the general glyph alpha
                        
                        _glyphEffectFlags = ~_glyphEffectFlags;
                        _glyphEffectFlags |= (1 << __SCRIBBLE_FLAG_CYCLE);
                        _glyphEffectFlags = ~_glyphEffectFlags;
                    }
                    
                    _glyphEffectFlags |= (1 << __SCRIBBLE_FLAG_GRAPHIC); //Set the graphic flag bit
                    
                    if (_imageSpeed > 0)
                    {
                        _glyphEffectFlags |= (1 << __SCRIBBLE_FLAG_ANIM_SPRITE); //Set the animated sprite flag bit
                        
                        var _sprite_number = sprite_get_number(_spriteIndex);
                        if (_sprite_number > 127)
                        {
                            __ScribbleTrace("Animated sprites cannot have more than 127 frames (", sprite_get_name(_spriteIndex), ")");
                            _sprite_number = 127;
                        }
                        
                        if (_imageSpeed >= 2)
                        {
                            __ScribbleTrace("Image speed cannot be more than 2.0 (" + string(_imageSpeed) + ")");
                            _imageSpeed = 2;
                        }
                        
                        var _glyphSpriteData = 16384*floor(256*_imageSpeed) + 128*_sprite_number + _imageIndex;
                        
                        if (_spriteOnce)
                        {
                            _glyphSpriteData *= -1;
                            var _increment = -1;
                        }
                        else
                        {
                            var _increment = 1;
                        }
                        
                        var _count = _sprite_number;
                    }
                    else
                    {
                        if (_imageSpeed < 0)
                        {
                            __ScribbleTrace("Image speed cannot be less than 0.0 (" + string(_imageSpeed) + ")");
                        }
                        
                        var _increment = 0;
                        var _count = 1;
                    }
                    
                    var _j = _imageIndex;
                    repeat(_count)
                    {
                        var _material = __ScribbleSpriteGetMaterial(_spriteIndex, _j);
                        
                        var _uvs = sprite_get_uvs(_spriteIndex, _j);
                        var _quadU0 = _uvs[0];
                        var _quadV0 = _uvs[1];
                        var _quadU1 = _uvs[2];
                        var _quadV1 = _uvs[3];
                        
                        var _quadL = floor(_glyphX + _uvs[4]/_glyphXScale);
                        var _quadT = floor(_glyphY + _uvs[5]/_glyphYScale);
                        var _quadR = _quadL + _uvs[6]*_glyphWidth;
                        var _quadB = _quadT + _uvs[7]*_glyphHeight;
                        
                        var _halfW = 0.5*(_quadR - _quadL);
                        var _halfH = 0.5*(_quadB - _quadT);
                        
                        __SCRIBBLE_VBUFF_WRITE_GLYPH;
                        
                        ++_j;
                        _glyphSpriteData += _increment;
                    }
                    
                    if (not SCRIBBLE_COLORIZE_SPRITES) _writeColor = _oldWriteColor;
                    _glyphEffectFlags = _oldGlyphEffectFlags;
                    _glyphSpriteData = 0; //Reset this because every other type of glyph doesn't use this
                    
                    #endregion
                }
                else if ((_glyphOrd == __SCRIBBLE_GLYPH_REPL_SURFACE) || (_glyphOrd == __SCRIBBLE_GLYPH_REPL_TEXTURE))
                {
                    #region Write surface or texture
                    
                    if (_textGetter)
                    {
                        buffer_write(_stringBuffer, buffer_u8, SCRIBBLE_UNICODE_SUB);
                    }
                    
                    __SCRIBBLE_VBUFF_READ_GLYPH;
                    
                    var _oldGlyphEffectFlags = _glyphEffectFlags;
                    
                    if (not SCRIBBLE_COLORIZE_SPRITES)
                    {
                        var _oldWriteColor = _writeColor;
                        _writeColor = _writeColor | 0xFFFFFF;
                        
                        _glyphEffectFlags = ~_glyphEffectFlags;
                        _glyphEffectFlags |= (1 << __SCRIBBLE_FLAG_CYCLE);
                        _glyphEffectFlags = ~_glyphEffectFlags;
                    }
                    
                    _glyphEffectFlags |= (1 << __SCRIBBLE_FLAG_GRAPHIC); //Set the graphic flag bit
                    
                    __SCRIBBLE_VBUFF_WRITE_GLYPH;
                    
                    if (not SCRIBBLE_COLORIZE_SPRITES)
                    {
                        _writeColor = _oldWriteColor;
                    }
                    
                    _glyphEffectFlags = _oldGlyphEffectFlags;
                    
                    #endregion
                }
                
                if (_glyphIndex < _glyphEnd)
                {
                    //TODO - Optimise
                    
                    if (_strike > 0)
                    {
                        var _quadL = _vbuffPosGrid[# _glyphIndex,   __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quadT = _lineY + _fontStrikeY - ceil(0.5*_strike);
                        var _quadR = _vbuffPosGrid[# _glyphIndex+1, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quadB = _quadT + _strike;
                        
                        var _material = _scribbleDotMaterial;
                        var _quadU0  = _scribbleDotUVs[0];
                        var _quadV0  = _scribbleDotUVs[1];
                        var _quadU1  = _scribbleDotUVs[2];
                        var _quadV1  = _scribbleDotUVs[3];
                        
                        var _halfW = 0.5*(1 + _quadR - _quadL);
                        var _halfH = 0.5*_strike;
                        
                        __SCRIBBLE_VBUFF_WRITE_GLYPH
                    }
                    
                    if (_underline > 0)
                    {
                        var _quadL = _vbuffPosGrid[# _glyphIndex,   __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quadT = _lineY + _fontUnderlineY + 1;
                        var _quadR = _vbuffPosGrid[# _glyphIndex+1, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quadB = _quadT + _underline;
                        
                        var _material = _scribbleDotMaterial;
                        var _quadU0  = _scribbleDotUVs[0];
                        var _quadV0  = _scribbleDotUVs[1];
                        var _quadU1  = _scribbleDotUVs[2];
                        var _quadV1  = _scribbleDotUVs[3];
                        
                        var _halfW = 0.5*(1 + _quadR - _quadL);
                        var _halfH = 0.5*_underline;
                        
                        __SCRIBBLE_VBUFF_WRITE_GLYPH
                    }
                }
                
                ++_glyphIndex;
            }
            
            ++_lineIndex;
        }
        
        //If we have a hanging glyph in an open region then ensure we pop it onto the page we're leaving
        if (_regionName != undefined)
        {
            _funcRegionPop(_pageData, _regionName, _regionStart, _glyphIndex-1);
            
            //Set up so that we still have a region open on the next page
            _regionStart = _glyphIndex;
        }
        
        if (_textGetter)
        {
            //Write a null terminator to finish off the string
            buffer_write(_stringBuffer, buffer_u8, 0);
            buffer_seek(_stringBuffer, buffer_seek_start, 0);
            _pageData.__text = buffer_read(_stringBuffer, buffer_string);
        }
        
        ++_pageIndex;
    }
    
    //Sweep up any remaining events
    var _controlDelta = _glyphGrid[# _glyphIndex-1, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _controlIndex;
    repeat(_controlDelta)
    {
        var _controlStruct = _controlArray[_controlIndex];
        if (_controlStruct.__type == __SCRIBBLE_GEN_CONTROL_TYPE_EVENT)
        {
            //FIXME - Add character index (and line index if possible)
            var _event = _controlStruct.__event;
            _event.revealIndex = _revealIndex;
            
            
            
            var _eventArray = _pageEventsDict[$ _revealIndex]; //Find the correct event array in the diciontary, creating a new one if needed
            
            if (not is_array(_eventArray))
            {
                var _eventArray = [];
                _pageEventsDict[$ _revealIndex] = _eventArray;
            }
            
            array_push(_eventArray, _event);
        }
                
        _controlIndex++;
    }
    
    //Ensure we've ended the vertex buffers we created
    __FinalizeVertexBuffers();
}
