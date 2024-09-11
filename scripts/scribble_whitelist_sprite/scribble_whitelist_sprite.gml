// Feather disable all

/// @param sprite

function scribble_whitelist_sprite(_sprite)
{
    static _scribble_state = __scribble_initialize().__state;
    
    _scribble_state.__sprite_whitelist_map[? _sprite] = true;
}