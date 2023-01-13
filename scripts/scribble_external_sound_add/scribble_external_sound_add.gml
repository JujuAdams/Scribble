/// @param soundID
/// @param alias

function scribble_external_sound_add(_soundID, _alias)
{
    var _external_sound_map = __scribble_get_external_sound_map();
    
    if (ds_map_exists(_external_sound_map, _alias))
    {
        __scribble_error("External sound alias \"", _alias, "\" already exists");
    }
    
    if (!audio_exists(_soundID))
    {
        __scribble_error("Audio asset ", _soundID, " could not be found");
    }
    
    _external_sound_map[? _alias] = _soundID;
}