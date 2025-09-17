// Feather disable all

/// @param sound
/// @param alias

function scribble_external_sound_add(_sound, _alias)
{
    static _externalSoundMap = __ScribbleSystem().__externalSoundMap;
    
    if (ds_map_exists(_externalSoundMap, _alias))
    {
        __ScribbleError("External sound alias \"", _alias, "\" already exists");
    }
    
    if (not audio_exists(_sound))
    {
        __ScribbleError("Audio asset ", _sound, " could not be found");
    }
    
    _externalSoundMap[? _alias] = _sound;
}
