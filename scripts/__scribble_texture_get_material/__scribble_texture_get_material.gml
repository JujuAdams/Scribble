// Feather disable all

/// @param textureIndex

function __scribble_texture_get_material(_textureIndex)
{
    return __scribble_get_material("texture", _textureIndex, __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
}