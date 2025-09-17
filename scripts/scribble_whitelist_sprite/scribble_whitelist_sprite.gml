// Feather disable all

/// @param sprite

function scribble_whitelist_sprite(_sprite)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    _scribbleState.__spriteWhitelistMap[? _sprite] = true;
}