/// Gets the sound index from the Scribble External Sound Database.
///
/// @param soundName   Name, as a string, of the audio that you previously assigned to Scribbles External Sound Database.

function scribble_external_sound_get_index(_soundName)
{
    // Check from database and return index
    if (ds_map_exists(global.__scribble_external_sound, _soundName)) 
    {
        var _soundID = global.__scribble_external_sound[? _soundName];
        if (audio_exists(_soundID)) {
            return _soundID;
        }
        else
        {
            return -1;
        }
    } else {
        return -1;
    }
}