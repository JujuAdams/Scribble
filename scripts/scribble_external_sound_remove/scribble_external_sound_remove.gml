// Feather disable all
function scribble_external_sound_remove(_alias)
{
    static _external_sound_map = __scribble_initialize().__external_sound_map;
    ds_map_delete(_external_sound_map, _alias);
}