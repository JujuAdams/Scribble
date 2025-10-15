// Feather disable all

/// @param key
/// @param fontName
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __ScribbleClassDynamicMaterial(_key, _fontName, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear) constructor
{
    __key                = _key;
    __debugFontName      = _fontName; //Not used anywhere, added for debugging purposes. This will *not* be updated if a font is renamed with `scribble_font_rename()`
    __texture            = undefined
    __texelWidth         = undefined
    __texelHeight        = undefined
    __renderType         = _renderType;
    __sdfPxRange         = _sdfPxRange;
    __sdfThicknessOffset = _sdfThicknessOffset;
    __bilinear           = _bilinear; //Can be `true`, `false`, or `undefined`
}