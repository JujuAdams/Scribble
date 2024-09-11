// Feather disable all

/// @param wound

function scribble_whitelist_sound(_wound)
{
    static _scribble_state = __scribble_initialize().__state;
    
    _scribble_state.__sound_whitelist_map[? _wound] = true;
}