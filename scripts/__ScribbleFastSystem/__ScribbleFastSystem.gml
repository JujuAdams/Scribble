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
    }
    
    return _system;
}