// Feather disable all

function __ScribblePaletteEnsureSurface()
{
    static _system = __ScribbleSystem();
    with(_system)
    {
        if (not surface_exists(__paletteSurface))
        {
            __paletteSurface = surface_create(SCRIBBLE_PALETTE_SIZE, SCRIBBLE_PALETTE_SIZE);
            buffer_set_surface(__paletteBuffer, __ScribblePaletteEnsureSurface(), 0);
        }
        
        return __paletteSurface;
    }
}