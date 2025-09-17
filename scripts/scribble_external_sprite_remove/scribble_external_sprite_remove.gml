// Feather disable all

function scribble_external_sprite_remove(_alias)
{
    static _external_sprite_map = __ScribbleSystem().__external_sprite_map;
    ds_map_delete(_external_sprite_map, _alias);
}