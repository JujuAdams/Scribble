// Feather disable all

/// @param textureIndex

function __scribble_texture_get_material(_texture_index)
{
    return __scribble_get_material("texture", _texture_index, __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
}