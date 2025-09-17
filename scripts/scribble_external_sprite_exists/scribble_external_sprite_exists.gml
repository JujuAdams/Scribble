// Feather disable all

function scribble_external_sprite_exists(_alias)
{
    static _externalSpriteMap = __ScribbleSystem().__externalSpriteMap;
    return ds_map_exists(_externalSpriteMap, _alias);
}