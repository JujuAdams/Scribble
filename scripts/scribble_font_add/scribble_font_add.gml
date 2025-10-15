// Feather disable all

/// @param name
/// @param path
/// @param size
/// @param [SDF=false]
/// @param [bold=false]
/// @param [italic=false]
/// @param [krutidev=false]

function scribble_font_add(_scribbleName, _path, _inputSize, _sdf = false, _inputBold = false, _inputItalic = false, _isKrutidev = false)
{
    var _globalGlyphBidiMap = __ScribbleSystem().__glyphData.__bidiMap;
    
    var _nativeFont = font_add(_path, _inputSize, _inputBold, _inputItalic, 32, 127);
    
    var _timer = get_timer();
    
    //TODO - Reconsider all of this
    //TODO - Implement Krutidev
    var _sdfPxRange = 0;
    var _sdfThicknessOffset = 0;
    var _sdfHeightOffset = 0;
    
    var _dataPath = __ScribbleMakeFontDataPath(_path, _inputSize, _inputBold, _inputItalic);
    
    if (not file_exists(_dataPath))
    {
        if (not SCRIBBLE_FONT_ADD_AUTOBUILD)
        {
            if (not __SCRIBBLE_ON_DESKTOP)
            {
                __ScribbleError($"Font data not found (looked for \"{_dataPath}\")\nPlease call `scribble_font_build_data()` for this font");
            }
            else
            {
                __ScribbleTrace($"Warning! Font data not found (looked for \"{_dataPath}\"). Please call `scribble_font_build_data()` for this font");
            }
            
            return _nativeFont;
        }
        
        if (not __SCRIBBLE_ON_DESKTOP)
        {
            __ScribbleError($"Font data not found (looked for \"{_dataPath}\")\nPlease re-run the game on the desktop platform you're using for your IDE");
            return _nativeFont;
        }
        
        __ScribbleTrace($"Warning! Font data not found (looked for \"{_dataPath}\")");
        _dataPath = filename_dir(GM_project_filename) + "/datafiles/" + _dataPath;
        __ScribbleTrace($"Changed file path to \"{_dataPath}\"");
        __ScribbleTrace($"Building font data automatically");
        
        scribble_font_build_data(_nativeFont, _dataPath);
        
        if (not file_exists(_dataPath))
        {
            __ScribbleError($"Font data failed to save (looked for \"{_dataPath}\")");
            return _nativeFont;
        }
    }
    
    __ScribbleTrace($"Loading font data \"{_dataPath}\"");
    
    var _compressedBuffer = buffer_load(_dataPath);
    if (_compressedBuffer < 0)
    {
        __ScribbleError($"Failed to load \"{_dataPath}\". Please re-run `scribble_font_build_data()` for this font");
        return _nativeFont;
    }
    
    var _buffer = buffer_decompress(_compressedBuffer);
    buffer_delete(_compressedBuffer);
    
    if (_buffer < 0)
    {
        __ScribbleError($"Failed to decompress \"{_dataPath}\". Please re-run `scribble_font_build_data()` for this font");
        return _nativeFont;
    }
    
    var _magicString = buffer_read(_buffer, buffer_string);
    if (_magicString != __SCRIBBLE_FONT_DATA_MAGIC_STRING)
    {
        __ScribbleError($"Font data failed verification check (\"{_dataPath}\"). Please re-run `scribble_font_build_data()` for this font");
        return _nativeFont;
    }
    
    var _versionNumber = buffer_read(_buffer, buffer_string);
    if (_versionNumber != __SCRIBBLE_FONT_DATA_VERSION)
    {
        __ScribbleError($"Font data failed verification check (\"{_dataPath}\"). Please re-run `scribble_font_build_data()` for this font");
        return _nativeFont;
    }
    
    var _foundFontName = buffer_read(_buffer, buffer_string);
    if (_path != _foundFontName)
    {
        __ScribbleTrace($"Warning! Font name mismatch. Found \"{_foundFontName}\", was expecting \"{_path}\"");
    }
    
    var _foundPointSize = buffer_read(_buffer, buffer_f32);
    if (_inputSize != _foundPointSize)
    {
        __ScribbleError($"Font point size mismatch. Found {_foundPointSize}, was expecting {_inputSize}");
        return _nativeFont;
    }
    
    var _lineHeight     = buffer_read(_buffer, buffer_u8);
    var _ascender       = buffer_read(_buffer, buffer_s8);
    var _ascenderOffset = buffer_read(_buffer, buffer_s8);
    
    var _foundMaxWidth   = buffer_read(_buffer, buffer_u8);
    var _foundMaxHeight  = buffer_read(_buffer, buffer_u8);
    
    var _foundGlyphCount = buffer_read(_buffer, buffer_u32);
    
    var _cellWidth  = 2 + _foundMaxWidth;
    var _cellHeight = 2 + _foundMaxHeight;
    
    var _cellCountX = floor(SCRIBBLE_FONT_ADD_TEXTURE_SIZE / _cellWidth);
    var _cellCountY = min(ceil(_foundGlyphCount / _cellCountX), floor(SCRIBBLE_FONT_ADD_TEXTURE_SIZE / _cellHeight));
    
    var _glyphsPerPage = _cellCountX*_cellCountY;
    var _surfaceWidth  = _cellCountX*_cellWidth;
    var _surfaceHeight = _cellCountY*_cellHeight;
    
    __ScribbleTrace($"- Font has {_foundGlyphCount} glyphs");
    __ScribbleTrace($"- Largest glyph is {_foundMaxWidth} x {_foundMaxHeight} px");
    __ScribbleTrace($"- Cell size is {_cellWidth} x {_cellHeight} px");
    __ScribbleTrace($"- Grid size is {_cellCountX} x {_cellCountY}. Maximum concurrent glyphs is {_glyphsPerPage}");
    __ScribbleTrace($"- Surface size is {_surfaceWidth} x {_surfaceHeight} px ({4*_surfaceWidth*_surfaceHeight / (1024*1024)} MB)");
    
    var _fontData = new __ScribbleClassFont(_scribbleName, _foundGlyphCount,
                                            __SCRIBBLE_RENDER_RASTER,
                                            false, true,
                                            __ScribbleCalculateUnderlineY(_inputSize, _ascender, _ascenderOffset),
                                            __ScribbleCalculateStrikeY(_inputSize, _ascender, _ascenderOffset));
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    _fontDataMap[? font_get_name(_nativeFont)] = _fontData;
    
    with(_fontData)
    {
        var _fontGlyphDataGrid = __glyphDataGrid;
        var _fontGlyphsMap     = __glyphsMap;
        var _fontKerningMap    = __kerningMap;
        
        __dynamic          = true;
        __dynFontAsset     = _nativeFont;
        __dynFreeSlotArray = [];
        __dynGlyphMap      = ds_map_create();
        __dynUsageGrid     = ds_grid_create(_cellCountX, _cellCountY);
        __dynSurface       = surface_create(_surfaceWidth, _surfaceHeight);
        __dynSurfaceWidth  = _surfaceWidth;
        __dynSurfaceHeight = _surfaceHeight;
        __dynCellWidth     = _cellWidth;
        __dynCellHeight    = _cellHeight;
        __dynCellCountX    = _cellCountX;
        __dynCellCountY    = _cellCountY;
        __dynCellCount     = _glyphsPerPage;
        __dynDirtyArray    = [];
        __dynSurfaceDirty  = true;
        
        surface_set_target(__dynSurface);
        draw_clear_alpha(c_white, 0);
        surface_reset_target();
    }
    
    //Set some basic repeated values in bulk for a little speed boost
    var _material = __ScribbleGetDynamicMaterial(_scribbleName, _sdf? __SCRIBBLE_RENDER_SDF : __SCRIBBLE_RENDER_RASTER, _sdfPxRange, _sdfThicknessOffset, false);
    _fontData.__dynMaterial = _material;
    _material.__fontData = _fontData;
    
    _material.__texture     = surface_get_texture(_fontData.__dynSurface);
    _material.__texelWidth  = texture_get_texel_width(_material.__texture);
    _material.__texelHeight = texture_get_texel_height(_material.__texture);
    
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT,  _foundGlyphCount-1, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT,  _lineHeight);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE,   _foundGlyphCount-1, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE,   1);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_MATERIAL,     _foundGlyphCount-1, __SCRIBBLE_GLYPH_PROPR_MATERIAL,     _material);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_U0,           _foundGlyphCount-1, __SCRIBBLE_GLYPH_PROPR_V1,           undefined);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, _foundGlyphCount-1, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, true);
    
    var _index = 0;
    repeat(_foundGlyphCount)
    {
        var _unicode      = buffer_read(_buffer, buffer_u32);
        var _width        = buffer_read(_buffer, buffer_u8);
        var _height       = buffer_read(_buffer, buffer_u8);
        var _xOffset      = buffer_read(_buffer, buffer_s8);
        var _yOffset      = buffer_read(_buffer, buffer_s8);
        var _separation   = buffer_read(_buffer, buffer_s8);
        var _pixelLeft    = buffer_read(_buffer, buffer_s8);
        
        if (ds_map_exists(_fontGlyphsMap, _unicode))
        {
            __ScribbleError($"Duplicate glyph detected ({_unicode})");
        }
        
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
        
        _fontGlyphsMap[? _unicode] = _index;
        
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_CHARACTER   ] = chr(_unicode);
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_UNICODE     ] = _unicode;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_BIDI        ] = _bidi;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_X_OFFSET    ] = _xOffset;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_Y_OFFSET    ] = _yOffset;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_WIDTH       ] = _width;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_HEIGHT      ] = _height;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT ] = 0;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_SEPARATION  ] = _separation;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET ] = -_xOffset;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE  ] = 1;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_MATERIAL    ] = _material;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_U0          ] = undefined;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_U1          ] = undefined;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_V0          ] = undefined;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_V1          ] = undefined;
        //_fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID] = true;
        _fontGlyphDataGrid[# _index, __SCRIBBLE_GLYPH_PROPR_DYN_OFFSET  ] = _pixelLeft;
        
        ++_index;
    }
    
    var _kerningPairCount = buffer_read(_buffer, buffer_u32);
    __ScribbleTrace($"- Font has {_kerningPairCount} kerning pairs");
    
    repeat(_kerningPairCount)
    {
        var _pairCode = buffer_read(_buffer, buffer_u32);
        var _delta    = buffer_read(_buffer, buffer_s8);
        _fontKerningMap[? _pairCode] = _delta;
    }
    
    _fontData.__height = _lineHeight + _sdfHeightOffset;
    _fontData.__EnsureAdditionalCharacters();
    
    buffer_delete(_buffer);
    
    __ScribbleTrace($"Font data load complete. Took {(get_timer() - _timer)/1000}ms");
    
    return _nativeFont;
}