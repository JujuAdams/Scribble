// Feather disable all

/// @param sprite
/// @param alias

function scribble_external_sprite_add(_sprite, _alias)
{
    static _externalSpriteMap = __ScribbleSystem().__externalSpriteMap;
    
    if (ds_map_exists(_externalSpriteMap, _alias))
    {
        __ScribbleError("External sprite alias \"", _alias, "\" already exists");
    }
    
    if (not sprite_exists(_sprite))
    {
        __ScribbleError("Sprite asset ", _sprite, " could not be found");
    }
    
    _externalSpriteMap[? _alias] = _sprite;
}
