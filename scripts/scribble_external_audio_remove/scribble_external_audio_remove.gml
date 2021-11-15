/// Removes an audio index that was created with either audio_create_buffer_sound or audio_create_stream from Scribbles External Audio Database.
/// Specifically added in for those who would like to remove the reference. i.e. Unloading audio.
///
/// @param audioName   Name, as a string, of the audio that you previously assigned to Scribbles External Audio Database.

function scribble_external_audio_remove(_audioName) 
{
    if (ds_map_exists(global.__scribble_external_audio, _audioName)) 
    {
        ds_map_delete(global.__scribble_external_audio, _audioName);
    }
    else
    {
        __scribble_error("External Audio " + _audioName + " doesn't exist in Scribbles External Audio Database!");
    }
}