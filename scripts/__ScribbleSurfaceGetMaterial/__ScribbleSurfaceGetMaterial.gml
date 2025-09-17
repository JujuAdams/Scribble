// Feather disable all

/// @param surface

function __ScribbleSurfaceGetMaterial(_surface)
{
    return __ScribbleGetMaterial("surface", surface_get_texture(_surface), __SCRIBBLE_RENDER_RASTER, undefined, undefined, SCRIBBLE_SPRITE_BILINEAR_FILTERING);
}