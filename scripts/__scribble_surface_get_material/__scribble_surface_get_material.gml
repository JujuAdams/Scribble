// Feather disable all

/// @param surface

function __scribble_surface_get_material(_surface)
{
    return __ScribbleGetMaterial("surface", surface_get_texture(_surface), __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
}