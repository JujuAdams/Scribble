// Feather disable all

/// @param textureIndex
/// @param bilinearFiltering

function __ScribbleTextureGetMaterial(_textureIndex, _bilinearFiltering)
{
    return __ScribbleGetMaterial("texture", _textureIndex, __SCRIBBLE_RENDER_RASTER, undefined, undefined, _bilinearFiltering);
}