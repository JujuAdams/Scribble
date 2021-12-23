/// @param soundID
/// @param alias

function scribble_external_sound_add(_soundID, _alias)
{
    //Ensure we're initialized
    __scribble_system();
    
    if (ds_map_exists(global.__scribble_external_sound_map, _alias))
    {
        __scribble_error("External sound alias \"", _alias, "\" already exists");
    }
    
    if (!audio_exists(_soundID))
    {
        __scribble_error("Audio asset ", _soundID, " could not be found");
    }
    
    global.__scribble_external_sound_map[? _alias] = _soundID;
}