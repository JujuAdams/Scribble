// Feather disable all

/// @param wound

function scribble_whitelist_sound(_wound)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    _scribbleState.__soundWhitelistMap[? _wound] = true;
}