// Feather disable all
/// Adjusts the separation offset between two characters
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param firstChar          First character in the pair, as a string
/// @param secondChar         Second character in the pair, as a string
/// @param value              The value to set
/// @param [relative=false]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value

function scribble_kerning_pair_set(_font, _firstChar, _secondChar, _value, _relative = false)
{
    var  _firstUnicode = is_real( _firstChar)?  _firstChar : ord( _firstChar);
    var _secondUnicode = is_real(_secondChar)? _secondChar : ord(_secondChar);
    
    if (_firstChar == 0)
    {
        __ScribbleError("Cannot use null character (U+0000) for the first character");
    }
    
    if (_firstChar < 0)
    {
        __ScribbleError("Cannot use negative value for first character");
    }
    
    if (_secondChar < 0)
    {
        __ScribbleError("Cannot use negative value for second character");
    }
    
    var _fontData = __ScribbleGetFontData(_font);
    var _kerningMap = _fontData.__kerningMap;
    
    var _lookup = ((_secondUnicode & 0xFFFF) << 16) | (_firstUnicode & 0xFFFF);
    var _newValue = _relative? ((_kerningMap[? _lookup] ?? 0) + _value) : _value;
    _kerningMap[? _lookup] = _newValue;
    
    return _newValue;
}
