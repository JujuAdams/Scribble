// Feather disable all

function __ScribblePaletteReplaceIndex(_index, _color)
{
    static _system = __ScribbleSystem();
    with(_system)
    {
        if (buffer_peek(__paletteBuffer, 4*_index, buffer_u32) != (0xFF000000 | _color))
        {
            buffer_poke(__paletteBuffer, 4*_index, buffer_u32, 0xFF000000 | _color);
            __paletteDirty = true;
            
            __ScribblePaletteEnsureSurfaceClean();
        }
        
        return _index;
    }
}