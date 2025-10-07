// Feather disable all

function __ScribblePaletteEnsureSurfaceClean()
{
    static _system = __ScribbleSystem();
    with(_system)
    {
        if (__paletteDirty)
        {
            __paletteDirty = false;
            buffer_set_surface(__paletteBuffer, __ScribblePaletteEnsureSurface(), 0);
        }
    }
}