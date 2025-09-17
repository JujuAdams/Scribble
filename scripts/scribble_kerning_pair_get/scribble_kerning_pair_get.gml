// Feather disable all
/// Returns the separation offset between two characters
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param firstChar          First character in the pair, as a string
/// @param secondChar         Second character in the pair, as a string

function scribble_kerning_pair_get(_font, _firstChar, _secondChar)
{
    var _fontData = __ScribbleGetFontData(_font);
    
    var  _first_unicode = is_real( _firstChar)?  _firstChar : ord( _firstChar);
    var _secondUnicode = is_real(_secondChar)? _secondChar : ord(_secondChar);
    
    var _kerning_map = _fontData.__kerningMap;
    
    return (_kerning_map[? ((_secondUnicode & 0xFFFF) << 16) | (_first_unicode & 0xFFFF)] ?? 0);
}
