// Feather disable all

function __ScribblePaletteNewColor(_color)
{
    static _system = __ScribbleSystem();
    with(_system)
    {
        var _index = __paletteCount++;
        
        buffer_poke(__paletteBuffer, 4*_index, buffer_u32, 0xFF000000 | _color);
        __paletteDirty = true;
        
        return _index;
    }
}