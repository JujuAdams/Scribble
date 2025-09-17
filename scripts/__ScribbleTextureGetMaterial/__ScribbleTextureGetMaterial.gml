// Feather disable all

/// @param textureIndex

function __ScribbleTextureGetMaterial(_textureIndex)
{
    return __ScribbleGetMaterial("texture", _textureIndex, __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
}