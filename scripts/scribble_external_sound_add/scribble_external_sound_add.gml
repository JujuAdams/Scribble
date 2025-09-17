// Feather disable all

/// @param sound
/// @param alias

function scribble_external_sound_add(_sound, _alias)
{
    static _external_sound_map = __ScribbleSystem().__external_sound_map;
    
    if (ds_map_exists(_external_sound_map, _alias))
    {
        __ScribbleError("External sound alias \"", _alias, "\" already exists");
    }
    
    if (not audio_exists(_sound))
    {
        __ScribbleError("Audio asset ", _sound, " could not be found");
    }
    
    _external_sound_map[? _alias] = _sound;
}
