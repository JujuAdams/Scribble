// Feather disable all

function scribble_external_sound_exists(_alias)
{
    static _external_sound_map = __scribble_initialize().__external_sound_map;
    return ds_map_exists(_external_sound_map, _alias);
}