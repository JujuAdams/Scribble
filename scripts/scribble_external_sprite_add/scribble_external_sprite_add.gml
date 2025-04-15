// Feather disable all

/// @param sprite
/// @param alias

function scribble_external_sprite_add(_sprite, _alias)
{
    static _external_sprite_map = __scribble_initialize().__external_sprite_map;
    
    if (ds_map_exists(_external_sprite_map, _alias))
    {
        __scribble_error("External sprite alias \"", _alias, "\" already exists");
    }
    
    if (not sprite_exists(_sprite))
    {
        __scribble_error("Sprite asset ", _sprite, " could not be found");
    }
    
    _external_sprite_map[? _alias] = _sprite;
}
