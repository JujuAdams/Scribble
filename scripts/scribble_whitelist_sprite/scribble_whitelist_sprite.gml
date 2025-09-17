// Feather disable all

/// @param sprite

function scribble_whitelist_sprite(_sprite)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    _scribbleState.__sprite_whitelist_map[? _sprite] = true;
}