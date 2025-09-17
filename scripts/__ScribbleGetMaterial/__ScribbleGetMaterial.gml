// Feather disable all

/// @param fontName
/// @param textureIndexOrPointer
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __ScribbleGetMaterial(_fontName, _textureIndexOrPointer, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear)
{
    static _material_map = __ScribbleSystem().__material_map;
    
    var _key = __ScribbleMakeMaterialKey(_textureIndexOrPointer, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear);
    
    var _material = _material_map[? _key];
    if (_material == undefined)
    {
        _material = new __ScribbleClassMaterial(_key, _fontName, _textureIndexOrPointer, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear);
        _material_map[? _key] = _material;
    }
    
    return _material;
}