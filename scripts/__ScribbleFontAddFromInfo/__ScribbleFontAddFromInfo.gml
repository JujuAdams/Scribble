// Feather disable all

/// @param fontName
/// @param textureGroup
/// @param textureUVs
/// @param fontInfo
/// @param lineHeight
/// @param isKrutidev
/// @param fromBundle

function __ScribbleFontAddFromInfo(_name, _textureGroup, _textureUVs, _fontInfo, _lineHeight, _isKrutidev, _fromBundle)
{
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    
    if (ds_map_exists(_fontDataMap, _name))
    {
        __ScribbleTrace("Warning! A font for \"", _name, "\" has already been added. Destroying the old font and creating a new one");
        _fontDataMap[? _name].__Destroy();
    }
    
    if (SCRIBBLE_VERBOSE) __ScribbleTrace("Adding \"", _name, "\" as standard font");
    
    var _scribbleState = __ScribbleSystem().__state;
    if (_scribbleState.__defaultFont == undefined)
    {
        if (SCRIBBLE_VERBOSE) __ScribbleTrace("Setting default font to \"" + string(_name) + "\"");
        _scribbleState.__defaultFont = _name;
    }
    
    var _globalGlyphBidiMap = __ScribbleSystem().__glyphData.__bidiMap;
    
    //Get font info from the runtime
    var _textureIndex   = _fontInfo.texture;
    var _infoGlyphsDict = _fontInfo.glyphs;
    var _ascenderOffset = _fontInfo.ascenderOffset;
    
    var _infoGlyphsArray = [];
    
    var _infoGlyphNames = variable_struct_get_names(_infoGlyphsDict);
    var _i = 0;
    repeat(array_length(_infoGlyphNames))
    {
        var _glyph = _infoGlyphNames[_i];
        var _struct = _infoGlyphsDict[$ _glyph];
        
        if (is_struct(_struct))
        {
            array_push(_infoGlyphsArray, _struct);
        }
        else
        {
            __ScribbleTrace($"Warning! Failed to access glyph data for char \"{_glyph}\" in font \"{_name}\"");
        }
        
        ++_i;
    }
    
    var _size = array_length(_infoGlyphsArray);
    
    var _texelsValid = true;
    
    if (not __ScribbleTextureGroupGetReady(_textureGroup))
    {
        //Uhoh, let's check to see if we've gotten valid texture dimensions
        if ((texture_get_width(_textureIndex) == 1)
        ||  (texture_get_height(_textureIndex) == 1)
        ||  (texture_get_texel_width(_textureIndex) == 1)
        ||  (texture_get_texel_height(_textureIndex) == 1))
        {
            //Nope, texels are invalid. We'll have to update them later
            _texelsValid = false;
            __ScribbleTrace("Font \"" + _name +"\" texture not ready, possibly a dynamic texture");
        }
    }
    
    if (_texelsValid)
    {
        var _textureTexelW = texture_get_texel_width(_textureIndex);
        var _textureTexelH = texture_get_texel_height(_textureIndex);
        var _textureW  = (_textureUVs[2] - _textureUVs[0])/_textureTexelW; //texture_get_width(_textureIndex);
        var _textureH  = (_textureUVs[3] - _textureUVs[1])/_textureTexelH; //texture_get_height(_textureIndex);
        var _textureL  = round(_textureUVs[0] / _textureTexelW);
        var _textureT  = round(_textureUVs[1] / _textureTexelH);
        
        if (SCRIBBLE_VERBOSE)
        {
            __ScribbleTrace("  \"" + _name +"\""
                                + ", texture = " + string(_textureIndex)
                                + ", top-left = " + string(_textureL) + "," + string(_textureT)
                                + ", size = " + string(_textureW) + " x " + string(_textureH)
                                + ", texel = " + string_format(_textureTexelW, 1, 10) + " x " + string_format(_textureTexelH, 1, 10)
                                + ", uvs = " + string_format(_textureUVs[0], 1, 10) + "," + string_format(_textureUVs[1], 1, 10)
                                + " -> " + string_format(_textureUVs[2], 1, 10) + "," + string_format(_textureUVs[3], 1, 10));
        }
    }
    else
    {
        var _textureTexelW = 1;
        var _textureTexelH = 1;
        var _textureL = 0;
        var _textureT = 0;
    }
    
    var _sdf = _fontInfo.sdfEnabled;
    if (_sdf)
    {
        var _sdfPxRange         = 2*_fontInfo.sdfSpread;
        var _sdfThicknessOffset = 0;
        var _sdfOffset          = -_sdfPxRange;
    }
    else
    {
        var _sdfPxRange         = undefined;
        var _sdfThicknessOffset = undefined;
        var _sdfOffset          = 0;
    }
    
    var _fontData = new __ScribbleClassFont(_name, _size,
                                            _sdf? __SCRIBBLE_RENDER_SDF : __SCRIBBLE_RENDER_RASTER,
                                            _fromBundle, _texelsValid,
                                            __ScribbleCalculateUnderlineY(_fontInfo.size, _fontInfo.ascender, _fontInfo.ascenderOffset),
                                            __ScribbleCalculateStrikeY(_fontInfo.size, _fontInfo.ascender, _fontInfo.ascenderOffset),);
    
    if (_isKrutidev) _fontData.__isKrutidev = true;
    
    var _fontGlyphsMap     = _fontData.__glyphsMap;
    var _fontGlyphDataGrid = _fontData.__glyphDataGrid;
    var _fontKerningMap    = _fontData.__kerningMap;
    
    //Set some basic repeated values in bulk for a little speed boost
    var _material = __ScribbleGetMaterial(_name, _textureIndex, _sdf? __SCRIBBLE_RENDER_SDF : __SCRIBBLE_RENDER_RASTER, _sdfPxRange, _sdfThicknessOffset, _fontData.__bilinear);
    
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT,  _size-1, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT,   _lineHeight);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE,   _size-1, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE,    1);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_MATERIAL,     _size-1, __SCRIBBLE_GLYPH_PROPR_MATERIAL,     _material);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, _size-1, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, _texelsValid);
    
    var _i = 0;
    repeat(_size)
    {
        var _glyphDict = _infoGlyphsArray[_i];
        
        var _unicode = _glyphDict.char;
        if ((_unicode >= 0x3000) && (_unicode <= 0x303F)) //CJK Symbols and Punctuation
        {
            var _bidi = __SCRIBBLE_BIDI_SYMBOL;
        }
        else if ((_unicode >= 0x3040) && (_unicode <= 0x30FF)) //Hiragana and Katakana
        {
            var _bidi = __SCRIBBLE_BIDI_ISOLATED_CJK;
        }
        else if ((_unicode >= 0x4E00) && (_unicode <= 0x9FFF)) //CJK Unified ideographs block
        {
            var _bidi = __SCRIBBLE_BIDI_ISOLATED_CJK;
        }
        else if ((_unicode >= 0xFF00) && (_unicode <= 0xFF0F)) //Fullwidth symbols
        {
            var _bidi = __SCRIBBLE_BIDI_SYMBOL;
        }
        else if ((_unicode >= 0xFF1A) && (_unicode <= 0xFF1F)) //More fullwidth symbols
        {
            var _bidi = __SCRIBBLE_BIDI_SYMBOL;
        }
        else if ((_unicode >= 0xFF5B) && (_unicode <= 0xFF64)) //Yet more fullwidth symbols
        {
            var _bidi = __SCRIBBLE_BIDI_SYMBOL;
        }
        else
        {
            var _bidi = _globalGlyphBidiMap[? _unicode];
            if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI_L2R;
        }
        
        if (_isKrutidev)
        {
            if (_bidi != __SCRIBBLE_BIDI_WHITESPACE)
            {
                _bidi = __SCRIBBLE_BIDI_L2R_DEVANAGARI;
                _unicode += __SCRIBBLE_DEVANAGARI_OFFSET;
            }
        }
        
        if (SCRIBBLE_USE_KERNING)
        {
            var _kerningArray = _glyphDict[$ "kerning"];
            if (is_array(_kerningArray))
            {
                var _j = 0;
                repeat(array_length(_kerningArray) div 2)
                {
                    var _first = _kerningArray[_j];
                    if (_first > 0) _fontKerningMap[? ((_unicode & 0xFFFF) << 16) | (_first & 0xFFFF)] = _kerningArray[_j+1];
                    _j += 2;
                }
            }
        }
        
        var _char = chr(_unicode);
        
        //FIXME - Workaround for HTML5 in GMS2.3.7.606 and above
        //        This doesn't seem to be needed in 2022.3.0.497
        var _x = _glyphDict[$ "x"];
        var _y = _glyphDict[$ "y"];
        var _w = _glyphDict.w;
        var _h = _glyphDict.h;
        
        var _xoffset = _glyphDict.offset + 0.5*_sdfOffset;
        var _yoffset = 0.5*_sdfOffset;
        
        if (_sdf && (SCRIBBLE_SDF_BORDER_TRIM > 0))
        {
            _x += SCRIBBLE_SDF_BORDER_TRIM;
            _y += SCRIBBLE_SDF_BORDER_TRIM;
            
            _w -= 2*SCRIBBLE_SDF_BORDER_TRIM;
            _h -= 2*SCRIBBLE_SDF_BORDER_TRIM;
            
            _xoffset += SCRIBBLE_SDF_BORDER_TRIM;
            _yoffset += SCRIBBLE_SDF_BORDER_TRIM;
        }
        
        var _u0 = _x*_textureTexelW;
        var _v0 = _y*_textureTexelH;
        var _u1 = _u0 + _w*_textureTexelW;
        var _v1 = _v0 + _h*_textureTexelH;
        
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_CHARACTER   ] = _char;
        
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_UNICODE     ] = _unicode;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_BIDI        ] = _bidi;
        
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_X_OFFSET    ] = _xoffset;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_Y_OFFSET    ] = _yoffset - _ascenderOffset;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_WIDTH       ] = _w;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_HEIGHT      ] = _h;

        //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT ] = _lineHeight; //Set above in bulk
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_SEPARATION  ] = _glyphDict.shift;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET ] = -_glyphDict.offset;
        //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE  ] = 1; //Set above in bulk
        
        //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL    ] = _material; //Set above in bulk
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U0          ] = _u0;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U1          ] = _u1;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V0          ] = _v0;
        _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V1          ] = _v1;
        //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID] = _texelsValid; //Set above in bulk
        
        _fontGlyphsMap[? _unicode] = _i;
        
        ++_i;
    }
    
    _fontData.__height = _lineHeight;
    _fontData.__EnsureAdditionalCharacters();
    
    //Check to see if this texture has been resized during compile
    var _GMScaling = _fontInfo.size / _fontGlyphDataGrid[# _fontGlyphsMap[? SCRIBBLE_UNICODE_SPACE], __SCRIBBLE_GLYPH_PROPR_HEIGHT];
    if (_GMScaling > 1)
    {
        __ScribbleTrace("Warning! Font \"", _name, "\" may have been scaled during compilation (font size = ", _fontInfo.size, ", space height = ", _fontGlyphDataGrid[# _fontGlyphsMap[? 32], __SCRIBBLE_GLYPH_PROPR_HEIGHT], ", scaling factor = ", _GMScaling, "). Check that the font is rendering correctly. If it is not, try setting `SCRIBBLE_ATTEMPT_FONT_SCALING_FIX` to `false`");
        if (SCRIBBLE_ATTEMPT_FONT_SCALING_FIX) scribble_font_scale(_name, ceil(_GMScaling));
    }
}
