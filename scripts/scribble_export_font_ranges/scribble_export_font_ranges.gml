// Feather disable all

/// Converts an array of characters (either single-character strings or Unicode codepoints) into
/// character ranges and then writes those character ranges into the source font .yy file for the
/// target font assets. Any font ranges already in the file are overwritten.
/// 
/// N.B. GameMaker will not regenerate the font automatically. You can regenerate fonts by
///      selecting the font in the asset browser (or multiple fonts with shift/ctrl + click) and
///      then pressing "Regenerate font texture" in the Inspector window.
/// 
/// @param fontArray
/// @param characterArray

function scribble_export_font_ranges(_fontArray, _characterArray)
{
    if (not SCRIBBLE_RUNNING_FROM_IDE)
    {
        __ScribbleTrace("Warning! Cannot call `scribble_write_font_range()` when not running from the IDE");
        return;
    }
    
    if (GM_is_sandboxed)
    {
        __ScribbleError("Please disable the file system sandbox before using this function");
        return;
    }
    
    if (not is_array(_fontArray))
    {
        _fontArray = [_fontArray];
    }
    
    if ((array_get_index(_characterArray, 0x20) < 0) && (array_get_index(_characterArray, " ") < 0))
    {
        __ScribbleError("Character array must contain a space character");
        return;
    }
    
    _characterArray = array_map(_characterArray, function(_value)
    {
        return is_string(_value)? ord(_value) : _value;
    });
    
    array_unique_ext(_characterArray);
    array_sort(_characterArray, true);
    
    //Make ranges as required
    var _rangeArray = [];
    
    var _start = _char;
    var _prev  = _start;
    
    var _i = 1;
    repeat(array_length(_characterArray)-1)
    {
        var _char = _characterArray[_i];
        if (_char != _prev+1)
        {
            array_push(_rangeArray, {
                lower: _start,
                upper: _prev,
            });
            
            _start = _char;
        }
        
        _prev = _char;
        ++_i;
    }
    
    array_push(_rangeArray, {
        lower: _start,
        upper: _prev,
    });
    
    //Build a string to insert into fonts
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_text, "  \"ranges\":[\n");
    
    var _i = 0;
    repeat(array_length(_rangeArray))
    {
        var _struct = _rangeArray[_i];
        
        buffer_write(_buffer, buffer_text, "    {\"lower\":");
        buffer_write(_buffer, buffer_text, string(_struct.lower));
        buffer_write(_buffer, buffer_text, ",\"upper\":");
        buffer_write(_buffer, buffer_text, string(_struct.upper));
        buffer_write(_buffer, buffer_text, ",},\n");
            
        ++_i;
    }
    
    buffer_write(_buffer, buffer_text, "  ],");
    var _newString = buffer_peek(_buffer, 0, buffer_string);
    buffer_delete(_buffer);
    
    //Then apply to fonts
    var _j = 0;
    repeat(array_length(_fontArray))
    {
        var _font = _fontArray[_j];
        
        if (is_handle(_font) && font_exists(_font))
        {
            var _fontName = font_get_name(_font);
            var _path = $"{filename_dir(GM_project_filename)}/fonts/{_fontName}/{_fontName}.yy";
        }
        else
        {
            __ScribbleError($"Input must be a font asset (typeof=\"{typeof(_font)}\")");
        }
        
        try
        {
            var _buffer = buffer_load(_path);
            var _string = buffer_read(_buffer, buffer_text);
        }
        catch(_error)
        {
            __ScribbleTrace(_error);
            __ScribbleError($"Failed to load font file \"{_path}\")");
        }
        finally
        {
            buffer_delete(_buffer);
        }
        
        var _startPos = string_pos("  \"ranges\":[", _string);
        var _endPos = string_pos_ext("  ],", _string, _startPos);
        
        if ((_startPos <= 0) || (_endPos <= 0))
        {
            __ScribbleError($"Failed to find insertion point in \"{_path}\")");
        }
        
        _string = string_delete(_string, _startPos, 4 + _endPos - _startPos);
        _string = string_insert(_newString, _string, _startPos);
        _string = string_replace_all(_string, "\"regenerateBitmap\":true", "\"regenerateBitmap\":false");
        
        var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, _path);
        buffer_delete(_buffer);
        
        ++_j;
    }
}