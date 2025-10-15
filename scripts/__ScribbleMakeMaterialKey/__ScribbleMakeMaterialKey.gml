// Feather disable all

/// @param textureIndexOrPointerOrFontName
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __ScribbleMakeMaterialKey(_textureIndexOrPointerOrFontName, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear)
{
    return string_join(":", _textureIndexOrPointerOrFontName, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear);
}