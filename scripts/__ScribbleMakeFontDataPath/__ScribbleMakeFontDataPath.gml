// Feather disable all

/// @param fontName
/// @param pointSize

function __ScribbleMakeFontDataPath(_fontName, _pointSize)
{
    return $"scribble_{string_lower(string_replace_all(_fontName, " ", "_"))}_{_pointSize}pt.dat";
}