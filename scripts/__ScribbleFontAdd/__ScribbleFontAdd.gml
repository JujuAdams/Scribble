// Feather disable all

#macro font_add      __ScribbleFontAdd
#macro __font_add__  font_add

function __ScribbleFontAdd(_name, _size, _bold, _italic, _first, _last)
{
    var _font = __font_add__(_name, _size, _bold, _italic, _first, _last);
    
    var _timer = get_timer();
    
    var _path = __ScribbleMakeFontDataPath(_name, _size);
    
    if (not file_exists(_path))
    {
        if (not SCRIBBLE_FONT_ADD_AUTOBUILD)
        {
            if (not __SCRIBBLE_ON_DESKTOP)
            {
                __ScribbleError($"Font data not found (looked for \"{_path}\"). Please call `scribble_font_build_data()` for this font");
            }
            else
            {
                __ScribbleTrace($"Warning! Font data not found (looked for \"{_path}\"). Please call `scribble_font_build_data()` for this font");
            }
            
            return _font;
        }
        
        if (not __SCRIBBLE_ON_DESKTOP)
        {
            __ScribbleError($"Font data not found (looked for \"{_path}\"). Please re-run the game on the desktop platform you're using for your IDE");
            return _font;
        }
        
        __ScribbleTrace($"Warning! Font data not found (looked for \"{_path}\")");
        
        _path = filename_dir(GM_project_filename) + "/datafiles/" + _path;
        __ScribbleTrace($"Changed file path to \"{_path}\" and building font data automatically");
        
        scribble_font_build_data(_font, _path);
        
        if (not file_exists(_path))
        {
            __ScribbleError($"Font data failed to save (looked for \"{_path}\")");
            return _font;
        }
    }
    
    __ScribbleTrace($"Loading font data \"{_path}\"");
    
    var _compressedBuffer = buffer_load(_path);
    if (_compressedBuffer < 0)
    {
        __ScribbleError($"Failed to load \"{_path}\". Please re-run `scribble_font_build_data()` for this font");
        return _font;
    }
    
    var _buffer = buffer_decompress(_compressedBuffer);
    buffer_delete(_compressedBuffer);
    
    if (_buffer < 0)
    {
        __ScribbleError($"Failed to decompress \"{_path}\". Please re-run `scribble_font_build_data()` for this font");
        return _font;
    }
    
    var _magicString = buffer_read(_buffer, buffer_string);
    if (_magicString != __SCRIBBLE_FONT_DATA_MAGIC_STRING)
    {
        __ScribbleError($"Font data failed verification check (\"{_path}\"). Please re-run `scribble_font_build_data()` for this font");
        return _font;
    }
    
    var _versionNumber = buffer_read(_buffer, buffer_string);
    if (_versionNumber != __SCRIBBLE_FONT_DATA_VERSION)
    {
        __ScribbleError($"Font data failed verification check (\"{_path}\"). Please re-run `scribble_font_build_data()` for this font");
        return _font;
    }
    
    var _foundFontName = buffer_read(_buffer, buffer_string);
    if (_name != _foundFontName)
    {
        __ScribbleTrace($"Warning! Font name mismatch. Found \"{_foundFontName}\", was expecting \"{_name}\"");
    }
    
    var _foundPointSize = buffer_read(_buffer, buffer_f32);
    if (_size != _foundPointSize)
    {
        __ScribbleError($"Font point size mismatch. Found {_foundPointSize}, was expecting {_size}");
        return _font;
    }
    
    var _foundNativeWidth  = buffer_read(_buffer, buffer_u8);
    var _foundNativeHeight = buffer_read(_buffer, buffer_u8);
    var _foundPixelWidth   = buffer_read(_buffer, buffer_u8);
    var _foundPixelHeight  = buffer_read(_buffer, buffer_u8);
    
    var _foundGlyphCount = buffer_read(_buffer, buffer_u32);
    
    var _cellWidth  = 2 + _foundPixelWidth;
    var _cellHeight = 2 + _foundPixelHeight;
    
    var _cellCountWidth  = floor(SCRIBBLE_FONT_ADD_TEXTURE_SIZE / _cellWidth);
    var _cellCountHeight = min(ceil(_foundGlyphCount / _cellCountWidth), floor(SCRIBBLE_FONT_ADD_TEXTURE_SIZE / _cellHeight));
    
    var _glyphsPerPage = _cellCountWidth*_cellCountHeight;
    var _textureWidth  = _cellCountWidth*_cellWidth;
    var _textureHeight = _cellCountHeight*_cellHeight;
    
    __ScribbleTrace($"- Font has {_foundGlyphCount} glyphs");
    __ScribbleTrace($"- Largest glyph is {_foundPixelWidth} x {_foundPixelHeight} px");
    __ScribbleTrace($"- Cell size is {_cellWidth} x {_cellHeight} px");
    __ScribbleTrace($"- Grid size is {_cellCountWidth} x {_cellCountHeight}. Maximum concurrent glyphs is {_glyphsPerPage}");
    __ScribbleTrace($"- Surface size is {_textureWidth} x {_textureHeight} px ({4*_textureWidth*_textureHeight / (1024*1024)} MB)");
    
    var _dictionary = {};
    
    repeat(_foundGlyphCount)
    {
        var _unicode      = buffer_read(_buffer, buffer_u32);
        var _nativeWidth  = buffer_read(_buffer, buffer_u8); //Unsigned
        var _nativeHeight = buffer_read(_buffer, buffer_u8); //Unsigned
        var _xOffset      = buffer_read(_buffer, buffer_u8); //Unsigned
        var _separation   = buffer_read(_buffer, buffer_u8); //Unsigned
        var _pixelLeft    = buffer_read(_buffer, buffer_s8); //Signed
        var _pixelTop     = buffer_read(_buffer, buffer_s8); //Signed
        var _pixelRight   = buffer_read(_buffer, buffer_s8); //Signed
        var _pixelBottom  = buffer_read(_buffer, buffer_s8); //Signed
        
        _dictionary[$ chr(_unicode)] = {
            __unicode:      _unicode,
            __nativeWidth:  _nativeWidth,
            __nativeHeight: _nativeHeight,
            __xOffset:      _xOffset,
            __separation:   _separation,
            __pixelLeft:    _pixelLeft,
            __pixelTop:     _pixelTop,
            __pixelRight:   _pixelRight,
            __pixelBottom:  _pixelBottom,
        };
    }
    
    buffer_delete(_buffer);
    
    __ScribbleTrace($"Font data load complete. Took {(get_timer() - _timer)/1000}ms");
    
    return _font;
}