// Feather disable all

function __ScribblePaletteEnsureColor(_color)
{
    static _system = __ScribbleSystem();
    with(_system)
    {
        var _index = __paletteIndexMap[? _color];
        if (_index == undefined)
        {
            var _index = __paletteCount++;
            
            __paletteUsageMap[? _color] = 0;
            __paletteIndexMap[? _color] = _index;
            
            buffer_poke(__paletteBuffer, 4*_index, buffer_u32, 0xFF000000 | _color);
            __paletteDirty = true;
        }
        
        return _index;
    }
}