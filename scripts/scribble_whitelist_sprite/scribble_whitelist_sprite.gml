// Feather disable all

/// @param sprite

function scribble_whitelist_sprite(_sprite)
{
    static _scribble_state = __scribble_get_state();
    
    _scribble_state.__sprite_whitelist_map[? _sprite] = true;
}