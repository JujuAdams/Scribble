// Feather disable all

function scribble_external_sound_exists(_alias)
{
    static _externalSoundMap = __ScribbleSystem().__externalSoundMap;
    return ds_map_exists(_externalSoundMap, _alias);
}