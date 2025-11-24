// Feather disable all

/// @param sprite
/// @param image
/// @param bilinearFiltering

function __ScribbleSpriteGetMaterial(_sprite, _image, _bilinearFiltering)
{
    return __ScribbleGetMaterial(string(_sprite), __ScribbleSpriteGetTextureIndex(_sprite, _image), __SCRIBBLE_RENDER_RASTER, undefined, undefined, _bilinearFiltering);
}