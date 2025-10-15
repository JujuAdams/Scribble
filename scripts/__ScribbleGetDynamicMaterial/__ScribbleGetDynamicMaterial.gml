// Feather disable all

/// @param fontName
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __ScribbleGetDynamicMaterial(_fontName, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear)
{
    static _materialMap = __ScribbleSystem().__materialMap;
    
    var _key = __ScribbleMakeMaterialKey(_fontName, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear);
    
    var _material = _materialMap[? _key];
    if (_material == undefined)
    {
        _material = new __ScribbleClassDynamicMaterial(_key, _fontName, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear);
        _materialMap[? _key] = _material;
    }
    
    return _material;
}