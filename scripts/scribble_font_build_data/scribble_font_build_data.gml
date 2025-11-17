// Feather disable all

/// @param font
/// @param [savePath]

#macro __SCRIBBLE_FONT_DATA_SURFACE_SIZE    128
#macro __SCRIBBLE_FONT_DATA_SURFACE_CENTER  (__SCRIBBLE_FONT_DATA_SURFACE_SIZE div 2)
#macro __SCRIBBLE_FONT_DATA_MAGIC_STRING    "Scribble Font Data"
#macro __SCRIBBLE_FONT_DATA_VERSION         "0.0.0"

function scribble_font_build_data(_font, _savePath = undefined)
{
    var _timer = get_timer();
    
    var _info = font_get_info(_font);
    
    var _fontName  = _info.name;
    var _pointSize = _info.size;
    
    __ScribbleTrace($"Building data for \"{_fontName}\" {_pointSize}pt ({_font})");
    
    draw_set_font(_font);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    //This is a bit silly but it seems to be the only way to reliably get an accurate line height
    var _lineHeight = string_height(" ");
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    
    var _context = {
        __surface:      surface_create(__SCRIBBLE_FONT_DATA_SURFACE_SIZE, __SCRIBBLE_FONT_DATA_SURFACE_SIZE),
        __buffer:       _buffer,
        __maxWidth:     0,
        __maxHeight:    0,
        __kerningArray: [],
    };
    
    buffer_write(_buffer, buffer_string, __SCRIBBLE_FONT_DATA_MAGIC_STRING);
    buffer_write(_buffer, buffer_string, __SCRIBBLE_FONT_DATA_VERSION);
    buffer_write(_buffer, buffer_string, _fontName);
    buffer_write(_buffer, buffer_f32,    _pointSize);
    buffer_write(_buffer, buffer_u8,     _lineHeight);
    buffer_write(_buffer, buffer_s8,     _info.ascender);
    buffer_write(_buffer, buffer_s8,     _info.ascenderOffset);
    
    var _maxSizeTell = buffer_tell(_buffer);
    buffer_write(_buffer, buffer_u8, 0);
    buffer_write(_buffer, buffer_u8, 0);
    
    var _glyphCount = struct_names_count(_info.glyphs);
    buffer_write(_buffer, buffer_u32, _glyphCount);
    
    __ScribbleTrace($"Font has {_glyphCount} glyphs, please wait...");
    
    struct_foreach(_info.glyphs, method(_context, function(_key, _value)
    {
        var _unicode = _value.char;
        
        surface_set_target(__surface);
        draw_clear_alpha(c_white, 0);
        draw_text(__SCRIBBLE_FONT_DATA_SURFACE_CENTER, __SCRIBBLE_FONT_DATA_SURFACE_CENTER, _key);
        surface_reset_target();
        
        var _bbox = __ScribblePixelBoundingBox(__surface);
        if (_bbox.valid)
        {
            var _left   = _bbox.left   - __SCRIBBLE_FONT_DATA_SURFACE_CENTER;
            var _top    = _bbox.top    - __SCRIBBLE_FONT_DATA_SURFACE_CENTER;
            var _right  = _bbox.right  - __SCRIBBLE_FONT_DATA_SURFACE_CENTER;
            var _bottom = _bbox.bottom - __SCRIBBLE_FONT_DATA_SURFACE_CENTER;
            
            var _glyphWidth  = 1 + _right - _left;
            var _glyphHeight = 1 + _bottom - _top;
            
            __maxWidth  = max(__maxWidth,  _glyphWidth);
            __maxHeight = max(__maxHeight, _glyphHeight);
        }
        else
        {
            var _left = 0;
        }
        
        var _buffer = __buffer;
        buffer_write(_buffer, buffer_u32, _unicode);
        buffer_write(_buffer, buffer_u8,  _value.w);
        buffer_write(_buffer, buffer_u8,  _value.h);
        buffer_write(_buffer, buffer_s8,  _value.offset);
        buffer_write(_buffer, buffer_s8,  _value.yoffset);
        buffer_write(_buffer, buffer_s8,  _value.shift);
        buffer_write(_buffer, buffer_s8,  _left);
        
        var _kerningArray = _value[$ "kerning"];
        if (is_array(_kerningArray))
        {
            var _j = 0;
            repeat(array_length(_kerningArray) div 2)
            {
                var _first = _kerningArray[_j];
                if (_first > 0)
                {
                    array_push(__kerningArray, ((_unicode & 0xFFFF) << 16) | (_first & 0xFFFF), _kerningArray[_j+1]);
                }
                
                _j += 2;
            }
        }
    }));
    
    //Write kerning data
    var _kerningArray = _context.__kerningArray;
    buffer_write(_buffer, buffer_u32, array_length(_kerningArray) div 2);
    
    var _i = 0;
    repeat(array_length(_kerningArray) div 2)
    {
        buffer_write(_buffer, buffer_u32, _kerningArray[_i  ]);
        buffer_write(_buffer, buffer_s8,  _kerningArray[_i+1]);
        _i += 2;
    }
    
    var _finalTell = buffer_tell(_buffer);
    
    //Go back and write found widths/heights
    buffer_seek(_buffer, buffer_seek_start, _maxSizeTell);
    buffer_write(_buffer, buffer_u8, _context.__maxWidth);
    buffer_write(_buffer, buffer_u8, _context.__maxHeight);
    
    surface_free(_context.__surface);
    
    var _compressedBuffer = buffer_compress(_buffer, 0, _finalTell);
    buffer_delete(_buffer);
    
    if (_savePath == undefined)
    {
        _savePath = filename_dir(GM_project_filename) + "/datafiles/" + __ScribbleMakeFontDataPath(_fontName, _pointSize, _info.bold, _info.italic);
        
        if (GM_is_sandboxed)
        {
            __ScribbleError($"Cannot save \"{_savePath}\"\nPlease disable file system sandbox for this platform.");
        }
    }
    
    __ScribbleTrace($"Saving compressed font data to \"{_savePath}\"");
    
    file_delete(_savePath);
    buffer_save(_compressedBuffer, _savePath);
    
    if (not file_exists(_savePath))
    {
        if (GM_is_sandboxed)
        {
            __ScribbleError($"Failed to save \"{_savePath}\"\nYou may need to disable file system sandbox for this platform.");
        }
        else
        {
            __ScribbleError($"Failed to save \"{_savePath}\"");
        }
    }
    
    buffer_delete(_compressedBuffer);
    
    var _timer = get_timer() - _timer;
    __ScribbleTrace($"Font parse complete. Took {_timer/1000}ms ({_timer / _glyphCount}us per glyph)");
}