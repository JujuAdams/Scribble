// Feather disable all

/// @param fontName
/// @param pointSize
/// @param bold
/// @param italic

function __ScribbleMakeFontDataPath(_fontName, _pointSize, _bold, _italic)
{
    var _string = $"scribble_{string_lower(string_replace_all(_fontName, " ", "_"))}_{_pointSize}pt";
    
    if (_bold) _string += "_b";
    if (_italic) _string += "_i";
    
    return _string + ".dat";
}