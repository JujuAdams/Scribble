// Feather disable all

/// Sets up a three-character ligature. Use `undefined` to remove a ligature.
/// 
/// @param fontName
/// @param firstChar
/// @param secondChar
/// @param thirdChar
/// @param replaceChar

function scribble_ligature_set_3(_font, _firstChar, _secondChar, _thirdChar, _replaceChar)
{
    if (not SCRIBBLE_ALLOW_LIGATURES)
    {
        __scribble_trace("Warning! Ligature will not be applied if `SCRIBBLE_ALLOW_LIGATURES` is set to `false`");
    }
    
    var   _firstUnicode = is_string(  _firstChar)? ord(  _firstChar) :   _firstChar;
    var  _secondUnicode = is_string( _secondChar)? ord( _secondChar) :  _secondChar;
    var   _thirdUnicode = is_string(  _thirdChar)? ord(  _thirdChar) :   _thirdChar;
    var _replaceUnicode = is_string(_replaceChar)? ord(_replaceChar) : _replaceChar;
    
    if (_firstUnicode == 0)
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
        __scribble_error("Cannot use negative value for first character");
    }
    
    if (is_numeric(_replaceUnicode) && (_replaceUnicode < 0))
    {
        __scribble_error("Cannot use negative value for second character");
    }
    
    var _ligatureMap = __scribble_get_font_data(_font).__ligatureMap;
    var _key = ((_firstUnicode & 0xFFFF) << 32) | ((_secondUnicode & 0xFFFF) << 16) | (_thirdUnicode & 0xFFFF);
    
    if (_replaceChar == undefined)
    {
        ds_map_delete(_ligatureMap, _key);
    }
    else
    {
        _ligatureMap[? _key] = _replaceUnicode & 0xFFFF;
    }
}
