function scribble_external_sound_exists(_alias)
{
    static _external_sound_map = __scribble_get_state().__external_sound_map;
    return ds_map_exists(_external_sound_map, _alias);
}