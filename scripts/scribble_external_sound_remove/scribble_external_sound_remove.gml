// Feather disable all

function scribble_external_sound_remove(_alias)
{
    static _externalSoundMap = __ScribbleSystem().__externalSoundMap;
    ds_map_delete(_externalSoundMap, _alias);
}