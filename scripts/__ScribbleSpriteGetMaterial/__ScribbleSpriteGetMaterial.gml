// Feather disable all

/// @param sprite
/// @param image

function __ScribbleSpriteGetMaterial(_sprite, _image)
{
    static _spriteTextureMaterialMap = __ScribbleSystem().__spriteTextureMaterialMap;
    
    var _textureIndex = __ScribbleSpriteGetTextureIndex(_sprite, _image);
    var _material = _spriteTextureMaterialMap[? _textureIndex];
    if (_material == undefined)
    {
        var _material = __ScribbleGetMaterial(sprite_get_name(_sprite), _textureIndex, __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
        _spriteTextureMaterialMap[? _textureIndex] = _material;
    }
    
    return _material;
}