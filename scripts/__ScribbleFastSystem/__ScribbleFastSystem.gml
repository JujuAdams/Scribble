// Feather disable all

function __ScribbleFastSystem()
{
    static _system = undefined;
    if (is_struct(_system)) return _system;
    
    _system = {};
    with(_system)
    {
        __cache = {};
        __cacheTest = {};
        __cacheFontInfo = {};
        __defaultFont = fntTest;
        
        __colourDict = {};
        __colourDict[$ "c_red"  ] = c_red;
        __colourDict[$ "c_blue" ] = c_blue;
        __colourDict[$ "/c"     ] = -1;
        __colourDict[$ "/color" ] = -1;
        __colourDict[$ "/colour"] = -1;
    }
    
    return _system;
}