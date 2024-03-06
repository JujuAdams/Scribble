// Feather disable all
function scribble_external_sound_exists(_alias)
{
    return ds_map_exists(__scribble_get_external_sound_map(), _alias);
}