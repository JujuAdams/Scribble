// Feather disable all

/// @param surface
/// @param bilinearFiltering

function __ScribbleSurfaceGetMaterial(_surface, _bilinearFiltering)
{
    return __ScribbleGetMaterial("surface", surface_get_texture(_surface), __SCRIBBLE_RENDER_RASTER, undefined, undefined, _bilinearFiltering);
}