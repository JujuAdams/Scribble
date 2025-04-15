// Feather disable all

function scribble_external_sprite_exists(_alias)
{
    static _external_sprite_map = __scribble_initialize().__external_sprite_map;
    return ds_map_exists(_external_sprite_map, _alias);
}