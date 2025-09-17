// Feather disable all

/// @param key
/// @param fontName
/// @param textureIndexOrPointer
/// @param renderType
/// @param sdfPxRange
/// @param sdfThicknessOffset
/// @param bilinear

function __ScribbleClassMaterial(_key, _fontName, _textureIndexOrPointer, _renderType, _sdfPxRange, _sdfThicknessOffset, _bilinear) constructor
{
    __key                = _key;
    __debugFontName      = _fontName; //Not used anywhere, added for debugging purposes. This will *not* be updated if a font is renamed with `scribble_font_rename()`
    __texture            = _textureIndexOrPointer;
    __texelWidth         = texture_get_texel_width(_textureIndexOrPointer);
    __texelHeight        = texture_get_texel_height(_textureIndexOrPointer);
    __renderType         = _renderType;
    __sdfPxRange         = _sdfPxRange;
    __sdfThicknessOffset = _sdfThicknessOffset;
    __bilinear           = _bilinear; //Can be `true`, `false`, or `undefined`
    
    static __duplicate_material_with_new_bilinear = function(_bilinear)
    {
        if (__bilinear == _bilinear) return self;
        return __ScribbleGetMaterial(__debugFontName, __texture, __renderType, __sdfPxRange, __sdfThicknessOffset, _bilinear);
    }
}