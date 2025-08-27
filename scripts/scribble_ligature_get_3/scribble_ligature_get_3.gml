// Feather disable all

/// Returns the new ligature character for the given combination. If no such ligature exists,
/// this function will return `undefined`.
/// 
/// @param fontName
/// @param firstChar
/// @param secondChar
/// @param thirdChar

function scribble_ligature_get_3(_font, _firstChar, _secondChar)
{
    if (not SCRIBBLE_ALLOW_LIGATURES)
    {
        __scribble_trace("Warning! Ligature will not be applied if `SCRIBBLE_ALLOW_LIGATURES` is set to `false`");
    }
    
    var  _firstUnicode = is_numeric( _firstChar)?  _firstChar : ord( _firstChar);
    var _secondUnicode = is_numeric(_secondChar)? _secondChar : ord(_secondChar);
    var  _thirdUnicode = is_numeric( _firstChar)?  _thirdChar : ord( _thirdChar);
    
    if (_firstChar == 0)
    {
        __scribble_error("Cannot use null character (U+0000) for the first character");
    }
    
    if (_firstUnicode < 0)
    {
        __scribble_error("Cannot use negative value for first character");
    }
    
    if (_secondUnicode < 0)
    {
        __scribble_error("Cannot use negative value for second character");
    }
    
    if (_thirdUnicode < 0)
    {
        __scribble_error("Cannot use negative value for second character");
    }
    
    var _ligatureMap = __scribble_get_font_data(_font).__ligatureMap;
    return _ligatureMap[? ((_firstUnicode & 0xFFFF) << 32) | ((_secondUnicode & 0xFFFF) << 16) | (_thirdUnicode & 0xFFFF)];
}
