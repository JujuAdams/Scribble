// Feather disable all

function scribble_external_sprite_remove(_alias)
{
    static _externalSpriteMap = __ScribbleSystem().__externalSpriteMap;
    ds_map_delete(_externalSpriteMap, _alias);
}