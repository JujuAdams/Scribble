/// Removes an audio index that was created with either audio_create_buffer_sound or audio_create_stream from Scribbles External Sound Database.
/// Specifically added in for those who would like to remove the reference. i.e. Unloading audio.
///
/// @param soundName   Name, as a string, of the audio that you previously assigned to Scribbles External Sound Database.

function scribble_external_sound_remove(_soundName) 
{
    if (ds_map_exists(global.__scribble_external_sound, _soundName)) 
    {
        ds_map_delete(global.__scribble_external_sound, _soundName);
    }
    else
    {
        __scribble_error("External Sound " + _soundName + " doesn't exist in Scribbles External Sound Database!");
    }
}