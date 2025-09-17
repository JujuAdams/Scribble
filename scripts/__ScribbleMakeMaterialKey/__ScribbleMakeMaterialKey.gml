// Feather disable all

/// @param textureIndexOrPointer
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __ScribbleMakeMaterialKey(_textureIndexOrPointer, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear)
{
    return string_join(":", _textureIndexOrPointer, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear);
}